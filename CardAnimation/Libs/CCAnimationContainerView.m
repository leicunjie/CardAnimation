//
//  CCAnimationContainerView.m
//  CCPlatform
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "CCAnimationContainerView.h"
#import "CCAnimationLoadingView.h"
#import "CardView.h"

#define Duration 0.2f


@interface CCAnimationContainerView()<UIGestureRecognizerDelegate>

@property(nonatomic)int currentPage;
@property(nonatomic)int currentViewIndex;
@property(nonatomic) BOOL isPan;//是否已经滑动
@property(nonatomic) BOOL isLeft;//是否向左滑动
@property(nonatomic) BOOL reloadFirst;//右滑的是否为第一页
@property(nonatomic) BOOL isUnknownDirection;//开始状态时不能判断方向，change时进行判断
@property(nonatomic)CGFloat  lastXDistance;//上次滑动时XDistance
@property(nonatomic, assign) BOOL isPushed;
//view相关
@property(nonatomic,strong)CCAnimationLoadingView * loadingView;
@property(nonatomic,strong)CardView * firstView;
@property(nonatomic,strong)CardView * secondView;
@property(nonatomic,strong)CardView * thirdView;
@property(nonatomic,strong)CardView * fourthView;
@property(nonatomic,strong)CardView * beforeCardView;

@end

@implementation CCAnimationContainerView
{
    float _wid;
    float _hei;
    //第一到三张的原点和宽度
    float _firstLeftOrignX;
    float _secondLeftOrignX;
    float _thirdLeftOrignX;
    float _firstWidth;
    float _secondWidth;
    float _thirdWidth;
    
    float _currentAngle;//当前转动的角度
    double _startDate ;//右滑开始时间
    double _endDate ;//右滑结束时间
}

- (id)initWithCardDataSource:(NSArray *)dataSourceArray {
    if(self = [super init]) {
        self.dataSourceArray = dataSourceArray;
    }
    return self;
}


-(void)addPanGesture{
    
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    
    //初始化数据
    CardView * currentcardView = self.subViewArray[self.currentPage];
    _wid = currentcardView.frame.size.width;
    _hei = currentcardView.frame.size.height;
    self.leftWidth = 18.0;
    _firstLeftOrignX = self.leftWidth;
    _secondLeftOrignX = self.leftWidth + 10;
    _thirdLeftOrignX = self.leftWidth + 20;
    _firstWidth = _wid;
    _secondWidth = _wid - 20;
    _thirdWidth = _wid - 40;
}

//调整显示view的frame
-(void)resetSubviews{
    [self obtainCardViews];
    [self changeFrameWithView:self.firstView showView2:self.secondView showView3:self.thirdView andHiddenView:self.fourthView];
}

- (void)changeFrameWithView:(CardView*)showView1
                  showView2:(CardView*)showView2
                  showView3:(CardView*)showView3
              andHiddenView:(CardView*)hiddenView{
    showView1.hidden = NO;
    showView2.hidden = NO;
    showView3.hidden = NO;
    hiddenView.hidden = YES;
    [self bringSubviewToFront:showView3];
    [self bringSubviewToFront:showView2];
    [self bringSubviewToFront:showView1];
    
    if(self.currentPage == self.totalCount - 2){
        showView3.hidden = YES;
    }
    else if(self.currentPage == self.totalCount - 1){
        showView2.hidden = YES;
        showView3.hidden = YES;
    }
    showView1.frame = CGRectMake(_firstLeftOrignX, 0, _firstWidth , _hei);
    showView2.frame = CGRectMake(_secondLeftOrignX, 10,_secondWidth ,_hei);
    showView3.frame = CGRectMake(_thirdLeftOrignX, 20,_thirdWidth , _hei);
    showView1.page = self.currentPage;
    showView2.page = self.currentPage + 1;
    showView3.page = self.currentPage + 2;
    if(self.currentPage < self.dataSourceArray.count)
        [showView1 updateContentWithData:self.dataSourceArray[self.currentPage]];
    if(self.currentPage + 1 < self.dataSourceArray.count)
        [showView2 updateContentWithData:self.dataSourceArray[self.currentPage + 1]];
    if(self.currentPage + 2 < self.dataSourceArray.count)
        [showView3 updateContentWithData:self.dataSourceArray[self.currentPage + 2]];
}

- (void)obtainCardViews{
    self.currentViewIndex = self.currentPage % 4;
    [self obtainFirstView];
    [self obtainSecondView];
    [self obtainThirdView];
    [self obtainfourthView];
    [self obtainBeforeCardView];
}

-(void)obtainFirstView{
    CardView * currentcardView = self.subViewArray[self.currentViewIndex];
    self.firstView = currentcardView;
}

-(void)obtainSecondView{
    CardView * nextcardView;
    if(self.currentPage + 1 < self.totalCount){
        if(self.currentViewIndex + 1 == 4)
            nextcardView = self.subViewArray[0];
        else
            nextcardView = self.subViewArray[self.currentViewIndex + 1];
    }
    self.secondView = nextcardView;
}

-(void)obtainThirdView{
    CardView * nextNextcardView;
    if(self.currentPage + 2 < self.totalCount){
        if(self.currentViewIndex + 2 == 4)
            nextNextcardView = self.subViewArray[0];
        else if(self.currentViewIndex + 2 == 5)
            nextNextcardView = self.subViewArray[1];
        else
            nextNextcardView = self.subViewArray[self.currentViewIndex + 2];
    }
    self.thirdView = nextNextcardView;
}

-(void)obtainfourthView{
    CardView * cardView;
    if(self.currentPage + 3 < self.totalCount){
        if(self.currentViewIndex == 0)
            cardView = self.subViewArray[3];
        else if(self.currentViewIndex == 1)
            cardView = self.subViewArray[0];
        else if(self.currentViewIndex == 2)
            cardView = self.subViewArray[1];
        else if(self.currentViewIndex == 3)
            cardView = self.subViewArray[2];
    }
    self.fourthView = cardView;
}

-(void)obtainBeforeCardView{
    CardView * beforecardView;
    if(self.currentPage - 1 >= 0){
        if(self.currentViewIndex - 1 < 0)
            beforecardView = self.subViewArray[3];
        else
            beforecardView = self.subViewArray[self.currentViewIndex - 1];
        [beforecardView updateContentWithData:[self.dataSourceArray objectAtIndex:self.currentPage - 1]];
    }
    self.beforeCardView = beforecardView;
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    if(self.currentPage >= self.totalCount)
        return;
    if(self.loadingView.isLoading)
        return;
    [self obtainCardViews];
    
    CGFloat xDistance = [self xDistanceWithGesture:gestureRecognizer];
    CGFloat rotationStrength = MIN(xDistance / _hei, 1);
    CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
    [self setAnchorPointAndPosition];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self beginPaningCardsWithXDistance:xDistance];
            break;
        };
        case UIGestureRecognizerStateChanged:{
            [self currentAngleWithRotationAngel:rotationAngel];
            if(self.isUnknownDirection == YES)
                [self directionWithXdistance:xDistance];
            //向左移动，不是最后一张
            if((xDistance < 0) && (self.isLeft == YES) && (self.currentPage != self.totalCount - 1))
                [self leftPanNotFirst];
            //向左移动，为最后一张
            else if((xDistance < 0) && (self.isLeft == YES) && (self.currentPage == self.totalCount - 1))
                [self lastCardToLeftWithXDistance:xDistance];
            //向右移动,是第一张
            else if(xDistance > 0 && (self.currentPage == 0) && (self.isLeft == NO))
                [self firstRightPanWithDistance:xDistance isEnd:NO];
            //向左移动，向右返回
            else if(xDistance > 0 && (self.isLeft == YES) &&(self.currentPage != 0) &&  (self.currentPage != self.totalCount - 1) && (self.lastXDistance < 0)){
                [self toLeftThenBack];
            }
            //向右移动,不是第一张
            else if(xDistance > 0 && (self.currentPage != 0) && (self.isLeft == NO))
                [self toRightNotFirstWithXDistance:xDistance];
            else
                [self otherStateChange];
            break;
        };
        case UIGestureRecognizerStateEnded:{
            //向右滑的为第一张
            if(self.reloadFirst && xDistance > 0 )
                [self firstRightPanWithDistance:xDistance isEnd:YES];
            //第一张，向右滑后再向左滑
            else if(self.reloadFirst && xDistance < 0 )
                [self firstToRightThenLeftEnd];
            //向左移出
            else if(_currentAngle <= -0.26  && (self.currentPage != self.totalCount - 1))
                [self toLeftEnd];
            //向左未超过15度回到原点
            else if(_currentAngle < 0 && (_currentAngle > - 0.26) &&
                    (self.currentPage != self.totalCount - 1))
                [self toLeftThenRightEnd];
            //向左滑为最后一张
            else if(_currentAngle < 0  && (self.currentPage == self.totalCount - 1))
                [self lastToLeftEnd];
            //向右滑不是第一张
            else if(self.isLeft == NO && (self.currentPage != 0))
                [self toRightNotFirstEndWithXDistance:xDistance];
            else
                [self otherStateEnd];
            
            [self endPaningCards];
            break;
        }
        default:
            break;
    }
}

#pragma mark - begin
//开始平移卡片
-(void)beginPaningCardsWithXDistance:(float)xDistance{
    self.isPandingCard = YES;
    //判断当前是往左还是往右滑
    if(_currentAngle == 0 && xDistance > 0)
        self.isLeft = NO;
    else if(_currentAngle == 0 && xDistance < 0)
        self.isLeft = YES;
    else if(_currentAngle == 0 && xDistance == 0)
        self.isUnknownDirection = YES;
}

#pragma mark - change
//第一张向右滑动
-(void)firstRightPanWithDistance:(CGFloat)xDistance isEnd:(BOOL)isEnd{
    if(xDistance > _wid/3)
        xDistance = _wid/3;
    else if (xDistance < 70){
        if(isEnd)
            xDistance = 70;
    }
    for(int i = 0;i < self.subViewArray.count;i++){
        CardView * baseView = [self.subViewArray objectAtIndex:i];
        if(i == self.currentPage)
            baseView.frame = CGRectMake(_firstLeftOrignX + xDistance, 0, _firstWidth, _hei);
        else if(i == self.currentPage + 1)
            baseView.frame = CGRectMake(_secondLeftOrignX + xDistance, 10, _secondWidth, _hei);
        else
            baseView.frame = CGRectMake(_thirdLeftOrignX + xDistance, 20, _thirdWidth, _hei);
    }
    if(!isEnd){
        self.reloadFirst = YES;
        if(self.loadingView == nil)
            [self createLoadingView];
    }
    else{
        [self resetAngleAndIsPan];
        [self startAnimation];
    }
    NSLog(@"type3");
}

//第一张向左滑动
-(void)firstLeftPan{
    for(int i = 0;i < self.subViewArray.count;i++){
        CardView * baseView = [self.subViewArray objectAtIndex:i];
        if(i == self.currentPage)
            baseView.frame = CGRectMake(_firstLeftOrignX, 0, _firstWidth, _hei);
        else if(i == self.currentPage + 1)
            baseView.frame = CGRectMake(_secondLeftOrignX, 10, _secondWidth, _hei );
        else
            baseView.frame = CGRectMake(_thirdLeftOrignX, 20,_thirdWidth, _hei );
    }
    self.reloadFirst = NO;
    [self stopAnimation];
}

//非第一张向左移动
-(void)leftPanNotFirst{
    self.firstView.layer.position = CGPointMake(self.leftWidth + _wid, _hei);
    self.firstView.layer.anchorPoint = CGPointMake(1, 1);
    if(_currentAngle > 0){
        self.firstView.transform = CGAffineTransformMakeRotation(0);
        self.secondView.transform = CGAffineTransformMakeRotation(0);
    }
    else if(_currentAngle > -0.26){
        self.firstView.transform = CGAffineTransformMakeRotation(_currentAngle);
        self.secondView.transform = CGAffineTransformMakeRotation(_currentAngle/2.0);
    }
    else{
        self.firstView.transform = CGAffineTransformMakeRotation(-0.26);
        self.secondView.transform = CGAffineTransformMakeRotation(-0.13);
    }
    self.isLeft = YES;
    NSLog(@"type1");
}

-(void)lastCardToLeftWithXDistance:(float)xDistance{
    if(xDistance < -_wid/3) {
        xDistance = -_wid/3;
        if (!_isPushed) {
            self.isPushed = YES;
            [self startPush];
        }
    }
    self.firstView.frame = CGRectMake(_firstLeftOrignX + xDistance, 0,_firstWidth, _hei);
    self.isLeft = YES;
    NSLog(@"type2");
}

-(void)toLeftThenBack
{
    [UIView animateWithDuration:Duration/2 animations:^{
        self.firstView.transform = CGAffineTransformMakeRotation(_currentAngle>0?0:_currentAngle);
        self.secondView.transform = CGAffineTransformMakeRotation(_currentAngle/2.0>0?0:_currentAngle/2.0);
    }];
    NSLog(@"type4");
}

-(void)toRightNotFirstWithXDistance:(float)xDistance{
    if(_startDate == 0)
        _startDate =  [[NSDate date]timeIntervalSince1970];
    [self bringSubviewToFront:self.beforeCardView];
    self.beforeCardView.frame = CGRectMake(-_wid-self.frame.origin.x + xDistance, 0, _wid, _hei);
    self.beforeCardView.hidden = NO;
    NSLog(@"type5");
}

-(void)otherStateChange{
    if((self.currentPage == 0) && (self.totalCount > 1) && (self.isLeft == YES)){
        [UIView animateWithDuration:Duration/2 animations:^{
            self.firstView.transform = CGAffineTransformMakeRotation(_currentAngle>0?0:_currentAngle);
            self.secondView.transform = CGAffineTransformMakeRotation(_currentAngle/2>0?0:_currentAngle/2);
        }];
    }
    NSLog(@"type6");
}

#pragma mark - end
- (void)firstToRightThenLeftEnd{
    [UIView animateWithDuration:Duration animations:^{
        [self firstLeftPan];
    } completion:^(BOOL finished) {
        self.reloadFirst = NO;
    }];
}

- (void)toLeftEnd{
    if(self.isPan == NO){
        self.isPan = YES;
        self.currentPage = self.currentPage + 1;
        self.currentViewIndex = self.currentPage % 4;
        self.fourthView.hidden = NO;
        self.fourthView.frame = CGRectMake(_thirdLeftOrignX, 20,_thirdWidth , _hei);
        
        self.firstView.layer.anchorPoint = CGPointMake(1, 1);
        [UIView animateWithDuration:Duration animations:^{
            float orignY = 0.134*0.966*_wid - 5;//y点移动的距离
            self.firstView.frame =
            CGRectMake(-_wid-self.frame.origin.x,orignY, _wid, _hei);
            self.firstView.transform = CGAffineTransformMakeRotation(0);
            self.secondView.transform = CGAffineTransformMakeRotation(0);
            self.secondView.frame = CGRectMake(_firstLeftOrignX,0, _wid, _hei);
            self.thirdView.frame =
            CGRectMake(_secondLeftOrignX, 10,_secondWidth ,_hei);
            
        } completion:^(BOOL finished) {
            [self resetAngleAndIsPan];
            [self.firstView setHidden:YES];
            [self resetSubviews];
        }];
    }
}

- (void)toLeftThenRightEnd{
    if(self.isPan == NO){
        self.isPan = YES;
        [UIView animateWithDuration:Duration animations:^{
            self.firstView.transform = CGAffineTransformMakeRotation(0);
            self.secondView.transform = CGAffineTransformMakeRotation(0);
            self.firstView.layer.anchorPoint = CGPointMake(1,1);
            self.secondView.layer.anchorPoint = CGPointMake(1,1);
        } completion:^(BOOL finished) {
            [self resetAngleAndIsPan];
        }];
    }
}

- (void)toRightNotFirstEndWithXDistance:(float)xDistance{
    if(xDistance > 1/4.0 * _wid){
        self.isLeft = YES;
        self.currentPage = self.currentPage - 1;
        self.currentViewIndex = self.currentPage % 4;
        float duration =  [self rightPanDurationWithXDistance:xDistance];
        [UIView animateWithDuration:duration animations:^{
            self.beforeCardView.frame = CGRectMake(_firstLeftOrignX, 0,_firstWidth , _hei);
        } completion:^(BOOL finished) {
            [self resetSubviews];
            [self resetAngleAndIsPan];
        }];
    }
    else{
        [UIView animateWithDuration:Duration animations:^{
            self.beforeCardView.frame = CGRectMake(-_wid-self.frame.origin.x, 0, _wid, _hei);
        } completion:^(BOOL finished) {
            [self resetSubviews];
            [self resetAngleAndIsPan];
        }];
    }
}

- (void)lastToLeftEnd{
    self.isPushed = NO;
    [UIView animateWithDuration:Duration animations:^{
        self.firstView.frame = CGRectMake(_firstLeftOrignX, 0, _wid, _hei);
    } completion:^(BOOL finished) {
    }];
}

- (void)otherStateEnd{
    [UIView animateWithDuration:Duration/2 animations:^{
        self.firstView.transform = CGAffineTransformMakeRotation(0);
        self.secondView.transform = CGAffineTransformMakeRotation(0);
    }];
    NSLog(@"##########");
}

-(void)endPaningCards{
    _currentAngle = 0;
    self.lastXDistance = 0;
    self.isLeft = NO;
    self.isPandingCard = NO;
}

#pragma mark private
- (CGFloat)xDistanceWithGesture:(UIPanGestureRecognizer*)gestureRecognizer{
    CGFloat xDistance = [gestureRecognizer translationInView:self.firstView].x;
    //向左滑动
    if(self.isLeft == YES && (self.currentPage != self.currentViewIndex - 1))
    {
        float xOffset = xDistance;
        //向右返回
        if(xDistance > self.lastXDistance){
            xDistance = xDistance - self.lastXDistance;
        }
        self.lastXDistance = xOffset;
    }
    return xDistance;
}

//转动角度清零  是否已经平移改为NO
-(void)resetAngleAndIsPan{
    self.isPan = NO;
    _currentAngle = 0;
}

- (void)currentAngleWithRotationAngel:(CGFloat)rotationAngel{
    //15度 0.26
    _currentAngle += rotationAngel;
    if(_currentAngle > 0.27)
        _currentAngle = 0.27;
    if(_currentAngle < - 0.27)
        _currentAngle = -0.27;
}

- (void)setAnchorPointAndPosition{
    if(!(_currentPage == 0 && self.totalCount == 1)) {
        self.firstView.layer.anchorPoint = CGPointMake(1,1);
        self.secondView.layer.anchorPoint = CGPointMake(1,1);
    }
    //不是第一页和最后一页
    if(self.reloadFirst == NO && (self.currentPage != self.totalCount - 1)){
        self.firstView.layer.position = CGPointMake(self.leftWidth + _wid, _hei);
        self.secondView.layer.position = CGPointMake(self.leftWidth + _wid - 10, _hei + 10);
    }
}

//右滑开始结束时间
-(CFTimeInterval)intevalTime{
    CFTimeInterval inteval = (_endDate - _startDate);
    _startDate = 0;
    return inteval;
}

//右滑动画时长
-(float)rightPanDurationWithXDistance:(float)xDistance{
    _endDate = [[NSDate date]timeIntervalSince1970];
    double inteval = [self intevalTime];
    double duration = (_wid - xDistance)/(xDistance/inteval);
    duration /= 2;
    if(duration > Duration)
        duration = Duration;
    return duration;
}

//创建loadingView
-(void)createLoadingView{
    [self.loadingView removeFromSuperview];
    self.loadingView = [[CCAnimationLoadingView alloc]init];
    self.loadingView.frame = CGRectMake(_firstLeftOrignX,self.frame.origin.y + _hei/2 - 30, 60, 60);
    [self.loadingView createImageView];
    [self.superview addSubview:self.loadingView];
    [self.superview sendSubviewToBack:self.loadingView];
}

//停止动画
-(void)stopAnimation{
    [self.loadingView stopLoading];
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
}

//开始动画
-(void)startAnimation{
    [self.loadingView startLoading];
    if(self.cardRefreshBlock)
        self.cardRefreshBlock();
    [self performSelector:@selector(firstLeftPan) withObject:nil afterDelay:3.0];
}

- (void)startPush {
    if (self.cardPushBlock) {
        self.cardPushBlock();
    }
}

//判断方向
-(void)directionWithXdistance:(float)xDistance{
    NSLog(@"isUnknownDirection");
    self.isUnknownDirection = NO;
    if(xDistance < 0)
        self.isLeft = YES;
    else if(xDistance > 0)
        self.isLeft = NO;
}

@end
