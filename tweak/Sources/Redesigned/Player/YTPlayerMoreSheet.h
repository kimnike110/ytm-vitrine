#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTPlayerMoreSheet : UIViewController

@property (nonatomic, copy, nullable) void (^onSelectSpeed)(float speed);
@property (nonatomic, copy, nullable) void (^onToggleLyrics)(void);
@property (nonatomic, copy, nullable) void (^onOpenAlbum)(void);
@property (nonatomic, copy, nullable) void (^onSleepTimerSet)(NSTimeInterval minutes);

@end

NS_ASSUME_NONNULL_END
