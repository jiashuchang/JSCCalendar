//
//  JSCCollectionViewFlowLayout.h
//  日历开发
//
//  Created by TianLi on 2018/4/17.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCCollectionViewFlowLayout : UICollectionViewFlowLayout
//    一页显示多少列
@property (nonatomic,assign) NSUInteger itemCountPerRow;
//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
