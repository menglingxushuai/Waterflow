//
//  UIView+Extension.h
//  FSQ_PLATFORM1
//
//  Created by 曹野 on 16/6/12.
//  Copyright © 2016年 曹野. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

/** 从xib加载 */
+ (instancetype)viewFromXib;

- (BOOL)intersectWithView:(UIView *)view;

/** 获取当前控制器 */
- (UIViewController *)parentController;

/** 动态添加手势 */
- (void)setTapActionWithBlock:(void (^)(void))block ;
- (void)zz_addTarget:(id)target
           action:(SEL)action;

/*********************分割线*************************/
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/** 头像圆角 */
@property (nonatomic) IBInspectable BOOL avatarCorner;

/** 边框 */
@property (nonatomic) IBInspectable CGFloat borderWidth;

/** 边框颜色*/
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

+ (__kindof UIView *)MQLoadNibView;
- (void)MQSetViewCircleWithBorderWidth:(CGFloat) width andColor:(UIColor *)borColor;
- (void)MQViewSetCornerRadius:(CGFloat)radius;

/*********************分割线*************************/
- (UIImage *)saveImageWithScale:(float)scale;
- (UIView *(^)(UIColor *backgroundColor))   zz_backgroundColor;
- (UIView *(^)(UIColor *borderColor))       zz_borderColor;
- (UIView *(^)(CGRect frame))               zz_frame;
- (UIView *(^)(UIView *superView))          zz_superView;
- (UIView *(^)(CGFloat borderwidth))        zz_borderWidth;
- (UIView *(^)(CGFloat radius))             zz_radius;
- (UIView *(^)(BOOL clipsToBounds))         zz_clipsToBounds;
- (UIView *(^)(CGPoint center))             zz_center;
- (UIView *(^)(CGAffineTransform transForm))zz_transForm;
- (UIView *(^)(BOOL hidden))                zz_hidden;
- (UIView *(^)(BOOL userInteractionEnabled))zz_userInteractionEnabled;
- (UIColor *)colorOfPoint:(CGPoint)point;
- (NSArray *)getRGBWithColor:(UIColor *)color;

@end
