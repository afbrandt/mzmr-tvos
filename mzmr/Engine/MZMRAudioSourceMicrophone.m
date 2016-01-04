//
//  MZMRAudioSourceMicrophone.m
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "MZMRAudioSourceMicrophone.h"

@implementation MZMRAudioSourceMicrophone

- (instancetype)init {
    self = [super init];
    
    if (self) {
    
    }
    
    return self;
}

- (AEAudioRenderCallback)renderCallback {
    return nil;
}

- (id<AEAudioPlayable>)channels {
    return nil;
}

@end
