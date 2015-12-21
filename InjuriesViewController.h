//
//  WorkoutsViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/3/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddWorkoutViewController.h"


@interface InjuriesViewController : UITableViewController <NSFetchedResultsControllerDelegate,WorkoutDelegate>

@property (strong, nonatomic) id injuryItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
