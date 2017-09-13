//
//  UIView+Helper.m
//  UIviewTool
//
//  Created by msy on 2017/9/12.
//  Copyright © 2017年 YM. All rights reserved.
//

#import "UIView+Helper.h"
#import <objc/runtime.h>

#define kRaniansToDegress(radians) ((radians) * (180.0 / M_PI))
#define kDegressToRanians(angle)  ((angle) / 180.0 * M_PI)

static char *LayerCornerRadius = "layerCornerRadius";
@implementation UIView (Helper)
@dynamic top, bottom, left, right, centerX, centerY, x, y, origin, width, height, size;
- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    objc_setAssociatedObject(self, LayerCornerRadius, @(layerCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setCornerRadius:layerCornerRadius];
}
- (CGFloat)layerCornerRadius {
    return ([(NSNumber *)objc_getAssociatedObject(self, LayerCornerRadius) integerValue]) * 1.0;
}
- (void)setCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, self.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 2.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
#pragma mark 呼吸动画
- (void)breathAnimation {
    [self breathAnimationWithDuaration:1.0f dealy:0 repeatCount:HUGE_VALF breathingRate:1.0 completion:nil];
}
- (void)breathAnimationWithDuaration:(NSTimeInterval)duration dealy:(NSTimeInterval)delay repeatCount:(CGFloat)count breathingRate:(CGFloat)rate completion:(Completion)completion {
    CABasicAnimation *breath =[CABasicAnimation animationWithKeyPath:@"opacity"];
    breath.fromValue = [NSNumber numberWithFloat:rate];
    breath.toValue = [NSNumber numberWithFloat:0.0f];
    breath.autoreverses = YES;
    breath.duration = duration;
    breath.repeatCount = count;
    breath.beginTime = CACurrentMediaTime() + delay;
    breath.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:breath forKey:@"breathAnimation"];
    if (completion) {
        __block CGFloat breathCount = count;
        __block BOOL isfinish = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:duration repeats:YES block:^(NSTimer * _Nonnull timer) {
                breathCount--;
                if (breathCount == 0) {
                    isfinish = YES;
                    [timer invalidate];
                    timer = nil;
                }
                completion(isfinish);
            }];
        });
    }
}
- (void)stopBreathAnimation {
    [self.layer removeAnimationForKey:@"breathAnimation"];
}
#pragma mark 摇摆动画
- (void)shareAnimation {
    [self shareAnimationWithDuaration:1.0f dealy:0 repeatCount:HUGE_VALF shareAngle:10 completion:nil];
}
- (void)shareAnimationWithDuaration:(NSTimeInterval)duration dealy:(NSTimeInterval)delay repeatCount:(CGFloat)count shareAngle:(CGFloat)angle completion:(Completion)completion {
    CABasicAnimation *shark = [CABasicAnimation animationWithKeyPath:@"transform"];
    shark.duration = duration;
    shark.beginTime = CACurrentMediaTime() + delay;
    shark.repeatCount = count;
    angle = kDegressToRanians(angle);
    shark.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, - angle, 0.0, 0.0, 1.0)];
    shark.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, angle, 0.0, 0.0, 1.0)];
    [self.layer addAnimation:shark forKey:@"shareTransform"];
    
    if (completion) {
        __block CGFloat sharkCount = count;
        __block BOOL isfinish = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:duration repeats:YES block:^(NSTimer * _Nonnull timer) {
                sharkCount--;
                if (sharkCount == 0) {
                    isfinish = YES;
                    [timer invalidate];
                    timer = nil;
                }
                completion(isfinish);
            }];
        });
    }
}

- (void)stopShakeAnimation {
    [self.layer removeAnimationForKey:@"shareTransform"];
}
#pragma mark 旋转动画
- (void)startRotateAnimation {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.repeatCount = HUGE_VALF;
    rotate.duration = 0.6;
    rotate.autoreverses = NO;
    rotate.removedOnCompletion = NO;
    CGFloat angle = M_PI;
    rotate.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, angle, 0.0, 0.0, 1.0)];
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.0, 0.0, 0.0, 1.0)];
    [self.layer addAnimation:rotate forKey:@"rotateTransform"];
    
}
- (void)stopRotateAnimation {
    [self.layer removeAnimationForKey:@"rotateTransform"];
}

- (void)transitionAnimationWithDuration:(NSTimeInterval)duration animationType:(ZHTransitonAnimationType)type transitionDirection:(ZHTransitonAnimationDirection)direction {
    NSString *directionString = nil;
    switch (direction) {
        case ZHTransitonAnimationDirectionTop: {
            directionString = kCATransitionFromTop;
        }
            break;
        case ZHTransitonAnimationDirectionBottom: {
            directionString = kCATransitionFromBottom;
        }
            break;
        case ZHTransitonAnimationDirectionLeft: {
            directionString = kCATransitionFromLeft;
        }
            break;
        case ZHTransitonAnimationDirectionRight: {
            directionString = kCATransitionFromRight;
        }
            break;
        default: {
            
        }
            break;
    }
    NSString *typeString = nil;
    switch (type) {
        case ZHTransitonAnimationTypeFade: {//不支持过渡方向
            typeString = kCATransitionFade;
        }
            break;
        case ZHTransitonAnimationTypePush: {
            typeString = kCATransitionPush;
        }
            break;
        case ZHTransitonAnimationTypeMoveIn: {
            typeString = kCATransitionMoveIn;
        }
            break;
        case ZHTransitonAnimationTypeReveal: {
            typeString = kCATransitionReveal;
        }
            break;
        case ZHTransitonAnimationTypeCube: {
            typeString = @"cube";
        }
            break;
        case ZHTransitonAnimationTypeOglFlip: {
            typeString = @"oglFlip";
        }
            break;
        case ZHTransitonAnimationTypeSuckEffect: {//不支持过渡方向
            typeString = @"suckEffect";
            directionString = nil;
        }
            break;
        case ZHTransitonAnimationTypeRippleEffect: {//不支持过渡方向
            typeString = @"rippleEffect";
            directionString = nil;
        }
            break;
        case ZHTransitonAnimationTypePageCurl: {
            typeString = @"PageCurl";
        }
            break;
        case ZHTransitonAnimationTypePageUnCurl: {
            typeString = @"PageUnCurl";
        }
            break;
        case ZHTransitonAnimationTypeCameraIrisHollowOpen: {//不支持过渡方向
            typeString = @"cameraIrisHollowOpen";
        }
            break;
        case ZHTransitonAnimationTypeCameraIrisHollowClose: {//不支持过渡方向
            typeString = @"cameraIrisHollowClose";
        }
            break;
    }
    [self transitionWithDuration:duration animationType:typeString transitionDirection:directionString];
}


- (void)transitionWithDuration:(NSTimeInterval)duration animationType:(NSString *)type transitionDirection:(NSString *)direction {
    
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.type = type; //过度效果
    if (direction != nil) {
        animation.subtype = direction; //过渡方向
    }
    animation.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0; //动画停止终点(在整体动画的百分比)
    [self.layer addAnimation:animation forKey:@"transitionAnimation"];
}








@end
