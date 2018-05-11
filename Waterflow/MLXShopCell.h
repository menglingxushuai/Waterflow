//
//  MLXShopCell.h
//  瀑布流
//
//  Created by 竹子 on 2018/5/11.
//  Copyright © 2018年 竹子. All rights reserved.
//

#import "MLXWaterflowCell.h"

@class  MLXWaterflowView, MLXShop;
@interface MLXShopCell : MLXWaterflowCell

+ (instancetype)cellWithWaterflowView:(MLXWaterflowView *)waterflowView;

@property (nonatomic, strong) MLXShop *shop;


@end
