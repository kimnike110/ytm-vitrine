#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTLyricLine : NSObject
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, nullable) NSString *translation;
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *wordOffsets;
@end

@interface YTLyricsManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) NSArray<YTLyricLine *> *currentLines;
@property (nonatomic, assign, readonly) NSInteger currentLineIndex;

- (void)fetchLyricsForTrack:(NSString *)track artist:(NSString *)artist completion:(void (^)(BOOL success))completion;
- (void)updatePlaybackTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
