//
//  OptytimeHomeViewController.m
//  Optytime
//
//  Created by Alexey Khan on 03.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import "OptytimeHomeViewController.h"
#import "SearchFieldView.h"
#import "Event.h"
#import "EventTableViewCell.h"

@interface OptytimeHomeViewController () {
    CGSize  screenSize;
    CGRect  datepickerFrame,
            searchfieldFrame,
            innercontainerFrame;
    float   hDiff;
    
    int current_date_index;
}

@property (nonatomic, assign) BOOL wrap;

@property (weak, nonatomic) IBOutlet SearchFieldView *searchfield;
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;

@end

@implementation OptytimeHomeViewController

//<-- Функция для получения цвета в формате rgba(r,g,b,a) -->//
#define RGBA2UIColor(r,g,b,a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

//<!-- Кнопки топбара -->//
@synthesize menuButton, addButton;
@synthesize eventsTimetableList;

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
    current_date_index = 0; // индекс сегодняшнего дня в DIDatepicker -> какой по индексу день из выбранного диапазона подчеркнуть
    
    float ic_top_margin = searchfieldFrame.origin.y + searchfieldFrame.size.height + 6.0,
    ic_height = screenSize.height - ic_top_margin - self.datepicker.frame.size.height - 6.0;
    innercontainerFrame = CGRectMake(0, ic_top_margin, screenSize.width, ic_height);
    
    //<-- Инициализация кнопок топбара -->//
    [self setTopBarLeftButtonWithImage:[UIImage imageNamed:@"menu.png"]];
    [self setTopBarRightButtonWithImage:[UIImage imageNamed:@"add.png"]];
    
    //<-- Инициализация вьюхи поиска -->//
    [self initSearchFiledView];
    
    //<-- Инициализация основной вьюхи с таблицами -->//
    [self initInnerContainerView];
    [self setCarouselDefaults:self.carousel];
    [self setEvents];
    [self.carousel reloadData];
    
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
#pragma mark SetEvents

- (void)setEvents
{
    // Retrieve all events
    
    eventsTimetableList = [[NSMutableArray alloc] init];

    NSInteger _minutes;
    NSInteger _type_id;
    NSArray *_types;
    NSString *_type;
    
    BOOL _hasNotification;
    NSString *_alertMessage;
    
    for (int i = 0; i < 11; i++) {
        
        // random timeToLocation value
        _minutes = (arc4random() % 59) + 1;
        
        // random type generator
        _type_id = (arc4random() % 2);
        _types = [NSArray arrayWithObjects:@"work", @"leisure", nil];
        _type = [_types objectAtIndex:_type_id];
        
        // random hasNotification generator
        _hasNotification = ((arc4random() % 2) == 0) ? YES : NO;
        if (_hasNotification) _alertMessage = @"Чувак, это алерт!";
        else _alertMessage = @"";
        
        Event *event = [[Event alloc] init];
        [event setUid: [NSString stringWithFormat:@"qwer%i", i]];
        [event setType:_type];
        [event setTitle:[NSString stringWithFormat:@"Idexed Event Title: %i", i]];
        [event setTimestamp:@"2014-10-25 19:25:00"]; //  у всех одна дата - так как тут единственно логичный способ - подгружать события по дате асинхронно, когда не известны, и выгружать из CoreData по match, когда события на эту дату уже записаны
        [event setLocation:@"Москва, Улица Пушкина, дом Колотушкина"];
        [event setTimeToLocation: _minutes];
        [event setHasNotification:_hasNotification];
        [event setAlertMessage:_alertMessage];
        [eventsTimetableList addObject:event];

    }
}


#pragma mark -
#pragma mark MainTableCarouselView

- (void)initInnerContainerView
{
    [self.innerContainerView setFrame:innercontainerFrame];
    self.innerContainerView.clipsToBounds = YES;
}

- (void)setCarouselDefaults:(iCarousel *)carousel
{
    self.wrap = YES;
    
    carousel.type = iCarouselTypeLinear;
    carousel.centerItemWhenSelected = YES;
    carousel.pagingEnabled = YES;
    carousel.stopAtItemBoundary = YES;
    
    carousel.delegate = self;
    carousel.dataSource = self;
    
    carousel.frame = CGRectMake(0, 0, screenSize.width, innercontainerFrame.size.height);
    
    hDiff = 40;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{

    return [eventsTimetableList count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    UITableView *innerTableView = nil;
    UILabel *dateLabel = nil;
    
    //Event *e = [eventsTimetableList objectAtIndex:index];
    
    // Create new view if no view is available for recycling
    if (view == nil)
    {
        /*
         // вариант с обычной UIView и label, который отображает выбранную дату
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, carousel.frame.size.height)];
        view.backgroundColor = UIColor.clearColor;
        
        innerTableView = [[UIView alloc] initWithFrame:view.frame];
        innerTableView.backgroundColor = UIColor.whiteColor;
        innerTableView.tag = 1;
        [view addSubview:innerTableView];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0, screenSize.width + 5.0, screenSize.width - 86.0, 25.0)];
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        dateLabel.tag = 2;
        [view addSubview:dateLabel];
         */
        // у всех остальных вьюшек поставить tag
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, carousel.frame.size.height)];
        view.backgroundColor = UIColor.clearColor;
        
        innerTableView = [[UITableView alloc] initWithFrame:view.frame];
        innerTableView.backgroundColor = UIColor.whiteColor;
        innerTableView.tag = 1;
        
        innerTableView.dataSource = self;
        innerTableView.delegate = self;
        
        innerTableView.separatorColor = RGBA2UIColor(0, 0, 0, .2);
        innerTableView.separatorInset = UIEdgeInsetsZero;
        
        [innerTableView registerNib:[UINib nibWithNibName:@"EventCellView"
                                                   bundle:nil] forCellReuseIdentifier:@"EventCell"];
        
        [view addSubview:innerTableView];
    }
    else
    {
        //get a reference to the inner views
        dateLabel = (UILabel *)[view viewWithTag:2];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    dateLabel.text = [formatter stringFromDate:self.datepicker.selectedDate];
    
    /*
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(openBouquetViewer:)];
    swipe.delegate = self;
    [innerBouquetView addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBouquetViewerByTap:)];
    tapGR.numberOfTapsRequired = 1;
    [innerBouquetView addGestureRecognizer:tapGR];*/
    
    return view;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view { return view; }

// смена текущей даты в нижнем контроллере при свайпе вьюшек

/*
 // этот метод использовать нельзя, поскольку если мы захотим перелистнуть через несколько дней, индекс успеет поменяться несколько раз => если мы с 0 даты перепрыгиваем на 4-ю, то сначала карусель обновит индекс с 0 до 1, а вместе с этим и сам datepicker обновится с 4 до 1! поэтому каждый раз будет перелистываться только по 1 дню! поэтому использовать метод окончания скролла.
 
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
 
 NSLog(@"Индекс текущей вьюшки в карусели: %li", carousel.currentItemIndex);
 [self.datepicker selectDateAtIndex:carousel.currentItemIndex];

}
*/

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    NSLog(@"Индекс текущей вьюшки в карусели: %li", carousel.currentItemIndex);
    
    // поскольку изначально показывается 0-я вьюха, и подчеркнута в datepicker нулевая по счету дата в диапазоне
    // можно ставить такую же дату по индексу, как и индекс текущей вьюхи
    [self.datepicker selectDateAtIndex:carousel.currentItemIndex];

}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return screenSize.width;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 3;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * screenSize.width);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


//* Table View *//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // здесь нужно указывать количество событий для конкретно текущего дня
    return eventsTimetableList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"EventCell";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (EventTableViewCell *)[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    Event *event = [[Event alloc] init];
    event = [eventsTimetableList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = event.title;
    cell.addressLabelLocation.text = event.location;
    cell.addressLabelSubtitle.text = event.location;
    cell.driveTimeLabel.text = [NSString stringWithFormat:@"Drive Time: %li min", event.timeToLocation];
    
    cell.titleLabel.adjustsFontSizeToFitWidth = NO;
    cell.addressLabelLocation.adjustsFontSizeToFitWidth = NO;
    cell.addressLabelSubtitle.adjustsFontSizeToFitWidth = NO;
    cell.driveTimeLabel.adjustsFontSizeToFitWidth = NO;
    
    cell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.addressLabelLocation.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.addressLabelSubtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.driveTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ячейка выделена, индекс ячейки: %li", indexPath.row);
}


#pragma mark -
#pragma mark DIDatepicker

- (void)updateSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    //self.selectedDateLabel.text = [formatter stringFromDate:self.datepicker.selectedDate];
    NSLog(@"Выбрали дату в нижнем контроллере: %@", [formatter stringFromDate:self.datepicker.selectedDate]);
    
}

- (void)diDatepicker:(DIDatepicker*)datepicker didChangeIndexTo:(NSInteger)index
{
    [self.carousel scrollToItemAtIndex:index duration:0.8];
}

- (void)initDatepicker
{
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    self.datepicker.delegate = self;
    
    [self.datepicker setFrame:datepickerFrame];

    
    //    [self.datepicker fillCurrentYear];
    //    [self.datepicker fillCurrentMonth];
    //    [self.datepicker fillCurrentWeek];
    [self.datepicker fillDatesFromCurrentDate:7];
    [self.datepicker selectDateAtIndex:current_date_index];
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
