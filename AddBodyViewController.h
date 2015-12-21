//
//  CreateWorkoutViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/3/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateDelegate;

@interface AddBodyViewController : UIViewController

@property id <CreateDelegate> delegate;

@end

@protocol CreateDelegate <NSObject>

-(void) createVC: (AddBodyViewController*) viewController returnsString: (NSString*)
str;

@end