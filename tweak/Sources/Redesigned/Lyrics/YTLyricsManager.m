#import "YTLyricsManager.h"

@implementation YTLyricLine
@end

@interface YTLyricsManager ()
@property (nonatomic, strong) NSMutableArray<YTLyricLine *> *lines;
@property (nonatomic, assign) NSInteger activeIndex;
@end

@implementation YTLyricsManager

+ (instancetype)sharedManager {
    static YTLyricsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YTLyricsManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lines = [NSMutableArray array];
        _activeIndex = -1;
    }
    return self;
}

- (NSArray<YTLyricLine *> *)currentLines {
    return _lines;
}

- (NSInteger)currentLineIndex {
    return _activeIndex;
}

- (void)fetchLyricsForTrack:(NSString *)track artist:(NSString *)artist completion:(void (^)(BOOL success))completion {
    if (!track.length) {
        if (completion) completion(NO);
        return;
    }
    
    // Fetch from synchronized LRCLIB API fallback
    NSString *encodedTrack = [track stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *encodedArtist = [artist stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"https://lrclib.net/api/get?track_name=%@&artist_name=%@", encodedTrack, encodedArtist];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data && !err) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *syncedLyrics = json[@"syncedLyrics"];
            if (syncedLyrics.length) {
                [self parseLrcString:syncedLyrics];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(YES);
                });
                return;
            }
        }
        
        // If not found, populate with graceful placeholder line
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.lines removeAllObjects];
            YTLyricLine *line = [[YTLyricLine alloc] init];
            line.startTime = 0;
            line.endTime = 999;
            line.text = [NSString stringWithFormat:@"♪ Enjoying %@ by %@ ♪", track, artist];
            [self.lines addObject:line];
            if (completion) completion(YES);
        });
    }];
    [task resume];
}

- (void)parseLrcString:(NSString *)lrc {
    [_lines removeAllObjects];
    NSArray<NSString *> *rawLines = [lrc componentsSeparatedByString:@"\n"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\d{2}):(\\d{2})\\.(\\d{2,3})\\](.*)" options:0 error:nil];
    
    for (NSString *raw in rawLines) {
        NSTextCheckingResult *match = [regex firstMatchInString:raw options:0 range:NSMakeRange(0, raw.length)];
        if (match && match.numberOfRanges >= 5) {
            NSString *minStr = [raw substringWithRange:[match rangeAtIndex:1]];
            NSString *secStr = [raw substringWithRange:[match rangeAtIndex:2]];
            NSString *msStr = [raw substringWithRange:[match rangeAtIndex:3]];
            NSString *textStr = [raw substringWithRange:[match rangeAtIndex:4]];
            
            NSTimeInterval sec = [minStr doubleValue] * 60.0 + [secStr doubleValue] + ([msStr doubleValue] / (msStr.length == 3 ? 1000.0 : 100.0));
            
            YTLyricLine *line = [[YTLyricLine alloc] init];
            line.startTime = sec;
            line.text = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [_lines addObject:line];
        }
    }
    
    // Compute end times
    for (NSUInteger i = 0; i < _lines.count; i++) {
        if (i + 1 < _lines.count) {
            _lines[i].endTime = _lines[i + 1].startTime;
        } else {
            _lines[i].endTime = _lines[i].startTime + 5.0;
        }
    }
}

- (void)updatePlaybackTime:(NSTimeInterval)time {
    NSInteger newIdx = -1;
    for (NSInteger i = 0; i < (NSInteger)_lines.count; i++) {
        YTLyricLine *l = _lines[i];
        if (time >= l.startTime && time <= l.endTime) {
            newIdx = i;
            break;
        }
    }
    _activeIndex = newIdx;
}

@end
