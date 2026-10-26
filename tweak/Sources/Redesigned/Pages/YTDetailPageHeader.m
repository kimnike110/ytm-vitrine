#import "YTDetailPageHeader.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"

@interface YTDetailPageHeader ()
@property (nonatomic, strong) CAGradientLayer *gradientOverlay;
@end

@implementation YTDetailPageHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [YTTokens trueBlackColor];
    
    _blurredBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _blurredBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _blurredBackgroundView.clipsToBounds = YES;
    _blurredBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_blurredBackgroundView];
    
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blur.frame = self.bounds;
    blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blur];
    
    _gradientOverlay = [CAGradientLayer layer];
    _gradientOverlay.colors = @[
        (id)[UIColor colorWithWhite:0.0 alpha:0.2].CGColor,
        (id)[UIColor colorWithWhite:0.0 alpha:0.85].CGColor
    ];
    _gradientOverlay.locations = @[@0.0, @1.0];
    [self.layer addSublayer:_gradientOverlay];
    
    _coverArtworkView = [[UIImageView alloc] init];
    _coverArtworkView.contentMode = UIViewContentModeScaleAspectFill;
    _coverArtworkView.layer.cornerRadius = 16.0;
    _coverArtworkView.clipsToBounds = YES;
    _coverArtworkView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_coverArtworkView];
    YTApplyGlassBorder(_coverArtworkView);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    _metadataLabel = [[UILabel alloc] init];
    _metadataLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _metadataLabel.textColor = [YTTokens secondaryTextColor];
    _metadataLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_metadataLabel];
    
    _playCapsuleButton = [[YTGlassButton alloc] initWithIconName:@"play.fill" pointSize:18 isCapsule:YES];
    _playCapsuleButton.isProminent = YES;
    _playCapsuleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playCapsuleButton];
    
    _shuffleButton = [[YTGlassButton alloc] initWithIconName:@"shuffle" pointSize:18 isCapsule:NO];
    _shuffleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_shuffleButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [_coverArtworkView.topAnchor constraintEqualToAnchor:self.topAnchor constant:54],
        [_coverArtworkView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_coverArtworkView.widthAnchor constraintEqualToConstant:180],
        [_coverArtworkView.heightAnchor constraintEqualToConstant:180],
        
        [_titleLabel.topAnchor constraintEqualToAnchor:_coverArtworkView.bottomAnchor constant:18],
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        
        [_metadataLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:4],
        [_metadataLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        
        [_playCapsuleButton.topAnchor constraintEqualToAnchor:_metadataLabel.bottomAnchor constant:16],
        [_playCapsuleButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40],
        [_playCapsuleButton.trailingAnchor constraintEqualToAnchor:_shuffleButton.leadingAnchor constant:-16],
        [_playCapsuleButton.heightAnchor constraintEqualToConstant:46],
        
        [_shuffleButton.centerYAnchor constraintEqualToAnchor:_playCapsuleButton.centerYAnchor],
        [_shuffleButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40],
        [_shuffleButton.widthAnchor constraintEqualToConstant:46],
        [_shuffleButton.heightAnchor constraintEqualToConstant:46]
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientOverlay.frame = self.bounds;
}

- (void)configureWithTitle:(NSString *)title
                  metadata:(NSString *)metadata
                   artwork:(nullable UIImage *)artwork {
    _titleLabel.text = title;
    _metadataLabel.text = metadata;
    _coverArtworkView.image = artwork;
    _blurredBackgroundView.image = artwork;
}

@end
