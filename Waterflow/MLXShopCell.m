//
//  MLXShopCell.m
//  瀑布流
//
//  Created by 竹子 on 2018/5/11.
//  Copyright © 2018年 竹子. All rights reserved.
//

#import "MLXShopCell.h"
#import "MLXShop.h"
#import "MLXWaterflowView.h"
#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"

#define ZZAlphaColor(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

@interface MLXShopCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end
@implementation MLXShopCell

+ (instancetype)cellWithWaterflowView:(MLXWaterflowView *)waterflowView {
    static NSString *ID = @"shop";
    MLXShopCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLXShopCell alloc] init];
        cell.identifier = ID;
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        _imageView = imageView;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = ZZAlphaColor(0, 0, 0, 0.3);
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _label = label;
    }
    return self;
}
- (void)setShop:(MLXShop *)shop {
    _shop = shop;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:shop
                                    .img] placeholderImage:nil];
    _label.text = shop.price;
}

- (void)layoutSubviews {
    _imageView.frame = self.bounds;
    _label.frame = CGRectMake(0, self.height - 20, self.width, 20);
    
}
@end
