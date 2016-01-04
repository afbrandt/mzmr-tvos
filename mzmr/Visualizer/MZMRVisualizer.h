//
//  MZMRVisualizer.h
//  mzmr
//
//  Created by Andrew Brandt on 12/29/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import "TheAmazingAudioEngine.h"

@protocol MZMRVisualizer <AEAudioReceiver>

- (id)initWithAudioDescription:(AudioStreamBasicDescription)audioDescription;

- (void)start;
- (void)stop;

- (AEAudioReceiverCallback)receiverCallback;

@end