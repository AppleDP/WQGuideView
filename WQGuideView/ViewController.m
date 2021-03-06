//
//  ViewController.m
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 1516年 SUWQ. All rights reserved.
//

#import "WQGuideView.h"
#import "ViewController.h"

@interface ViewController ()<WQGuideViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    // 生成数据源
    NSMutableArray *customerShapes = [[NSMutableArray alloc] init];
    NSArray *subViews = self.view.subviews;
    NSMutableArray<NSDictionary<NSString *,NSValue *> *> *mutableGuides = [[NSMutableArray alloc] initWithCapacity:subViews.count];
    for (int index = 0; index < subViews.count; index ++) {
        if ([subViews[index] isKindOfClass:[UILabel class]] || [subViews[index] isKindOfClass:[UIImageView class]]) {
            NSString *describe = [NSString stringWithFormat:@"Welcome to use WQGuideView .\n The current view is %@ , number is %d",[subViews[index] class],index];
            UIView *view = subViews[index];
            
            // 添加描述内容和引导位置
            [mutableGuides addObject:@{describe : [NSValue valueWithCGRect:view.frame]}];

            /************************** 自 定 义 引 导 形 状 **************************/
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMinX(view.frame)-10, CGRectGetMinY(view.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(view.frame)+10, CGRectGetMinY(view.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(view.frame)+10-CGRectGetWidth(view.frame)*1/5, CGRectGetMaxY(view.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(view.frame)-10+CGRectGetWidth(view.frame)*1/5, CGRectGetMaxY(view.frame))];
            [path closePath];
            [customerShapes addObject:path];
        }
    }
    
    /************************** 生 成 引 导 视 图 **************************/
    WQGuideView *guideView = [[WQGuideView alloc] initWithFrame:self.view.bounds
                                                         guides:mutableGuides];
    guideView.delegate = self;
    
    
    /************************** 使 用 自 定 的 引 导 形 状 **************************/
//    guideView.boxStyle = WQCustomer;
//    guideView.customerShapes = customerShapes;
    
    
    /************************** 使 用 内 置 引 导 图 形 **************************/
//    /* 圆 形 */
//    guideView.boxStyle |= WQCircle;
//    /* 方 形 */
//    guideView.boxStyle |= WQRect;
//    /* 加 花 纹 */
//    guideView.boxStyle |= WQPattern;
//    /* 不 加 花 纹 */
//    guideView.boxStyle |= WQNonePattern;
    
    
    /************************** 使 用 内 置 引 导 描 述 放 置 样 式 **************************/
//    guideView.messageStyle = WQStyle1;
    
    
    /************************** 设 置 引 导 描 述 字 体 **************************/
//    guideView.messageFont = [UIFont systemFontOfSize:15];
//    guideView.messageColor = [UIColor greenColor];
    
    
    /************************** 设 置 引 导 描 述 与 引 导 框 距 离 **************************/
//    guideView.space = 10;
    
    
    [self.view addSubview:guideView];
    [guideView showGuide];
}

#pragma mark WQGuideViewDelegate
- (void)hideGuide {
    NSLog(@"***************** 欢 迎 使 用 WQGuideView *****************");
}
@end







