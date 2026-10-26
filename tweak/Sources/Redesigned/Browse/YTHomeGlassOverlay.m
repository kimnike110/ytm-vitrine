#import "YTHomeGlassOverlay.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"

@interface YTHomeGlassOverlay ()
@property (nonatomic, strong) UIVisualEffectView *glassView;
@end

@implementation YTHomeGlassOverlay

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _glassView = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _glassView.frame = self.bounds;
    _glassView.userInteractionEnabled = NO;
    [self addSubview:_glassView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Listen Now";
    _titleLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    _profileAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _profileAvatarButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
    _profileAvatarButton.layer.cornerRadius = 18.0;
    _profileAvatarButton.clipsToBounds = YES;
    _profileAvatarButton.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 13.0, *)) {
        UIImage *pImg = [UIImage systemImageNamed:@"person.crop.circle.fill"];
        [_profileAvatarButton setImage:pImg forState:UIControlStateNormal];
        _profileAvatarButton.tintColor = [UIColor whiteColor];
    }
    [self addSubview:_profileAvatarButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [_titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-12],
        
        [_profileAvatarButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [_profileAvatarButton.centerYAnchor constraintEqualToAnchor:_titleLabel.centerYAnchor],
        [_profileAvatarButton.widthAnchor constraintEqualToConstant:36],
        [_profileAvatarButton.heightAnchor constraintEqualToConstant:36]
    ]];
    
    YTApplyGlassBorder(self);
}

- (void)updateCollapseWithScrollOffset:(CGFloat)offset {
    CGFloat maxCollapse = 40.0;
    CGFloat progress = MAX(0.0, MIN(1.0, offset / maxCollapse));
    
    CGFloat targetSize = 34.0 - (progress * 14.0); // Collapses to 20pt title
    _titleLabel.font = [UIFont systemFontOfSize:targetSize weight:UIFontWeightBold];
    _glassView.alpha = MAX(0.6, progress);
}

@end
