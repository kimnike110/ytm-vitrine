#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YTTHooksBridge.h"
#import "../Core/YTGlass.h"
#import "../Core/YTRuntime.h"
#import "../Core/YTTokens.h"
#import "../Settings/YTSettingsManager.h"
#import "../Settings/YTGlassSettingsViewController.h"
#import "../Redesigned/Lyrics/YTLyricsViewController.h"
#import "../Redesigned/Lyrics/YTLyricsManager.h"
#import "../Redesigned/Kit/YTHapticManager.h"

// Forward declarations
@interface YTPivotBarViewController : UIViewController
@end

@interface YTPivotBarView : UIView
- (void)ytm_handleTabBarLongPress:(UILongPressGestureRecognizer *)gesture;
@end

@interface YTMTabViewController : UIViewController
@end

@interface YTLightweightBrowseBackgroundView : UIView
@end

@interface YTMWatchViewController : UIViewController
@property (nonatomic, strong) UIView *view;
@end

@interface YTMMiniPlayerView : UIView
@end

@interface YTMPlayerControlsView : UIView
@end

@interface YTMPlayerHeaderViewController : UIViewController
@end

// State references
static __weak YTMWatchViewController *sCurrentWatchVC = nil;
static __weak UIImageView *sWatchArtworkBackdrop = nil;
static __weak UIVisualEffectView *sWatchGlassBlur = nil;
static __weak UIButton *sWatchLyricsButton = nil;
static UIImage *sLatestArtworkImage = nil;
static BOOL sIsCurrentlyPlaying = NO;

UIWindow *YTGetKeyWindow(void) {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *win in windowScene.windows) {
                    if (win.isKeyWindow) return win;
                }
            }
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

void YTOpenVitrineSettings(void) {
    [[YTHapticManager sharedManager] triggerSelection];
    UIWindow *win = YTGetKeyWindow();
    UIViewController *top = win.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    if (!top) return;
    
    YTGlassSettingsViewController *vc = [[YTGlassSettingsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    YTPresentDarkStyle(nav);
    [top presentViewController:nav animated:YES completion:nil];
}

void YTOpenVitrineLyrics(void) {
    [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleMedium];
    UIWindow *win = YTGetKeyWindow();
    UIViewController *top = win.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    if (!top) return;
    
    YTLyricsViewController *vc = [[YTLyricsViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    YTPresentDarkStyle(vc);
    [top presentViewController:vc animated:YES completion:nil];
}

static UIImageView *YTFindMainArtworkView(UIView *root) {
    if (!root) return nil;
    if ([root isKindOfClass:[UIImageView class]]) {
        UIImageView *iv = (UIImageView *)root;
        if (iv.bounds.size.width >= 160 && iv.bounds.size.height >= 160) {
            return iv;
        }
    }
    for (UIView *sub in root.subviews) {
        UIImageView *found = YTFindMainArtworkView(sub);
        if (found) return found;
    }
    return nil;
}

static void YTAnimateArtworkScale(UIView *artView, BOOL isPlaying) {
    if (!artView) return;
    CGFloat targetScale = isPlaying ? 1.0 : 0.85;
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        artView.transform = isPlaying ? CGAffineTransformIdentity : CGAffineTransformMakeScale(targetScale, targetScale);
    } completion:nil];
}

#pragma mark - 1. Liquid Glass Tab Bar (Lag-Free)

%hook YTPivotBarView

- (void)didMoveToWindow {
    %orig;
    if (!self.window) return;
    
    self.backgroundColor = [UIColor clearColor];
    
    // Add long-press gesture to open Vitrine Settings (0.4s)
    static char kLongPressKey;
    if (!objc_getAssociatedObject(self, &kLongPressKey)) {
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ytm_handleTabBarLongPress:)];
        lp.minimumPressDuration = 0.40;
        [self addGestureRecognizer:lp];
        objc_setAssociatedObject(self, &kLongPressKey, lp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

%new
- (void)ytm_handleTabBarLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleHeavy];
        YTOpenVitrineSettings();
    }
}

- (void)layoutSubviews {
    %orig;
    
    if (![YTSettingsManager sharedManager].isRedesignEnabled) return;
    
    self.backgroundColor = [UIColor clearColor];
    
    static const char kPivotGlassKey;
    UIVisualEffectView *glass = YTGlassForView(self, &kPivotGlassKey);
    if (!CGRectEqualToRect(glass.frame, self.bounds)) {
        glass.frame = self.bounds;
        YTShapeGlassView(glass, 22.0, NO);
    }
}

%end

#pragma mark - 2. Liquid Glass Mini Player (Lag-Free)

%hook YTMMiniPlayerView

- (void)didMoveToWindow {
    %orig;
    if (!self.window) return;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    %orig;
    
    if (![YTSettingsManager sharedManager].isRedesignEnabled) return;
    
    self.backgroundColor = [UIColor clearColor];
    
    static const char kMiniPlayerGlassKey;
    UIVisualEffectView *glass = YTGlassForView(self, &kMiniPlayerGlassKey);
    if (!CGRectEqualToRect(glass.frame, self.bounds)) {
        glass.frame = self.bounds;
        YTShapeGlassView(glass, 14.0, NO);
    }
}

%end

#pragma mark - 3. YouTube Music Watch & Full Player Redesign

%hook YTMWatchViewController

- (void)viewDidLoad {
    %orig;
    sCurrentWatchVC = self;
    
    if ([YTSettingsManager sharedManager].isTrueBlackEnabled) {
        self.view.backgroundColor = [YTTokens trueBlackColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    %orig(animated);
    sCurrentWatchVC = self;
    
    if (![YTSettingsManager sharedManager].isRedesignEnabled) return;
    
    // Add Dynamic Blurred Fluid Artwork background behind player
    if (!sWatchArtworkBackdrop || sWatchArtworkBackdrop.superview != self.view) {
        UIImageView *art = [[UIImageView alloc] initWithFrame:self.view.bounds];
        art.contentMode = UIViewContentModeScaleAspectFill;
        art.clipsToBounds = YES;
        art.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        art.layer.zPosition = -2;
        [self.view insertSubview:art atIndex:0];
        sWatchArtworkBackdrop = art;
        
        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blur.frame = self.view.bounds;
        blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blur.layer.zPosition = -1;
        
        UIView *dim = [[UIView alloc] initWithFrame:self.view.bounds];
        dim.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
        dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [blur.contentView addSubview:dim];
        
        [self.view insertSubview:blur atIndex:1];
        sWatchGlassBlur = blur;
    }
    
    if (sLatestArtworkImage) {
        sWatchArtworkBackdrop.image = sLatestArtworkImage;
    }
    
    // Add floating "🎤 Lyrics" button
    static const NSInteger kLyricsBtnTag = 887766;
    if (![self.view viewWithTag:kLyricsBtnTag]) {
        UIButton *lyricsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        lyricsBtn.tag = kLyricsBtnTag;
        lyricsBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
        lyricsBtn.layer.cornerRadius = 16.0;
        lyricsBtn.layer.borderWidth = 0.5;
        lyricsBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;
        lyricsBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 14, 6, 14);
        [lyricsBtn setTitle:@"🎤 Lyrics" forState:UIControlStateNormal];
        [lyricsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lyricsBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        [lyricsBtn addTarget:[YTTHooksBridge sharedBridge] action:@selector(openLyricsAction) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat topY = 54.0;
        if (@available(iOS 11.0, *)) {
            topY = MAX(54.0, self.view.safeAreaInsets.top + 8.0);
        }
        lyricsBtn.frame = CGRectMake(16.0, topY, 94.0, 32.0);
        [self.view addSubview:lyricsBtn];
        [self.view bringSubviewToFront:lyricsBtn];
        sWatchLyricsButton = lyricsBtn;
    }
    
    // Apply initial scale on artwork
    UIImageView *cover = YTFindMainArtworkView(self.view);
    if (cover) {
        YTAnimateArtworkScale(cover, sIsCurrentlyPlaying);
    }
}

- (void)viewDidLayoutSubviews {
    %orig;
    if (sWatchLyricsButton && self.view) {
        CGFloat topY = 54.0;
        if (@available(iOS 11.0, *)) {
            topY = MAX(54.0, self.view.safeAreaInsets.top + 8.0);
        }
        sWatchLyricsButton.frame = CGRectMake(16.0, topY, 94.0, 32.0);
        [self.view bringSubviewToFront:sWatchLyricsButton];
    }
}

%end

#pragma mark - 4. Playback Controls Glass Styling

%hook YTMPlayerControlsView

- (void)layoutSubviews {
    %orig;
    
    if (![YTSettingsManager sharedManager].isRedesignEnabled) return;
    
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.bounds.size.width > 44 && btn.bounds.size.height > 44) {
                if (btn.backgroundColor == nil || CGColorGetAlpha(btn.backgroundColor.CGColor) == 0) {
                    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
                    btn.layer.cornerRadius = btn.bounds.size.height / 2.0;
                    btn.clipsToBounds = YES;
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
                }
            }
        }
    }
}

%end

#pragma mark - 5. True Black AMOLED (Zero-Lag: set once in didMoveToWindow)

%hook YTLightweightBrowseBackgroundView

- (void)didMoveToWindow {
    %orig;
    if (self.window && [YTSettingsManager sharedManager].isTrueBlackEnabled) {
        self.backgroundColor = [YTTokens trueBlackColor];
    }
}

%end

%hook UICollectionView

- (void)didMoveToWindow {
    %orig;
    if (self.window && [YTSettingsManager sharedManager].isTrueBlackEnabled) {
        self.backgroundColor = [YTTokens trueBlackColor];
    }
}

%end

%hook UITableView

- (void)didMoveToWindow {
    %orig;
    if (self.window && [YTSettingsManager sharedManager].isTrueBlackEnabled) {
        self.backgroundColor = [YTTokens trueBlackColor];
    }
}

%end

#pragma mark - 6. Persistent Floating Glass "✨ Vitrine" Button

static void EnsureVitrineFloatingButton(void) {
    UIWindow *win = YTGetKeyWindow();
    if (!win) return;
    
    static const NSInteger kVitrineButtonTag = 998877;
    if ([win viewWithTag:kVitrineButtonTag]) return;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = kVitrineButtonTag;
    btn.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.75];
    btn.layer.cornerRadius = 16.0;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    btn.clipsToBounds = YES;
    btn.contentEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 12);
    [btn setTitle:@"✨ Vitrine" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    
    CGFloat topInset = 54.0;
    if (@available(iOS 11.0, *)) {
        if (win.safeAreaInsets.top > 0) {
            topInset = win.safeAreaInsets.top + 8.0;
        }
    }
    
    CGFloat w = 84.0;
    CGFloat h = 32.0;
    btn.frame = CGRectMake(win.bounds.size.width - w - 16.0, topInset, w, h);
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [btn addTarget:[YTTHooksBridge sharedBridge] action:@selector(openSettingsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [win addSubview:btn];
    [win bringSubviewToFront:btn];
}

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        EnsureVitrineFloatingButton();
    });
}

%end

#pragma mark - Bridge Implementation

@implementation YTTHooksBridge

+ (instancetype)sharedBridge {
    static YTTHooksBridge *b = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        b = [[YTTHooksBridge alloc] init];
    });
    return b;
}

- (void)openSettingsAction {
    YTOpenVitrineSettings();
}

- (void)openLyricsAction {
    YTOpenVitrineLyrics();
}

- (void)playbackUpdatedWithTitle:(NSString *)title
                          artist:(NSString *)artist
                         artwork:(UIImage *)artwork
                       isPlaying:(BOOL)isPlaying
                         elapsed:(NSTimeInterval)elapsed
                        duration:(NSTimeInterval)duration {
    sIsCurrentlyPlaying = isPlaying;
    if (artwork) {
        sLatestArtworkImage = artwork;
        if (sWatchArtworkBackdrop) {
            sWatchArtworkBackdrop.image = artwork;
        }
    }
    
    if (sCurrentWatchVC && sCurrentWatchVC.view) {
        UIImageView *cover = YTFindMainArtworkView(sCurrentWatchVC.view);
        if (cover) {
            YTAnimateArtworkScale(cover, isPlaying);
        }
    }
}

@end

%ctor {
    NSLog(@"[YTMVitrine] Chroma Liquid Glass Engine Loaded.");
}
