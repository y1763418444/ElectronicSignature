//
//  SignViewController.h
//  UIViewTool
//
//  Created by msy on 2017/9/12.
//  Copyright © 2017年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignResult)(UIImage *signImage);

@interface SignViewController : UIViewController

/**
 已签名的照片,跳转传入
 */
@property (nonatomic, strong) UIImage *signImage;

/**
 签名笔划颜色 (默认蓝色)
 */
@property (nonatomic, strong) UIColor *signLineColor;

/**
 签名笔划宽度 (默认3.3)
 */
@property (nonatomic, assign) CGFloat signLineWidth;

/**
 无签名时占位文字 (默认签名区域)
 */
@property (nonatomic, copy) NSString *signPlaceHoalder;


/**
 签名完成后的回调Block,里面有完成的签名图片

 @param result block
 */
- (void)signResultWithBlock:(SignResult)result;

@end
