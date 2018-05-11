//
//  MLXWaterflowView.m
//  瀑布流
//
//  Created by 竹子 on 2018/5/10.
//  Copyright © 2018年 竹子. All rights reserved.
//

#import "MLXWaterflowView.h"
#import "UIView+Extension.h"
#import "MLXWaterflowCell.h"

#define MLXWaterFlowViewDefaultCellH 70
#define MLXWaterFlowViewDefaultNumberOfColmns 3
#define MLXWaterFlowViewDefaultMargin 8

@interface MLXWaterflowView()
/**
 存放左右cell frame的数组
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayCells;
/**
 缓存池(用set存放离开的cell)
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;

@end
@implementation MLXWaterflowView

@dynamic delegate;
- (id<UIScrollViewDelegate>)delegate
{
    id curDelegate = [super delegate];
    return curDelegate;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    [super setDelegate:delegate];
}

#pragma mark - 初始化
- (NSMutableArray *)cellFrames {
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayCells {
    if (!_displayCells) {
        _displayCells = [NSMutableDictionary dictionary];
    }
    return _displayCells;
}

- (NSMutableSet *)reusableCells {
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// 即将显示在父视图
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

- (CGFloat)cellWidth {
    // cell的总列数
    int numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:MLXWaterflowViewMarginLeft];
    CGFloat righM = [self marginForType:MLXWaterflowViewMarginRight];
    CGFloat columnM = [self marginForType:MLXWaterflowViewMarginColumn];
    
    return (self.width - leftM - righM -  (numberOfColumns - 1) * columnM) / numberOfColumns;
}
/**
 刷新数据
 1.计算每一个cell的frame
 */
- (void)reloadData {
    
    // 清空之前的所有数据
    // 移除正在显示的cell
    [self.displayCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    // cell的总数
    int numberOfCells = (int)[self.dataSource numberOfCellsInWaterflowView:self];
    
    // cell的总列数
    int numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:MLXWaterflowViewMarginLeft];
    CGFloat columnM = [self marginForType:MLXWaterflowViewMarginColumn];
    // 间距
    CGFloat topM = [self marginForType:MLXWaterflowViewMarginTop];
    CGFloat bottomM = [self marginForType:MLXWaterflowViewMarginBottom];
  
    CGFloat rowM = [self marginForType:MLXWaterflowViewMarginRow];
    // cell的宽度
    CGFloat cellW = [self cellWidth];
    
    // 用c语言数组存放所有列的最大Y值
    CGFloat maxYofColumns[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        maxYofColumns[i] = 0.0;
    }
    
    for (int i = 0; i < numberOfCells; i++) {
        
        // cell处在第几列 (最短的列)
        NSInteger cellColumn = 0;
        // cell所处那列的(最短的列 最大Y值)
        CGFloat maxYOfCellColumn = maxYofColumns[cellColumn];
        // 求出最短的一列
        for (int j = 0; j < numberOfColumns; j++) {
            if (maxYofColumns[j] < maxYOfCellColumn) {
                cellColumn = j;
                maxYOfCellColumn = maxYofColumns[j];
            }
        }
         // 询问代理i的高度
        CGFloat cellH = [self heightAtIndex:i];
        // cell的位置
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) { // 首行
            cellY = topM;
        } else {
            cellY = maxYOfCellColumn + rowM;
        }
        
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        
        // 添加frame到数组中
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新最短那列的最大Y值
        maxYofColumns[cellColumn] = CGRectGetMaxY(cellFrame);
        
        // 显示cell
//        MLXWaterflowCell *cell = [self.dataSource waterflowView:self cellAtIndex:i];
//        cell.frame = cellFrame;
//        [self addSubview:cell];
    }
    
    // 设置contentSize
    CGFloat contentH = maxYofColumns[0];
    for (int j = 0; j < numberOfColumns; j++) {
        if (maxYofColumns[j] > contentH) {
            contentH = maxYofColumns[j];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}

/**
 当scrollView滚动的时候也会调用这个方法
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"个数%zd", self.subviews.count);
    // 向数据源索要对应的cell
    NSInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i < numberOfCells; i++) {
        // 取出i位置frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        // 有限从字典中去取i位置的cell
        MLXWaterflowCell *cell = self.displayCells[@(i)];
        
        // 判断i位置对应的frame在不在屏幕上(能否看见)
        if ([self isInScreenWithFrame:cellFrame]) { // 在屏幕上
           
            if (cell == nil) {
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                // 存放在字典中
                self.displayCells[@(i)] = cell;
            }
            
        } else {  // 不在屏幕上
            if (cell) {
                // 从scrollView中和字典中移除
                [cell removeFromSuperview];
                [self.displayCells removeObjectForKey:@(i)];
                // 存放进缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
    
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    
    __block MLXWaterflowCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(MLXWaterflowCell *cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    
    return reusableCell;
}

#pragma mark - 私有方法
/**
 判断一个frame有无显示在屏幕上
 */
- (BOOL)isInScreenWithFrame:(CGRect)frame {
    return (CGRectGetMaxY(frame) > self.contentOffset.y) && (CGRectGetMinY(frame) < (self.contentOffset.y + self.height));
}

- (CGFloat)marginForType:(MLXWaterflowViewMarginType)type {
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
    } else {
        return MLXWaterFlowViewDefaultMargin;
    }
}
- (int)numberOfColumns {
    if ([self.delegate respondsToSelector:@selector(numberOfColumusInWaterflowView:)]) {
        return (int)[self.dataSource numberOfColumusInWaterflowView:self];
    } else{
        return MLXWaterFlowViewDefaultNumberOfColmns;
    }
}
- (CGFloat)heightAtIndex:(int)index {
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    } else{
        return MLXWaterFlowViewDefaultCellH;
    }
}

#pragma mark - 事件处理
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MLXWaterflowCell *cell, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectIndex) {
        [self.delegate waterflowView:self didSelectAtIndex:[selectIndex integerValue]];
    }
}
@end
