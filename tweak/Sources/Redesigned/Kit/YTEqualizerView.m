#import "YTEqualizerView.h"

@interface YTEqualizerView ()
@property (nonatomic, strong) NSArray<CALayer *> *barLayers;
@end

@implementation YTEqualizerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _barColor = [UIColor whiteColor];
        [self setupBars];
    }
    return self;
}

- (void)setupBars {
    NSMutableArray *layers = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        CALayer *bar = [CALayer layer];
        bar.backgroundColor = _barColor.CGColor;
        bar.cornerRadius = 1.0;
        [self.layer addSublayer:bar];
        [layers addObject:bar];
    }
    _barLayers = layers;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = 3.0;
    CGFloat spacing = 2.0;
    CGFloat totalW = (3 * w) + (2 * spacing);
    CGFloat startX = (self.bounds.size.width - totalW) / 2.0;
    CGFloat maxH = self.bounds.size.height;
    
    for (int i = 0; i < _barLayers.count; i++) {
        CALayer *bar = _barLayers[i];
        bar.backgroundColor = _barColor.CGColor;
        bar.frame = CGRectMake(startX + i * (w + spacing), maxH - 4.0, w, 4.0);
    }
}

- (void)startAnimating {
    if (_isAnimating) return;
    _isAnimating = YES;
    
    CGFloat heights[3][4] = {
        {4, 14, 8, 4},
        {12, 4, 16, 10},
        {8, 16, 6, 12}
    };
    
    for (int i = 0; i < _barLayers.count; i++) {
        CALayer *bar = _barLayers[i];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.height"];
        NSMutableArray *vals = [NSMutableArray array];
        for (int j = 0; j < 4; j++) {
            [vals addObject:@(heights[i][j])];
        }
        anim.values = vals;
        anim.duration = 0.65 + (i * 0.15);
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [bar addAnimation:anim forKey:@"eqAnim"];
    }
}

- (void)stopAnimating {
    _isAnimating = NO;
    for (CALayer *bar in _barLayers) {
        [bar removeAnimationForKey:@"eqAnim"];
    }
}

@end
