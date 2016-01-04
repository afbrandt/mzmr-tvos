//
//  ViewController.m
//  mzmr
//
//  Created by Andrew Brandt on 12/21/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import "MZMRMainViewController.h"
#import "MZMRVisualizerOscilloscope.h"
#import "MZMRAudioSource.h"
#import "MZMRAudioEngine.h"

#import <MediaPlayer/MediaPlayer.h>

@interface MZMRMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *primaryMenu;
@property (weak, nonatomic) IBOutlet UIView *secondaryMenu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryMenuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryMenuLeadingEdge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondaryMenuWidth;

@property (strong, nonatomic) MZMRAudioEngine *audioEngine;
@property (strong, nonatomic) MZMRVisualizerOscilloscope *currentVisualizer;

@end

@implementation MZMRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.audioEngine = [MZMRAudioEngine new];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.primaryMenuWidth.constant = width/10;
    self.secondaryMenuWidth.constant = 0;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [self.view addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *playPause = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPlayPause)];
    playPause.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [self.view addGestureRecognizer:playPause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.audioEngine startEngine];
    
    self.currentVisualizer = [[MZMRVisualizerOscilloscope alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo];
    self.currentVisualizer.frame = self.view.frame;
    [self.audioEngine setVisualizer:self.currentVisualizer];
    [self.view.layer addSublayer:self.currentVisualizer];
//    MPMusicPlayerController *controller;
//    MPMediaQuery *query;
    
}

- (void)didSwipe: (UISwipeGestureRecognizer *)sender {
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionUp: {
            break;
        }
        case UISwipeGestureRecognizerDirectionDown: {
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft: {
            break;
        }
        case UISwipeGestureRecognizerDirectionRight: {
            break;
        }
    }
}

- (void)didTap: (UITapGestureRecognizer *)sender {
//    [self.audioEngine playPause];
}

- (void)didPlayPause {
    [self.audioEngine playPause];
}

@end
