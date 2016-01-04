//
//  MZMRAudioSource.h
//  mzmr
//
//  Created by Andrew Brandt on 1/1/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "TheAmazingAudioEngine.h"

typedef NS_ENUM(NSInteger, MZMRSourceType) {
    MZMRSourceTypeFile,
    MZMRSourceTypeStream,
    MZMRSourceTypeMicrophone,
    MZMRSourceTypeUnknown
};

@protocol MZMRAudioSource <AEAudioPlayable>

@required

@property (assign, nonatomic) MZMRSourceType sourceType;

- (id<AEAudioPlayable>)channels;

@optional

+ (instancetype)sourceFromURL: (NSURL *)url;

@end
