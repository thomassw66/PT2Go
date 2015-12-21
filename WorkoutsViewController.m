//
//  TableViewController.m
//  PT2Go
//
//  Created by thomas wheeler on 4/24/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "WorkoutsViewController.h"
#import "CreateWorkoutViewController.h"
#import "MyWorkouts.h"

@interface WorkoutsViewController ()

@end

@implementation WorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	//self.navigationItem.rightBarButtonItem = addButtonItem;
	self.navigationItem.title = @"Select A Workout";
}

- (void) insertNewObject: (id) sender {
	/*AddWorkoutViewController *awvc = [[AddWorkoutViewController alloc] initWithNibName:@"AddWorkoutViewController" bundle:nil];
	awvc.delagate = self;
	[self presentViewController:awvc animated:YES completion:nil];*/
	
	UIStoryboard* sb=  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController * nav = [sb instantiateViewControllerWithIdentifier:@"Nav"];
	[((CreateWorkoutViewController*)nav.topViewController) setManagedObjectContext:self.managedObjectContext];
	[((CreateWorkoutViewController*)nav.topViewController) setBody:[self.workoutsItem valueForKey:@"bodyPart"]];
	[((CreateWorkoutViewController*)nav.topViewController) setInjury:self.workoutsItem];
	[self presentViewController:nav animated:YES completion:nil];
}

-(void) addWorkoutVC:(AddWorkoutViewController *)awViewController didReturnWorkout:(NSDictionary *)workout {
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	[newManagedObject setValue: workout[@"title"] forKey:@"title"];
	[newManagedObject setValue: workout[@"instructions"] forKey:@"type"];
	[newManagedObject setValue:self.workoutsItem forKey:@"injury"];
	
	
	
	// Save the context.
	NSError *error = nil;
	if (![context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void)setWorkoutsItem:(id)workoutsItem {
	if (_workoutsItem != workoutsItem) {
		_workoutsItem = workoutsItem;
		
		// Update the view.
		//[self configureView];
	}
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSManagedObject * object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
	
	
	if( [object valueForKey:@"selected"] == nil || ![[object valueForKey:@"selected"] boolValue] ){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		//[[MyWorkouts selectedObjects] addObject:object];
		[object setValue: [NSNumber numberWithBool:YES] forKey:@"selected"];
		[object setValue: [NSDate date] forKey:@"timeSelected"];
	}else{
		cell.accessoryType = UITableViewCellAccessoryNone;
		//[[MyWorkouts selectedObjects] removeObject:object];
		[object setValue: [NSNumber numberWithBool:NO] forKey:@"selected"];
	}
	//NSLog(@"%@",[object valueForKey:@"timeSelected"]);
	
	NSError *error = nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Failed to save managed object context after modifying workout status");
	}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.accessoryType =
	//[[MyWorkouts selectedObjects] containsObject:object]?UITableViewCellAccessoryCheckmark :UITableViewCellAccessoryNone;
	[cell valueForKey:@"selected"] != nil && [[object valueForKey:@"selected"] boolValue] ?UITableViewCellAccessoryCheckmark :UITableViewCellAccessoryNone;
	
	//NSLog(@"%i",[[object valueForKey:@"selected"] boolValue]);
	
	cell.detailTextLabel.text = [[object valueForKey:@"type"] description];
	cell.textLabel.text = [[object valueForKey:@"title"] description];
}


/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error = nil;
		if (![context save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
	}
}*/


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	//set preditcate to only get workouts for this body part
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"injury == %@", self.workoutsItem];
	[fetchRequest setPredicate:predicate];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		default:
			return;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}


@end
