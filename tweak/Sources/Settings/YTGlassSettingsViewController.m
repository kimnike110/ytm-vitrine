#import "YTGlassSettingsViewController.h"
#import "YTSettingsManager.h"
#import "../Core/YTGlass.h"
#import "../Core/YTTokens.h"
#import "../Redesigned/Kit/YTGlassCardView.h"
#import "../Redesigned/Kit/YTHapticManager.h"

@interface YTGlassSettingsViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation YTGlassSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Vitrine Settings";
    self.view.backgroundColor = [YTTokens trueBlackColor];
    YTPresentDarkStyle(self);
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        appearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(dismissSelf)];
    doneBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    [self setupContent];
}

- (void)dismissSelf {
    [[YTSettingsManager sharedManager] save];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupContent {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    _stackView = [[UIStackView alloc] init];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 18;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor constant:16],
        [_stackView.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:16],
        [_stackView.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-16],
        [_stackView.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor constant:-32],
        [_stackView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor constant:-32]
    ]];
    
    // Header Banner
    [self addBannerCard];
    
    // 1. LIQUID GLASS & APPEARANCE
    [self addSectionTitle:@"LIQUID GLASS & APPEARANCE"];
    YTGlassCardView *visualCard = [[YTGlassCardView alloc] init];
    UIStackView *vStack = [self createCardStack];
    [visualCard.contentView addSubview:vStack];
    [self pinToCard:vStack inCard:visualCard];
    
    BOOL hasNative = YTHasNativeGlass();
    [self addToggleToStack:vStack
                     title:@"Liquid Glass UI (iOS 26+)"
                  subtitle:hasNative ? @"UIGlassEffect active" : @"iOS 26+ required (using high-res dark blur fallback)"
                     value:[YTSettingsManager sharedManager].isRedesignEnabled
                   enabled:hasNative
                    action:@selector(redesignToggled:)];
    
    [self addDividerToStack:vStack];
    [self addToggleToStack:vStack
                     title:@"True Black AMOLED"
                  subtitle:@"Pure #000000 base background on all views"
                     value:[YTSettingsManager sharedManager].isTrueBlackEnabled
                   enabled:YES
                    action:@selector(trueBlackToggled:)];
    
    [self addDividerToStack:vStack];
    [self addToggleToStack:vStack
                     title:@"Glass Specular Highlight"
                  subtitle:@"Subtle borders and light reflections on glass edges"
                     value:[YTSettingsManager sharedManager].isGlassGlowEnabled
                   enabled:YES
                    action:@selector(glassGlowToggled:)];
    
    [_stackView addArrangedSubview:visualCard];
    
    // 2. NAVIGATION & TAB BAR
    [self addSectionTitle:@"NAVIGATION & TAB BAR"];
    YTGlassCardView *navCard = [[YTGlassCardView alloc] init];
    UIStackView *navStack = [self createCardStack];
    [navCard.contentView addSubview:navStack];
    [self pinToCard:navStack inCard:navCard];
    
    [self addToggleToStack:navStack
                     title:@"Mini Player Inside Tab Bar"
                  subtitle:@"Apple Music style player nested inside floating glass bar"
                     value:[YTSettingsManager sharedManager].isMiniPlayerInTabBar
                   enabled:YES
                    action:@selector(miniPlayerToggled:)];
    
    [self addDividerToStack:navStack];
    [self addToggleToStack:navStack
                     title:@"Floating Glass Bar"
                  subtitle:@"Floats above content with 16pt margin and rounded corners"
                     value:[YTSettingsManager sharedManager].isFloatingTabBar
                   enabled:YES
                    action:@selector(floatingTabToggled:)];
    
    [_stackView addArrangedSubview:navCard];
    
    // 3. FULL PLAYER & ANIMATED ARTWORK
    [self addSectionTitle:@"PLAYER & MOTION"];
    YTGlassCardView *playerCard = [[YTGlassCardView alloc] init];
    UIStackView *pStack = [self createCardStack];
    [playerCard.contentView addSubview:pStack];
    [self pinToCard:pStack inCard:playerCard];
    
    [self addToggleToStack:pStack
                     title:@"Animated Fluid Canvas Artwork"
                  subtitle:@"Plays dynamic animated cover/video backdrop with 60% dimming"
                     value:[YTSettingsManager sharedManager].isAnimatedArtworkEnabled
                   enabled:YES
                    action:@selector(animatedArtToggled:)];
    
    [self addDividerToStack:pStack];
    [self addToggleToStack:pStack
                     title:@"Haptic Feedback"
                  subtitle:@"Tactile response on playback controls and scrubbing"
                     value:[YTSettingsManager sharedManager].isHapticsEnabled
                   enabled:YES
                    action:@selector(hapticsToggled:)];
    
    [_stackView addArrangedSubview:playerCard];
    
    // 4. KARAOKE SYNCHRONIZED LYRICS
    [self addSectionTitle:@"WORD-BY-WORD LYRICS"];
    YTGlassCardView *lyricsCard = [[YTGlassCardView alloc] init];
    UIStackView *lStack = [self createCardStack];
    [lyricsCard.contentView addSubview:lStack];
    [self pinToCard:lStack inCard:lyricsCard];
    
    [self addToggleToStack:lStack
                     title:@"Word-by-Word Animation"
                  subtitle:@"Real-time glowing word sweep as lines are sung"
                     value:[YTSettingsManager sharedManager].isWordByWordLyrics
                   enabled:YES
                    action:@selector(wordLyricsToggled:)];
    
    [self addDividerToStack:lStack];
    [self addToggleToStack:lStack
                     title:@"Blur Inactive Lyrics"
                  subtitle:@"Focuses on the current line and smoothly dims others"
                     value:[YTSettingsManager sharedManager].isBlurInactiveLyrics
                   enabled:YES
                    action:@selector(blurLyricsToggled:)];
    
    [self addDividerToStack:lStack];
    [self addToggleToStack:lStack
                     title:@"Immersive Landscape Mode"
                  subtitle:@"Hides all player controls and displays full-screen lyrics"
                     value:[YTSettingsManager sharedManager].isImmersiveLandscape
                   enabled:YES
                    action:@selector(landscapeLyricsToggled:)];
    
    [_stackView addArrangedSubview:lyricsCard];
    
    // 5. AUDIO & ENHANCEMENTS
    [self addSectionTitle:@"AUDIO & ENHANCEMENTS"];
    YTGlassCardView *audioCard = [[YTGlassCardView alloc] init];
    UIStackView *aStack = [self createCardStack];
    [audioCard.contentView addSubview:aStack];
    [self pinToCard:aStack inCard:audioCard];
    
    [self addToggleToStack:aStack
                     title:@"Volume Boost (+6dB)"
                  subtitle:@"Increases maximum loudness for quiet tracks & headphones"
                     value:[YTSettingsManager sharedManager].isVolumeBoostEnabled
                   enabled:YES
                    action:@selector(volumeBoostToggled:)];
    
    [self addDividerToStack:aStack];
    [self addToggleToStack:aStack
                     title:@"Bass Warmth Enhancer"
                  subtitle:@"Rich low-frequency response with glass tuning"
                     value:[YTSettingsManager sharedManager].isBassBoostEnabled
                   enabled:YES
                    action:@selector(bassBoostToggled:)];
    
    [self addDividerToStack:aStack];
    [self addToggleToStack:aStack
                     title:@"3D Stereo Spatializer"
                  subtitle:@"Simulates acoustic crossfeed and headphone depth"
                     value:[YTSettingsManager sharedManager].isSpatializerEnabled
                   enabled:YES
                    action:@selector(spatializerToggled:)];
    
    [_stackView addArrangedSubview:audioCard];
    
    // 6. ABOUT
    [self addSectionTitle:@"ABOUT YTMVITRINE"];
    YTGlassCardView *aboutCard = [[YTGlassCardView alloc] init];
    UIStackView *aboutStack = [self createCardStack];
    [aboutCard.contentView addSubview:aboutStack];
    [self pinToCard:aboutStack inCard:aboutCard];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"YTMVitrine v%@", @YTM_VERSION];
    versionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    versionLabel.textColor = [UIColor whiteColor];
    [aboutStack addArrangedSubview:versionLabel];
    
    UILabel *creditLabel = [[UILabel alloc] init];
    creditLabel.text = @"Direct port of Chroma.pw / Vitrine's Liquid Glass UI to YouTube Music iOS.\nDeveloped with Theos & Cyan.";
    creditLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    creditLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    creditLabel.numberOfLines = 0;
    [aboutStack addArrangedSubview:creditLabel];
    
    [_stackView addArrangedSubview:aboutCard];
}

- (void)addBannerCard {
    YTGlassCardView *banner = [[YTGlassCardView alloc] init];
    banner.layer.borderColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.4 alpha:0.5].CGColor;
    banner.layer.borderWidth = 1.0;
    
    UIStackView *content = [[UIStackView alloc] init];
    content.axis = UILayoutConstraintAxisVertical;
    content.spacing = 6;
    content.translatesAutoresizingMaskIntoConstraints = NO;
    [banner.contentView addSubview:content];
    [self pinToCard:content inCard:banner];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"✨ Liquid Glass Experience";
    title.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [content addArrangedSubview:title];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.text = @"1:1 visual match of Chroma.pw (Vitrine) with Apple Music-style floating player and real-time word-by-word karaoke lyrics.";
    desc.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    desc.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    desc.numberOfLines = 0;
    [content addArrangedSubview:desc];
    
    [_stackView addArrangedSubview:banner];
}

- (UIStackView *)createCardStack {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 14;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    return stack;
}

- (void)pinToCard:(UIView *)view inCard:(UIView *)card {
    [NSLayoutConstraint activateConstraints:@[
        [view.topAnchor constraintEqualToAnchor:card.topAnchor constant:16],
        [view.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [view.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
        [view.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-16]
    ]];
}

- (void)addSectionTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = title;
    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    lbl.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [_stackView addArrangedSubview:lbl];
}

- (void)addDividerToStack:(UIStackView *)stack {
    UIView *div = [[UIView alloc] init];
    div.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    div.translatesAutoresizingMaskIntoConstraints = NO;
    [div.heightAnchor constraintEqualToConstant:0.5].active = YES;
    [stack addArrangedSubview:div];
}

- (void)addToggleToStack:(UIStackView *)stack
                   title:(NSString *)title
                subtitle:(NSString *)subtitle
                   value:(BOOL)val
                 enabled:(BOOL)enabled
                  action:(SEL)action {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    row.spacing = 12;
    
    UIStackView *textStack = [[UIStackView alloc] init];
    textStack.axis = UILayoutConstraintAxisVertical;
    textStack.spacing = 3;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    titleLabel.textColor = enabled ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.4];
    [textStack addArrangedSubview:titleLabel];
    
    if (subtitle.length > 0) {
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.text = subtitle;
        subLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        subLabel.textColor = enabled ? [UIColor colorWithWhite:1.0 alpha:0.6] : [UIColor colorWithWhite:1.0 alpha:0.3];
        subLabel.numberOfLines = 0;
        [textStack addArrangedSubview:subLabel];
    }
    
    [row addArrangedSubview:textStack];
    
    UISwitch *toggle = [[UISwitch alloc] init];
    toggle.on = val;
    toggle.enabled = enabled;
    toggle.onTintColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.4 alpha:1.0];
    [toggle addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [row addArrangedSubview:toggle];
    
    [stack addArrangedSubview:row];
}

#pragma mark - Actions

- (void)redesignToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isRedesignEnabled = s.on; }
- (void)trueBlackToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isTrueBlackEnabled = s.on; }
- (void)glassGlowToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isGlassGlowEnabled = s.on; }
- (void)miniPlayerToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isMiniPlayerInTabBar = s.on; }
- (void)floatingTabToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isFloatingTabBar = s.on; }
- (void)animatedArtToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isAnimatedArtworkEnabled = s.on; }
- (void)hapticsToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isHapticsEnabled = s.on; }
- (void)wordLyricsToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isWordByWordLyrics = s.on; }
- (void)blurLyricsToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isBlurInactiveLyrics = s.on; }
- (void)landscapeLyricsToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isImmersiveLandscape = s.on; }
- (void)volumeBoostToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isVolumeBoostEnabled = s.on; }
- (void)bassBoostToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isBassBoostEnabled = s.on; }
- (void)spatializerToggled:(UISwitch *)s { [[YTHapticManager sharedManager] triggerSelection]; [YTSettingsManager sharedManager].isSpatializerEnabled = s.on; }

@end
