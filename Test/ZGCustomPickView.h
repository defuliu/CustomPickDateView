//
//  ZGCustomPickView.h
//  Test
//
//  Created by 刘德福 on 2019/3/25.
//  Copyright © 2019 ZGW. All rights reserved.
//




#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MyDatePickerViewMode) {
    
    MyDatePickerViewDateYearMonthDayHourMinuteSecondMode = 0,//年月日,时分秒
    MyDatePickerViewDateYearMonthDayHourMinuteMode,//年月日,时分
    MyDatePickerViewDateYearMonthDayHourMode,//年月日,时
    MyDatePickerViewDateYearMonthDayMode,//年月日
    MyDatePickerViewDateYearMonthMode,//年月
    MyDatePickerViewDateYearMode,//年
    
};

@class AGLocation;
@protocol ZGPickDateViewDelegate <NSObject>

@optional

- (void)pickViewYear:(NSString *)getYear month:(NSString *)month;

- (void)selectDate:(NSString *)date;

@end


@interface ZGCustomPickView : UIView

<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,  strong)UIPickerView *pickerView;
@property (nonatomic,  strong)AGLocation   *locate;
@property (nonatomic,  strong)NSArray      *provincesArr;
@property (nonatomic,  strong)NSArray      *citiesArr;
@property (nonatomic,  strong)NSMutableArray      *areaArr;
@property (nonatomic,  strong)UIControl    *control;
@property (nonatomic,  assign)NSInteger    row;
@property (nonatomic,  assign)NSInteger    areaRow;
@property (nonatomic,  strong)NSString     *areaStr;
@property(nonatomic,     copy)NSString     *idStr;
@property(nonatomic,     copy)NSString     *textStr;
@property (nonatomic,    copy)NSString     *proviceStr;
@property (nonatomic,    copy)NSString     *proviceId;
//选择器得数据源
@property (nonatomic, strong)NSMutableArray *pickerDataArray;

@property (nonatomic,  unsafe_unretained)BOOL isHidden;

@property (nonatomic,  assign) id <ZGPickDateViewDelegate>delegate;

/**选择模式*/
@property (nonatomic, assign) MyDatePickerViewMode pickerViewMode;

#pragma mark - Instantiation method
- (void)hidePicker;

- (void)showPicker;

- (void)createUIControlWithFrame:(CGRect)rect view:(UIView *)view;

/*
 * view的初始化方法
 * @param frame view的框架
 * @param dataSourceArr pickerView数据源
 */
- (id)initWithFrame:(CGRect)frame
      getDataSource:(NSArray *)dataSourceArr
              index:(NSInteger)index
     addResposeTime:(NSString *)responseTime;

-(void)reloadDataWithData:(NSArray *)dataArr;

@end




