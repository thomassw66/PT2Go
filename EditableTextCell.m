//
//  EditableTextCell.m
//  PT2Go
//
//  Created by thomas wheeler on 4/26/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "EditableTextCell.h"

@implementation EditableTextCell

- (void)awakeFromNib {
    // Initialization code
	self.textField.delegate = self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
