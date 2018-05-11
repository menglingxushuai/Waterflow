//
//  ViewController.m
//  瀑布流
//
//  Created by 竹子 on 2018/5/10.
//  Copyright © 2018年 竹子. All rights reserved.
//

#import "ViewController.h"
#import "MLXWaterflowView.h"
#import "MLXShopCell.h"
#import "MLXShop.h"
#import <MJExtension/MJExtension.h>

#define ZZColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define ZZAlphaColor(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define ZZRandomColor ZZColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface ViewController ()<MLXWaterflowViewDelegate, MLXWaterflowViewDataSource>
{
    NSInteger num;
}
@property (nonatomic, strong) NSMutableArray *shops;

@property (nonatomic, strong) MLXWaterflowView *waterflowView;

@end

@implementation ViewController
- (NSMutableArray *)shops {
    if (_shops == nil) {
        NSArray *newShops = [MLXShop mj_objectArrayWithFilename:@"1.plist"];
        self.shops = [NSMutableArray array];
        [self.shops addObjectsFromArray:newShops];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MLXWaterflowView *waterflowView = [[MLXWaterflowView alloc] initWithFrame:self.view.bounds];
    
    _waterflowView = waterflowView;
    waterflowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    waterflowView.delegate = self;
    waterflowView.dataSource = self;
    [self.view addSubview:waterflowView];
    
    // 刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [waterflowView reloadData];

    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}

- (void)changeRotate:(NSNotification*)noti {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        NSLog(@"竖屏");
        num = 3;
    } else {
        //横屏
        NSLog(@"横屏");
        num = 5;
        
    }
    [_waterflowView reloadData];
}

#pragma mark - 数据源方法
- (NSUInteger)numberOfCellsInWaterflowView:(MLXWaterflowView *)waterflowView {
    return self.shops.count;
}

- (NSUInteger)numberOfColumusInWaterflowView:(MLXWaterflowView *)waterflowView {
    return num ? num : 3;
}

- (MLXWaterflowCell *)waterflowView:(MLXWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index {
   
    MLXShopCell *cell = [MLXShopCell cellWithWaterflowView:waterflowView];
    cell.shop = self.shops[index];
    cell.backgroundColor = ZZRandomColor;
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)waterflowView:(MLXWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index {
    
    MLXShop *shop = self.shops[index];
    // 根据cell 的宽度 和图片的宽高比 算出cell的高度
    CGFloat height = waterflowView.cellWidth * shop.h / shop.w;
    
    return height;
}



- (void)waterflowView:(MLXWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index {
    NSLog(@"点击了第%zd个cell", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
