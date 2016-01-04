//
//  MZMRAudioSourceFile.m
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "MZMRAudioSourceFile.h"

@interface MZMRAudioSourceFile ()

@property (strong, nonatomic) AEAudioFilePlayer *player;

@end

@implementation MZMRAudioSourceFile

- (instancetype)initWithURL: (NSURL *)url {
    self = [super init];
    
    if (self) {
        self.sourceType = MZMRSourceTypeFile;
        NSError *error;
        
        if (url) {
            self.player = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        }
        
        if (error) {
            NSLog(@"error loading url: %@", error);
        }
    }
    
    return self;
}

+ (instancetype)sourceFromURL: (NSURL *)url {
    MZMRAudioSourceFile *file = [[MZMRAudioSourceFile alloc] initWithURL:url];
    return file;
}

- (id<AEAudioPlayable>)channels {
    return self.player;
}

@end
