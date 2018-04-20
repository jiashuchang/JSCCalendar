//
//  JSCheaderCollectionReusableView.m
//  日历开发
//
//  Created by TianLi on 2018/4/16.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import "JSCheaderCollectionReusableView.h"

@implementation JSCheaderCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self ceartView];
    }
    return self;
}
-(void)ceartView{
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:label];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"2345";
    
    //    self.yearerLabel = [[UILabel alloc]initWithFrame:self.bounds];
    //    self.yearerLabel.textColor = [UIColor darkGrayColor];
    //    self.yearerLabel.textAlignment = NSTextAlignmentCenter;
    //    self.yearerLabel.font = [UIFont systemFontOfSize:15];
    //    [self addSubview:_yearerLabel];
}
@end
