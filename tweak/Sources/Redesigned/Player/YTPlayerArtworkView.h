#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTPlayerArtworkView : UIView

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, nullable) AVPlayer *videoPlayer;

- (void)setImage:(nullable UIImage *)image animated:(BOOL)animated;
- (void)playVideoCoverWithURL:(NSURL *)videoURL;
- (void)stopVideoCover;

@end

NS_ASSUME_NONNULL_END
