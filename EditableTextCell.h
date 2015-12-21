//
//  EditableTextCell.h
//  PT2Go
//
//  Created by thomas wheeler on 4/26/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTextCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* textField;

@end
