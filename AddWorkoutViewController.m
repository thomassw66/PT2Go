//
//  AddWorkoutViewController.m
//  PT2Go
//
//  Created by thomas wheeler on 4/3/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "AddWorkoutViewController.h"

@interface AddWorkoutViewController ()

@end

@implementation AddWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWorkout:(id)sender {
	NSDictionary *d = @{@"title":self.textField.text,
						@"instructions":self.textView.text};
	[self dismissViewControllerAnimated:YES completion:^(){
		[self.delagate addWorkoutVC:self didReturnWorkout:d];
	}];
}
@end
