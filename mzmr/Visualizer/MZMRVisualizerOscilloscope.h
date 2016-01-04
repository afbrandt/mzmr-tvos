//
//  MZMRVisualizerOscilloscope.h
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TheAmazingAudioEngine.h"
#import "MZMRVisualizer.h"

@interface MZMRVisualizerOscilloscope : CALayer <MZMRVisualizer>

@property (strong, nonatomic) UIColor *lineColor;

- (void)start;
- (void)stop;

- (id)initWithAudioDescription:(AudioStreamBasicDescription)audioDescription;

- (AEAudioReceiverCallback)receiverCallback;

@end
