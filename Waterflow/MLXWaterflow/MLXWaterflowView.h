//
//  MLXWaterflowView.h
//  瀑布流
//
//  Created by 竹子 on 2018/5/10.
//  Copyright © 2018年 竹子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLXWaterflowViewMarginTop,
    MLXWaterflowViewMarginBottom,
    MLXWaterflowViewMarginLeft,
    MLXWaterflowViewMarginRight,
    MLXWaterflowViewMarginColumn,  // 每一列
    MLXWaterflowViewMarginRow,     // 每一行
} MLXWaterflowViewMarginType;

@class MLXWaterflowView, MLXWaterflowCell;

@protocol MLXWaterflowViewDataSource <NSObject>
@required
/**
 * 一共有多少个数据
 */
- (NSUInteger)numberOfCellsInWaterflowView:(MLXWaterflowView *)waterflowView;
/**
 * 返回index位置对应的cell
 */
- (MLXWaterflowCell *)waterflowView:(MLXWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;

@optional
/**
 * 一共有多少个列
 */
- (NSUInteger)numberOfColumusInWaterflowView:(MLXWaterflowView *)waterflowView;

@end


#pragma mark - 代理方法
@protocol MLXWaterflowViewDelegate <UIScrollViewDelegate>
@optional
/**
 第index位置对应的高度
 */
- (CGFloat)waterflowView:(MLXWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;
/**
 选中的第index位置的cell
 */
- (void)waterflowView:(MLXWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index;
/**
 返回间距
 */
- (CGFloat)waterflowView:(MLXWaterflowView *)waterflowView marginForType:(MLXWaterflowViewMarginType)type;

@end


/**
 瀑布流控件
 */
@interface MLXWaterflowView : UIScrollView
/**
 * 数据源
 */
@property (nonatomic, weak) id<MLXWaterflowViewDataSource> dataSource;
/**
 * 代理
 */
@property (nonatomic, weak) id<MLXWaterflowViewDelegate> delegate;
/**
 * 刷新数据(只要调用这个方法,会重新向数据源和代理发送请求数据)
 */
- (void)reloadData;
/**
 cell的宽度
 */
- (CGFloat)cellWidth;

/**
 根据标识去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
