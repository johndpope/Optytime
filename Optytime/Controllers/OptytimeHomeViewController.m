//
//  OptytimeHomeViewController.m
//  Optytime
//
//  Created by Alexey Khan on 03.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import "OptytimeHomeViewController.h"
#import "DIDatepicker.h"
#import "SearchFieldView.h"

@interface OptytimeHomeViewController () {
    CGSize screenSize;
    CGRect datepickerFrame, searchfieldFrame;
}

@property (weak, nonatomic) IBOutlet SearchFieldView *searchfield;
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;

@end

@implementation OptytimeHomeViewController

//<-- Функция для получения цвета в формате rgba(r,g,b,a) -->//
#define RGBA2UIColor(r,g,b,a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

//<!-- Кнопки топбара -->//
@synthesize menuButton, addButton;

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
    
    //<-- Инициализация параметров контроллера -->//
    screenSize = [[UIScreen mainScreen] bounds].size;
    datepickerFrame = CGRectMake(0, screenSize.height - 60, screenSize.width, 60);
    searchfieldFrame = CGRectMake(0, 60, screenSize.width, 50);
    
    //<-- Инициализация кнопок топбара -->//
    [self setTopBarLeftButtonWithImage:[UIImage imageNamed:@"menu.png"]];
    [self setTopBarRightButtonWithImage:[UIImage imageNamed:@"add.png"]];
    
    //<-- Инициализация вьюхи поиска -->//
    [self initSearchFiledView];
    
    //<-- Инициализация нижнего контроллера дат DIDatepicker -->//
    [self initDatepicker];
}


#pragma mark -
#pragma mark TopBarButtons

- (void)setTopBarLeftButtonWithImage:(UIImage *)image
{
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(15, 28, 20, 20);
    [menuButton setImage:image forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuButton];
}
- (void)setTopBarRightButtonWithImage:(UIImage *)image
{
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(288, 28, 20, 20);
    [addButton setImage:image forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}
- (IBAction)revealMenu:(id)sender
{
    NSLog(@"Menu button clicked!");
}
- (IBAction)addEvent:(id)sender
{
    NSLog(@"Add Event Button clicked!");
}


#pragma mark -
#pragma mark SearchFiledView

- (void)initSearchFiledView
{
    [self.searchfield setFrame:searchfieldFrame];
    
    CALayer *topBorder = [CALayer layer];
    CALayer *bottomBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0.0f, 0.0f, searchfieldFrame.size.width, 1.0f);
    topBorder.backgroundColor = RGBA2UIColor(0, 0, 0, .2).CGColor;
    
    bottomBorder.frame = CGRectMake(0.0f, searchfieldFrame.size.height - 1.0f, searchfieldFrame.size.width, 1.0f);
    bottomBorder.backgroundColor = RGBA2UIColor(0, 0, 0, .2).CGColor;
    
    [self.searchfield.layer addSublayer:topBorder];
    [self.searchfield.layer addSublayer:bottomBorder];
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
