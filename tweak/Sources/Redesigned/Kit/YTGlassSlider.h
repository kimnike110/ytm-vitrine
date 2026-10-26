#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTGlassSlider : UIControl

@property (nonatomic, assign) CGFloat value; // 0.0 to 1.0
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalDuration;
@property (nonatomic, copy, nullable) void (^onSeek)(NSTimeInterval time);

- (void)setProgress:(CGFloat)progress currentTime:(NSTimeInterval)current duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
