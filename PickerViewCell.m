//
//  PickerViewCell.m
//  PT2Go
//
//  Created by thomas wheeler on 4/26/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "PickerViewCell.h"

@implementation PickerViewCell

- (void)awakeFromNib {
    // Initialization code
	
	self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
	[self.contentView addSubview:self.pickerView];
	
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.hidden = YES;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return 2;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component{
	
	return @"YAS";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
