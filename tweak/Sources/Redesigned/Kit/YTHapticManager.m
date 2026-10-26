#import "YTHapticManager.h"
#import "../../Settings/YTSettingsManager.h"

@implementation YTHapticManager

+ (instancetype)sharedManager {
    static YTHapticManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YTHapticManager alloc] init];
    });
    return instance;
}

- (void)triggerImpact:(UIImpactFeedbackStyle)style {
    if (![YTSettingsManager sharedManager].isHapticsEnabled) return;
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
        [generator prepare];
        [generator impactOccurred];
    }
}

- (void)triggerSelection {
    if (![YTSettingsManager sharedManager].isHapticsEnabled) return;
    if (@available(iOS 10.0, *)) {
        UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
        [generator prepare];
        [generator selectionChanged];
    }
}

- (void)triggerSuccess {
    if (![YTSettingsManager sharedManager].isHapticsEnabled) return;
    if (@available(iOS 10.0, *)) {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator prepare];
        [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
    }
}

@end
