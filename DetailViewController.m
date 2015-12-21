//
//  DetailViewController.m
//  PT2Go
//
//  Created by thomas wheeler on 3/25/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property NSInteger count;
@property NSMutableArray* images;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
	    _detailItem = newDetailItem;
	        
	    // Update the view.
	    [self configureView];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	
	if (self.detailItem) {
		self.workoutTitle.text = [self.detailItem valueForKey:@"type"];
		self.workoutDescription.text = [self.detailItem valueForKey:@"title"];
		
		_count = 0;
		
		NSArray * arr = [self.detailItem valueForKey:@"images"];
		_images = [[NSMutableArray alloc] initWithCapacity:arr.count];
		for(NSString* image in arr) {
			[_images addObject: [UIImage imageNamed:image ]];
		}
		
		self.imageView.clipsToBounds = YES;
		
		
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		self.imageView.animationImages = _images;
		self.imageView.animationDuration = _images.count *1.0f;
		self.imageView.animationRepeatCount = 0;
		
		[self.imageView startAnimating];
		
		//[self refreshImage];
		//[NSTimer scheduledTimerWithTimeInterval:10.0f target: self selector:@selector(refreshImage)  userInfo:nil repeats:YES];
		
	}
}

-(void) refreshImage {
	UIImage * i = _images[_count++];
	_count %= _images.count;
	
	//[UIView animateWithDuration:.1f delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.imageView.image = i;
	//} completion:nil];
	
	CATransition *transition = [CATransition animation];
	transition.duration = 2.0f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.imageView.layer addAnimation:transition forKey:nil];
	});
	
}

- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	
	UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
	gr.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer: gr];
	
	
}

-(void) swiped: (id) sender {
	[self dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
