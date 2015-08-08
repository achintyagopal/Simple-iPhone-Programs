//
//  ViewController.h
//  RowReducedEchelonForm
//
//  Created by Achintya Gopal on 3/19/15.
//  Copyright (c) 2015 Achintya Gopal\. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
//@property (strong, nonatomic) id matrixArray;
@property (nonatomic) int rows;
@property (nonatomic) int columns;

- (IBAction)createNewMatrix:(id)sender;
- (IBAction)solveMatrix:(id)sender;

@end

