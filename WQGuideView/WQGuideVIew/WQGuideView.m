//
//  WQGuideView.m
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import "WQGuideView.h"

#define sWidth  [UIScreen mainScreen].bounds.size.width
#define sHeigth [UIScreen mainScreen].bounds.size.height

typedef enum{
    Left  = 1,
    Right = 1 << 1,
    Upper = 1 << 2,
    Down  = 1 << 3
}WQMessageLocation;

@interface WQGuideView ()
@property (nonatomic, copy) NSArray<NSDictionary<NSString *,NSValue *> *> *guides;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIButton *btnGuide;
@property (nonatomic, strong) UILabel *labMessage;
@property (nonatomic, assign) WQMessageLocation location;
@end

@implementation WQGuideView
- (WQGuideView *)initWithFrame:(CGRect)frame
                       guides:(NSArray<NSDictionary<NSString *,NSValue *> *> *)guides {
    self = [super initWithFrame:frame];
    if (self) {
        self.guides = [guides copy];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        
        // 点击动作
        self.btnGuide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btnGuide.backgroundColor = [UIColor clearColor];
        [self.btnGuide addTarget:self
                          action:@selector(nextGuide:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnGuide];
        
        // 引导描述
        self.labMessage = [[UILabel alloc] init];
        self.labMessage.textColor = [UIColor whiteColor];
        self.labMessage.numberOfLines = 0;
        self.labMessage.font = [UIFont fontWithName:@"Avenir"
                                               size:14];
        [self addSubview:self.labMessage];
    }
    return self;
}

- (void)setMessageFont:(UIFont *)messageFont {
    self.labMessage.font = messageFont;
}

- (void)showGuide {
    self.currentIndex = 0;
    [self guideWithIndex:self.currentIndex];
}

- (void)guideWithIndex:(NSInteger)index {
    NSDictionary *dic = self.guides[index];
    CGRect rect = [dic[[[dic allKeys] firstObject]] CGRectValue];
    self.btnGuide.frame = rect;
    
    // 添加描述
    [self addMessage:[[dic allKeys] firstObject]
            nearRect:rect];
    
    // 添加空白处
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:self.bounds];
    [bezier appendPath:[[UIBezierPath bezierPathWithOvalInRect:rect] bezierPathByReversingPath]];
    layer.path = bezier.CGPath;
    layer.lineWidth = 2.f;
    layer.lineJoin = kCALineJoinBevel;
    layer.lineDashPattern = @[@5,@5];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor blackColor].CGColor;
    self.layer.mask = layer;
}

- (void)addMessage:(NSString *)message
          nearRect:(CGRect)rect{
    CGPoint center = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect)/2,
                                 CGRectGetMinY(rect) + CGRectGetHeight(rect)/2);
    self.location = center.x > sWidth - center.x ? Left : Right;
    self.location |= (sHeigth - center.y) > sHeigth/2 ? Down : Upper;
    
    // 文字最大显示区域
    CGSize size = CGSizeMake(self.location & Left ?  center.x : sWidth - center.x,
                             self.location & Upper ? sHeigth -10 - CGRectGetMinY(rect) : sHeigth - (10 + CGRectGetMaxY(rect)));
    
    // 文字长宽
    CGRect msgRect = [message boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : self.labMessage.font}
                                           context:nil];
    CGFloat labY = self.location & Upper ? CGRectGetMinY(rect) - 10 - CGRectGetHeight(msgRect) : CGRectGetMaxY(rect) + 10;
    CGFloat labX = self.location & Left ? center.x - CGRectGetWidth(msgRect) : center.x;
    CGRect labRect = CGRectMake(labX,
                                labY,
                                msgRect.size.width,
                                msgRect.size.height);
    self.labMessage.frame = labRect;
    self.labMessage.text = message;
}

- (void)nextGuide:(UIButton *)sender {
    self.currentIndex ++;
    if (self.currentIndex < self.guides.count) {
        [self guideWithIndex:self.currentIndex];
        return;
    }
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(hideGuide)]) {
        [self.delegate hideGuide];
    }
}
@end







