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
            innercontainerFrame,
            calendarViewHiddenFrame,
            calendarViewVisibleFrame;
    float   hDiff,
            ic_top_margin,
            ic_height,
            calendarViewHiddenHeight,
            calendarViewVisibleHeight,
            cv_top_margin,
            cv_visible_top_margin,
            datepickerHeight;
    
    int     current_date_index;
    
    BOOL    freeToSwipe,
            calendarviewVisible;
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
    
    //<-- Инициализация выдвижного календаря -->//
    [self initCalendarView];
    
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
    searchfieldFrame = CGRectMake(0, 60, screenSize.width, 50);
    current_date_index = 0; // индекс сегодняшнего дня в DIDatepicker -> какой по индексу день из выбранного диапазона подчеркнуть
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
    NSArray *_locations;
    NSString *_type;
    NSInteger _location_id;
    
    BOOL _hasNotification;
    NSString *_alertMessage;
    NSString *_location;
    
    for (int i = 0; i < 11; i++) {
        
        // random timeToLocation value
        _minutes = (arc4random() % 59) + 1;
        
        // random type generator
        _types = [NSArray arrayWithObjects:@"work", @"leisure", nil];
        _type_id = (arc4random() % [_types count]);
        _type = [_types objectAtIndex:_type_id];
        
        // random location generator
        _locations = [NSArray arrayWithObjects:@"Москва, Улица Пушкина, дом Колотушкина", @"Второе тупое название", @"", nil];
        _location_id = (arc4random() % [_locations count]);
        _location = [_locations objectAtIndex:_location_id];
        
        // random hasNotification generator
        _hasNotification = ((arc4random() % 2) == 0) ? YES : NO;
        if (_hasNotification) _alertMessage = @"Чувак, это алерт! Глянька это событие, потому что там что-то зашибись какое важное и все такое, ну ты понимаешь.";
        else _alertMessage = @"";
        
        Event *event = [[Event alloc] init];
        [event setUid: [NSString stringWithFormat:@"qwer%i", i]];
        [event setType:_type];
        [event setTitle:[NSString stringWithFormat:@"Idexed Event Title: %i", i]];
        [event setTimestamp:@"2014-10-25 19:25:00"]; //  у всех одна дата - так как тут единственно логичный способ - подгружать события по дате асинхронно, когда не известны, и выгружать из CoreData по match, когда события на эту дату уже записаны
        [event setLocation:_location];
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
    ic_top_margin = searchfieldFrame.origin.y + searchfieldFrame.size.height + 6.0;
    ic_height = screenSize.height - ic_top_margin - self.datepicker.frame.size.height - 6.0 - 13.0; // 13.0 - высота выступа выдвижного календаря
    innercontainerFrame = CGRectMake(0, ic_top_margin, screenSize.width, ic_height);
    
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
    
    return view;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view { return view; }

// смена текущей даты в нижнем контроллере при свайпе вьюшек
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

//<!-- Table View Sources -->

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
    Event *event = [[Event alloc] init];
    event = [eventsTimetableList objectAtIndex:indexPath.row];
    
    if ([event.location isEqualToString:@""]) {
        return 60.0;
    }
    else if (event.hasNotification && [event.alertMessage isEqualToString:@""] == NO) {
        return 160.0;
    }
    else return 110.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"EventCell";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (EventTableViewCell *)[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.clipsToBounds = YES;
    
    Event *event = [[Event alloc] init];
    event = [eventsTimetableList objectAtIndex:indexPath.row];
    
    if ([event.location isEqualToString:@""]) {
        // cell height = 60
        // title label height = 18
        cell.titleLabel.frame = CGRectMake(88.0, 21.0, 202.0, 18.0);
    }
    else cell.titleLabel.frame = CGRectMake(88.0, 11.0, 202.0, 18.0);
    
    cell.titleLabel.text = event.title;
    cell.addressLabelSubtitle.text = event.location;
    cell.addressLabelLocation.text = event.location;
    cell.driveTimeLabel.text = [NSString stringWithFormat:@"Drive Time: %li min", event.timeToLocation];
    
    cell.titleLabel.adjustsFontSizeToFitWidth = NO;
    cell.addressLabelSubtitle.adjustsFontSizeToFitWidth = NO;
    cell.addressLabelLocation.adjustsFontSizeToFitWidth = NO;
    cell.driveTimeLabel.adjustsFontSizeToFitWidth = NO;
    
    cell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    cell.addressLabelSubtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    cell.addressLabelLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    cell.driveTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    cell.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.notificationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    
    NSString *timestampTimePart = [event.timestamp componentsSeparatedByString:@" "][1];
    NSString *time = [NSString stringWithFormat:@"%@:%@", [timestampTimePart componentsSeparatedByString:@":"][0], [timestampTimePart componentsSeparatedByString:@":"][1]];
    
    cell.timeLabel.text = time;
    cell.addressLabelLocation.textColor = RGBA2UIColor(0, 0, 0, .8);
    
    if ([event.type isEqualToString:@"work"]) [cell.locationImageView setImage:[UIImage imageNamed:@"locationWork.png"]];
    else if ([event.type isEqualToString:@"leisure"]) [cell.locationImageView setImage:[UIImage imageNamed:@"locationLeisure.png"]];
    
    [cell.notificationImageView setImage:[UIImage imageNamed:@"locationWork.png"]];
    cell.notificationLabel.text = event.alertMessage;
    
    cell.verticalSeparatorView.backgroundColor = UIColor.redColor;
    CALayer *l = cell.verticalSeparatorView.layer;
    l.masksToBounds = YES;
    l.cornerRadius = 2;
    l.borderColor = UIColor.clearColor.CGColor;
    l.borderWidth = 0;
    
    cell.locationImageView.tag = 1;
    cell.addressLabelLocation.tag = 2;
    cell.notificationImageView.tag = 3;
    cell.notificationLabel.tag = 4;
    
    UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationPushAction:)];
    tapOnImage.numberOfTapsRequired = 1;
    [cell.locationImageView addGestureRecognizer:tapOnImage];
    cell.locationImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationPushAction:)];
    tapOnLabel.numberOfTapsRequired = 1;
    [cell.addressLabelLocation addGestureRecognizer:tapOnLabel];
    cell.addressLabelLocation.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapOnNotificationImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationPushAction:)];
    tapOnNotificationImage.numberOfTapsRequired = 1;
    [cell.notificationImageView addGestureRecognizer:tapOnNotificationImage];
    cell.notificationImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapOnNotificationLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationPushAction:)];
    tapOnNotificationLabel.numberOfTapsRequired = 1;
    [cell.notificationLabel addGestureRecognizer:tapOnNotificationLabel];
    cell.notificationLabel.userInteractionEnabled = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ячейка выделена, индекс ячейки: %li", indexPath.row);
}

- (void)locationPushAction:(UITapGestureRecognizer *)gesture
{
    // iOS 7 : view -> cell
    EventTableViewCell *currCell = (EventTableViewCell *)gesture.view.superview;
    
    UITableView *tableview = (UITableView *)[self.carousel.currentItemView viewWithTag:1];
    NSIndexPath *indexPath = [tableview indexPathForCell:currCell];
    
    Event *currEvent = [eventsTimetableList objectAtIndex:indexPath.row];
    NSLog(@"IndexPath row: %li", indexPath.row);
    
    if (gesture.view.tag == 1) NSLog(@"Кликнули на картинку локейшена.");
    else if (gesture.view.tag == 2) NSLog(@"Кликнули на текст локейшена.");
    
    NSLog(@"Current Event Location: %@, Drive Time: %li min", currEvent.location, currEvent.timeToLocation);
}

- (void)notificationPushAction:(UITapGestureRecognizer *)gesture
{
    // iOS 7 : view -> cell
    EventTableViewCell *currCell = (EventTableViewCell *)gesture.view.superview;
    
    UITableView *tableview = (UITableView *)[self.carousel.currentItemView viewWithTag:1];
    NSIndexPath *indexPath = [tableview indexPathForCell:currCell];
    
    Event *currEvent = [eventsTimetableList objectAtIndex:indexPath.row];
    NSLog(@"IndexPath row: %li", indexPath.row);
    
    if (gesture.view.tag == 3) NSLog(@"Кликнули на картинку нотификейшена.");
    else if (gesture.view.tag == 4) NSLog(@"Кликнули на текст нотификейшена.");
    
    NSLog(@"Current Event Location: %@, Drive Time: %li min", currEvent.location, currEvent.timeToLocation);
}

#pragma mark -
#pragma mark RSDayFlowPicker

- (void)initCalendarView
{
    freeToSwipe = YES;
    calendarviewVisible = NO;
    calendarViewHiddenHeight = 13.0;
    calendarViewVisibleHeight = 380.0;
    cv_top_margin = ic_top_margin + ic_height + 6.0;
    cv_visible_top_margin = screenSize.height - datepickerFrame.size.height - calendarViewVisibleHeight;
    calendarViewHiddenFrame = CGRectMake(0, cv_top_margin, screenSize.width, calendarViewVisibleHeight);
    calendarViewVisibleFrame = CGRectMake(0, screenSize.height - calendarViewVisibleHeight - datepickerHeight, screenSize.width, calendarViewVisibleHeight);
    
    self.calendarView.frame = calendarViewHiddenFrame;
    
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCalendarView:)];
    swipe.delegate = self;
    [self.calendarView addGestureRecognizer:swipe];
}

#pragma mark -
#pragma mark calendarViewGesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        UIPanGestureRecognizer *panGestureRec = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGestureRec velocityInView:self.view];
        
        if (fabsf(point.y) > 2*fabsf(point.x) && freeToSwipe == YES) {
            return YES;
        }
    }
    return NO;
}

- (void)toggleCalendarView:(UIPanGestureRecognizer *)gesture {
    
    UIView *view = gesture.view; // ||---> calendarView
    
    BOOL animate = NO;
    BOOL highSpeedSwipeToBottom = NO;
    BOOL highSpeedSwipeToTop = NO;
    
    CGPoint translate = [gesture translationInView:view];
    
    if (translate.x > 0) translate.x = 0;
    
    NSLog(@"Translate.Y = %f; View Position Y = %f", translate.y, view.frame.origin.y);
    
    if (translate.y < 0 && calendarviewVisible == NO) {
        if (- translate.y < cv_top_margin)
            animate = YES;
    }
    else if (translate.y > 0 && calendarviewVisible == YES) {
        if (translate.y < cv_top_margin)
            animate = YES;
    }
    // too big velocity - too high speed of swiping
    if (translate.y > 0 && calendarviewVisible == NO) {
        if (view.frame.origin.y != calendarViewHiddenFrame.origin.y) {
            highSpeedSwipeToBottom = YES;
        }
    }
    else if (translate.y < 0 && calendarviewVisible == YES) {
        if (view.frame.origin.y != calendarViewHiddenFrame.origin.y) {
            highSpeedSwipeToTop = YES;
        }
    }
    
    float positionY = (translate.y < 0) ? (cv_top_margin + translate.y >= cv_visible_top_margin) ? cv_top_margin + translate.y : cv_visible_top_margin : (cv_visible_top_margin + translate.y <= datepickerFrame.origin.y) ? cv_visible_top_margin + translate.y : datepickerFrame.origin.y;
    
    if (animate == YES) {
        
        view.frame  = CGRectMake(
                                 0,
                                 positionY,
                                 screenSize.width,
                                 view.frame.size.height);
        
        if (gesture.state == UIGestureRecognizerStateCancelled ||
            gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateFailed)
        {
            
            if (translate.y < 0.0 && calendarviewVisible == NO) {
                
                // swipe from the bottom to the top
                freeToSwipe = NO;
                
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                                 animations:^(void) {
                                     view.frame = CGRectMake(0, cv_visible_top_margin, screenSize.width, calendarViewVisibleHeight);
                                 }
                                 completion:^(BOOL finished){
                                     freeToSwipe = YES;
                                     calendarviewVisible = YES;
                                 }];
            }
            else if (translate.y > 0.0 && calendarviewVisible == YES) {
                
                // swipe from the top to the bottom
                freeToSwipe = NO;
                
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                                 animations:^(void) {
                                     view.frame = CGRectMake(0, cv_top_margin, screenSize.width, calendarViewVisibleHeight);
                                 }
                                 completion:^(BOOL finished){
                                     freeToSwipe = YES;
                                     calendarviewVisible = NO;
                                 }];
                
            }
        }
    }
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
    
    datepickerHeight = 60.0;
    datepickerFrame = CGRectMake(0, screenSize.height - datepickerHeight, screenSize.width, datepickerHeight);
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
