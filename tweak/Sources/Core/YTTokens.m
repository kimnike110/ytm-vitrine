#import "YTTokens.h"

@implementation YTTokens

+ (UIColor *)trueBlackColor {
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)glassSurfaceColor {
    return [UIColor colorWithWhite:1.0 alpha:0.08];
}

+ (UIColor *)glassHighlightColor {
    return [UIColor colorWithWhite:1.0 alpha:0.18];
}

+ (UIColor *)primaryTextColor {
    return [UIColor colorWithWhite:1.0 alpha:0.96];
}

+ (UIColor *)secondaryTextColor {
    return [UIColor colorWithWhite:1.0 alpha:0.62];
}

+ (UIColor *)accentGlowColor {
    return [UIColor colorWithRed:1.0 green:0.22 blue:0.38 alpha:0.8]; // YTM Red-Pink Glow
}

+ (CGFloat)cardCornerRadius {
    return 24.0;
}

+ (CGFloat)tabBarCornerRadius {
    return 28.0;
}

+ (CGFloat)miniPlayerCornerRadius {
    return 20.0;
}

+ (CGFloat)buttonCornerRadius {
    return 24.0;
}

+ (CGFloat)horizontalPadding {
    return 20.0;
}

+ (CGFloat)sectionSpacing {
    return 24.0;
}

+ (void)springAnimate:(void (^)(void))animations completion:(nullable void (^)(BOOL finished))completion {
    [self springAnimateWithDamping:0.82 response:0.42 animations:animations completion:completion];
}

+ (void)springAnimateWithDamping:(CGFloat)damping response:(CGFloat)response animations:(void (^)(void))animations completion:(nullable void (^)(BOOL finished))completion {
    if (@available(iOS 10.0, *)) {
        UISpringTimingParameters *timing = [[UISpringTimingParameters alloc] initWithDampingRatio:damping];
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:response timingParameters:timing];
        [animator addAnimations:animations];
        if (completion) {
            [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                completion(finalPosition == UIViewAnimatingPositionEnd);
            }];
        }
        [animator startAnimation];
    } else {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:damping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:animations completion:completion];
    }
}

@end
