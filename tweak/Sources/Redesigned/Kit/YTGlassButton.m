#import "YTGlassButton.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "YTHapticManager.h"

@interface YTGlassButton ()
@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIView *highlightFilm;
@end

@implementation YTGlassButton

- (instancetype)initWithIconName:(NSString *)iconName pointSize:(CGFloat)size isCapsule:(BOOL)capsule {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _isCapsule = capsule;
        [self setupViewsWithIcon:iconName pointSize:size];
    }
    return self;
}

- (void)setupViewsWithIcon:(NSString *)iconName pointSize:(CGFloat)size {
    self.backgroundColor = [UIColor clearColor];
    
    _glassView = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _glassView.frame = self.bounds;
    _glassView.userInteractionEnabled = NO;
    [self addSubview:_glassView];
    
    _highlightFilm = [[UIView alloc] initWithFrame:self.bounds];
    _highlightFilm.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _highlightFilm.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
    _highlightFilm.userInteractionEnabled = NO;
    _highlightFilm.alpha = 0.0;
    [self addSubview:_highlightFilm];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.tintColor = [UIColor whiteColor];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_iconImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [_iconImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    [self setIconName:iconName pointSize:size];
    YTApplyGlassBorder(self);
}

- (void)setIconName:(NSString *)iconName pointSize:(CGFloat)size {
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:size weight:UIImageSymbolWeightBold];
        _iconImageView.image = [UIImage systemImageNamed:iconName withConfiguration:config];
    }
}

- (void)setIconName:(NSString *)iconName {
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightBold];
        _iconImageView.image = [UIImage systemImageNamed:iconName withConfiguration:config];
    }
}

- (void)setIsProminent:(BOOL)isProminent {
    _isProminent = isProminent;
    _highlightFilm.alpha = isProminent ? 0.22 : 0.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat r = _isCapsule ? (self.bounds.size.height / 2.0) : (self.bounds.size.width / 2.0);
    YTShapeGlassView(self, r, _isCapsule);
    YTShapeGlassView(_glassView, r, _isCapsule);
    YTShapeGlassView(_highlightFilm, r, _isCapsule);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [[YTHapticManager sharedManager] triggerImpact:UIImpactFeedbackStyleLight];
    }
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = highlighted ? CGAffineTransformMakeScale(0.92, 0.92) : CGAffineTransformIdentity;
        self.alpha = highlighted ? 0.75 : 1.0;
    } completion:nil];
}

@end
