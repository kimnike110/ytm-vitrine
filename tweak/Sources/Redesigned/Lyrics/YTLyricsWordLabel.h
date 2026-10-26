#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTLyricsWordLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat progress; // 0.0 to 1.0 word sweep
@property (nonatomic, assign) BOOL isCurrentLine;

- (void)setText:(NSString *)text font:(UIFont *)font;
- (void)animateWordSweepFrom:(CGFloat)fromProgress to:(CGFloat)toProgress duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
