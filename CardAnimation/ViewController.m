//
//  ViewController.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "ViewController.h"
#import "CCAnimationContainerView.h"
#import "CardView.h"

@interface ViewController ()

@property(nonatomic, strong) CCAnimationContainerView *cardContainerView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic)float leftWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self createCardViewWithDataSource:self.dataArray];
}

//创建容器
- (void)createCardViewWithDataSource:(NSArray *)array {
    self.leftWidth = 10.0;
    
    CCAnimationContainerView * containerView = [[CCAnimationContainerView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 300)];
    self.cardContainerView = containerView;
    self.cardContainerView.totalCount = array.count;
    self.cardContainerView.dataSourceArray = array;
    
    self.cardContainerView.cardRefreshBlock = ^(){
        
    };
    self.cardContainerView.cardPushBlock = ^(){
        
    };
    [self.view addSubview:self.cardContainerView];
    [self setAnimationSubviews];
}

//设置容器子视图
-(void)setAnimationSubviews{
    self.cardContainerView.subViewArray = [NSMutableArray array];
    NSInteger cardCount = (self.dataArray.count >= 4)?4:self.dataArray.count;
    for(int i = 0;i < cardCount;i++){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CardView" owner:nil options:nil];
        CardView *cardView = [nibView lastObject];
        cardView.frame = CGRectMake(self.leftWidth, 0, CGRectGetWidth(self.cardContainerView.frame) - 2* self.leftWidth, CGRectGetHeight(self.cardContainerView.frame));
        [cardView setupDataSource:self.dataArray[i] andPage:i];
        
        cardView.tag = 100 + i;
        if(i == 1){
            cardView.frame = CGRectMake(10 + self.leftWidth, 10, CGRectGetWidth(self.cardContainerView.frame) - 2 * self.leftWidth - 20, CGRectGetHeight(self.cardContainerView.frame));
        }
        if(i >= 2){
            cardView.frame = CGRectMake(20 + self.leftWidth, 20, CGRectGetWidth(self.cardContainerView.frame) -2 * self.leftWidth - 40, CGRectGetHeight(self.cardContainerView.frame));
        }
        [self.cardContainerView.subViewArray addObject:cardView];
        [self.cardContainerView addSubview:cardView];
        [self.cardContainerView sendSubviewToBack:cardView];
        
    }
    [self.cardContainerView addPanGesture];
}

- (NSArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 1;i < 8;i++) {
            NSString *title = [NSString stringWithFormat:@"这是标题%d",i];
            NSString *content = [NSString stringWithFormat:@"这是内容%d",i];
            NSString *image = [NSString stringWithFormat:@"%d.jpg",i];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",content,@"content",image,@"image", nil];
            [_dataArray addObject:dic];
        }
    }
    return _dataArray;
}

@end
