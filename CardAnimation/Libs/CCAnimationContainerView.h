//
//  CCAnimationContainerView.h
//  CCPlatform
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CardRefreshBlock)();
typedef void(^CardPushBlock)();
@interface CCAnimationContainerView : UIView

/***子视图*/
@property(nonatomic,strong)NSMutableArray * subViewArray;
@property(nonatomic,strong)NSArray * dataSourceArray;
@property (nonatomic ,copy) CardRefreshBlock cardRefreshBlock;
@property(nonatomic, copy) CardPushBlock cardPushBlock;
@property (nonatomic)NSInteger totalCount;//卡片总数


- (id)initWithCardDataSource:(NSArray *)dataSourceArray;

/**
 *  正在滑动卡片
 */
@property(nonatomic)BOOL isPandingCard;
//与屏幕左部间距
@property(nonatomic)float leftWidth;

-(void)addPanGesture;

-(void)firstLeftPan;
- (void)lastToLeftEnd;
@end
