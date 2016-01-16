//
//  MZMRCurrentlyPlayingView.m
//  mzmr
//
//  Created by Andrew Brandt on 1/7/16.
//  Copyright © 2016 Dory Studios. All rights reserved.
//

#import "MZMRCurrentlyPlayingView.h"
#import "MZMRAudioSource.h"

@interface MZMRCurrentlyPlayingView ()

@property (weak, nonatomic) IBOutlet UILabel *currentMediaLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *songArtistLabel;

@end

@implementation MZMRCurrentlyPlayingView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self addObserver:self forKeyPath:@"currentlyPlaying" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentlyPlaying"]) {
        id<MZMRAudioSource> obj = change[NSKeyValueChangeNewKey];
        switch (obj.sourceType) {
            case MZMRSourceTypeFile: {
                self.currentMediaLabel.text = @"now playing";
                break;
            }
            case MZMRSourceTypeStream: {
                self.currentMediaLabel.text = @"now streaming";
                break;
            }
            case MZMRSourceTypeMicrophone: {
                self.currentMediaLabel.text =  @"now listening";
                break;
            }
            case MZMRSourceTypeUnknown: {
                break;
            }
        }
    }
}

@end
