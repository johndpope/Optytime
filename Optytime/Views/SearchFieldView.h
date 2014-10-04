//
//  SearchFieldView.h
//  Optytime
//
//  Created by Alexey Khan on 03.10.14.
//  Copyright (c) 2014 Alexey Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFieldView : UIView  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchInput;

@end
