//
//  DetailViewController.h
//  PT2Go
//
//  Created by thomas wheeler on 3/25/15.
//  Copyright (c) 2015 Tia Nayar ISM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *workoutTitle;
@property (strong, nonatomic) IBOutlet UILabel *workoutDescription;

@end

