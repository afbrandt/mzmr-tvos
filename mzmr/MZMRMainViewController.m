//
//  ViewController.m
//  mzmr
//
//  Created by Andrew Brandt on 12/21/15.
//  Copyright © 2015 Dory Studios. All rights reserved.
//

#import "MZMRMainViewController.h"
#import "MZMRCurrentlyPlayingView.h"

#import "MZMRVisualizer.h"
#import "MZMRAudioSource.h"
#import "MZMRAudioEngine.h"

#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, MZMRSecondaryMenuType) {
    MZMRSecondaryMenuTypePlay,
    MZMRSecondaryMenuTypeVisualizer,
    MZMRSecondaryMenuTypeSettings
};

@interface MZMRMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *primaryMenu;
@property (weak, nonatomic) IBOutlet UIView *secondaryMenu;
@property (weak, nonatomic) IBOutlet UIView *primaryMenuContainer;
@property (weak, nonatomic) IBOutlet UITableView *primaryMenuTable;
@property (weak, nonatomic) IBOutlet UITableView *secondaryMenuTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryMenuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryMenuLeadingEdge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondaryMenuWidth;

@property (weak, nonatomic) UITableView *focusedTable;

@property (strong, nonatomic) MZMRAudioEngine *audioEngine;
@property (strong, nonatomic) id<MZMRVisualizer> currentVisualizer;
@property (strong, nonatomic) NSString *visualizerName;

@property (strong, nonatomic) NSTimer *hideTimer;
@property (strong, nonatomic) MZMRCurrentlyPlayingView *currentlyPlayingView;

@property (assign, nonatomic) NSInteger menuDepth;
@property (assign, nonatomic) NSInteger menuIndex;

@property (strong, nonatomic) NSArray *secondaryMenuContents;
@property (assign, nonatomic) MZMRSecondaryMenuType secondaryMenuType;

@end

@implementation MZMRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.audioEngine = [MZMRAudioEngine new];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.primaryMenuWidth.constant = width/8;
    self.secondaryMenuWidth.constant = width/8;
    self.primaryMenuLeadingEdge.constant = width/-6;
    
    self.menuDepth = 0;
    self.menuIndex = 0;
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MZMRCurrentlyPlayingView" owner:self options:nil];
    if ([nibs count] > 0) {
        MZMRCurrentlyPlayingView *currentPlayView = nibs[0];
        CGFloat height = currentPlayView.frame.size.height;
        currentPlayView.frame = CGRectMake(0, self.primaryMenuTable.frame.origin.y-height, self.primaryMenuWidth.constant, height);
        [self.primaryMenuContainer addSubview:currentPlayView];
        self.currentlyPlayingView = currentPlayView;
    }
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipe2.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe2];
    
    UISwipeGestureRecognizer *swipe3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipe3.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe3];
    
    UISwipeGestureRecognizer *swipe4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipe4.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe4];
    
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
    
    [self updateVisualizerToNamed:@"MZMRVisualizerOscilloscope"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
    [self.primaryMenuTable addGestureRecognizer:tap];
    
//    self.currentVisualizer = [[MZMRVisualizerOscilloscope alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo];
//    self.currentVisualizer.layer.bounds = self.view.frame;
//    
//    [self.audioEngine setVisualizer:self.currentVisualizer];
//    [self.view.layer addSublayer:self.currentVisualizer.layer];
//    MPMusicPlayerController *controller;
//    MPMediaQuery *query;
}

- (void)didSwipe: (UISwipeGestureRecognizer *)sender {
    if (self.menuDepth == 0) {
        [self updateMenuVisible: YES];
    } else {
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirectionUp: {
                
                break;
            }
            case UISwipeGestureRecognizerDirectionDown: {
                break;
            }
            case UISwipeGestureRecognizerDirectionLeft: {
                if (self.primaryMenuTable.isFocused) {
                    [self collapseMenu];
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionRight: {
                break;
            }
        }
    }
}

- (void)didTap: (UITapGestureRecognizer *)sender {
//    [self.audioEngine playPause];
//    switch (self.menuDepth) {
//        case 1: {
//            [self updateSecondaryMenuVisible: YES];
//        }
//        case 2: {
//            [self didSelectSecondaryItem];
//        }
//        default: {
//            [self updateMenuVisible:YES];
//            break;
//        }
//    }
    if (self.primaryMenuTable == self.focusedTable) {
        
    } else if (self.secondaryMenuTable == self.focusedTable) {
        [self didSelectSecondaryItem];
        
    }
}

- (void)didPlayPause {
    [self.audioEngine playPause];
}

- (void)didSelectSecondaryItem {
//    NSIndexPath *selectedItem = self.secondaryMenuTable.indexPathForSelectedRow;
    NSDictionary *selectedDictionary = self.secondaryMenuContents[self.menuIndex];
    NSString *itemName = @"Unknown";
    switch (self.secondaryMenuType) {
        case MZMRSecondaryMenuTypeVisualizer: {
            NSString *class = selectedDictionary[@"className"];
            itemName = selectedDictionary[@"labelName"];
            if (![self.visualizerName isEqualToString:itemName]) {
                [self updateVisualizerToNamed:class];
                self.visualizerName = itemName;
            }
        }
        default: break;
    }
    NSLog(@"Selected Secondary Item %lu : %@", self.menuIndex, itemName);
}

- (void)updateVisualizerToNamed: (NSString *)visualizerName {
    
    //TODO: support layered layers
    if (self.currentVisualizer) {
        [self.currentVisualizer.layer removeFromSuperlayer];
    }
    
    Class visualizerClass = NSClassFromString(visualizerName);
    if (visualizerClass && [visualizerClass conformsToProtocol:@protocol(MZMRVisualizer)]) {
        id<MZMRVisualizer> vo = [[visualizerClass alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo];
        self.currentVisualizer = vo;
        
        self.currentVisualizer.layer.backgroundColor = [UIColor blackColor].CGColor;
        self.currentVisualizer.layer.bounds = self.view.frame;
        self.currentVisualizer.layer.anchorPoint = CGPointMake(0, 0);
        
        [self.audioEngine setVisualizer:self.currentVisualizer];
        [self.view.layer insertSublayer:self.currentVisualizer.layer atIndex:0];
    } else {
        //TODO: choose basic visualizer
    }
    
    NSLog(@"Presented Visualizer Class : %@", visualizerName);
}

- (void)collapseMenu {
    if (self.menuDepth == 1) {
        [self updateMenuVisible:NO];
    } else if (self.menuDepth == 2) {
        [self updateSecondaryMenuVisible:NO];
    }
}

- (void)updateMenuVisible: (BOOL)visible {
    if (visible && self.menuDepth == 0) {
        self.menuDepth = 1;
        self.primaryMenuLeadingEdge.constant = 0;
    } else if (!visible && self.menuDepth > 0) {
        self.menuDepth = 0;
        self.primaryMenuLeadingEdge.constant = self.primaryMenuWidth.constant * -1.2;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
        
        }
    }];
}

- (void)updateSecondaryMenuVisible: (BOOL)visible {
    UITableView *focusedTable;
    NSInteger newDepth;
    if (visible) {
        self.secondaryMenuWidth.constant = self.primaryMenuWidth.constant;
        focusedTable = self.secondaryMenuTable;
        newDepth = 2;
    } else {
        self.secondaryMenuWidth.constant = 0;
        focusedTable = self.primaryMenuTable;
        newDepth = 1;
    }
    
//    [self loadSecondaryMenuForType: self.secondaryMenuType];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateFocusOnMenu:focusedTable];
            self.menuDepth = newDepth;
        }
    }];
}

- (void)updateFocusOnMenu: (UITableView *)menu {
    [menu reloadData];
    [self updateFocusIfNeeded];
}

- (void)updateSecondaryMenuType: (MZMRSecondaryMenuType)type {
    NSArray *contents = [self loadSecondaryMenuForType:type];
    self.secondaryMenuContents = contents;
    [self.secondaryMenuTable reloadData];
}

- (NSArray *)loadSecondaryMenuForType: (MZMRSecondaryMenuType)type {
    NSArray *arr;
    switch (type) {
        case MZMRSecondaryMenuTypePlay: {
            arr = @[@"First",@"Second",@"Third"];
            break;
        }
        case MZMRSecondaryMenuTypeSettings: {
            arr = @[@"First",@"Second",@"Third"];
            break;
        }
        case MZMRSecondaryMenuTypeVisualizer: {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"Visualizers" withExtension:@"plist"];
            arr = [NSArray arrayWithContentsOfURL:url];
            break;
        }
    }
    return arr;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.primaryMenuTable) {
        return 3;
    } else if (tableView == self.secondaryMenuTable) {
        return [self.secondaryMenuContents count];
//        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.primaryMenuTable) {
        cell = [UITableViewCell new];
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"Play";
                break;
            }
            case 1: {
                cell.textLabel.text = @"Visualizer";
                break;
            }
            case 2: {
                cell.textLabel.text = @"Settings";
                break;
            }
            default: break;
        }
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:0.3];
        return cell;
    } else if (tableView == self.secondaryMenuTable) {
        cell = [UITableViewCell new];
//        cell.textLabel.textColor = [UIColor whiteColor];
        if (self.secondaryMenuType == MZMRSecondaryMenuTypeVisualizer) {
            NSDictionary *visualizer = self.secondaryMenuContents[indexPath.row];
            cell.textLabel.text = visualizer[@"labelName"];
        } else {
            cell.textLabel.text = @"Secondary";
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
//    NSLog(@"focus updated");
    NSIndexPath *path = [context nextFocusedIndexPath];
    NSString *menuSelected, *itemSelected;
    itemSelected = [NSString stringWithFormat:@"Item %lu",path.row];
    if (path && tableView == self.primaryMenuTable) {
        menuSelected = @"Primary Menu";
        switch (path.row) {
            case 0: {
                self.secondaryMenuType = MZMRSecondaryMenuTypePlay;
                break;
            }
            case 1: {
                self.secondaryMenuType = MZMRSecondaryMenuTypeVisualizer;
                break;
            }
            case 2: {
                self.secondaryMenuType = MZMRSecondaryMenuTypeSettings;
                break;
            }
            default: break;
        }
        
        self.focusedTable = tableView;
        
        [self updateSecondaryMenuType:self.secondaryMenuType];
        
    } else if (path && tableView == self.secondaryMenuTable) {
        self.focusedTable = tableView;
        self.menuIndex = path.row;
        menuSelected = @"Secondary Menu";
    }
    NSLog(@"%@ : %@", menuSelected, itemSelected);
}


@end
