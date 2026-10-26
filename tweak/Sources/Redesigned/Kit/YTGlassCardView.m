#import "YTGlassCardView.h"
#import "../../Core/YTGlass.h"
#import "../../Core/YTTokens.h"

@interface YTGlassCardView ()
@property (nonatomic, strong) UIVisualEffectView *glassView;
@end

@implementation YTGlassCardView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithCornerRadius:[YTTokens cardCornerRadius]];
}

- (instancetype)initWithCornerRadius:(CGFloat)radius {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _cornerRadius = radius;
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _cornerRadius = [YTTokens cardCornerRadius];
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
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    [self updateShape];
    YTApplyGlassBorder(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShape];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateShape];
}

- (void)updateShape {
    YTShapeGlassView(self, _cornerRadius, NO);
    YTShapeGlassView(_glassView, _cornerRadius, NO);
    YTShapeGlassView(_contentView, _cornerRadius, NO);
}

@end
