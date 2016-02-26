//
//  UWRQViewController.m
//  QRCode
//
//  Created by liguowei on 15/11/19.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import "ViewController.h"
#import "UWRQViewController.h"
#import "UWCreateQR.h"
#import "createQRViewController.h"
#import "UWDiscernQRInImage.h"
#import "UWCreateQRWithColor.h"

@interface ViewController ()<uwRQDelegate>
{
    UIImageView *_qrImageView;
    UITextField *_textView;
    UILabel *_label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"二维码";
    
//    NSDictionary *dic = [NSDictionary dictionary];
//    
//    NSLog(@"%@===%lu",dic,(unsigned long)dic.count);
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 30)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(20, 350, 60, 30);
    [button setTitle:@"扫描" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor blueColor];
    button2.frame = CGRectMake(100, 350, 60, 30);
    [button2 setTitle:@"生成" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(makeRQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor blueColor];
    button3.frame = CGRectMake(180, 350, 60, 30);
    [button3 setTitle:@"颜色" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(createQR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = [UIColor blueColor];
    button4.frame = CGRectMake(260, 350, 60, 30);
    [button4 setTitle:@"识别" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(discern) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_qrImageView];
    
    _textView = [[UITextField alloc] initWithFrame:CGRectMake(50, 230, 250, 40)];
    _textView.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textView];
}

- (void)discern
{
   NSString*string = [UWDiscernQRInImage discernImage:_qrImageView.image];
    _label.text = string;
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
}

- (void)createQR
{
    _qrImageView.image = [UWCreateQRWithColor QRImageForString:_textView.text imageSize:200 onColor:[UIColor blueColor] offColor:[UIColor whiteColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void)makeRQ
{
  _qrImageView.image = [UWCreateQR QRImageForString:_textView.text imageSize:200];
}

- (void)startScan
{
    UWRQViewController *uw = [[UWRQViewController alloc] init];
    uw.delegate = self;
    uw.navigationItem.title = @"二维码扫描";
    [self.navigationController pushViewController:uw animated:YES];
}
- (void)uwRQFinshedScan:(NSString *)result
{
    _label.text = result;
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
