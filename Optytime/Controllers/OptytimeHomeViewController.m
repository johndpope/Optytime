//
//  OptytimeHomeViewController.m
//  Optytime
//
//  Created by Alexey Khan on 03.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import "OptytimeHomeViewController.h"
#import "DIDatepicker.h"

@interface OptytimeHomeViewController () {
    CGSize screenSize;
    CGRect datepickerFrame;
}

@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;

@end

@implementation OptytimeHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //<-- Инициализация параметров и объектов контроллера -->//
    screenSize = [[UIScreen mainScreen] bounds].size;
    datepickerFrame = CGRectMake(0, screenSize.height - 60, screenSize.width, 60);
    

    
    //<-- Инициализация нижнего контроллера дат DIDatepicker -->//
    [self initDatepicker];
}


#pragma mark -
#pragma mark DIDatepicker

- (void)updateSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    self.selectedDateLabel.text = [formatter stringFromDate:self.datepicker.selectedDate];
}

- (void)initDatepicker
{
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    [self.datepicker setFrame:datepickerFrame];
    
    //    [self.datepicker fillDatesFromCurrentDate:14];
    //    [self.datepicker fillCurrentWeek];
    //    [self.datepicker fillCurrentMonth];
    [self.datepicker fillCurrentYear];
    [self.datepicker selectDateAtIndex:0];
}


#pragma mark -
#pragma mark DefaultPrecomposedCode

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
