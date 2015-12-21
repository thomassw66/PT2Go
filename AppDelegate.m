//
//  AppDelegate.m
//  PT2Go
//
//  Created by thomas wheeler on 3/25/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "BodyPartViewController.h"
#import "MyWorkouts.h"
#import "CreateWorkoutViewController.h"

@interface AppDelegate ()

@property BOOL firstinstall;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.

	
	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	CreateWorkoutViewController *controller = (CreateWorkoutViewController *)navigationController.topViewController;
	controller.managedObjectContext = self.managedObjectContext;
	
	/*CreateWorkoutViewController *cwvc = [[UIStoryboard storyboardWithName: @"Main" bundle:nil] instantiateViewControllerWithIdentifier: @"CWork" ];
	//[cwvc loadView];
	self.window.rootViewController = cwvc;
	*/
	
	//to help with animations
	//self.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "tnism.PT2Go" in the application's documents directory.
	// Returns the URL to the application's Documents directory.
	NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PT2Go" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
	_firstinstall = NO;
	
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PT2Go.sqlite"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
		
		_firstinstall = YES;
		NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PT2Go" ofType:@"sqlite"]];
		NSError* err = nil;
		
		//convert it into new object model somehow
		
		if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
			NSLog(@"Oops, could copy preloaded data");
		}
	}
	
	//NSDictionary * options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
	//					  NSInferMappingModelAutomaticallyOption : @YES};
	
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
	/*if(_firstinstall)
	{
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Workout"];
		[fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"2=2"]];
		fetchRequest.fetchLimit = 1000000;
		NSArray * workouts = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
		
		for(NSManagedObject * workout in workouts){
			
			[workout setValue: [NSNumber numberWithBool:NO] forKey:@"selected"];
			[workout setValue: [NSDate date] forKey:@"timeSelected"];
		}
		
		if(![self.managedObjectContext save:nil]){
			NSLog(@"yo");
		}
	}*/
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}

@end
