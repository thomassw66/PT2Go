//
//  SelectTypeController.m
//  PT2Go
//
//  Created by thomas wheeler on 4/27/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "SelectTypeController.h"

@interface SelectTypeController ()

@property NSArray * data;
@property NSInteger selected;

@end

@implementation SelectTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) setData:(NSArray *)data titleString:(NSString*) str selected:(NSInteger)index {
	self.data = data;
	self.selected = index;
	self.navigationItem.title = str;
	[self.tableView reloadData];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(self.data)
		return self.data.count;
	return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTypeCell"];
	cell.textLabel.text = self.data[indexPath.row];
	cell.accessoryType = indexPath.row == self.selected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:self.selected inSection:0];
	UITableViewCell* cell= [tableView cellForRowAtIndexPath:oldIndexPath];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	self.selected = indexPath.row;
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	newCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	NSString * str = [[tableView cellForRowAtIndexPath:indexPath] textLabel].text;
	[self.delegate didReturnString:str atIndexPath:indexPath forTitleString: self.navigationItem.title];
	
	//[self.navigationController popViewControllerAnimated:YES];
}

@end
