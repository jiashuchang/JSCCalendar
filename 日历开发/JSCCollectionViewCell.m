//
//  JSCCollectionViewCell.m
//  日历开发
//
//  Created by TianLi on 2018/4/16.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import "JSCCollectionViewCell.h"

@interface JSCCollectionViewCell(){
    
}
@end

@implementation JSCCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)initView{
    
    CGRect frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width, self.bounds.size.height/2);
    
    _label = [[UILabel alloc] initWithFrame:frame];
    [self addSubview:_label];
    [_label setTextAlignment:NSTextAlignmentLeft];
    [_label setFont:[UIFont systemFontOfSize:17]];
    _label.textColor = [UIColor blackColor];
    
}

@end
