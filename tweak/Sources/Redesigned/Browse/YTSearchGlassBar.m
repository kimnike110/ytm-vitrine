#import "YTSearchGlassBar.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"

@interface YTSearchGlassBar () <UITextFieldDelegate>
@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIImageView *searchIcon;
@end

@implementation YTSearchGlassBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _glassView = [[UIVisualEffectView alloc] initWithEffect:YTGlassEffect()];
    _glassView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _glassView.frame = self.bounds;
    _glassView.userInteractionEnabled = NO;
    [self addSubview:_glassView];
    
    _searchIcon = [[UIImageView alloc] init];
    _searchIcon.contentMode = UIViewContentModeScaleAspectFit;
    _searchIcon.tintColor = [YTTokens secondaryTextColor];
    _searchIcon.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 13.0, *)) {
        _searchIcon.image = [UIImage systemImageNamed:@"magnifyingglass"];
    }
    [self addSubview:_searchIcon];
    
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _searchTextField.textColor = [UIColor whiteColor];
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search YouTube Music" attributes:@{NSForegroundColorAttributeName: [YTTokens secondaryTextColor]}];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_searchTextField];
    
    [NSLayoutConstraint activateConstraints:@[
        [_searchIcon.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14],
        [_searchIcon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_searchIcon.widthAnchor constraintEqualToConstant:18],
        [_searchIcon.heightAnchor constraintEqualToConstant:18],
        
        [_searchTextField.leadingAnchor constraintEqualToAnchor:_searchIcon.trailingAnchor constant:10],
        [_searchTextField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [_searchTextField.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_searchTextField.heightAnchor constraintEqualToConstant:36]
    ]];
    
    YTShapeGlassView(self, 20.0, NO);
    YTApplyGlassBorder(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    YTShapeGlassView(self, 20.0, NO);
    YTShapeGlassView(_glassView, 20.0, NO);
}

- (void)textDidChange {
    if (self.onTextChanged) {
        self.onTextChanged(_searchTextField.text ?: @"");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
