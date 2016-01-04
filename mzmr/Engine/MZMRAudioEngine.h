//
//  MZMRAudioEngine.h
//  mzmr
//
//  Created by Andrew Brandt on 12/23/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MZMRVisualizer;

@interface MZMRAudioEngine : NSObject

- (void)startEngine;

- (BOOL)playResource: (NSURL *)url;
- (BOOL)enqueueResource: (NSURL *)url;
- (BOOL)dequeueResource: (NSURL *)url;

- (void)playPause;

- (void)setVisualizer: (id<MZMRVisualizer>)visualizer;

@end
