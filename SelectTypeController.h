//
//  SelectTypeController.h
//  PT2Go
//
//  Created by thomas wheeler on 4/27/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTypeDelegate;

@interface SelectTypeController : UITableViewController

-(void) setData: (NSArray*) data titleString:(NSString*)str selected: (NSInteger)index;
@property (strong, nonatomic) id <SelectTypeDelegate> delegate;

@end


@protocol SelectTypeDelegate<NSObject>

-(void) didReturnString: (NSString*) str atIndexPath: (NSIndexPath*) path forTitleString:(NSString*) str;

@end