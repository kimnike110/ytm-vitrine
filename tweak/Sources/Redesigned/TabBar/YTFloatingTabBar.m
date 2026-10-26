#import "YTFloatingTabBar.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "../Kit/YTHapticManager.h"

@interface YTFloatingTabBar ()
@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIStackView *tabStack;
@property (nonatomic, strong) NSMutableArray<UIButton *> *tabButtons;
@property (nonatomic, strong) NSArray<NSString *> *iconNames;
@end

@implementation YTFloatingTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tabButtons = [NSMutableArray array];
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
    
    _miniPlayerView = [[YTMiniPlayerView alloc] initWithFrame:CGRectZero];
    _miniPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_miniPlayerView];
    
    _tabStack = [[UIStackView alloc] init];
    _tabStack.axis = UILayoutConstraintAxisHorizontal;
    _tabStack.distribution = UIStackViewDistributionFillEqually;
    _tabStack.alignment = UIStackViewAlignmentCenter;
    _tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tabStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [_miniPlayerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:6],
        [_miniPlayerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [_miniPlayerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8],
        [_miniPlayerView.heightAnchor constraintEqualToConstant:54],
        
        [_tabStack.topAnchor constraintEqualToAnchor:_miniPlayerView.bottomAnchor constant:4],
        [_tabStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12],
        [_tabStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12],
        [_tabStack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-6],
        [_tabStack.heightAnchor constraintEqualToConstant:48]
    ]];
    
    YTShapeGlassView(self, [YTTokens tabBarCornerRadius], NO);
    YTApplyGlassBorder(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    YTShapeGlassView(self, [YTTokens tabBarCornerRadius], NO);
    YTShapeGlassView(_glassView, [YTTokens tabBarCornerRadius], NO);
}

- (void)setTabTitles:(NSArray<NSString *> *)titles iconNames:(NSArray<NSString *> *)icons {
    _iconNames = icons;
    for (UIButton *b in _tabButtons) {
        [b removeFromSuperview];
    }
    [_tabButtons removeAllObjects];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.tintColor = (i == _selectedIndex) ? [UIColor whiteColor] : [YTTokens secondaryTextColor];
        
        if (@available(iOS 13.0, *)) {
            NSString *iconName = (i < icons.count) ? icons[i] : @"music.note";
            BOOL isSelected = (i == _selectedIndex);
            NSString *glyph = isSelected ? [NSString stringWithFormat:@"%@.fill", iconName] : iconName;
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightMedium];
            UIImage *img = [UIImage systemImageNamed:glyph withConfiguration:config];
            if (!img) img = [UIImage systemImageNamed:iconName withConfiguration:config];
            [btn setImage:img forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_tabStack addArrangedSubview:btn];
        [_tabButtons addObject:btn];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (NSInteger i = 0; i < _tabButtons.count; i++) {
        UIButton *b = _tabButtons[i];
        BOOL isSelected = (i == selectedIndex);
        b.tintColor = isSelected ? [UIColor whiteColor] : [YTTokens secondaryTextColor];
        
        if (@available(iOS 13.0, *)) {
            NSString *base = (i < _iconNames.count) ? _iconNames[i] : @"music.note";
            NSString *glyph = isSelected ? [NSString stringWithFormat:@"%@.fill", base] : base;
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:isSelected ? UIImageSymbolWeightBold : UIImageSymbolWeightMedium];
            UIImage *img = [UIImage systemImageNamed:glyph withConfiguration:config];
            if (!img) img = [UIImage systemImageNamed:base withConfiguration:config];
            [b setImage:img forState:UIControlStateNormal];
        }
    }
}

- (void)tabTapped:(UIButton *)sender {
    [[YTHapticManager sharedManager] triggerSelection];
    self.selectedIndex = sender.tag;
    if (self.onTabSelected) {
        self.onTabSelected(sender.tag);
    }
}

- (void)setMiniPlayerHidden:(BOOL)hidden animated:(BOOL)animated {
    void (^actions)(void) = ^{
        self.miniPlayerView.alpha = hidden ? 0.0 : 1.0;
        self.miniPlayerView.hidden = hidden;
    };
    if (animated) {
        [YTTokens springAnimate:actions completion:nil];
    } else {
        actions();
    }
}

@end
