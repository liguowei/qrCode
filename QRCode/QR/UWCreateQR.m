//
//  UWCreateQR.m
//  QRCode
//
//  Created by liguowei on 15/11/19.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import "UWCreateQR.h"


@implementation UWCreateQR

+ (UIImage *)QRImageForString:(NSString *)string imageSize:(CGFloat)size
{
    return [QRCodeGenerator qrImageForString:string imageSize:size];
}

@end
