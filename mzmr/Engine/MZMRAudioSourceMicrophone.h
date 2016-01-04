//
//  MZMRAudioSourceMicrophone.h
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZMRAudioSource.h"

@interface MZMRAudioSourceMicrophone : NSObject <MZMRAudioSource>

@property (assign, nonatomic) MZMRSourceType sourceType;

@end
