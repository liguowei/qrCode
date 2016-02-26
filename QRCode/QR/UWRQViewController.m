//
//  rootViewController.m
//  QRCode
//
//  Created by liguowei on 15/11/18.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import "UWRQViewController.h"
#import <AVFoundation/AVFoundation.h>

static const char *UWlgwQRCodeQueueName = "UWlgwQRCodeQueue";

@interface UWRQViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic)AVCaptureSession *captureSession;
@property (nonatomic)AVCaptureVideoPreviewLayer *videPreviewLayer;
@property (nonatomic)BOOL lastResult;

@property (nonatomic, strong) UIView *photo;

@end

@implementation UWRQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    [self layoutView];
    
    _lastResult = YES;
    
    [self startReading];
}

- (void)layoutView
{
    _photo = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_photo];
    
    _QRview = [[RQView alloc] initWithFrame:CGRectMake(50, 200, 230, 230)];
    _QRview.layer.borderWidth = 1;
    _QRview.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:_QRview];
    
    _photo.center = _QRview.center = self.view.center;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _QRview.frame.origin.y+_QRview.frame.size.height, self.view.frame.size.width, 20)];
    label.text = @"将二维码放到框内";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];

}

- (BOOL)startReading
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
       if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
       {
           UIAlertController *alerCon = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
           [alerCon addAction:action];
           
           [self presentViewController:alerCon animated:YES completion:nil];
           
       } else {
           
           UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
             [aler show];

       }
        return NO;
    }
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
     _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    CGSize size = self.view.bounds.size;
    CGRect cropRect = _QRview.frame;
    captureMetadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                              cropRect.origin.x/size.width,
                                              cropRect.size.height/size.height,
                                              cropRect.size.width/size.width);
    
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(UWlgwQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,nil]];
    
    _videPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videPreviewLayer setFrame:_photo.layer.bounds];
    [_photo.layer addSublayer:_videPreviewLayer];
    
//    UIView *view = [[UIView alloc] initWithFrame:_photo.bounds];
//        CGRect bounds = view.bounds;
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = bounds;
//        maskLayer.fillColor = [UIColor cyanColor].CGColor;
//        
//        static CGFloat const kRadius = 100;
//        CGRect const circleRect = CGRectMake(CGRectGetMidX(bounds) - kRadius,
//                                             CGRectGetMidY(bounds) - kRadius,
//                                              kRadius,  kRadius);
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
//        [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
//        maskLayer.path = path.CGPath;
//        maskLayer.fillRule = kCAFillRuleEvenOdd;
//        
//        _photo.layer.mask = maskLayer;
   // [_videPreviewLayer addSublayer:view.layer];
    
    
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:_photo.bounds];
    view.layer.opacity = 0.5;
    [_photo.layer addSublayer:view.layer];
    view.layer.contents = (__bridge id _Nullable)([self drawing:view andEmptyArea:_QRview.frame].CGImage);
    
    [_captureSession startRunning];
    
    return YES;
}

#pragma mark - 绘图中间镂空
- (UIImage *)drawing:(UIImageView *)referenceImage andEmptyArea:(CGRect)size
{
    UIGraphicsBeginImageContext(referenceImage.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0,0,0,1); //设置填充颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect drawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    
    CGContextFillRect(ctx, drawRect);
    
    drawRect = CGRectMake(size.origin.x-referenceImage.frame.origin.x, size.origin.y-referenceImage.frame.origin.y, size.size.width,size.size.height);
    CGContextClearRect(ctx, drawRect);
    
    UIImage* returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnimage;
}


- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
            result = metadataObj.stringValue;
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

#pragma mark uwRQDelegate

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResult) {
        return;
    }
    _lastResult = NO;
    
    // 以下处理了结果，继续下次扫描
    [_QRview removeFromSuperview];
    _QRview = nil;
    
    if ([self.delegate respondsToSelector:@selector(uwRQFinshedScan:)]) {
        [self.delegate uwRQFinshedScan:result];
    }
    
    _lastResult = YES;
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
