//
//  Event.m
//  Optytime
//
//  Created by Alexey Khan on 04.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import "Event.h"

@implementation Event

// get values
- (NSString *)uid { return uid; }
- (NSString *)type { return type; }
- (NSString *)timestamp { return timestamp; }
- (NSString *)title { return title; }
- (NSString *)location { return location; }
- (NSInteger)timeToLocation { return timeToLocation; }
- (BOOL) hasNotification { return hasNotification; }
- (NSString *)alertMessage { return alertMessage; }

// set values
- (void) setUid:(NSString *)_uid { uid = _uid; }
- (void) setType:(NSString *)_type { type = _type; }
- (void) setTimestamp:(NSString *)_timestamp { timestamp = _timestamp; }
- (void) setTitle:(NSString *)_title { title = _title; }
- (void) setLocation:(NSString *)_location { location = _location; }
- (void) setTimeToLocation:(NSInteger)_timeToLocation { timeToLocation = _timeToLocation; }
- (void) setHasNotification:(BOOL)_hasNotification { hasNotification = _hasNotification; }
- (void) setAlertMessage:(NSString *)_alertMessage { alertMessage = _alertMessage; }

@end
