#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTHapticManager : NSObject

+ (instancetype)sharedManager;

- (void)triggerImpact:(UIImpactFeedbackStyle)style;
- (void)triggerSelection;
- (void)triggerSuccess;

@end

NS_ASSUME_NONNULL_END
