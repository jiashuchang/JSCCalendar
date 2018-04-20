//
//  JSCCollectionViewCell.h
//  日历开发
//
//  Created by TianLi on 2018/4/16.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCCollectionViewCell : UICollectionViewCell
//自定义cell里面用strong，因为如果用weak，cell在创建完成并没有被引用，这个weak修饰的控件会被释放掉，和控制器中不一样，控制器中创建一个ui控件，控制器并没有被释放，因此ui控件在控制器中不会被释放
@property (nonatomic, strong) UILabel *label;
@end
