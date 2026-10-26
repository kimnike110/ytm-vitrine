#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTHomeGlassOverlay : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *profileAvatarButton;

- (void)updateCollapseWithScrollOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
