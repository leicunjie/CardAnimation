//
//  CCAnimationLoadingView.h
//  CCPlatform
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAnimationLoadingView : UIView

-(void)createImageView;

-(void)startLoading;

-(void)stopLoading;

@property(nonatomic)BOOL isLoading;

@end
