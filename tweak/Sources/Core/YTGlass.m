#import "YTGlass.h"
#import <objc/runtime.h>

@interface UIGlassEffect : UIVisualEffect
+ (instancetype)effectWithStyle:(NSInteger)style;
@end

@interface UICornerRadius : NSObject
+ (instancetype)fixedRadius:(CGFloat)radius;
+ (instancetype)containerConcentricRadius;
@end

@interface UICornerConfiguration : NSObject
+ (instancetype)capsuleConfiguration;
+ (instancetype)configurationWithUniformRadius:(id)radius;
@end

@interface UIView (UICornerConfig)
- (void)setCornerConfiguration:(id)config;
@end

BOOL YTHasNativeGlass(void) {
    Class glassClass = NSClassFromString(@"UIGlassEffect");
    return (glassClass != nil && [glassClass respondsToSelector:@selector(effectWithStyle:)]);
}

UIVisualEffect *YTGlassEffect(void) {
    Class glass = NSClassFromString(@"UIGlassEffect");
    if ([glass respondsToSelector:@selector(effectWithStyle:)]) {
        return [glass effectWithStyle:0];
    }
    if (@available(iOS 13.0, *)) {
        return [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark];
    }
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}

static UIVisualEffectView *newGlassPane(void) {
    UIVisualEffectView *glass = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    glass.userInteractionEnabled = NO;
    glass.layer.zPosition = -1;
    glass.layer.borderWidth = 0.5;
    glass.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    return glass;
}

UIVisualEffectView *YTGlassForView(UIView *host, const void *key) {
    if (!host) return nil;
    UIVisualEffectView *glass = objc_getAssociatedObject(host, key);
    if (!glass) {
        glass = newGlassPane();
        objc_setAssociatedObject(host, key, glass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (glass.superview != host) {
        [host insertSubview:glass atIndex:0];
        glass.frame = host.bounds;
    }
    return glass;
}

void YTShapeGlassView(UIView *view, CGFloat cornerRadius, BOOL isCapsule) {
    if (!view) return;
    Class config = NSClassFromString(@"UICornerConfiguration");
    Class cornerRadiusCls = NSClassFromString(@"UICornerRadius");
    id shape = nil;
    if (config && [view respondsToSelector:@selector(setCornerConfiguration:)]) {
        if (isCapsule && [config respondsToSelector:@selector(capsuleConfiguration)]) {
            shape = [config capsuleConfiguration];
        } else if ([config respondsToSelector:@selector(configurationWithUniformRadius:)] &&
                   [cornerRadiusCls respondsToSelector:@selector(fixedRadius:)]) {
            shape = [config configurationWithUniformRadius:[cornerRadiusCls fixedRadius:cornerRadius]];
        }
    }
    if (shape) {
        [view setCornerConfiguration:shape];
        view.clipsToBounds = NO;
    } else {
        CGFloat radius = isCapsule ? (view.bounds.size.height / 2.0) : cornerRadius;
        view.layer.cornerRadius = radius;
        view.layer.cornerCurve = kCACornerCurveContinuous;
        view.clipsToBounds = YES;
    }
}

void YTApplyGlassBorder(UIView *view) {
    if (!view) return;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
}

void YTPresentDarkStyle(UIViewController *controller) {
    if (!controller) return;
    controller.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    if (controller.presentationController) {
        controller.presentationController.overrideTraitCollection =
            [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];
    }
}
