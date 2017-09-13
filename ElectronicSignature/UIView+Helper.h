//
//  UIView+Helper.h
//  UIviewTool
//
//  Created by msy on 2017/9/12.
//  Copyright © 2017年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZHTransitonAnimationType) {
    ZHTransitonAnimationTypeFade, //交叉淡化过渡(不支持过渡方向)
    ZHTransitonAnimationTypePush, //新视图把旧视图推出去
    ZHTransitonAnimationTypeMoveIn, //新视图移到旧视图上面
    ZHTransitonAnimationTypeReveal, //将旧视图移开,显示下面的新视图
    ZHTransitonAnimationTypeCube, //立方体翻滚效果
    ZHTransitonAnimationTypeOglFlip, //上下左右翻转效果
    ZHTransitonAnimationTypeSuckEffect, //收缩效果，如一块布被抽走(不支持过渡方向)
    ZHTransitonAnimationTypeRippleEffect, //滴水效果(不支持过渡方向)
    ZHTransitonAnimationTypePageCurl, //向上翻页效果
    ZHTransitonAnimationTypePageUnCurl, //向下翻页效果
    ZHTransitonAnimationTypeCameraIrisHollowOpen, //相机镜头打开效果(不支持过渡方向)
    ZHTransitonAnimationTypeCameraIrisHollowClose, //相机镜头关上效果(不支持过渡方向)
};

typedef NS_ENUM(NSUInteger, ZHTransitonAnimationDirection) {
    ZHTransitonAnimationDirectionTop,
    ZHTransitonAnimationDirectionBottom,
    ZHTransitonAnimationDirectionLeft,
    ZHTransitonAnimationDirectionRight,
    ZHTransitonAnimationDirectionNone,
};

typedef void(^Completion)(BOOL finished);

@interface UIView (Helper)

/**
 设置圆角属性,任意继承自UIView的控件
 */
@property (nonatomic, assign) CGFloat layerCornerRadius;

/**
 控件顶部,即y坐标
 */
@property (nonatomic, assign) CGFloat top;

/**
 控件底部,即y坐标+高
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 控件左侧,即x坐标
 */
@property (nonatomic, assign) CGFloat left;

/**
 控件右侧,即x坐标+宽
 */
@property (nonatomic, assign) CGFloat right;

/**
 控件中心点X坐标
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 控件中心点Y坐标
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 控件X
 */
@property (nonatomic, assign) CGFloat x;

/**
 控件Y
 */
@property (nonatomic, assign) CGFloat y;
/**
 控件(x, y)
 */
@property (nonatomic, assign) CGPoint origin;

/**
 控件宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 控件高
 */
@property (nonatomic, assign) CGFloat height;

/**
 控件(width, height)
 */
@property (nonatomic, assign) CGSize size;

/**
 截图

 @return 图片
 */
- (UIImage *)screenshot;

/**
 控件所在的控制器

 @return 控制器
 */
- (UIViewController*)viewController;

/**
 呼吸动画,无限重复
 */
- (void)breathAnimation;

/**
 呼吸动画,可定制
 
 @param duration 动画周期
 @param delay 延迟时间
 @param count 重复次数
 @param rate  呼吸频率
 @param completion 动画完成事件
 */
- (void)breathAnimationWithDuaration:(NSTimeInterval)duration dealy:(NSTimeInterval)delay repeatCount:(CGFloat)count breathingRate:(CGFloat)rate completion:(Completion)completion;

/**
 停止呼吸动画
 */
- (void)stopBreathAnimation;

/**
 摇摆动画,无限重复
 */
- (void)shareAnimation;

/**
 摇摆动画,可定制

 @param duration 动画周期
 @param delay 延迟时间
 @param count 重复次数
 @param angle 摆动角度
 @param completion 动画完成事件
 */
- (void)shareAnimationWithDuaration:(NSTimeInterval)duration dealy:(NSTimeInterval)delay repeatCount:(CGFloat)count shareAngle:(CGFloat)angle completion:(Completion)completion;

/**
 停止摇摆动画
 */
- (void)stopShakeAnimation;

/**
 旋转动画
 */
- (void)startRotateAnimation;

/**
 停止旋转动画
 */
- (void)stopRotateAnimation;

/**
 页面跳转动画

 @param duration 动画周期
 @param type 动画方式
 @param direction 方向
 */
- (void)transitionAnimationWithDuration:(NSTimeInterval)duration animationType:(ZHTransitonAnimationType)type transitionDirection:(ZHTransitonAnimationDirection)direction;



@end
