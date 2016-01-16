//
//  MZMRVisualizerParticles.m
//  mzmr
//
//  Created by Andrew Brandt on 1/12/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "MZMRVisualizerParticles.h"
#include <libkern/OSAtomic.h>

@interface MZMRVisualizerParticles () {

    SAMPLETYPE  *_buffer;
    CGPoint     *_scratchBuffer;
    int          _buffer_head;
    AudioBufferList *_conversionBuffer;
#if TARGET_OS_IPHONE
    id           _timer;
#else
    CVDisplayLinkRef _displayLink;
#endif

}
@property (nonatomic, strong) AEFloatConverter *floatConverter;
@property (nonatomic, strong) CAEmitterLayer *emitter;

@end

@implementation MZMRVisualizerParticles

- (CALayer *)layer {
    return self;
}

- (id)initWithAudioDescription:(AudioStreamBasicDescription)audioDescription {
    if ( !(self = [super init]) ) return nil;

    self.floatConverter = [[AEFloatConverter alloc] initWithSourceFormat:audioDescription];
    _conversionBuffer = AEAllocateAndInitAudioBufferList(_floatConverter.floatingPointAudioDescription, kMaxConversionSize);
    _buffer = (SAMPLETYPE*)calloc(kBufferLength, sizeof(SAMPLETYPE));
    _scratchBuffer = (CGPoint*)malloc(kBufferLength * sizeof(CGPoint));
    
#if TARGET_OS_IPHONE
    self.contentsScale = [[UIScreen mainScreen] scale];
    self.lineColor = [UIColor yellowColor];
#else
    self.lineColor = [NSColor blackColor];
#endif
    
    // Disable animating view refreshes
    self.actions = @{@"contents": [NSNull null]};
    
    self.delegate = self;
    
    self.emitter = [CAEmitterLayer layer];
    
    
    return self;
}

- (void)start {
//    self.lineColor = [UIColor whiteColor];
#if TARGET_OS_IPHONE
    if ( _timer ) return;
    if ( NSClassFromString(@"CADisplayLink") ) {
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        ((CADisplayLink*)_timer).frameInterval = 2;
        [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
#else
    if ( _displayLink ) return;
    
    CGDirectDisplayID displayID = CGMainDisplayID();
    CVReturn error = kCVReturnSuccess;
    error = CVDisplayLinkCreateWithCGDisplay(displayID, &_displayLink);
    if ( error ) {
        NSLog(@"DisplayLink created with error:%d", error);
        _displayLink = NULL;
    }
    CVDisplayLinkSetOutputCallback(_displayLink, displayLinkRenderCallback, (__bridge void *)self);
    CVDisplayLinkStart(_displayLink);
#endif
}

- (void)stop {
#if TARGET_OS_IPHONE
    if ( !_timer ) return;
    [_timer invalidate];
    _timer = nil;
#else
    if ( !_displayLink ) return;
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
    _displayLink = NULL;
#endif
}

-(AEAudioReceiverCallback)receiverCallback {
    return &audioCallback;
}

#pragma mark - Rendering

-(void)update {

}

-(void)drawInContext:(CGContextRef)ctx {

    CGContextSetShouldAntialias(ctx, true);
    
    // Render ring buffer as path
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [_lineColor CGColor]);
    
    int frames = kBufferLength-1;
    int tail = (_buffer_head+1) % kBufferLength;
    SAMPLETYPE x = 0;
    SAMPLETYPE xIncrement = (self.bounds.size.width / (float)(frames-1)) * (float)(kSkipFrames+1);
    SAMPLETYPE multiplier = self.bounds.size.height / 2.0;
    
    // Generate samples
    SAMPLETYPE *scratchPtr = (SAMPLETYPE*)_scratchBuffer;
    while ( frames > 0 ) {
        int framesToRender = MIN(frames, kBufferLength - tail);
        int samplesToRender = framesToRender / kSkipFrames;
        
        VRAMP(&x, &xIncrement, (SAMPLETYPE*)scratchPtr, 2, samplesToRender);
        VSMUL(&_buffer[tail], kSkipFrames, &multiplier, ((SAMPLETYPE*)scratchPtr)+1, 2, samplesToRender);
        
        scratchPtr += 2 * samplesToRender;
        x += (samplesToRender-1)*xIncrement;
        tail += framesToRender;
        if ( tail == kBufferLength ) tail = 0;
        frames -= framesToRender;
    }
    
    int sampleCount = (kBufferLength-1) / kSkipFrames;
    
    // Apply an envelope
    SAMPLETYPE start = 0.0;
    int envelopeLength = sampleCount / 2;
    SAMPLETYPE step = 1.0 / (float)envelopeLength;
    VRAMPMUL((SAMPLETYPE*)_scratchBuffer + 1, 2, &start, &step, (SAMPLETYPE*)_scratchBuffer + 1, 2, envelopeLength);
    
    start = 1.0;
    step = -step;
    VRAMPMUL((SAMPLETYPE*)_scratchBuffer + 1 + (envelopeLength*2), 2, &start, &step, (SAMPLETYPE*)_scratchBuffer + 1 + (envelopeLength*2), 2, envelopeLength);
    
    // Assign midpoint
    SAMPLETYPE midpoint = self.bounds.size.height / 2.0;
    VSADD((SAMPLETYPE*)_scratchBuffer+1, 2, &midpoint, (SAMPLETYPE*)_scratchBuffer+1, 2, sampleCount);
    
    // Render lines
    CGContextBeginPath(ctx);
    CGContextAddLines(ctx, (CGPoint*)_scratchBuffer, sampleCount);
    CGContextStrokePath(ctx);
}

#pragma mark - Callback

static void audioCallback(__unsafe_unretained MZMRVisualizerParticles *THIS,
                          __unsafe_unretained AEAudioController *audioController,
                          void *source,
                          const AudioTimeStamp *time,
                          UInt32 frames,
                          AudioBufferList *audio) {
    // Convert audio
    AEFloatConverterToFloatBufferList(THIS->_floatConverter, audio, THIS->_conversionBuffer, frames);
    
    // Get a pointer to the audio buffer that we can advance
    float *audioPtr = THIS->_conversionBuffer->mBuffers[0].mData;
    
    // Copy in contiguous segments, wrapping around if necessary
    int remainingFrames = frames;
    while ( remainingFrames > 0 ) {
        int framesToCopy = MIN(remainingFrames, kBufferLength - THIS->_buffer_head);
        
#if CGFLOAT_IS_DOUBLE
        vDSP_vspdp(audioPtr, 1, THIS->_buffer + THIS->_buffer_head, 1, framesToCopy);
#else
        memcpy(THIS->_buffer + THIS->_buffer_head, audioPtr, framesToCopy * sizeof(float));
#endif
        audioPtr += framesToCopy;
        
        int buffer_head = THIS->_buffer_head + framesToCopy;
        if ( buffer_head == kBufferLength ) buffer_head = 0;
        OSMemoryBarrier();
        THIS->_buffer_head = buffer_head;
        remainingFrames -= framesToCopy;
    }
}

@end
