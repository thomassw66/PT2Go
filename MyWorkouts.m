//
//  MyWorkouts.m
//  PT2Go
//
//  Created by thomas wheeler on 4/6/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "MyWorkouts.h"
#import <CoreData/CoreData.h>
#import "BodyPartViewController.h"
#import "DetailViewController.h"

@interface MyWorkouts ()

@property (strong, nonatomic) IBOutlet UILabel *helpLabel;

@end

@implementation MyWorkouts

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearSelected:)];
	
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	if([self tableView:self.tableView numberOfRowsInSection:0] == 0){
		self.helpLabel.hidden = NO;
		self.helpLabel.alpha = 0;
		[UIView animateWithDuration:.5f delay:1.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^(){
			self.helpLabel.alpha = 1;
		} completion:nil];
	}else {
		self.helpLabel.hidden = YES;
	}
}
-(void) viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) clearSelected: (id) sender {
	
	//[[MyWorkouts selectedObjects] removeAllObjects];
	
	if([self tableView:self.tableView numberOfRowsInSection:0] > 0){
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Woah" message:@"This will remove all workouts are you sure?" delegate:self cancelButtonTitle:@"Whoops don't do that" otherButtonTitles:@"Yeah", nil];
		
		[alert show];

	}
	
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		// do stuff
		NSInteger n = [self tableView:self.tableView numberOfRowsInSection:0];
		for(int i = 0; i < n; i++){
			NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
			[[self.fetchedResultsController objectAtIndexPath:path] setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
		}
		[self.managedObjectContext save:nil];
		//[self.tableView reloadData];
	}
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	BodyPartViewController * controller = (BodyPartViewController*)[segue destinationViewController];
	[controller setManagedObjectContext:self.managedObjectContext];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DetailViewController * controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	//[controller setDetailItem: [[MyWorkouts selectedObjects] objectAtIndex:indexPath.row]];
	[controller setDetailItem: [self.fetchedResultsController objectAtIndexPath:indexPath]];
	//[self.navigationController pushViewController:controller animated:YES];
	[self presentViewController:controller animated:YES completion:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [MyWorkouts selectedObjects].count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyWorkoutsCell"];
	[self configureCell: cell forIndexPath:indexPath];
	return cell;
}

-(void) configureCell: (UITableViewCell*)cell forIndexPath: (NSIndexPath*) indexPath{
	NSManagedObject * object = //[[MyWorkouts selectedObjects] objectAtIndex:indexPath.row];
							   [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = [[object valueForKey:@"title"] description];
	cell.detailTextLabel.text = [[object valueForKey:@"type"] description];
}

+(NSMutableOrderedSet*) selectedObjects {
	// structure used to test whether the block has completed or not
	static dispatch_once_t p = 0;
	
	// initialize sharedObject as nil (first call only)
	__strong static id _sharedObject = nil;
	
	// executes a block object once and only once for the lifetime of an application
	dispatch_once(&p, ^{
		_sharedObject = [[NSMutableOrderedSet alloc] init];
	});
	
	// returns the same object each time
	return _sharedObject;
}


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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == %@", [NSNumber numberWithBool:YES]];
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
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
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
	if([self tableView:self.tableView numberOfRowsInSection:0] == 0){
		self.helpLabel.hidden = NO;
		self.helpLabel.alpha = 0;
		[UIView animateWithDuration:.5f delay:1.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^(){
			self.helpLabel.alpha = 1;
		} completion:nil];
	}else {
		self.helpLabel.hidden = YES;
	}
}



@end
