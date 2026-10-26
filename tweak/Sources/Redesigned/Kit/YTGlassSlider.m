#import "YTGlassSlider.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "YTHapticManager.h"

@interface YTGlassSlider ()
@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UILabel *elapsedLabel;
@property (nonatomic, strong) UILabel *remainingLabel;
@property (nonatomic, assign) BOOL isScrubbing;
@end

@implementation YTGlassSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _trackView = [[UIView alloc] init];
    _trackView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
    _trackView.layer.cornerRadius = 2.0;
    _trackView.clipsToBounds = YES;
    [self addSubview:_trackView];
    
    _progressView = [[UIView alloc] init];
    _progressView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    _progressView.layer.cornerRadius = 2.0;
    _progressView.clipsToBounds = YES;
    [_trackView addSubview:_progressView];
    
    _thumbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _thumbView.backgroundColor = [UIColor whiteColor];
    _thumbView.layer.cornerRadius = 7.0;
    _thumbView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _thumbView.layer.shadowRadius = 6.0;
    _thumbView.layer.shadowOpacity = 0.8;
    _thumbView.layer.shadowOffset = CGSizeZero;
    [self addSubview:_thumbView];
    
    _elapsedLabel = [[UILabel alloc] init];
    _elapsedLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    _elapsedLabel.textColor = [YTTokens secondaryTextColor];
    _elapsedLabel.text = @"0:00";
    [self addSubview:_elapsedLabel];
    
    _remainingLabel = [[UILabel alloc] init];
    _remainingLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    _remainingLabel.textColor = [YTTokens secondaryTextColor];
    _remainingLabel.textAlignment = NSTextAlignmentRight;
    _remainingLabel.text = @"-0:00";
    [self addSubview:_remainingLabel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    _trackView.frame = CGRectMake(0, 8, w, 4);
    
    CGFloat progressWidth = w * _value;
    _progressView.frame = CGRectMake(0, 0, progressWidth, 4);
    _thumbView.center = CGPointMake(progressWidth, 10);
    
    _elapsedLabel.frame = CGRectMake(0, 18, 60, 14);
    _remainingLabel.frame = CGRectMake(w - 60, 18, 60, 14);
}

- (NSString *)formatTime:(NSTimeInterval)interval {
    if (isnan(interval) || interval < 0) interval = 0;
    NSInteger totalSec = (NSInteger)interval;
    NSInteger m = totalSec / 60;
    NSInteger s = totalSec % 60;
    return [NSString stringWithFormat:@"%ld:%02ld", (long)m, (long)s];
}

- (void)setProgress:(CGFloat)progress currentTime:(NSTimeInterval)current duration:(NSTimeInterval)duration {
    if (_isScrubbing) return;
    _value = MAX(0.0, MIN(1.0, progress));
    _currentTime = current;
    _totalDuration = duration;
    
    _elapsedLabel.text = [self formatTime:current];
    _remainingLabel.text = [NSString stringWithFormat:@"-%@", [self formatTime:MAX(0, duration - current)]];
    [self setNeedsLayout];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint loc = [gesture locationInView:self];
    CGFloat w = self.bounds.size.width;
    CGFloat newVal = MAX(0.0, MIN(1.0, loc.x / w));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _isScrubbing = YES;
        [[YTHapticManager sharedManager] triggerSelection];
        [UIView animateWithDuration:0.15 animations:^{
            self.thumbView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        _value = newVal;
        NSTimeInterval curr = newVal * _totalDuration;
        _elapsedLabel.text = [self formatTime:curr];
        _remainingLabel.text = [NSString stringWithFormat:@"-%@", [self formatTime:MAX(0, _totalDuration - curr)]];
        [self setNeedsLayout];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        _isScrubbing = NO;
        _value = newVal;
        [UIView animateWithDuration:0.15 animations:^{
            self.thumbView.transform = CGAffineTransformIdentity;
        }];
        if (self.onSeek) {
            self.onSeek(newVal * _totalDuration);
        }
    }
}

@end
