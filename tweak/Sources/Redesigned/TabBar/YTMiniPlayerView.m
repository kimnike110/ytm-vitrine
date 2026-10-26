#import "YTMiniPlayerView.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "../Kit/YTHapticManager.h"

@interface YTMiniPlayerView ()
@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIStackView *textStack;
@end

@implementation YTMiniPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.06];
    
    _glassView = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _glassView.frame = self.bounds;
    _glassView.userInteractionEnabled = NO;
    [self addSubview:_glassView];
    
    _artworkView = [[UIImageView alloc] init];
    _artworkView.contentMode = UIViewContentModeScaleAspectFill;
    _artworkView.layer.cornerRadius = 8.0;
    _artworkView.clipsToBounds = YES;
    _artworkView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    _artworkView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_artworkView];
    
    _textStack = [[UIStackView alloc] init];
    _textStack.axis = UILayoutConstraintAxisVertical;
    _textStack.spacing = 2;
    _textStack.alignment = UIStackViewAlignmentLeading;
    _textStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_textStack];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_textStack addArrangedSubview:_titleLabel];
    
    _artistLabel = [[UILabel alloc] init];
    _artistLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _artistLabel.textColor = [YTTokens secondaryTextColor];
    _artistLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_textStack addArrangedSubview:_artistLabel];
    
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _playPauseButton.tintColor = [UIColor whiteColor];
    _playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_playPauseButton addTarget:self action:@selector(handlePlayPause) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playPauseButton];
    
    [self setPlayPauseIconPlaying:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [_artworkView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [_artworkView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_artworkView.widthAnchor constraintEqualToConstant:40],
        [_artworkView.heightAnchor constraintEqualToConstant:40],
        
        [_playPauseButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [_playPauseButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_playPauseButton.widthAnchor constraintEqualToConstant:36],
        [_playPauseButton.heightAnchor constraintEqualToConstant:36],
        
        [_textStack.leadingAnchor constraintEqualToAnchor:_artworkView.trailingAnchor constant:10],
        [_textStack.trailingAnchor constraintEqualToAnchor:_playPauseButton.leadingAnchor constant:-8],
        [_textStack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
    
    YTShapeGlassView(self, [YTTokens miniPlayerCornerRadius], NO);
    YTApplyGlassBorder(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    YTShapeGlassView(self, [YTTokens miniPlayerCornerRadius], NO);
    YTShapeGlassView(_glassView, [YTTokens miniPlayerCornerRadius], NO);
}

- (void)setPlayPauseIconPlaying:(BOOL)playing {
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:18 weight:UIImageSymbolWeightBold];
        NSString *name = playing ? @"pause.fill" : @"play.fill";
        [_playPauseButton setImage:[UIImage systemImageNamed:name withConfiguration:config] forState:UIControlStateNormal];
    }
}

- (void)updateWithTitle:(NSString *)title
                 artist:(NSString *)artist
                artwork:(nullable UIImage *)artwork
              isPlaying:(BOOL)playing {
    _titleLabel.text = title.length ? title : @"Not Playing";
    _artistLabel.text = artist.length ? artist : @"YouTube Music";
    if (artwork) {
        _artworkView.image = artwork;
    } else {
        _artworkView.image = nil;
    }
    [self setPlayPauseIconPlaying:playing];
}

- (void)handleTap {
    [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleLight];
    if (self.onTap) {
        self.onTap();
    }
}

- (void)handlePlayPause {
    [[YTHapticManager sharedManager] triggerSelection];
    if (self.onPlayPauseTap) {
        self.onPlayPauseTap();
    }
}

@end
