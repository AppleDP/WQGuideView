//
//  WQGuideView.h
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WQNonePattern = 1,        /*! 没有花纹 */
    WQPattern     = 1 << 1,   /*! 有花纹 */
    WQRect        = 1 << 2,   /*! 方形 */
    WQCircle      = 1 << 3,   /*! 圆形 */
    WQCustomer    = 1 << 4    /*! 自定义引导图形 */
}WQGuideStyle;

@protocol WQGuideViewDelegate <NSObject>
- (void)hideGuide;
@end

@interface WQGuideView : UIView
/*! 移除引导页面时调用代理 */
@property (nonatomic, weak) id<WQGuideViewDelegate> delegate;
/*! 引导描述与引导框距离，默认为 10 */
@property (nonatomic, assign) CGFloat space;
/*! 设置引导提示文字字体 */
@property (nonatomic, strong) UIFont *messageFont;
/*! 设置引导提示文字颜色，默认为白 */
@property (nonatomic, strong) UIColor *messageColor;
/*! 引导框样式，默认为圆形无边框 */
@property (nonatomic, assign) WQGuideStyle style;
/*! 自定义引导框形状，在 style 设置为 WQCustomer 时可用 */
@property (nonatomic, copy) NSArray<UIBezierPath *> *customerShapes;
/*! 花纹大小，默认为 5，在 style 设置为 WQPattern 时可用 */
@property (nonatomic, assign) CGFloat patternWidth;

/*!
 *  初始化引导页面
 *
 *  @param frame  引导页面的 frame
 *  @param guides <@"引导描述" : 点击范围>
 *
 *  @return 引导页面
 */
- (WQGuideView *)initWithFrame:(CGRect)frame
                        guides:(NSArray<NSDictionary<NSString *,NSValue *> *> *)guides;

/*!
 *  开始引导
 */
- (void)showGuide;
@end





