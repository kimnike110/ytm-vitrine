#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTTHooksBridge : NSObject

+ (instancetype)sharedBridge;

- (void)openSettingsAction;
- (void)openLyricsAction;

- (void)playbackUpdatedWithTitle:(nullable NSString *)title
                          artist:(nullable NSString *)artist
                         artwork:(nullable UIImage *)artwork
                       isPlaying:(BOOL)isPlaying
                         elapsed:(NSTimeInterval)elapsed
                        duration:(NSTimeInterval)duration;

@end

UIWindow * _Nullable YTGetKeyWindow(void);
void YTOpenVitrineSettings(void);
void YTOpenVitrineLyrics(void);

NS_ASSUME_NONNULL_END
