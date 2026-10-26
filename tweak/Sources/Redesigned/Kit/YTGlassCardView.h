#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTGlassCardView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign) CGFloat cornerRadius;

- (instancetype)initWithCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
