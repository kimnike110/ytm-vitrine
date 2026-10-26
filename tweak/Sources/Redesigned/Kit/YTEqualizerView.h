#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTEqualizerView : UIView

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UIColor *barColor;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
