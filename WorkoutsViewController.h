//
//  TableViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/24/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddWorkoutViewController.h"


@interface WorkoutsViewController : UITableViewController <NSFetchedResultsControllerDelegate, WorkoutDelegate>


@property (strong, nonatomic) id workoutsItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
