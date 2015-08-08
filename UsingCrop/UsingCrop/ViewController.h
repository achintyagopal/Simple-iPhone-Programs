//
//  ViewController.h
//  UsingCrop
//
//  Created by Achintya Gopal on 3/19/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *camera;

- (IBAction)getPhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cropPhoto:(id)sender;

@end

