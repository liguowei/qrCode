//
//  UWDiscernQRInImage.h
//  QRCode
//
//  Created by liguowei on 15/11/20.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UWDiscernQRInImage : NSObject

/**
 *  识别图片中的二维码
 *
 *  @param image 传入的图片
 *
 *  @return 返回二维码信息
 */
+ (NSString *)discernImage:(UIImage *)image;

@end
