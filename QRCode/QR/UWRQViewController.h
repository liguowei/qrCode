//
//  rootViewController.h
//  QRCode
//
//  Created by liguowei on 15/11/18.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

/*
 二维码扫描结果 实现uwRQDelegate这个代理 获取扫描结果。
 该类是实现二维码扫描的类，可以继承也可以直接用
 */

#import <UIKit/UIKit.h>
#import "RQView.h"

@protocol uwRQDelegate <NSObject>

/**
 *  二维码扫描返回结果
 *
 *  @param result 二维码扫描返回的结果
 */
- (void)uwRQFinshedScan:(NSString *)result;

@end

@interface UWRQViewController : UIViewController
@property (nonatomic, weak) id <uwRQDelegate>delegate;

/**
 *  扫描框
 */
@property (nonatomic, strong) RQView *QRview;

@end
