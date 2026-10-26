#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTTokens : NSObject

// Colors
+ (UIColor *)trueBlackColor;
+ (UIColor *)glassSurfaceColor;
+ (UIColor *)glassHighlightColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)accentGlowColor;

// Dimensions & Corner Radii
+ (CGFloat)cardCornerRadius;
+ (CGFloat)tabBarCornerRadius;
+ (CGFloat)miniPlayerCornerRadius;
+ (CGFloat)buttonCornerRadius;

// Layout Padding
+ (CGFloat)horizontalPadding;
+ (CGFloat)sectionSpacing;

// Animations
+ (void)springAnimate:(void (^)(void))animations completion:(nullable void (^)(BOOL finished))completion;
+ (void)springAnimateWithDamping:(CGFloat)damping response:(CGFloat)response animations:(void (^)(void))animations completion:(nullable void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
