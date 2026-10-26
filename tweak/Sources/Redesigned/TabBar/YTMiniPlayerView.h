#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTMiniPlayerView : UIControl

@property (nonatomic, strong, readonly) UIImageView *artworkView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *artistLabel;
@property (nonatomic, strong, readonly) UIButton *playPauseButton;
@property (nonatomic, copy, nullable) void (^onTap)(void);
@property (nonatomic, copy, nullable) void (^onPlayPauseTap)(void);

- (void)updateWithTitle:(NSString *)title
                 artist:(NSString *)artist
                artwork:(nullable UIImage *)artwork
              isPlaying:(BOOL)playing;

@end

NS_ASSUME_NONNULL_END
