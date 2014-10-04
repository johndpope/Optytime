//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepicker.h"
#import "DIDatepickerDateView.h"


const NSTimeInterval kSecondsInDay = 86400;
const NSInteger kMondayOffset = 2;
const CGFloat kDIDetepickerHeight = 60.;
const CGFloat kDIDatepickerSpaceBetweenItems = 15.;


@interface DIDatepicker ()

@property (strong, nonatomic) UIScrollView *datesScrollView;

@end


@implementation DIDatepicker

- (void)awakeFromNib
{
    [self setupViews];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;

    [self setupViews];

    return self;
}


- (void)setDelegate:(id<DIDatepickerDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
    }
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor whiteColor];
    self.bottomLineColor = [UIColor colorWithWhite:0.816 alpha:1.000];
    self.selectedDateBottomLineColor = [UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000];
}


#pragma mark Setters | Getters

- (void)setDates:(NSArray *)dates
{
    _dates = dates;

    [self updateDatesView];

    self.selectedDate = nil;
    self.carousel = nil;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    
#pragma mark -
#pragma mark - UPD by Alexey Khan
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *found_date = nil;

    for (id subview in self.datesScrollView.subviews) {
        if ([subview isKindOfClass:[DIDatepickerDateView class]]) {
            DIDatepickerDateView *dateView = (DIDatepickerDateView *)subview;
            
            // FUCKING HOLY MSITAKE DONE! I HATE YOU! WHO WROTE THIS FUCKING CODE?
            //dateView.isSelected = [dateView.date isEqualToDate:selectedDate];
            
            // My version:
            NSDateComponents* components_date = [calendar components:flags fromDate:dateView.date];
            NSDate* dateOnly_date = [calendar dateFromComponents:components_date];
            
            NSDateComponents* components_newdate = [calendar components:flags fromDate:selectedDate];
            NSDate* dateOnly_newdate = [calendar dateFromComponents:components_newdate];
            
            dateView.isSelected = ([dateOnly_date compare:dateOnly_newdate]  == NSOrderedSame) ? YES : NO;
            if ([dateOnly_date compare:dateOnly_newdate]  == NSOrderedSame) found_date = dateView.date;
        }
    }

    [self updateSelectedDatePosition];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
#pragma mark -
#pragma UPDforICarouselByAlexeyKhan
    
    //<!-- UPD by Alexey Khan -->//
    id<DIDatepickerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(diDatepicker:didChangeIndexTo:)]) {
        NSInteger fooIndex = [self.dates indexOfObject:found_date];
        [strongDelegate diDatepicker:self didChangeIndexTo:fooIndex];
    }
}

- (UIScrollView *)datesScrollView
{
    if (!_datesScrollView) {
        _datesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _datesScrollView.showsHorizontalScrollIndicator = NO;
        _datesScrollView.autoresizingMask = self.autoresizingMask;
        [self addSubview:_datesScrollView];
    }
    return _datesScrollView;
}

- (void)setSelectedDateBottomLineColor:(UIColor *)selectedDateBottomLineColor
{
    _selectedDateBottomLineColor = selectedDateBottomLineColor;

    for (id subview in self.datesScrollView.subviews) {
        if ([subview isKindOfClass:[DIDatepickerDateView class]]) {
            DIDatepickerDateView *dateView = (DIDatepickerDateView *)subview;
            [dateView setItemSelectionColor:selectedDateBottomLineColor];
        }
    }
}


#pragma mark Public methods

- (void)fillDatesFromCurrentDate:(NSInteger)nextDatesCount
{
    NSAssert(nextDatesCount < 1000, @"Too much dates");

    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger day = 0; day < nextDatesCount; day++) {
        [dates addObject:[NSDate dateWithTimeIntervalSinceNow:day * kSecondsInDay]];
    }

    self.dates = dates;
}

- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)nextDatesCount
{
    NSAssert(nextDatesCount < 1000, @"Too much dates");

    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger day = 0; day < nextDatesCount; day++)
    {
        [dates addObject:[fromDate dateByAddingTimeInterval:day * kSecondsInDay]];
    }
    
    self.dates = dates;
}

- (void)fillCurrentWeek
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:today];

    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger weekday = 0; weekday < 7; weekday++) {
        [dates addObject:[NSDate dateWithTimeInterval:(kMondayOffset + weekday - todayComponents.weekday)*kSecondsInDay sinceDate:today]];
    }

    self.dates = dates;
}

- (void)fillCurrentMonth
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:today];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:today];

    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger day = 1; day <= days.length; day++) {
        [todayComponents setDay:day];
        [dates addObject:[calendar dateFromComponents:todayComponents]];
    }

    self.dates = dates;
}

- (void)fillCurrentYear
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear fromDate:today];

    NSMutableArray *dates = [[NSMutableArray alloc] init];

    NSUInteger daysInYear = [self numberOfDaysInThisYear];
    for (NSInteger day = 1; day <= daysInYear; day++) {
        [todayComponents setDay:day];
        [dates addObject:[calendar dateFromComponents:todayComponents]];
    }

    self.dates = dates;
}

- (NSUInteger)numberOfDaysInThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startOfYear;
    NSTimeInterval lengthOfYear;
    [calendar rangeOfUnit:NSYearCalendarUnit
                startDate:&startOfYear
                 interval:&lengthOfYear
                  forDate:[NSDate date]];
    NSDate *endOfYear = [startOfYear dateByAddingTimeInterval:lengthOfYear];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                         fromDate:startOfYear
                                           toDate:endOfYear
                                          options:0];
    return [components day];
}

- (void)selectDate:(NSDate *)date
{
    //NSAssert([self.dates indexOfObject:date] != NSNotFound, @"Date not found in dates array");

    self.selectedDate = date;
}

- (void)selectDateAtIndex:(NSUInteger)index
{
    NSAssert(index < self.dates.count, @"Index too big");

    self.selectedDate = self.dates[index];
}


#pragma mark Private methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // draw bottom line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.bottomLineColor.CGColor);
    CGContextSetLineWidth(context, .5);
    CGContextMoveToPoint(context, 0, rect.size.height - .5);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - .5);
    CGContextStrokePath(context);
}

- (void)updateDatesView
{
    [self.datesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat currentItemXPosition = kDIDatepickerSpaceBetweenItems;
    for (NSDate *date in self.dates) {
        DIDatepickerDateView *dateView = [[DIDatepickerDateView alloc] initWithFrame:CGRectMake(currentItemXPosition, 0, kDIDatepickerItemWidth, self.frame.size.height)];
        dateView.date = date;
        dateView.selected = [date isEqualToDate:self.selectedDate];
        [dateView setItemSelectionColor:self.selectedDateBottomLineColor];
        [dateView addTarget:self action:@selector(updateSelectedDate:) forControlEvents:UIControlEventValueChanged];

        [self.datesScrollView addSubview:dateView];

        currentItemXPosition += kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems;
    }

    self.datesScrollView.contentSize = CGSizeMake(currentItemXPosition, self.frame.size.height);
}

- (void)updateSelectedDate:(DIDatepickerDateView *)dateView
{
    self.selectedDate = dateView.date;
    NSInteger fooIndex = [self.dates indexOfObject:self.selectedDate];
    [self.carousel scrollToItemAtIndex:fooIndex duration:0.1];
}

- (void)updateSelectedDatePosition
{
    NSUInteger itemIndex = [self.dates indexOfObject:self.selectedDate];

    CGSize itemSize = CGSizeMake(kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems, self.frame.size.height);
    CGFloat itemOffset = itemSize.width * itemIndex - (self.frame.size.width - (kDIDatepickerItemWidth + 2 * kDIDatepickerSpaceBetweenItems)) / 2;

    itemOffset = MAX(0, MIN(self.datesScrollView.contentSize.width - (self.frame.size.width ), itemOffset));

    [self.datesScrollView setContentOffset:CGPointMake(itemOffset, 0) animated:YES];
}

@end
