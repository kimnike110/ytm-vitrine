#import <UIKit/UIKit.h>
#import "YTPlayerArtworkView.h"
#import "../Kit/YTGlassSlider.h"
#import "../Kit/YTGlassButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTFullPlayerViewController : UIViewController

@property (nonatomic, strong, readonly) YTPlayerArtworkView *artworkView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *artistLabel;
@property (nonatomic, strong, readonly) YTGlassSlider *scrubber;
@property (nonatomic, strong, readonly) YTGlassButton *playPauseButton;
@property (nonatomic, strong, readonly) YTGlassButton *prevButton;
@property (nonatomic, strong, readonly) YTGlassButton *nextButton;
@property (nonatomic, strong, readonly) YTGlassButton *shuffleButton;
@property (nonatomic, strong, readonly) YTGlassButton *repeatButton;
@property (nonatomic, strong, readonly) YTGlassButton *lyricsButton;
@property (nonatomic, strong, readonly) YTGlassButton *moreButton;

- (void)updateMetadataWithTitle:(NSString *)title
                         artist:(NSString *)artist
                        artwork:(nullable UIImage *)artwork
                      isPlaying:(BOOL)playing;

- (void)updatePlaybackProgress:(CGFloat)progress currentTime:(NSTimeInterval)current duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
