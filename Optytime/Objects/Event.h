//
//  Event.h
//  Optytime
//
//  Created by Alexey Khan on 04.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

/*
 [03.10.14, 20:48:49] Gad Ossmann: Данные события для главного меню:
 1) тип события (ворк или фан) Стобы разделять цвет иконки
 2) название
 3) место (проверка на его наличие)
 4) время
 5) drive time
 6) и еще одно важное. - текстовое сообщение, что делать (2 слова буквально) вечером покажу как разместить ну или час размести если не день) суть такая - прога говорит что делать двумя словами! Типа - выходи сейчас! Перенеси встречу!
 [03.10.14, 20:49:10] Gad Ossmann: Если не лень*
 [03.10.14, 20:49:22] Gad Ossmann: Около каждой встречи
 [03.10.14, 20:50:03] Gad Ossmann: Там где нет сообщения, рекомендации  - не показывается просто.
 */

#import <Foundation/Foundation.h>

@interface Event : NSObject {
    NSString *uid;
    NSString *type;
    NSString *timestamp;
    NSString *location;
    NSString *timeToLocation; // в минутах
    BOOL hasNotification;
    NSString *alertMessage;
}

// get values
- (NSString *)uid;
- (NSString *)type;
- (NSString *)timestamp;
- (NSString *)location;
- (NSString *)timeToLocation;
- (BOOL)hasNotification;
- (NSString *)alertMessage;

// set values
- (void) setUid:(NSString *)_uid;
- (void) setType:(NSString *)_type;
- (void) setTimestamp:(NSString *)_timestamp;
- (void) setLocation:(NSString *)_location;
- (void) setTimeToLocation:(NSString *)_timeToLocation;
- (void) setAlertMessage:(NSString *)_alertMessage;
- (void) setHasNotification:(BOOL)_hasNotification;

@end
