#import "YTLyricsViewController.h"
#import "YTLyricsWordLabel.h"
#import "YTLyricsManager.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "../Kit/YTGlassButton.h"
#import "../Kit/YTHapticManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPRemoteCommand (YTPrivate)
- (id)trigger;
- (id)trigger:(id)event;
@end

@interface YTLyricsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIVisualEffectView *glassBackground;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YTGlassButton *closeButton;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger lastLineIndex;
@property (nonatomic, assign) BOOL isLandscape;
@end

@implementation YTLyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    YTPresentDarkStyle(self);
    
    _lastLineIndex = -1;
    
    _glassBackground = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassBackground.frame = self.view.bounds;
    _glassBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_glassBackground];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.contentInset = UIEdgeInsetsMake(self.view.bounds.size.height / 3.0, 0, self.view.bounds.size.height / 3.0, 0);
    [self.view addSubview:_tableView];
    
    _closeButton = [[YTGlassButton alloc] initWithIconName:@"xmark" pointSize:16 isCapsule:NO];
    _closeButton.frame = CGRectMake(self.view.bounds.size.width - 24 - 44, 44, 44, 44);
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startSyncTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopSyncTimer];
}

- (void)startSyncTimer {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(syncTick)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopSyncTimer {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)syncTick {
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSDictionary *info = center.nowPlayingInfo;
    NSTimeInterval elapsed = [info[MPNowPlayingInfoPropertyElapsedPlaybackTime] doubleValue];
    float rate = [info[MPNowPlayingInfoPropertyPlaybackRate] floatValue];
    
    if (rate > 0) {
        NSDate *lastDate = info[MPNowPlayingInfoPropertyCurrentPlaybackDate];
        if (lastDate) {
            elapsed += [[NSDate date] timeIntervalSinceDate:lastDate];
        }
    }
    
    [[YTLyricsManager sharedManager] updatePlaybackTime:elapsed];
    NSInteger activeIdx = [YTLyricsManager sharedManager].currentLineIndex;
    
    if (activeIdx != _lastLineIndex && activeIdx >= 0) {
        _lastLineIndex = activeIdx;
        [_tableView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:activeIdx inSection:0];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YTLyricsManager sharedManager].currentLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LyricsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        YTLyricsWordLabel *label = [[YTLyricsWordLabel alloc] initWithFrame:cell.contentView.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.tag = 1001;
        [cell.contentView addSubview:label];
    }
    
    YTLyricsWordLabel *wordLabel = [cell.contentView viewWithTag:1001];
    YTLyricLine *line = [YTLyricsManager sharedManager].currentLines[indexPath.row];
    BOOL isCurrent = (indexPath.row == _lastLineIndex);
    
    [wordLabel setText:line.text font:[UIFont systemFontOfSize:26 weight:UIFontWeightBold]];
    wordLabel.isCurrentLine = isCurrent;
    wordLabel.progress = isCurrent ? 1.0 : 0.0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[YTHapticManager sharedManager] triggerSelection];
    YTLyricLine *line = [YTLyricsManager sharedManager].currentLines[indexPath.row];
    
    id seekCmd = [MPRemoteCommandCenter sharedCommandCenter].changePlaybackPositionCommand;
    id event = [[NSClassFromString(@"MPChangePlaybackPositionCommandEvent") alloc] init];
    @try {
        [event setValue:@(line.startTime) forKey:@"positionTime"];
        [event setValue:seekCmd forKey:@"command"];
        if ([seekCmd respondsToSelector:NSSelectorFromString(@"trigger:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [seekCmd performSelector:NSSelectorFromString(@"trigger:") withObject:event];
#pragma clang diagnostic pop
        }
    } @catch (NSException *e) {}
}

#pragma mark - Orientation & Immersive

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    BOOL landscape = (size.width > size.height);
    _isLandscape = landscape;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.closeButton.alpha = landscape ? 0.0 : 1.0;
    } completion:nil];
}

- (void)handleScreenTap {
    if (_isLandscape) {
        // In landscape immersive mode, tapping toggles controls visibility
        [UIView animateWithDuration:0.25 animations:^{
            self.closeButton.alpha = (self.closeButton.alpha == 0.0) ? 1.0 : 0.0;
        }];
    }
}

- (void)handleClose {
    [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleLight];
    [self stopSyncTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [self stopSyncTimer];
}

@end
