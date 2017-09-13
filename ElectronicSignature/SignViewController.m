

//
//  SignViewController.m
//  UIViewTool
//
//  Created by msy on 2017/9/12.
//  Copyright © 2017年 YM. All rights reserved.
//

#import "SignViewController.h"
#import "UIView+Helper.h"

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface SignViewController ()
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UILabel *placeHoalderLabel;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, copy) SignResult result;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
    [self layoutSubviews];
}

- (void)layoutSubviews {
    // 导航view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.y = topView.bottom;
    line.width = topView.width;
    line.height = 1;
    line.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.8];
    [self.view addSubview:line];
    [self.view addSubview:topView];
    
    // 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 44);
    [backBtn setTitle:@" <返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 0, self.view.width, 44)];
    titleLabel.text = @"电子签名";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    [topView addSubview:titleLabel];
    
    // 签字区域
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.x = 10;
    imageView.y = topView.bottom + 10;
    imageView.width = self.view.width - 20;
    imageView.height = self.view.height - (topView.bottom + 20 + 50);
    imageView.layerCornerRadius = 10;
    imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.signImageView = imageView;
    [self.view addSubview:imageView];
    
    // 提示
    UILabel *placeHoalderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    placeHoalderLabel.width = imageView.width;
    placeHoalderLabel.height = 100;
    placeHoalderLabel.center = imageView.center;
    placeHoalderLabel.textAlignment = NSTextAlignmentCenter;
    if (self.signPlaceHoalder) {
        placeHoalderLabel.text = self.signPlaceHoalder;
    } else {
        placeHoalderLabel.text = @"签名区域";
    }
    placeHoalderLabel.font = [UIFont systemFontOfSize:35];
    placeHoalderLabel.alpha = 0.8;
    placeHoalderLabel.textColor = [UIColor grayColor];
    self.placeHoalderLabel = placeHoalderLabel;
    [self.view addSubview:placeHoalderLabel];
    
    // 清除按钮
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectZero;
    clearBtn.y = imageView.bottom + 10;
    clearBtn.width = self.view.width / 2;
    clearBtn.height = 50;
    clearBtn.layer.borderColor = [UIColor redColor].CGColor;
    clearBtn.layer.borderWidth = 1.0;
    NSString *title = @"清除";
    if (self.signImage) {
        title = @"修改";
        imageView.image = self.signImage;
        placeHoalderLabel.hidden = YES;
    }
    [clearBtn setTitle:title forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearSignAction:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.8];
    [self.view addSubview:clearBtn];
    
    // 完成
    UIButton *signDone = [UIButton buttonWithType:UIButtonTypeCustom];
    signDone.frame = clearBtn.frame;
    signDone.x = clearBtn.right;
    signDone.layer.borderColor = [UIColor redColor].CGColor;
    signDone.layer.borderWidth = 1.0;
    [signDone setTitle:@"完成" forState:UIControlStateNormal];
    [signDone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [signDone addTarget:self action:@selector(signDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    signDone.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:signDone];
}

#pragma mark - 绘制
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.signImageView];
    if (self.lastPoint.x > 0) {
        self.placeHoalderLabel.text = nil;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.signImageView];
    UIGraphicsBeginImageContext(self.signImageView.frame.size);
    [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    //CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

    CGPoint midPoint = midpoint(self.lastPoint, currentPoint);
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(), midPoint.x,midPoint.y,currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGFloat lineWidth = 3.3;
    if (self.signLineWidth) {
        lineWidth = self.signLineWidth;
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if (self.signLineColor) {
        NSDictionary *rgbDic = [self RGBDictionaryByColor:self.signLineColor];
        red = [rgbDic[@"red"] floatValue];
        green = [rgbDic[@"green"] floatValue];
        blue = [rgbDic[@"blue"] floatValue];
    }
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
}

#pragma mark - 返回
- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signResultWithBlock:(SignResult)result {
    self.result = result;
}

#pragma mark - 完成
- (void)signDoneAction:(UIButton *)sender {
    if (self.result) {
        self.result(self.signImageView.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 清除
- (void)clearSignAction:(UIButton *)sender {
    self.signImageView.image = nil;
    self.placeHoalderLabel.hidden = NO;
    if (self.signPlaceHoalder) {
        self.placeHoalderLabel.text = self.signPlaceHoalder;
    } else {
        self.placeHoalderLabel.text = @"签名区域";
    }
}

#pragma mark - 根据颜色返回字典
- (NSDictionary *)RGBDictionaryByColor:(UIColor *)color {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(color.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{@"red":@(red), @"green":@(green), @"blue":@(blue), @"alpha":@(alpha)};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
