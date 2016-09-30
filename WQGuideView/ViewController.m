//
//  ViewController.m
//  WQGuideView
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SUWQ. All rights reserved.
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
    NSArray *subViews = self.view.subviews;
    NSMutableArray<NSDictionary<NSString *,NSValue *> *> *mutableGuides = [[NSMutableArray alloc] initWithCapacity:subViews.count];
    for (int index = 0; index < subViews.count; index ++) {
        if ([subViews[index] isKindOfClass:[UILabel class]] || [subViews[index] isKindOfClass:[UIImageView class]]) {
            NSString *describe = [NSString stringWithFormat:@"This is %@ %d",[subViews[index] class],index];
            UIView *view = subViews[index];
            [mutableGuides addObject:@{describe : [NSValue valueWithCGRect:view.frame]}];
        }
    }
    
    WQGuideView *guideView = [[WQGuideView alloc] initWithFrame:self.view.bounds
                                                         guides:mutableGuides];
    guideView.delegate = self;
    [guideView showGuide];
    [self.view addSubview:guideView];
}

- (void)hideGuide {
    NSLog(@"***************** 欢 迎 使 用 WQGuideView *****************");
}
@end







