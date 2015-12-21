//
//  CreateWorkoutViewController.m
//  PT2Go
//
//  Created by thomas wheeler on 4/24/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "CreateWorkoutViewController.h"
#import <CoreData/CoreData.h> 
#import "EditableTextCell.h"

#define YASSSS YES

@interface CreateWorkoutViewController ()



@property BOOL selectedBodyPart;
@property NSArray * bodyObjects;
@property NSManagedObject * selectedBody;

@property NSArray *injuryObjects;
@property NSManagedObject * selectedInjury;
@property BOOL didSelectInjury;

@end

@implementation CreateWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style: UIBarButtonItemStylePlain target:self action: @selector(createWorkout)];
	//self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStylePlain target:self action:@selector(bye)];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	if(self.selectedInjury){
		[self setInjury:self.selectedInjury];
	}
	
	if(self.selectedBody){
		[self setBody:self.selectedBody];
	}
	
}

-(void) bye{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createWorkout {
	NSString *name = ((EditableTextCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]]).textField.text;
	NSString *type = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
	
	//NSLog(@"%@ %@", name, type);
	
	NSMutableArray *photos = [[NSMutableArray alloc]init];
	/*for(int i = 1; i <= 4; i++){
		NSString *fileame = [NSString stringWithFormat:@"%@-%@-%@-%i.jpg", [(NSString*)[self.selectedBody valueForKey:@"bodyPart"] stringByReplacingOccurrencesOfString: @"/" withString: @"_"], [[self.selectedInjury valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"], [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"], i];
		//NSLog(@"%@",fileame);
		NSLog(@"filename: %@",fileame);
		if([UIImage imageNamed:fileame]){
			[photos addObject:fileame];
		}
		
	}
	NSLog(@"%lu", (unsigned long)photos.count);
	
	 */ //code for adding photos to project
	
	
	NSManagedObjectContext *moc = self.managedObjectContext;
	NSManagedObject * obj = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:moc];
	
	
	
	[obj setValue: [NSDate date] forKey:@"timeStamp"];
	[obj setValue:name forKey:@"title"];
	[obj setValue:type forKey:@"type"];
	[obj setValue:self.selectedInjury forKey:@"injury"];
	[obj setValue: photos forKey:@"images"];
	//[obj setValue: [NSNumber numberWithBool:NO] forKey:@"selected"];
	//[object setValue: [NSDate date] forKey:@"timeSelected"];

	// Save the context.
	NSError *error = nil;
	if (![moc save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	[self bye];
}

-(void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YASSSS];

	if(indexPath.section == 0 && indexPath.row == 1){
		
		UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
		
		SelectTypeController * s = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectType"];
		[s setDelegate:self];
		NSArray * arr= @[@"Exercise",@"Stretch"];
		[s setData:arr titleString: @"Select Type" selected: [arr indexOfObject: cell.detailTextLabel.text]];
		
		[self showViewController:s sender:self];
	}
	
	if(indexPath.section == 1 && indexPath.row == 0){
		NSManagedObjectContext * moc = self.managedObjectContext;
		NSEntityDescription * entity = [NSEntityDescription entityForName: @"BodyPart" inManagedObjectContext: moc];
		
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc ] initWithKey:@"bodyPart" ascending:YASSSS];
		[fetchRequest setSortDescriptors:@[sortDescriptor]];
		
		NSError * err;
		NSArray * res = [moc executeFetchRequest:fetchRequest error:&err];
		if(err){
			NSLog(@"%@", err);
		}
		self.bodyObjects = res;
		
		NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:res.count];
		for (NSManagedObject* obj in res) {
			[arr addObject:[obj valueForKey:@"bodyPart"]];
		}
		
		SelectTypeController * s = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectType"];
		[s setDelegate:self];
		[s setData:arr titleString:@"Select Body Part" selected: [arr indexOfObject:[self.selectedBody valueForKey:@"bodyPart"]]];
		
		[self showViewController:s sender:self];
	}
	if(indexPath.section == 2 && indexPath.row == 0 && self.selectedBodyPart){
		
		NSPredicate *thisBodyPartPredicate = [NSPredicate predicateWithFormat:@"%K = %@", @"bodyPart", self.selectedBody];
		
		
		NSManagedObjectContext * moc = self.managedObjectContext;
		NSEntityDescription * entity = [NSEntityDescription entityForName: @"Injury" inManagedObjectContext: moc];
		
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:thisBodyPartPredicate];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc ] initWithKey:@"title" ascending:YASSSS];
		[fetchRequest setSortDescriptors:@[sortDescriptor]];
		
		NSError * err;
		NSArray * res = [moc executeFetchRequest:fetchRequest error:&err];
		if(err){
			NSLog(@"%@", err);
		}
		self.injuryObjects = res;
		
		NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:res.count];
		for (NSManagedObject* obj in res) {
			[arr addObject:[obj valueForKey:@"title"]];
		}
		
		SelectTypeController * s = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectType"];
		[s setDelegate:self];
		[s setData:arr titleString:@"Select Injury" selected: [arr indexOfObject:[self.selectedInjury valueForKey:@"title"]]];
		
		[self showViewController:s sender:self];
	}
}

-(void) didReturnString:(NSString *)str atIndexPath:(NSIndexPath *)path forTitleString:(NSString *)title{
	if([title isEqualToString:@"Select Type"]){
		// Set the selected type
		UITableViewCell * cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection:0]];
		cell.detailTextLabel.text = str;
	}else if ([title isEqualToString:@"Select Body Part"]){
		// Set the selected body part
		UITableViewCell * cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
		cell.detailTextLabel.text = str;
		self.selectedBodyPart = YASSSS;
		self.selectedBody = self.bodyObjects[path.row];
	}else if ([title isEqualToString:@"Select Injury"]){
		UITableViewCell * cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
		cell.detailTextLabel.text = str;
		self.didSelectInjury = YASSSS;
		self.selectedInjury = self.injuryObjects[path.row];
	}
	
	if(self.didSelectInjury && self.selectedBodyPart){
		self.navigationItem.rightBarButtonItem.enabled = YASSSS;
	}
}

-(void) setBody: (NSManagedObject *) body{
	self.selectedBody = body;
	self.selectedBodyPart = YASSSS;
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].detailTextLabel.text = [body valueForKey:@"bodyPart"];
	[self.tableView reloadData];
}
-(void) setInjury: (NSManagedObject *) injury{
	self.selectedInjury = injury;
	self.didSelectInjury = YASSSS;
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]].detailTextLabel.text = [injury valueForKey:@"title"];
	[self.tableView reloadData];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
