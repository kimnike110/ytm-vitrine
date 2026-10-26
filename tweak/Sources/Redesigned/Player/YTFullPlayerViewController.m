#import "YTFullPlayerViewController.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "YTPlayerMoreSheet.h"
#import "../Lyrics/YTLyricsViewController.h"
#import "../Kit/YTHapticManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPRemoteCommand (YTPrivate)
- (id)trigger;
- (id)trigger:(id)event;
@end

@interface YTFullPlayerViewController ()
@property (nonatomic, strong) UIImageView *backgroundBlurredArtView;
@property (nonatomic, strong) UIView *darkDimmingOverlay;
@property (nonatomic, strong) UIVisualEffectView *backgroundBlur;
@property (nonatomic, strong) YTGlassButton *likeButton;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation YTFullPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [YTTokens trueBlackColor];
    YTPresentDarkStyle(self);
    
    [self setupDynamicBackground];
    [self setupHeaderControls];
    [self setupArtwork];
    [self setupTrackInfo];
    [self setupScrubber];
    [self setupPlaybackControls];
    [self setupBottomAuxiliaryControls];
    
    // Swipe down to dismiss gesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)setupDynamicBackground {
    _backgroundBlurredArtView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundBlurredArtView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundBlurredArtView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_backgroundBlurredArtView];
    
    _backgroundBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _backgroundBlur.frame = self.view.bounds;
    _backgroundBlur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_backgroundBlur];
    
    _darkDimmingOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
    _darkDimmingOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.60];
    _darkDimmingOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_darkDimmingOverlay];
}

- (void)setupHeaderControls {
    UIView *grabber = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 40) / 2.0, 16, 40, 5)];
    grabber.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    grabber.layer.cornerRadius = 2.5;
    grabber.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:grabber];
}

- (void)setupArtwork {
    CGFloat artSize = MIN(self.view.bounds.size.width - 64, 340);
    _artworkView = [[YTPlayerArtworkView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - artSize) / 2.0, 70, artSize, artSize)];
    _artworkView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_artworkView];
}

- (void)setupTrackInfo {
    CGFloat startY = CGRectGetMaxY(_artworkView.frame) + 32;
    CGFloat width = self.view.bounds.size.width - 48;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, startY, width - 48, 28)];
    _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"Song Title";
    [self.view addSubview:_titleLabel];
    
    _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, startY + 30, width - 48, 22)];
    _artistLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _artistLabel.textColor = [YTTokens secondaryTextColor];
    _artistLabel.text = @"Artist Name";
    [self.view addSubview:_artistLabel];
    
    _likeButton = [[YTGlassButton alloc] initWithIconName:@"heart" pointSize:18 isCapsule:NO];
    _likeButton.frame = CGRectMake(self.view.bounds.size.width - 24 - 40, startY + 8, 40, 40);
    [_likeButton addTarget:self action:@selector(handleLikeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_likeButton];
}

- (void)setupScrubber {
    CGFloat startY = CGRectGetMaxY(_artistLabel.frame) + 24;
    _scrubber = [[YTGlassSlider alloc] initWithFrame:CGRectMake(24, startY, self.view.bounds.size.width - 48, 36)];
    __weak typeof(self) weakSelf = self;
    _scrubber.onSeek = ^(NSTimeInterval time) {
        [weakSelf seekToTime:time];
    };
    [self.view addSubview:_scrubber];
}

- (void)setupPlaybackControls {
    CGFloat startY = CGRectGetMaxY(_scrubber.frame) + 24;
    CGFloat centerX = self.view.bounds.size.width / 2.0;
    
    // Play / Pause (64pt)
    _playPauseButton = [[YTGlassButton alloc] initWithIconName:@"pause.fill" pointSize:26 isCapsule:NO];
    _playPauseButton.frame = CGRectMake(centerX - 32, startY, 64, 64);
    _playPauseButton.isProminent = YES;
    [_playPauseButton addTarget:self action:@selector(handlePlayPauseTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playPauseButton];
    
    // Previous (48pt)
    _prevButton = [[YTGlassButton alloc] initWithIconName:@"backward.fill" pointSize:20 isCapsule:NO];
    _prevButton.frame = CGRectMake(centerX - 32 - 48 - 28, startY + 8, 48, 48);
    [_prevButton addTarget:self action:@selector(handlePrevTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_prevButton];
    
    // Next (48pt)
    _nextButton = [[YTGlassButton alloc] initWithIconName:@"forward.fill" pointSize:20 isCapsule:NO];
    _nextButton.frame = CGRectMake(centerX + 32 + 28, startY + 8, 48, 48);
    [_nextButton addTarget:self action:@selector(handleNextTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}

- (void)setupBottomAuxiliaryControls {
    CGFloat startY = CGRectGetMaxY(_playPauseButton.frame) + 32;
    CGFloat spacing = (self.view.bounds.size.width - (4 * 44)) / 5.0;
    
    _shuffleButton = [[YTGlassButton alloc] initWithIconName:@"shuffle" pointSize:16 isCapsule:NO];
    _shuffleButton.frame = CGRectMake(spacing, startY, 44, 44);
    [self.view addSubview:_shuffleButton];
    
    _lyricsButton = [[YTGlassButton alloc] initWithIconName:@"quote.bubble.fill" pointSize:16 isCapsule:NO];
    _lyricsButton.frame = CGRectMake(spacing * 2 + 44, startY, 44, 44);
    [_lyricsButton addTarget:self action:@selector(handleLyricsTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lyricsButton];
    
    _repeatButton = [[YTGlassButton alloc] initWithIconName:@"repeat" pointSize:16 isCapsule:NO];
    _repeatButton.frame = CGRectMake(spacing * 3 + 88, startY, 44, 44);
    [self.view addSubview:_repeatButton];
    
    _moreButton = [[YTGlassButton alloc] initWithIconName:@"ellipsis" pointSize:16 isCapsule:NO];
    _moreButton.frame = CGRectMake(spacing * 4 + 132, startY, 44, 44);
    [_moreButton addTarget:self action:@selector(handleMoreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];
}

- (void)updateMetadataWithTitle:(NSString *)title
                         artist:(NSString *)artist
                        artwork:(nullable UIImage *)artwork
                      isPlaying:(BOOL)playing {
    _isPlaying = playing;
    _titleLabel.text = title.length ? title : @"Not Playing";
    _artistLabel.text = artist.length ? artist : @"YouTube Music";
    
    [_artworkView setImage:artwork animated:YES];
    if (artwork) {
        _backgroundBlurredArtView.image = artwork;
    }
    
    NSString *icon = playing ? @"pause.fill" : @"play.fill";
    [_playPauseButton setIconName:icon];
}

- (void)updatePlaybackProgress:(CGFloat)progress currentTime:(NSTimeInterval)current duration:(NSTimeInterval)duration {
    [_scrubber setProgress:progress currentTime:current duration:duration];
}

#pragma mark - Actions

- (void)handlePlayPauseTapped {
    [[YTHapticManager sharedManager] triggerSelection];
    MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
    if (_isPlaying) {
        [center.pauseCommand trigger];
    } else {
        [center.playCommand trigger];
    }
}

- (void)handlePrevTapped {
    [[YTHapticManager sharedManager] triggerSelection];
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand trigger];
}

- (void)handleNextTapped {
    [[YTHapticManager sharedManager] triggerSelection];
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand trigger];
}

- (void)seekToTime:(NSTimeInterval)time {
    id seekCmd = [MPRemoteCommandCenter sharedCommandCenter].changePlaybackPositionCommand;
    id event = [[NSClassFromString(@"MPChangePlaybackPositionCommandEvent") alloc] init];
    @try {
        [event setValue:@(time) forKey:@"positionTime"];
        [event setValue:seekCmd forKey:@"command"];
        if ([seekCmd respondsToSelector:NSSelectorFromString(@"trigger:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [seekCmd performSelector:NSSelectorFromString(@"trigger:") withObject:event];
#pragma clang diagnostic pop
        }
    } @catch (NSException *e) {}
}

- (void)handleLikeTapped {
    _isLiked = !_isLiked;
    [[YTHapticManager sharedManager] triggerSelection];
    NSString *icon = _isLiked ? @"heart.fill" : @"heart";
    [_likeButton setIconName:icon];
    _likeButton.iconImageView.tintColor = _isLiked ? [UIColor colorWithRed:1.0 green:0.25 blue:0.4 alpha:1.0] : [UIColor whiteColor];
}

- (void)handleLyricsTapped {
    [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleMedium];
    YTLyricsViewController *lyricsVC = [[YTLyricsViewController alloc] init];
    lyricsVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:lyricsVC animated:YES completion:nil];
}

- (void)handleMoreTapped {
    [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleLight];
    YTPlayerMoreSheet *sheet = [[YTPlayerMoreSheet alloc] init];
    if (@available(iOS 15.0, *)) {
        sheet.modalPresentationStyle = UIModalPresentationPageSheet;
        sheet.sheetPresentationController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
        sheet.sheetPresentationController.prefersGrabberVisible = YES;
    } else {
        sheet.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    __weak typeof(self) weakSelf = self;
    sheet.onToggleLyrics = ^{
        [weakSelf handleLyricsTapped];
    };
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)handleDismissPan:(UIPanGestureRecognizer *)gesture {
    CGPoint trans = [gesture translationInView:self.view];
    if (trans.y > 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, trans.y);
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (trans.y > 140) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

@end
