#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTSettingsManager : NSObject

+ (instancetype)sharedManager;

// Visuals
@property (nonatomic, assign) BOOL isRedesignEnabled;
@property (nonatomic, assign) BOOL isTrueBlackEnabled;
@property (nonatomic, assign) BOOL isGlassGlowEnabled;
@property (nonatomic, copy) NSString *accentColorChoice; // Pink, Cyan, Violet, White

// Navigation & Tab Bar
@property (nonatomic, assign) BOOL isMiniPlayerInTabBar;
@property (nonatomic, assign) BOOL isFloatingTabBar;

// Player & Motion
@property (nonatomic, assign) BOOL isAnimatedArtworkEnabled;
@property (nonatomic, assign) BOOL isFluidMotionEnabled;
@property (nonatomic, assign) BOOL isHapticsEnabled;
@property (nonatomic, assign) NSInteger hapticStyle; // 0: Light, 1: Medium, 2: Heavy

// Lyrics
@property (nonatomic, assign) BOOL isWordByWordLyrics;
@property (nonatomic, assign) BOOL isLyricsGlowEnabled;
@property (nonatomic, assign) BOOL isBlurInactiveLyrics;
@property (nonatomic, assign) BOOL isImmersiveLandscape;

// Audio
@property (nonatomic, assign) BOOL isVolumeBoostEnabled;
@property (nonatomic, assign) NSInteger volumeBoostLevel; // 3, 6, 12 dB
@property (nonatomic, assign) BOOL isBassBoostEnabled;
@property (nonatomic, assign) BOOL isSpatializerEnabled;

// App Icon
@property (nonatomic, copy) NSString *selectedAppIcon;

- (void)save;
- (void)load;

@end

NS_ASSUME_NONNULL_END
