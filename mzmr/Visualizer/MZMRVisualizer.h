//
//  MZMRVisualizer.h
//  mzmr
//
//  Created by Andrew Brandt on 12/29/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import "TheAmazingAudioEngine.h"
#import <Accelerate/Accelerate.h>
#import <UIKit/UIKit.h>

@protocol MZMRVisualizer <AEAudioReceiver>

@property (strong, nonatomic, readonly) CALayer* layer;

- (id)initWithAudioDescription:(AudioStreamBasicDescription)audioDescription;

- (void)start;
- (void)stop;

- (AEAudioReceiverCallback)receiverCallback;

@end

#define kBufferLength 2048 // In frames; higher values mean oscilloscope spans more time
#define kMaxConversionSize 4096
#define kSkipFrames 16     // Frames to skip - higher value means faster render time, but rougher display

#if CGFLOAT_IS_DOUBLE
#define SAMPLETYPE double
#define VRAMP vDSP_vrampD
#define VSMUL vDSP_vsmulD
static void VRAMPMUL(const SAMPLETYPE *__vDSP_I, vDSP_Stride __vDSP_IS, SAMPLETYPE *__vDSP_Start, const SAMPLETYPE *__vDSP_Step, SAMPLETYPE *__vDSP_O, vDSP_Stride __vDSP_OS, vDSP_Length __vDSP_N) {
    // No double version of vDSP_vrampmul, so do it sample by sample
    int idx=0;
    SAMPLETYPE *iptr = (SAMPLETYPE*)__vDSP_I;
    SAMPLETYPE *optr = (SAMPLETYPE*)__vDSP_O;
    for ( ; idx<__vDSP_N; iptr+=__vDSP_IS, optr+=__vDSP_OS, idx++ ) {
        *optr = *iptr * (*__vDSP_Start += *__vDSP_Step);
    }
}
#define VSADD vDSP_vsaddD
#else
#define SAMPLETYPE float
#define VRAMP vDSP_vramp
#define VSMUL vDSP_vsmul
#define VRAMPMUL vDSP_vrampmul
#define VSADD vDSP_vsadd
#endif