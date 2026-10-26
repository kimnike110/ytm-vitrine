#import "YTLyricsWordLabel.h"
#import "../../Core/YTTokens.h"

@interface YTLyricsWordLabel ()
@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, strong) UILabel *highlightedLabel;
@property (nonatomic, strong) CALayer *maskLayer;
@end

@implementation YTLyricsWordLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _backgroundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    _backgroundLabel.numberOfLines = 0;
    _backgroundLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_backgroundLabel];
    
    _highlightedLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _highlightedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _highlightedLabel.textColor = [UIColor whiteColor];
    _highlightedLabel.numberOfLines = 0;
    _highlightedLabel.textAlignment = NSTextAlignmentCenter;
    _highlightedLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    _highlightedLabel.layer.shadowRadius = 8.0;
    _highlightedLabel.layer.shadowOpacity = 0.5;
    _highlightedLabel.layer.shadowOffset = CGSizeZero;
    [self addSubview:_highlightedLabel];
    
    _maskLayer = [CALayer layer];
    _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    _highlightedLabel.layer.mask = _maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMask];
}

- (void)setText:(NSString *)text font:(UIFont *)font {
    _text = [text copy];
    _backgroundLabel.font = font;
    _highlightedLabel.font = font;
    _backgroundLabel.text = text;
    _highlightedLabel.text = text;
    [self setNeedsLayout];
}

- (void)setIsCurrentLine:(BOOL)isCurrentLine {
    _isCurrentLine = isCurrentLine;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundLabel.alpha = isCurrentLine ? 1.0 : 0.4;
        self.transform = isCurrentLine ? CGAffineTransformMakeScale(1.05, 1.05) : CGAffineTransformIdentity;
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(0.0, MIN(1.0, progress));
    [self updateMask];
}

- (void)updateMask {
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    _maskLayer.frame = CGRectMake(0, 0, w * _progress, h);
}

- (void)animateWordSweepFrom:(CGFloat)fromProgress to:(CGFloat)toProgress duration:(NSTimeInterval)duration {
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.progress = toProgress;
    [CATransaction commit];
}

@end
