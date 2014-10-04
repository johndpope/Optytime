//
//  OptytimeHomeViewController.h
//  Optytime
//
//  Created by Alexey Khan on 03.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DIDatepicker.h"

@interface OptytimeHomeViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, DIDatepickerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) NSMutableArray *eventsTimetableList;

@property (weak, nonatomic) IBOutlet UIView *innerContainerView;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end
