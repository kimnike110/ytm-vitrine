#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif

/// Safely swizzles an instance method on a named class if found.
BOOL YTSwizzleInstanceMethod(Class cls, SEL origSel, SEL newSel);

/// Finds any loaded class matching a substring prefix/suffix.
NSArray<Class> *YTFindClassesMatching(NSString *keyword);

/// Finds the nearest UIViewController responsible for a view.
UIViewController * _Nullable YTFindViewControllerForView(UIView *view);

/// Finds a view in the hierarchy matching a class name prefix.
UIView * _Nullable YTFindSubviewMatching(UIView *root, NSString *classNamePrefix);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
