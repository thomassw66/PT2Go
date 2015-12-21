//
//  PickerViewCell.h
//  PT2Go
//
//  Created by thomas wheeler on 4/26/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)  UIPickerView* pickerView;

@end
