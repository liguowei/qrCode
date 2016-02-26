//
//  UWCreateQRWithColor.h
//  QRCode
//
//  Created by liguowei on 15/11/20.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UWCreateQRWithColor : NSObject
/**
 *  该方法可以使用与ios8及之后
 *
 *  @param string   要生成二维码的
 *  @param length   二维码图片的大小
 *  @param onColor  背景颜色建议颜色设置对比度高，否则可能会识别不出来
 *  @param offColor 码颜色
 *
 *  @return 返回二维码图片
 */
+ (UIImage *)QRImageForString:(NSString *)string imageSize:(CGFloat)length onColor:(UIColor*)onColor offColor:(UIColor *)offColor;

@end
