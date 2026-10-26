#import "YTPlayerMoreSheet.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "../Kit/YTGlassCardView.h"
#import "../Kit/YTHapticManager.h"

@interface YTPlayerMoreSheet ()
@property (nonatomic, strong) UIVisualEffectView *glassBackground;
@property (nonatomic, strong) UIStackView *contentStack;
@end

@implementation YTPlayerMoreSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _glassBackground = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassBackground.frame = self.view.bounds;
    _glassBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_glassBackground];
    
    UIView *grabber = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 40) / 2.0, 10, 40, 5)];
    grabber.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    grabber.layer.cornerRadius = 2.5;
    grabber.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:grabber];
    
    _contentStack = [[UIStackView alloc] init];
    _contentStack.axis = UILayoutConstraintAxisVertical;
    _contentStack.spacing = 16;
    _contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_contentStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [_contentStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:32],
        [_contentStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [_contentStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
    
    UILabel *header = [[UILabel alloc] init];
    header.text = @"Playback Options";
    header.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    header.textColor = [UIColor whiteColor];
    [_contentStack addArrangedSubview:header];
    
    [self addOptionButton:@"Lyrics & Annotations" icon:@"quote.bubble.fill" action:@selector(handleLyrics)];
    [self addOptionButton:@"Go to Album / Artist" icon:@"opticaldisc.fill" action:@selector(handleAlbum)];
    [self addOptionButton:@"Sleep Timer" icon:@"moon.zzz.fill" action:@selector(handleSleepTimer)];
    [self addSpeedControl];
    
    YTShapeGlassView(self.view, 32.0, NO);
    YTApplyGlassBorder(self.view);
}

- (void)addOptionButton:(NSString *)title icon:(NSString *)iconName action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    btn.layer.cornerRadius = 16.0;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 16);
    btn.tintColor = [UIColor whiteColor];
    
    if (@available(iOS 13.0, *)) {
        UIImage *img = [UIImage systemImageNamed:iconName];
        [btn setImage:img forState:UIControlStateNormal];
    }
    
    [btn setTitle:[NSString stringWithFormat:@"   %@", title] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [_contentStack addArrangedSubview:btn];
}

- (void)addSpeedControl {
    UIStackView *speedStack = [[UIStackView alloc] init];
    speedStack.axis = UILayoutConstraintAxisHorizontal;
    speedStack.distribution = UIStackViewDistributionFillEqually;
    speedStack.spacing = 8;
    
    NSArray *speeds = @[@"0.75x", @"1.0x", @"1.25x", @"1.5x"];
    for (NSString *spd in speeds) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
        b.layer.cornerRadius = 12.0;
        [b setTitle:spd forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        b.tag = (NSInteger)([spd floatValue] * 100);
        [b addTarget:self action:@selector(handleSpeedSelect:) forControlEvents:UIControlEventTouchUpInside];
        [speedStack addArrangedSubview:b];
    }
    
    [_contentStack addArrangedSubview:speedStack];
}

- (void)handleLyrics {
    [[YTHapticManager sharedManager] triggerSelection];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onToggleLyrics) self.onToggleLyrics();
    }];
}

- (void)handleAlbum {
    [[YTHapticManager sharedManager] triggerSelection];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onOpenAlbum) self.onOpenAlbum();
    }];
}

- (void)handleSleepTimer {
    [[YTHapticManager sharedManager] triggerSelection];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onSleepTimerSet) self.onSleepTimerSet(30.0);
    }];
}

- (void)handleSpeedSelect:(UIButton *)sender {
    [[YTHapticManager sharedManager] triggerSelection];
    float spd = sender.tag / 100.0f;
    if (self.onSelectSpeed) {
        self.onSelectSpeed(spd);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
