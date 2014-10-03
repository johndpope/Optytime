//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

extern const NSTimeInterval kSecondsInDay;
extern const CGFloat kDIDetepickerHeight;

@protocol DIDatepickerDelegate;

@interface DIDatepicker : UIControl

//<!-- UPD by Alexey Khan -->//
@property (nonatomic, weak) id<DIDatepickerDelegate> delegate;

// data
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic, readonly) NSDate *selectedDate;
@property (strong, nonatomic) iCarousel *carousel;

// UI
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (strong, nonatomic) UIColor *selectedDateBottomLineColor;

// methods
- (void)fillDatesFromCurrentDate:(NSInteger)nextDatesCount;
- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)nextDatesCount;
- (void)fillCurrentWeek;
- (void)fillCurrentMonth;
- (void)fillCurrentYear;
- (void)selectDate:(NSDate *)date;
- (void)selectDateAtIndex:(NSUInteger)index;

@end

//<!-- UPD by Alexey Khan -->//
@protocol DIDatepickerDelegate <NSObject>

- (void)diDatepicker:(DIDatepicker*)datepicker didChangeIndexTo:(NSInteger)index;

@end
