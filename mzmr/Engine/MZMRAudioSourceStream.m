//
//  MZMRAudioSourceStream.m
//  mzmr
//
//  Created by Andrew Brandt on 1/3/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "MZMRAudioSourceStream.h"
//#import "Spotify.h"

@interface MZMRAudioSourceStream ()

//@property (strong, nonatomic) SPTAudioStreamingController *streamingPlayer;

@end

@implementation MZMRAudioSourceStream

- (instancetype)initWithSpotify {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)search: (NSString *)song {
    
//    [SPTSearch performSearchWithQuery:song
//                            queryType:SPTQueryTypeTrack
//                          accessToken:nil
//                             callback:^(NSError *error, id object) {
//         if (error) {
//            NSLog(@"error searching: %@",error);
//         }
//         
//         SPTListPage *response = object;
//         
//         if ([response.items count] > 0) {
//            NSLog(@"%@", response.items[0]);
//         }
//         
//     }];
}

//- (void)initSpotify {
//    [SPTAuth defaultInstance].clientID = kSpotifyClientId;
//    [SPTAuth defaultInstance].requestedScopes = [self getAccessTokenScopes];
//    [SPTAuth defaultInstance].redirectURL = [NSURL URLWithString:kSpotifyCallbackURL];
//    [SPTAuth defaultInstance].tokenRefreshURL = [NSURL URLWithString:kSpotifyTokenRefreshServiceURL];
//    [SPTAuth defaultInstance].tokenSwapURL = [NSURL URLWithString:kSpotifySwapURL];
//    [SPTAuth defaultInstance].sessionUserDefaultsKey = kSpotifyDefaultSessionKey;
//
//    if(self.streamingPlayer) { // lazy initialize the Streaming Player
//        self.streamingPlayer = [[SPTAudioStreamingController alloc] initWithClientId:kSpotifyClientId];
//        [self.streamingPlayer setDelegate:self];
//        [self.streamingPlayer setPlaybackDelegate:self];
//        [self.streamingPlayer setTargetBitrate:SPTBitrateHigh callback:^(NSError *error) {
//            if(error) {
////                [[Logger sharedLogger] error:error withMessage:@"Error setting player bitrate"];
//            }
//        }];
//
//        taskReadQueue = dispatch_queue_create(kSpotifyReadTaskQueue, DISPATCH_QUEUE_CONCURRENT);
//        dispatch_set_target_queue(taskReadQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
//    }

@end
