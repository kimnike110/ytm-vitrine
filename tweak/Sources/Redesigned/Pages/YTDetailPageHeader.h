#import <UIKit/UIKit.h>
#import "../Kit/YTGlassButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTDetailPageHeader : UIView

@property (nonatomic, strong, readonly) UIImageView *blurredBackgroundView;
@property (nonatomic, strong, readonly) UIImageView *coverArtworkView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *metadataLabel;
@property (nonatomic, strong, readonly) YTGlassButton *playCapsuleButton;
@property (nonatomic, strong, readonly) YTGlassButton *shuffleButton;

- (void)configureWithTitle:(NSString *)title
                  metadata:(NSString *)metadata
                   artwork:(nullable UIImage *)artwork;

@end

NS_ASSUME_NONNULL_END
