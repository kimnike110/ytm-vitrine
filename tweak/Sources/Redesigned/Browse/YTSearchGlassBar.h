#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTSearchGlassBar : UIView

@property (nonatomic, strong, readonly) UITextField *searchTextField;
@property (nonatomic, copy, nullable) void (^onTextChanged)(NSString *query);

@end

NS_ASSUME_NONNULL_END
