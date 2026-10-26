#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTGlassButton : UIControl

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isCapsule;
@property (nonatomic, assign) BOOL isProminent;

- (instancetype)initWithIconName:(NSString *)iconName pointSize:(CGFloat)size isCapsule:(BOOL)capsule;
- (void)setIconName:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
