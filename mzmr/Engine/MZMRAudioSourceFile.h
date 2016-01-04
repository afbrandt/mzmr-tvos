//
//  MZMRAudioSourceFile.h
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "TheAmazingAudioEngine.h"
#import "MZMRAudioSource.h"

@interface MZMRAudioSourceFile : AEAudioFilePlayer <MZMRAudioSource>

@property (assign, nonatomic) MZMRSourceType sourceType;

+ (instancetype)sourceFromURL: (NSURL *)url;

@end
