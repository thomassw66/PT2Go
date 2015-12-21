//
//  CreateWorkoutViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/24/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 

#import "SelectTypeController.h"

@interface CreateWorkoutViewController : UITableViewController<SelectTypeDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property NSManagedObjectContext * managedObjectContext;
-(void) setInjury: (NSManagedObject*) inkury;
-(void) setBody: (NSManagedObject*) body;

@end
