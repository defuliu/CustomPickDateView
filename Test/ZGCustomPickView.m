//
//  ZGCustomPickView.m
//  Test
//
//  Created by 刘德福 on 2019/3/25.
//  Copyright © 2019 ZGW. All rights reserved.
//

#define hight (self.frame.origin.y - (IOS7?0:20))
/**************************** 常用代码块 ***************************/
#define kRGBColorAlpha(_red, _green, _blue, _alpha) \
[UIColor colorWithRed:(_red / 255.0f) \
green:(_green / 255.0f) \
blue:(_blue / 255.0f) \
alpha:_alpha]

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%@(Line: %d) %s \n" fmt),self, __LINE__, __PRETTY_FUNCTION__,##__VA_ARGS__);
#else
# define DLog(...);
#endif


#import "ZGCustomPickView.h"

@interface ZGCustomPickView ()
{
    NSString *provinceStr;
    // NSString *cityStr;
    NSString *localStr;
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
}
@property (nonatomic, assign)NSInteger setIndex;
@property (nonatomic, strong)NSMutableArray *yearArray;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong)NSMutableArray *monthArray;
@property(nonatomic, assign)NSInteger   firstSelRow;//选择的省份index
@property(nonatomic, assign)NSInteger   secondSelRow;//选择的城市index
@property(nonatomic, strong)NSString *str10;
@property(nonatomic, strong)NSString *str11;
@property(nonatomic, strong)NSString *timeSelectedString;
@property (nonatomic, strong)NSString *responseTime;
@end

@implementation ZGCustomPickView

#pragma mark -
- (id)initWithFrame:(CGRect)frame
      getDataSource:(NSArray *)dataSourceArr
              index:(NSInteger)index
     addResposeTime:(NSString *)responseTime
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pickerViewMode = MyDatePickerViewDateYearMonthDayMode;
        
        [self loadUIComponets];
        
    }
    return self;
}


- (void)showPicker {
    if (self.isHidden) {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.frame = CGRectMake(0, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }];
        self.isHidden = NO;
    }
}

- (void)loadUIComponets
{
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.bounds.size.width, 200)];
    // subView.backgroundColor = kRGBColorAlpha(238, 238, 238, 0.8);
    subView.backgroundColor = kRGBColorAlpha(235, 235, 235, 0.7);
    [self addSubview:subView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    // [btn setTitleColor:[ZGCoreUtil colorWithHexString:@"#009b79" alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[btn setTitleColor:[ZGCoreUtil colorWithHexString:@"#009b79" alpha:1] forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setFrame:CGRectMake(0, 10, 50, 20)];
    [btn addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    //    [btn2 setTitleColor:[ZGCoreUtil colorWithHexString:@"#009b79" alpha:1] forState:UIControlStateNormal];
    //    [btn2 setTitleColor:[ZGCoreUtil colorWithHexString:@"#009b79" alpha:1] forState:UIControlStateHighlighted];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [btn2 setBackgroundColor:[UIColor clearColor]];
    [btn2 setFrame:CGRectMake(self.frame.size.width-50, 10, 50, 20)];
    [btn2 addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btn2];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,35,self.frame.size.width, 175)];
    _pickerView.layer.borderColor = [UIColor orangeColor].CGColor;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    
    [subView addSubview:_pickerView];
    
    
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    startYear=year-1;
    yearRange=20;
    [self setCurrentDate:[NSDate date]];
}

- (void)createUIControlWithFrame:(CGRect)rect view:(UIView *)view
{
    _control =[[UIControl alloc]initWithFrame:rect];
    _control.backgroundColor = kRGBColorAlpha(0, 0, 0, 0.4);
    [_control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_control];
    
    if (self) {
        [view insertSubview:_control belowSubview:self];
    }
}

- (void)hidePicker
{
    [_control removeFromSuperview];
    if (!self.isHidden) {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }];
        self.isHidden = YES;
    }
}

#pragma  mark - action
- (void)confirmAction
{
    [self hidePicker];
    
    
    NSLog(@"xxxxxxxx:%@",_string);
    
    if([self.delegate respondsToSelector:@selector(selectDate:)])
    {
        [self.delegate selectDate:_string];
    }
    
    
}

- (void)controlAction:(UIControl *)aControl
{
    [aControl removeFromSuperview];
    [self hidePicker];
}

#pragma mark - RefreshDataSource
-(void)reloadDataWithData:(NSArray *)dataArr
{
    _provincesArr = nil;
    _provincesArr = dataArr;
    [_pickerView reloadAllComponents];
}

//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    selectedSecond =second;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
        
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        
        
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
        
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 选择对应月份的天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        return 5;
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        return 6;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        return 4;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        return 3;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        return 2;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        return 1;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            case 5:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:15.0];
    label.textAlignment=NSTextAlignmentCenter;
    
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
        
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/6;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/4;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/1;
    }
    
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
            case 5:
            {
                selectedSecond=row;
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute,selectedSecond];
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld",selectedYear,selectedMonth,selectedDay,selectedHour];
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthDayMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMonthMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    }
    else if (self.pickerViewMode == MyDatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld",selectedYear];
    }
}


@end

