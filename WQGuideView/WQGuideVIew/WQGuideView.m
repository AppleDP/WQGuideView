//
//  WQGuideView.m
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import "WQGuideView.h"

#define sWidth  CGRectGetWidth(self.frame)
#define sHeigth CGRectGetHeight(self.frame)

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
        
        // 默认样式为圆形有花
        self.style = WQCircle;
        self.style |= WQNonePattern;
        
        // 描述与框默认距离
        self.space = 10;
        
        // 默认花边大小
        self.patternWidth = 5.f;
        
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
        self.messageFont = [UIFont fontWithName:@"Zapfino"
                                           size:10];
        [self addSubview:self.labMessage];
    }
    return self;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    self.labMessage.font = messageFont;
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.labMessage.textColor = messageColor;
}

- (void)showGuide {
    self.currentIndex = 0;
    [self guideWithIndex:self.currentIndex];
}

- (void)guideWithIndex:(NSInteger)index {
    if (self.guides.count == 0) {
        [self nextGuide:nil];
        return;
    }
    NSDictionary *dic = self.guides[index];
    CGRect rect = [dic[[[dic allKeys] firstObject]] CGRectValue];
    self.btnGuide.frame = rect;
    
    // 添加描述
    [self addMessage:[[dic allKeys] firstObject]
            nearRect:rect];
    
    UIBezierPath *shapePath;
    CGFloat lineWidth = 0.0;
    
    if (self.style & WQRect) {
        // 方形
        shapePath = [UIBezierPath bezierPathWithRect:rect];
    }
    
    if (self.style & WQCircle) {
        // 圆形
        shapePath = [UIBezierPath bezierPathWithOvalInRect:rect];
    }
    
    if (self.style & WQPattern) {
        // 有花纹
        lineWidth = self.patternWidth;
    }
    
    if (self.style & WQNonePattern) {
        // 无花纹
        lineWidth = 0;
    }
    
    if (self.style & WQCustomer) {
        // 用户自定义
        NSAssert(self.customerShapes.count == self.guides.count, @"自定义引导形状个数和引导个数不一致");
        shapePath = (UIBezierPath *)self.customerShapes[index];
    }
    
    // 添加圆形空白处
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:self.bounds];
    [bezier appendPath:[shapePath bezierPathByReversingPath]];
    layer.path = bezier.CGPath;
    layer.lineWidth = lineWidth;
    layer.lineDashPattern = @[@5,@5];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    self.layer.mask = layer;
}

#pragma mark 引导描述放于中心上下的一个边
- (void)addMessage:(NSString *)message
          nearRect:(CGRect)rect{
    CGPoint center = CGPointMake(CGRectGetMidX(rect),
                                 CGRectGetMidY(rect));
    self.location = center.x > sWidth - center.x ? Left : Right;
    self.location |= (sHeigth - center.y) > sHeigth/2 ? Down : Upper;
    
    // 文字最大显示区域
    CGSize size = CGSizeMake(self.location & Left ?  center.x : sWidth - center.x - 10,
                             self.location & Upper ? CGRectGetMinY(rect) - self.space : sHeigth - (self.space + CGRectGetMaxY(rect)));
    
    // 文字长宽
    CGRect msgRect = [message boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : self.labMessage.font}
                                           context:nil];
    CGFloat labY = self.location & Upper ? CGRectGetMinY(rect) - self.space - CGRectGetHeight(msgRect) : CGRectGetMaxY(rect) + self.space;
    CGFloat labX = self.location & Left ? center.x - CGRectGetWidth(msgRect) + 10 : center.x;
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
    self.currentIndex = 0;
    [self guideWithIndex:self.currentIndex];
    return;
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(hideGuide)]) {
        [self.delegate hideGuide];
    }
}
@end







