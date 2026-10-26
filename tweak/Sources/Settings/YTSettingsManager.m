#import "YTSettingsManager.h"

static NSString *const kPrefRedesign = @"YTMVitrine_RedesignEnabled";
static NSString *const kPrefTrueBlack = @"YTMVitrine_TrueBlackEnabled";
static NSString *const kPrefGlassGlow = @"YTMVitrine_GlassGlow";
static NSString *const kPrefAccentColor = @"YTMVitrine_AccentColor";
static NSString *const kPrefMiniPlayer = @"YTMVitrine_MiniPlayerInTabBar";
static NSString *const kPrefFloatingTabBar = @"YTMVitrine_FloatingTabBar";
static NSString *const kPrefAnimatedArtwork = @"YTMVitrine_AnimatedArtwork";
static NSString *const kPrefFluidMotion = @"YTMVitrine_FluidMotion";
static NSString *const kPrefHaptics = @"YTMVitrine_Haptics";
static NSString *const kPrefHapticStyle = @"YTMVitrine_HapticStyle";
static NSString *const kPrefWordLyrics = @"YTMVitrine_WordByWordLyrics";
static NSString *const kPrefLyricsGlow = @"YTMVitrine_LyricsGlow";
static NSString *const kPrefBlurInactiveLyrics = @"YTMVitrine_BlurInactiveLyrics";
static NSString *const kPrefImmersiveLandscape = @"YTMVitrine_ImmersiveLandscape";
static NSString *const kPrefVolumeBoost = @"YTMVitrine_VolumeBoost";
static NSString *const kPrefVolumeBoostLevel = @"YTMVitrine_VolumeBoostLevel";
static NSString *const kPrefBassBoost = @"YTMVitrine_BassBoost";
static NSString *const kPrefSpatializer = @"YTMVitrine_Spatializer";
static NSString *const kPrefAppIcon = @"YTMVitrine_AppIcon";

@implementation YTSettingsManager

+ (instancetype)sharedManager {
    static YTSettingsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YTSettingsManager alloc] init];
        [instance load];
    });
    return instance;
}

- (void)load {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
    _isRedesignEnabled = [d objectForKey:kPrefRedesign] ? [d boolForKey:kPrefRedesign] : YES;
    _isTrueBlackEnabled = [d objectForKey:kPrefTrueBlack] ? [d boolForKey:kPrefTrueBlack] : YES;
    _isGlassGlowEnabled = [d objectForKey:kPrefGlassGlow] ? [d boolForKey:kPrefGlassGlow] : YES;
    _accentColorChoice = [d stringForKey:kPrefAccentColor] ?: @"Pink";
    
    _isMiniPlayerInTabBar = [d objectForKey:kPrefMiniPlayer] ? [d boolForKey:kPrefMiniPlayer] : YES;
    _isFloatingTabBar = [d objectForKey:kPrefFloatingTabBar] ? [d boolForKey:kPrefFloatingTabBar] : YES;
    
    _isAnimatedArtworkEnabled = [d objectForKey:kPrefAnimatedArtwork] ? [d boolForKey:kPrefAnimatedArtwork] : YES;
    _isFluidMotionEnabled = [d objectForKey:kPrefFluidMotion] ? [d boolForKey:kPrefFluidMotion] : YES;
    _isHapticsEnabled = [d objectForKey:kPrefHaptics] ? [d boolForKey:kPrefHaptics] : YES;
    _hapticStyle = [d objectForKey:kPrefHapticStyle] ? [d integerForKey:kPrefHapticStyle] : 0;
    
    _isWordByWordLyrics = [d objectForKey:kPrefWordLyrics] ? [d boolForKey:kPrefWordLyrics] : YES;
    _isLyricsGlowEnabled = [d objectForKey:kPrefLyricsGlow] ? [d boolForKey:kPrefLyricsGlow] : YES;
    _isBlurInactiveLyrics = [d objectForKey:kPrefBlurInactiveLyrics] ? [d boolForKey:kPrefBlurInactiveLyrics] : YES;
    _isImmersiveLandscape = [d objectForKey:kPrefImmersiveLandscape] ? [d boolForKey:kPrefImmersiveLandscape] : YES;
    
    _isVolumeBoostEnabled = [d objectForKey:kPrefVolumeBoost] ? [d boolForKey:kPrefVolumeBoost] : NO;
    _volumeBoostLevel = [d objectForKey:kPrefVolumeBoostLevel] ? [d integerForKey:kPrefVolumeBoostLevel] : 6;
    _isBassBoostEnabled = [d objectForKey:kPrefBassBoost] ? [d boolForKey:kPrefBassBoost] : NO;
    _isSpatializerEnabled = [d objectForKey:kPrefSpatializer] ? [d boolForKey:kPrefSpatializer] : NO;
    
    _selectedAppIcon = [d stringForKey:kPrefAppIcon] ?: @"Liquid Glass";
}

- (void)save {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setBool:_isRedesignEnabled forKey:kPrefRedesign];
    [d setBool:_isTrueBlackEnabled forKey:kPrefTrueBlack];
    [d setBool:_isGlassGlowEnabled forKey:kPrefGlassGlow];
    [d setObject:_accentColorChoice forKey:kPrefAccentColor];
    
    [d setBool:_isMiniPlayerInTabBar forKey:kPrefMiniPlayer];
    [d setBool:_isFloatingTabBar forKey:kPrefFloatingTabBar];
    
    [d setBool:_isAnimatedArtworkEnabled forKey:kPrefAnimatedArtwork];
    [d setBool:_isFluidMotionEnabled forKey:kPrefFluidMotion];
    [d setBool:_isHapticsEnabled forKey:kPrefHaptics];
    [d setInteger:_hapticStyle forKey:kPrefHapticStyle];
    
    [d setBool:_isWordByWordLyrics forKey:kPrefWordLyrics];
    [d setBool:_isLyricsGlowEnabled forKey:kPrefLyricsGlow];
    [d setBool:_isBlurInactiveLyrics forKey:kPrefBlurInactiveLyrics];
    [d setBool:_isImmersiveLandscape forKey:kPrefImmersiveLandscape];
    
    [d setBool:_isVolumeBoostEnabled forKey:kPrefVolumeBoost];
    [d setInteger:_volumeBoostLevel forKey:kPrefVolumeBoostLevel];
    [d setBool:_isBassBoostEnabled forKey:kPrefBassBoost];
    [d setBool:_isSpatializerEnabled forKey:kPrefSpatializer];
    
    [d setObject:_selectedAppIcon forKey:kPrefAppIcon];
    [d synchronize];
}

@end
