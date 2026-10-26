#import <UIKit/UIKit.h>
#import "YTMiniPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTFloatingTabBar : UIView

@property (nonatomic, strong, readonly) YTMiniPlayerView *miniPlayerView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy, nullable) void (^onTabSelected)(NSInteger index);

- (void)setTabTitles:(NSArray<NSString *> *)titles iconNames:(NSArray<NSString *> *)icons;
- (void)setMiniPlayerHidden:(BOOL)hidden animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
