//
//  AddWorkoutViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/3/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkoutDelegate;

@interface AddWorkoutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)addWorkout:(id)sender;

@property id <WorkoutDelegate> delagate;

@end



@protocol WorkoutDelegate <NSObject>

-(void) addWorkoutVC: (AddWorkoutViewController*) awViewController didReturnWorkout: (NSDictionary *) workout;

@end