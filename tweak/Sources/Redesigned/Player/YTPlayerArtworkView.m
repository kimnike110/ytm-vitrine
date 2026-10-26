#import "YTPlayerArtworkView.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"

@interface YTPlayerArtworkView ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CAGradientLayer *reflectionLayer;
@end

@implementation YTPlayerArtworkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
    // Glass specular reflection sheen
    _reflectionLayer = [CAGradientLayer layer];
    _reflectionLayer.colors = @[
        (id)[UIColor colorWithWhite:1.0 alpha:0.25].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.1].CGColor
    ];
    _reflectionLayer.locations = @[@0.0, @0.4, @1.0];
    _reflectionLayer.startPoint = CGPointMake(0, 0);
    _reflectionLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:_reflectionLayer];
    
    YTShapeGlassView(self, [YTTokens cardCornerRadius], NO);
    YTApplyGlassBorder(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _reflectionLayer.frame = self.bounds;
    if (_playerLayer) {
        _playerLayer.frame = self.bounds;
    }
    YTShapeGlassView(self, [YTTokens cardCornerRadius], NO);
}

- (void)setImage:(nullable UIImage *)image animated:(BOOL)animated {
    if (animated) {
        [UIView transitionWithView:_imageView
                          duration:0.35
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            self.imageView.image = image;
        } completion:nil];
    } else {
        _imageView.image = image;
    }
}

- (void)playVideoCoverWithURL:(NSURL *)videoURL {
    [self stopVideoCover];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];
    _videoPlayer = [AVPlayer playerWithPlayerItem:item];
    _videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame = self.bounds;
    _playerLayer.cornerRadius = [YTTokens cardCornerRadius];
    _playerLayer.masksToBounds = YES;
    [self.layer insertSublayer:_playerLayer above:_imageView.layer];
    
    [_videoPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)note {
    [_videoPlayer seekToTime:kCMTimeZero];
    [_videoPlayer play];
}

- (void)stopVideoCover {
    if (_videoPlayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_videoPlayer pause];
        _videoPlayer = nil;
    }
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
}

- (void)dealloc {
    [self stopVideoCover];
}

@end
