#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTLibraryGlassView : UIView

@property (nonatomic, assign) BOOL isGridView;
@property (nonatomic, copy, nullable) void (^onFilterSelected)(NSString *filter);
@property (nonatomic, copy, nullable) void (^onToggleLayout)(BOOL isGrid);

@end

NS_ASSUME_NONNULL_END
