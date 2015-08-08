//
//  ViewController.m
//  UsingTesseract
//
//  Created by Achintya Gopal on 3/19/15.
//  Copyright (c) 2015 Achintya Gopal\. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc]initWithLanguage:@"eng"];
    operation.tesseract.charWhitelist = @"0123456789+=";
    operation.tesseract.image = [[UIImage imageNamed:@"math2.jpg"]g8_blackAndWhite];
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract){
        NSLog(@"%@",[recognizedTesseract recognizedText]);
        NSString *input = [NSString stringWithFormat:@"%@",[recognizedTesseract recognizedText]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Result" message:input delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    };
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
