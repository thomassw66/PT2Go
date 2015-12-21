//
//  MasterViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 3/25/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AddBodyViewController.h"

@interface BodyPartViewController : UITableViewController <NSFetchedResultsControllerDelegate,CreateDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

