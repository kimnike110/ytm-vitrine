#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif

/// Checks whether native UIGlassEffect (iOS 26+) is available on this runtime.
BOOL YTHasNativeGlass(void);

/// Produces a UIGlassEffect on iOS 26+, or a fallback ultra-thin material blur on older iOS versions.
UIVisualEffect *YTGlassEffect(void);

/// Attaches or returns an associated glass panel on a host view.
UIVisualEffectView *YTGlassForView(UIView *host, const void *key);

/// Shapes a view or glass effect view with continuous rounded corners or capsule radius.
void YTShapeGlassView(UIView *view, CGFloat cornerRadius, BOOL isCapsule);

/// Adds a subtle liquid glass specular highlight / border to a container view.
void YTApplyGlassBorder(UIView *view);

/// Sets dark appearance for a controller and its presentation context.
void YTPresentDarkStyle(UIViewController *controller);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
