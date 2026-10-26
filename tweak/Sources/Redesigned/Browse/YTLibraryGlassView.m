#import "YTLibraryGlassView.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"
#import "../Kit/YTGlassButton.h"
#import "../Kit/YTHapticManager.h"

@interface YTLibraryGlassView ()
@property (nonatomic, strong) UIScrollView *chipsScrollView;
@property (nonatomic, strong) UIStackView *chipsStack;
@property (nonatomic, strong) YTGlassButton *gridToggleBtn;
@property (nonatomic, strong) NSMutableArray<UIButton *> *chipButtons;
@property (nonatomic, copy) NSString *selectedFilter;
@end

@implementation YTLibraryGlassView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _chipButtons = [NSMutableArray array];
        _selectedFilter = @"Playlists";
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _chipsScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _chipsScrollView.showsHorizontalScrollIndicator = NO;
    _chipsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_chipsScrollView];
    
    _chipsStack = [[UIStackView alloc] init];
    _chipsStack.axis = UILayoutConstraintAxisHorizontal;
    _chipsStack.spacing = 8;
    _chipsStack.translatesAutoresizingMaskIntoConstraints = NO;
    [_chipsScrollView addSubview:_chipsStack];
    
    _gridToggleBtn = [[YTGlassButton alloc] initWithIconName:@"square.grid.2x2" pointSize:16 isCapsule:NO];
    _gridToggleBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_gridToggleBtn addTarget:self action:@selector(handleToggleLayout) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gridToggleBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [_chipsScrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [_chipsScrollView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [_chipsScrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4],
        [_chipsScrollView.trailingAnchor constraintEqualToAnchor:_gridToggleBtn.leadingAnchor constant:-8],
        
        [_chipsStack.leadingAnchor constraintEqualToAnchor:_chipsScrollView.leadingAnchor],
        [_chipsStack.trailingAnchor constraintEqualToAnchor:_chipsScrollView.trailingAnchor],
        [_chipsStack.topAnchor constraintEqualToAnchor:_chipsScrollView.topAnchor],
        [_chipsStack.bottomAnchor constraintEqualToAnchor:_chipsScrollView.bottomAnchor],
        [_chipsStack.heightAnchor constraintEqualToAnchor:_chipsScrollView.heightAnchor],
        
        [_gridToggleBtn.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [_gridToggleBtn.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_gridToggleBtn.widthAnchor constraintEqualToConstant:36],
        [_gridToggleBtn.heightAnchor constraintEqualToConstant:36]
    ]];
    
    NSArray *filters = @[@"Playlists", @"Songs", @"Albums", @"Artists", @"Downloads"];
    for (NSString *f in filters) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        b.layer.cornerRadius = 16.0;
        b.clipsToBounds = YES;
        b.contentEdgeInsets = UIEdgeInsetsMake(6, 14, 6, 14);
        [b setTitle:f forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        [b addTarget:self action:@selector(filterTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_chipsStack addArrangedSubview:b];
        [_chipButtons addObject:b];
    }
    
    [self updateFilterSelection];
}

- (void)updateFilterSelection {
    for (UIButton *b in _chipButtons) {
        BOOL isSel = [b.currentTitle isEqualToString:_selectedFilter];
        b.backgroundColor = isSel ? [UIColor colorWithWhite:1.0 alpha:0.25] : [UIColor colorWithWhite:1.0 alpha:0.08];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:isSel ? UIFontWeightBold : UIFontWeightMedium];
    }
}

- (void)filterTapped:(UIButton *)sender {
    [[YTHapticManager sharedManager] triggerSelection];
    _selectedFilter = sender.currentTitle;
    [self updateFilterSelection];
    if (self.onFilterSelected) {
        self.onFilterSelected(_selectedFilter);
    }
}

- (void)handleToggleLayout {
    _isGridView = !_isGridView;
    [[YTHapticManager sharedManager] triggerSelection];
    NSString *icon = _isGridView ? @"list.bullet" : @"square.grid.2x2";
    [_gridToggleBtn setIconName:icon];
    if (self.onToggleLayout) {
        self.onToggleLayout(_isGridView);
    }
}

@end
