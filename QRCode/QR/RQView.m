//
//  RQView.m
//  QRCode
//
//  Created by liguowei on 15/11/19.
//  Copyright © 2015年 liguiwei. All rights reserved.
//

#import "RQView.h"

@interface RQView ()
{
    UIView *_line;
}

@end

@implementation RQView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
        [self creatUI];
    }
    
    return self;
}

- (void)creatUI
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    _line.backgroundColor = [UIColor greenColor];
    [self addSubview:_line];
    
    self.run = YES;
    
    [self startToDown];
}

- (void)startToDown
{
    __weak typeof(self) weakSelf = self;
    
    [RQView animateWithDuration:2.5 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        CGPoint center = _line.center;
        center.y += self.frame.size.height;
        _line.center = center;
        
    } completion:^(BOOL finished) {
        
            [weakSelf startToUP];
    
    }];

}
- (void)startToUP
{
     __weak typeof(self) weakSelf = self;
    
    [RQView animateWithDuration:2.5 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGPoint center = _line.center;
        center.y -= self.frame.size.height;
        _line.center = center;
        
    } completion:^(BOOL finished) {
        [weakSelf startToDown];
    }];
}

@end
