//
//  CCAnimationLoadingView.m
//  CCPlatform
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "CCAnimationLoadingView.h"

@interface CCAnimationLoadingView()

@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)NSString * path;

@end

@implementation CCAnimationLoadingView

-(void)createImageView{
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"loading_2_animation_00000"];
    self.imgView = imgView;
    [self addSubview:imgView];
}

-(void)startLoading{
    NSMutableArray * imgArray = [NSMutableArray array];
    for(int i = 0;i <= 3;i++){
        NSString * imgStr = [NSString stringWithFormat:@"loading_2_animation_000%02d",i];
        UIImage * image = [UIImage imageNamed:imgStr];
        [imgArray addObject:image];
    }
    self.imgView.animationImages = imgArray;
    //设置重复次数，0表示不重复
    self.imgView.animationRepeatCount=0;
    self.imgView.animationDuration = 2.0;
    [self.imgView startAnimating];
    self.isLoading = YES;
}

-(void)stopLoading{
    [self.imgView stopAnimating];
    self.isLoading = NO;
}

@end
