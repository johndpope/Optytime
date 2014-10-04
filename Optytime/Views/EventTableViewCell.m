//
//  EventTableViewCell.m
//  Optytime
//
//  Created by Alexey Khan on 04.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize timeLabel, titleLabel, addressLabelSubtitle, addressLabelLocation, driveTimeLabel, locationImageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"EventCellView" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
