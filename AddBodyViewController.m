//
//  CreateWorkoutViewController.m
//  PT2Go
//
//  Created by thomas wheeler on 4/3/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "AddBodyViewController.h"

@interface AddBodyViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) UIView * inputView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

- (IBAction)addWorkout:(id)sender;

@end

@implementation AddBodyViewController

-(void) viewDidLoad {
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addWorkout:(id)sender {
	
	[self dismissViewControllerAnimated:YES completion:^(){
		
		[self.delegate createVC:self returnsString:self.textField.text];
	}];
	
}
@end
