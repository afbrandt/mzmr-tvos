//
//  MZMRAudioSourceStream.h
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMRAudioSourceStream : NSObject

- (instancetype)initWithSpotify;

- (void)search: (NSString *)song;

@end
