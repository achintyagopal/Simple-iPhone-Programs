//
//  ViewController.h
//  ImageProcessing
//
//  Created by Achintya Gopal on 3/4/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

- (IBAction)selectPhoto:(UIBarButtonItem *)sender;
- (IBAction)takePhoto:(UIBarButtonItem *)sender;
- (IBAction)editPhoto:(UIBarButtonItem *)sender;

@end

