//
//  ViewController.m
//  日历开发
//
//  Created by TianLi on 2018/4/13.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import "ViewController.h"
#import "NSCalendar+JSCCalendar.h"
#import "JSCCollectionViewCell.h"
#import "JSCheaderCollectionReusableView.h"
#import "JSCfooterCollectionReusableView.h"
#import "JSCCollectionViewFlowLayout.h"
#import "BRDatePickerView.h"

static NSString * const cellId = @"cellid";
static NSString * const headerid = @"headerid";
static NSString * const footerid = @"footerid";

#define JyColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//轮播个数3个，这个暂时不能改
#define NUMBER_PAGES_LOADED 3
//item间距
#define itemmargin 1.0
//section边距
#define edgemargin 2.0
//列数
#define columncount 7
//标题文字大小
#define textFont 17

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _cellWH;//cell的宽高
    NSDate *_currentDate;//当前展示的日期
    UICollectionView *_collectionView;
    NSArray *_daysInMonth;//三个月的日历数据数组
    NSArray *_threedateArray;//三个月的今天数据数组（例如：2018-03-18，2018-04-18，2018-05-18）
    NSInteger rowcount;//多少行collectionview
    JSCCollectionViewFlowLayout *_layout;
    UIButton *_calendarButton;//展示当前显示日期的button
    NSDateFormatter *_dateFormatter;
}
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化对象
    [self SettGlobalVariables];
    //设置CollectionView
    [self setUpCollectionView];
    //设置日历顶部的周几显示控件
    [self setWeekViewday];
    //设置当前展示label和上下页按钮等子控件
    [self addChildsubviews];
    //获取数据源
    [self getDataSource];
    //设置collectionview的ContentOffset
    [self repositionViews];
}
#pragma mark - 设置当前展示label和上下页按钮等子控件
- (void)addChildsubviews{
    
    _calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_calendarButton];
    [_calendarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _calendarButton.titleLabel.font = [UIFont systemFontOfSize:textFont];
    [_calendarButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self updateCalendarTitle];
    
    UIButton *backdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backdateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:backdateBtn];
    [backdateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backdateBtn setTitle:@"今日" forState:UIControlStateNormal];
    [backdateBtn addTarget:self action:@selector(backdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    CGSize dictsize = [backdateBtn.titleLabel.text sizeWithAttributes:dict];
    CGFloat frameX = self.view.frame.size.width - dictsize.width - 10;
    CGFloat frameY = 100 - dictsize.height - 20 -10;
    backdateBtn.frame = CGRectMake(frameX, frameY, dictsize.width, dictsize.height);
    
}
- (void)backdateBtnClick{
    _currentDate = [NSDate date];
    [self getDataSource];
    [self updateCollectionView];
    [self repositionViews];
}
#pragma mark - 选择日期
- (void)btnClick{
    
    NSDate *minDate = [NSDate setYear:1970 month:1 day:1];
    NSDate *maxDate = [NSDate setYear:2050 month:12 day:1];
    //填写默认值（字符串）
    [_dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *defaultDate = [_dateFormatter stringFromDate:_currentDate];
    
    [BRDatePickerView showDatePickerWithTitle:@"请选择日期" dateType:BRDatePickerModeYM defaultSelValue:defaultDate minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:[UIColor redColor] resultBlock:^(NSString *selectValue) {
        
        NSArray *array = [selectValue componentsSeparatedByString:@"-"];
        _currentDate = [NSDate setYear:[array[0] integerValue] month:[array[1] integerValue]];
        
        [self getDataSource];

        [self updateCollectionView];
        
        [self repositionViews];
        
    }];
    
}
#pragma mark - 初始化对象
- (void)SettGlobalVariables{
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.calendar = calendar;
    
    _currentDate = [NSDate date];
    
    _cellWH = (self.view.frame.size.width - (columncount - 1)*itemmargin - 2*edgemargin )/7;
    
    rowcount = [self.calendar dataCollectViewRowcount:_currentDate];
}
#pragma mark - 获取数据源
- (void)getDataSource{
    
    _daysInMonth = [self.calendar threedateArray:_currentDate];
    NSDate *lastdate = [self.calendar lastMonth:_currentDate];
    NSDate *nextdate = [self.calendar nextMonth:_currentDate];
    _threedateArray = [NSArray arrayWithObjects:lastdate, _currentDate, nextdate, nil];
}
#pragma mark - 设置collectionview的ContentOffset
- (void)repositionViews{
    [_collectionView setContentOffset:CGPointMake(self.view.frame.size.width*round(NUMBER_PAGES_LOADED/2), 0)];
}
#pragma mark - 设置日历顶部的周几显示控件
- (void)setWeekViewday{
    UIView *weekView = [[UIView alloc] init];
    weekView.frame = CGRectMake(0, 80, self.view.frame.size.width, 20);
    [self.view addSubview:weekView];
    weekView.backgroundColor = JyColor(242, 242, 242, 1);
    NSArray *weekTitleArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i<weekTitleArray.count; i++) {
        UILabel *weekTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(i * ((self.view.frame.size.width/(weekTitleArray.count))), 0, self.view.frame.size.width/(weekTitleArray.count ), 20)];
        if (i == 0 || i == 6) {
            weekTitleLable.textColor = JyColor(236, 125, 183, 1);
        }else{
            weekTitleLable.textColor = [UIColor grayColor];
        }
        weekTitleLable.text = [weekTitleArray objectAtIndex:i];
        weekTitleLable.textAlignment = NSTextAlignmentCenter;
        weekTitleLable.font = [UIFont systemFontOfSize:12];
        [weekView addSubview:weekTitleLable];
    }
    
}
#pragma mark - 设置CollectionView
- (void)setUpCollectionView{
    
    //1.初始化layout
    JSCCollectionViewFlowLayout *layout = [[JSCCollectionViewFlowLayout alloc] init];
    _layout = layout;
    layout.rowCount = rowcount;
    layout.itemCountPerRow = columncount;
    
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    //该方法也可以设置itemSize
    //    layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = JyColor(242, 242, 242, 1);
    _collectionView = collectionView;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = false;
    //备注：高度是不固定的
    //    collectionView.frame = CGRectMake(0, 50, self.view.frame.size.width, 5*_cellWH+_headerAndfooterHeight+_headerAndfooterHeight);
    CGFloat frameHeight = 2*edgemargin + (rowcount - 1)*itemmargin + rowcount*_cellWH;
    collectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, frameHeight);
    [self.view addSubview:collectionView];
    
    //3.注册collectionViewCell/
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [collectionView registerClass:[JSCCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为headerid
    //    [collectionView registerClass:[JSCheaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerid];
    //    //注册footerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为footerId
    //    [collectionView registerClass:[JSCfooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerid];
    
    //4.设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    //5设置setContentOffset始终在中间
//    [self repositionViews];
}
#pragma mark collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return NUMBER_PAGES_LOADED;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return rowcount*columncount;
//    return [self.calendar totaldaysInMonth:_currentDate] + [self.calendar firstWeekdayInThisMonth:_currentDate];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSInteger firstWeekday = [self.calendar firstWeekdayInThisMonth:_threedateArray[indexPath.section]];
    NSInteger totaldays = [self.calendar totaldaysInMonth:_threedateArray[indexPath.section]];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item < firstWeekday) {
//        cell.backgroundColor = [UIColor clearColor];
//        cell.label.text = @"历头";
        cell.label.text = @"";
        return cell;
    }else if ((indexPath.item - firstWeekday + 1) > totaldays){
//        cell.backgroundColor = [UIColor clearColor];
//        cell.label.text = @"历尾";
        cell.label.text = @"";
        return cell;
    }else{
//        NSInteger weekinteger = [self.calendar firstWeekdayInThisMonth:_threedateArray[indexPath.section]];
        cell.label.textColor = [UIColor greenColor];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5.0;
        NSDate *date = _daysInMonth[indexPath.section][indexPath.row - firstWeekday];
        NSInteger day = [self.calendar day:date];
        cell.label.text = [NSString stringWithFormat:@"%ld",day];
        if (indexPath.row == [self.calendar dateInCalendarTodaySubscript:_threedateArray[indexPath.section]]) {
            cell.backgroundColor = JyColor(236, 125, 183, 1);
        }
        return cell;
    }
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWH, _cellWH);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return itemmargin;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return itemmargin;
}
 //设置每个section的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(edgemargin, edgemargin, edgemargin, edgemargin);
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    NSString *msg = cell.botlabel.text;
    //    NSLog(@"%@",msg);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = CGRectGetWidth(self.view.frame);
    CGFloat fractionalPage = _collectionView.contentOffset.x / pageWidth;
    int currentPage = roundf(fractionalPage);
    if (currentPage == round(NUMBER_PAGES_LOADED / 2)){
        //如果没有滚动整页，就return，不用去请求新数据
        return;
    };
    
    _currentDate = [self getNewCurrentDate];
    [self getDataSource];
    
    //设置collectionview的ContentOffset
    [self repositionViews];
    //更新collectionviewframe并刷新
    [self updateCollectionView];
    
}
#pragma mark - 重新计算collectionView的frame，刷新collectionView数据
- (void)updateCollectionView{
    //重新计算rowcount，重新布局_collectionView和JSCCollectionViewFlowLayout
    rowcount = [self.calendar dataCollectViewRowcount:_currentDate];
    _layout.rowCount = rowcount;
    CGFloat frameHeight = 2*edgemargin + (rowcount - 1)*itemmargin + rowcount*_cellWH;
    [UIView animateWithDuration:0.5 animations:^{
        _collectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, frameHeight);
    }];
    
//    [CATransaction setDisableActions:YES];
//    [_collectionView reloadData];
//    [CATransaction commit];
    
    [UIView performWithoutAnimation:^{
        [_collectionView reloadData];
    }];
    
    
    //修改当前展示日历label
    [self updateCalendarTitle];
}
#pragma mark - 修改标题日历时间
- (void)updateCalendarTitle{
    NSInteger year = [self.calendar year:_currentDate];
    NSInteger month = [self.calendar month:_currentDate];
    [_calendarButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",year,month] forState:UIControlStateNormal];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName]=[UIFont systemFontOfSize:textFont];
    CGSize dictsize = [_calendarButton.titleLabel.text sizeWithAttributes:dict];
    CGFloat frameX = (self.view.frame.size.width - dictsize.width)/2;
    CGFloat frameY = 100 - dictsize.height - 20 -10;
    _calendarButton.frame = CGRectMake(frameX, frameY, dictsize.width, dictsize.height);
}
#pragma mark - 获取当前展示的最新时间
- (NSDate *)getNewCurrentDate{
    CGFloat pageWidth = CGRectGetWidth(self.view.frame);
    CGFloat fractionalPage = _collectionView.contentOffset.x / pageWidth;
    int currentPage = roundf(fractionalPage);
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSDate *currentDate;
    dateComponents.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    currentDate = [self.calendar dateByAddingComponents:dateComponents toDate:_currentDate options:0];
    return currentDate;
}




/*
 //设置每个item的UIEdgeInsets
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
     return UIEdgeInsetsMake(10, 0, 0, 0);
 }
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        JSCheaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerid forIndexPath:indexPath];
//        if(headerView == nil){
//            headerView = [[UICollectionReusableView alloc] init];
//        }
        headerView.backgroundColor = [UIColor redColor];
        
        return headerView;
    }else{
        JSCfooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerid forIndexPath:indexPath];
//        if(footerView == nil){
//            footerView = [[UICollectionReusableView alloc] init];
//        }
        footerView.backgroundColor = [UIColor grayColor];
        return footerView;
    }

}
 //footer的size
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
 
 //    return CGSizeMake(self.view.frame.size.width, _headerAndfooterHeight);
 return CGSizeMake(self.view.frame.size.width, _headerAndfooterHeight);
 }
 
 //header的size
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 
 return CGSizeMake(self.view.frame.size.width, _headerAndfooterHeight);
 //    return CGSizeMake(self.view.frame.size.width, _headerAndfooterHeight);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
