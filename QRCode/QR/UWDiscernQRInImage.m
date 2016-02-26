//
//  UWDiscernQRInImage.m
//  QRCode
//
//  Created by liguowei on 15/11/20.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import "UWDiscernQRInImage.h"

@implementation UWDiscernQRInImage

+ (NSString *)discernImage:(UIImage *)image
{
    UIImage * srcImage = image;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    CIImage *ciimage = [CIImage imageWithCGImage:srcImage.CGImage];
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:ciimage forKey:kCIInputImageKey];
    
    float i = 0;
    while (i<=4) {
        [lighten setValue:@(i) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[ciimage extent]];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
        
        if (features.count >= 1) {
            CIQRCodeFeature *feature = [features firstObject];
            NSString *scannedResult = feature.messageString;
            if (scannedResult) {
                return scannedResult;
            }
        }
        
        i += 0.2;
    }
    
    return nil;
}























@end
