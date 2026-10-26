#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YTTHooksBridge.h"
#import "../Core/YTGlass.h"
#import "../Settings/YTSettingsManager.h"
#import "../Redesigned/Lyrics/YTLyricsManager.h"

%hook MPNowPlayingInfoCenter

- (void)setNowPlayingInfo:(NSDictionary<NSString *, id> *)info {
    %orig(info);
    
    if (![YTSettingsManager sharedManager].isRedesignEnabled) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = info[MPMediaItemPropertyTitle];
        NSString *artist = info[MPMediaItemPropertyArtist];
        MPMediaItemArtwork *artObj = info[MPMediaItemPropertyArtwork];
        UIImage *artImage = nil;
        if (artObj && [artObj respondsToSelector:@selector(imageWithSize:)]) {
            artImage = [artObj imageWithSize:CGSizeMake(400, 400)];
        }
        
        float rate = [info[MPNowPlayingInfoPropertyPlaybackRate] floatValue];
        BOOL isPlaying = (rate > 0.0);
        
        NSTimeInterval elapsed = [info[MPNowPlayingInfoPropertyElapsedPlaybackTime] doubleValue];
        NSTimeInterval duration = [info[MPMediaItemPropertyPlaybackDuration] doubleValue];
        
        [[YTTHooksBridge sharedBridge] playbackUpdatedWithTitle:title
                                                         artist:artist
                                                        artwork:artImage
                                                      isPlaying:isPlaying
                                                        elapsed:elapsed
                                                       duration:duration];
        
        if (title.length) {
            [[YTLyricsManager sharedManager] fetchLyricsForTrack:title
                                                          artist:artist ?: @""
                                                      completion:^(BOOL success) {}];
        }
    });
}

%end
