//
//  WQGuideView.h
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQGuideViewDelegate <NSObject>
- (void)hideGuide;
@end

@interface WQGuideView : UIView
/*! 移除引导页面时调用代理 */
@property (nonatomic, weak) id<WQGuideViewDelegate> delegate;
/*! 设置引导提示文字 */
@property (nonatomic, strong) UIFont *messageFont;

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
