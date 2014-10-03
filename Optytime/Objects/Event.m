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
- (NSString *)location { return location; }
- (NSString *)timeToLocation { return timeToLocation; }
- (BOOL) hasNotification { return hasNotification; }
- (NSString *)alertMessage { return alertMessage; }

// set values
- (void) setUid:(NSString *)_uid { uid = _uid; }
- (void) setType:(NSString *)_type { type = _type; }
- (void) setTimestamp:(NSString *)_timestamp { timestamp = _timestamp; }
- (void) setLocation:(NSString *)_location { location = _location; }
- (void) setTimeToLocation:(NSString *)_timeToLocation { timeToLocation = _timeToLocation; }
- (void) setHasNotification:(BOOL)_hasNotification { hasNotification = _hasNotification; }
- (void) setAlertMessage:(NSString *)_alertMessage { alertMessage = _alertMessage; }

@end
