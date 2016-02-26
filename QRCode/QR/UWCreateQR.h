//
//  UWCreateQR.h
//  QRCode
//
//  Created by liguowei on 15/11/19.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QRCodeGenerator.h"

@interface UWCreateQR : NSObject

/**
 *  生成二维码
 *
 *  @param string 要生成二维码的字符串
 *  @param size   生成二维码图片的大小
 *
 *  @return 返回二维码图片
 */
+ (UIImage *)QRImageForString:(NSString *)string imageSize:(CGFloat)size;

@end
