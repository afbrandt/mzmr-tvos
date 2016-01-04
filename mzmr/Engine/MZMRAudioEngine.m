//
//  MZMRAudioEngine.m
//  mzmr
//
//  Created by Andrew Brandt on 12/23/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import "MZMRAudioEngine.h"
#import "MZMRAudioSource.h"
#import "MZMRAudioSourceFile.h"
#import "MZMRAudioSourceStream.h"

#import "MZMRVisualizer.h"

#import "AEAudioController.h"
#import "AEAudioFilePlayer.h"
#import "AEPlaythroughChannel.h"
#import "AEUtilities.h"

@interface MZMRAudioEngine ()

@property (strong, nonatomic) AEAudioController *controller;
@property (strong, nonatomic) AEAudioFilePlayer *filePlayer;
//@property (strong, nonatomic) AEPlaythroughChannel *sourceListener;
@property (strong, nonatomic) MZMRAudioSourceStream *playing;
@property (strong, nonatomic) AEAudioFilePlayer *currentlyPlaying;

@property (strong, nonatomic) NSArray *playQueue;

@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) id<MZMRVisualizer> currentVisualizer;

@end

@implementation MZMRAudioEngine

#pragma mark - Lifecycle methods

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self prepareEngine];
        self.playQueue = [NSArray array];
        self.isPlaying = NO;
    }
    
    return self;
}

- (void)prepareEngine {
    self.controller = [[AEAudioController alloc]
                        initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo
                        inputEnabled:YES];
                        
//    self.sourceListener = [[AEPlaythroughChannel alloc] init];
//    
//    [self.controller addChannels:@[self.sourceListener]];
//    [self.controller addInputReceiver:self.sourceListener];
    
}

- (void)startEngine {
    NSError *error;
    BOOL result = [self.controller start:&error];
    
    if (!result) {
        NSLog(@"%@",error);
    }
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"DemoSong" withExtension:@"m4a"];
    self.currentlyPlaying = [[AEAudioFilePlayer alloc] initWithURL:fileURL error:&error];
//    self.currentlyPlaying = [MZMRAudioSourceFile sourceFromURL:fileURL];
//    MZMRAudioSource *track = [MZMRAudioSource new];
//    self.currentlyPlaying = track;

    MZMRAudioSourceStream *stream = [[MZMRAudioSourceStream alloc] initWithSpotify];
    [stream search:@"Madness"];
    self.playing = stream;

    [self playPause];
}

#pragma mark - Audio control methods

- (BOOL)playResource: (NSURL *)url {
    return YES;
}

- (BOOL)enqueueResource: (NSURL *)url {
    return YES;
}

- (BOOL)dequeueResource: (NSURL *)url {
    return YES;
}

- (void)playPause {
    if (self.isPlaying) {
        self.isPlaying = NO;
        [self.controller removeChannels:@[self.currentlyPlaying]];
    } else {
        self.isPlaying = YES;
        [self.controller addChannels:@[self.currentlyPlaying]];
    }
}

#pragma mark - Visualizer control methods

- (void)setVisualizer:(id<MZMRVisualizer>)visualizer {
    self.currentVisualizer = visualizer;
    [self.currentVisualizer start];
    [self.controller addOutputReceiver:self.currentVisualizer];
}

@end
