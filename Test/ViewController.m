//
//  ViewController.m
//  Test
//
//  Created by 刘德福 on 2019/3/25.
//  Copyright © 2019 ZGW. All rights reserved.
//

#import "ViewController.h"
#import "WLPickDateView.h"

@interface ViewController ()<WLPickDateViewDelegate>
@property (nonatomic, strong)WLPickDateView *pickDateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  UIButton *btnType =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnType.frame = CGRectMake(40, 200, self.view.frame.size.width - 2*40,40 );
    btnType.backgroundColor = [UIColor blueColor];
    [btnType setTitle:@"测试" forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btnType];
}

- (void)testAction:(UIButton *)sender
{
    NSString *responseTime = @"2019-03-25 13:23:30";
    _pickDateView = [[WLPickDateView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-200, self.view.frame.size.width, 200 )
                                            getDataSource:nil index:0 addResposeTime:responseTime];
    _pickDateView.delegate = self;
    _pickDateView.pickerViewMode = MyDatePickerViewDateYearMonthDayMode;
    [self.view addSubview: _pickDateView];
    
}



#pragma mark - WLPickDateViewDelegate
- (void)pickViewYear:(NSString *)getYear month:(NSString *)month
{
}
@end
