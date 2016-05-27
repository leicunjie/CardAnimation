//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
@end

@implementation CardView


- (void)setupDataSource:(NSDictionary *)dataDic andPage:(int)page {
    self.page = page;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 7.0;
    [self setViewShadow];
    [self updateContentWithData:dataDic];
}

- (void)updateContentWithData:(id)data {
    NSString *title = data[@"title"];
    NSString *content = data[@"content"];
    NSString *imageName = data[@"image"];
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.imageView.image = [UIImage imageNamed:imageName];
}

-(void)setViewShadow {
    //设置阴影
    self.layer.shadowColor = [UIColor colorWithRed:10/255.0 green:2/255.0 blue:4/255.0 alpha:1].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,3.0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.1;//阴影透明度，默认0
}

@end
