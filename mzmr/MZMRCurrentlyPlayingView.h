//
//  MZMRCurrentlyPlayingView.h
//  mzmr
//
//  Created by Andrew Brandt on 1/7/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MZMRAudioSource;

@interface MZMRCurrentlyPlayingView : UIView

@property (strong, nonatomic) id<MZMRAudioSource> currentlyPlaying;

@end
