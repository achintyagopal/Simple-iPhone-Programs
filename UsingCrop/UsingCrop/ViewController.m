//
//  ViewController.m
//  UsingCrop
//
//  Created by Achintya Gopal on 3/19/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import "ViewController.h"
#import "Square.h"

@interface ViewController ()

@property(nonatomic, weak) UIImage *image;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.linesInProgress = [[NSMutableDictionary alloc] init];
    self.finishedLines = [[NSMutableArray alloc] init];
   // [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        self.camera.enabled = NO;
    }
    
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImage:)];
    [self.view addGestureRecognizer:pinchGR];
    self.image = NULL;

    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveImage:)];
    panGR.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGR];
}

-(void)moveImage:(UIPanGestureRecognizer *)uigr{
    if (uigr.state == UIGestureRecognizerStateEnded)
    {
        CGPoint newCenter = CGPointMake(
                                        self.imageView.center.x + self.imageView.transform.tx,
                                        self.imageView.center.y + self.imageView.transform.ty);
        self.imageView.center = newCenter;
            
        CGAffineTransform theTransform = self.imageView.transform;
        theTransform.tx = 0.0f;
        theTransform.ty = 0.0f;
        self.imageView.transform = theTransform;
        
        return;
    }
    
    CGPoint translation = [uigr translationInView:self.imageView.superview];
    CGAffineTransform theTransform = self.imageView.transform;
    theTransform.tx = translation.x;
    theTransform.ty = translation.y;
    self.imageView.transform = theTransform;
}


-(void)pinchImage: (UIPinchGestureRecognizer *)recognize{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, recognize.scale, recognize.scale);
    recognize.scale = 1;
}


-(void)aMethod:(NSTimer *)timer{
    
    //[[UIColor blackColor] set];
    for (Square *line in self.finishedLines) {
       [self strokeLine:line];
    }
    
    //[[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

- (void)strokeLine:(Square *)line
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(line.begin.x, line.begin.y)];
    [path addLineToPoint:CGPointMake(line.end.x, line.begin.y)];
    [path addLineToPoint:CGPointMake(line.end.x, line.end.y)];
    [path addLineToPoint:CGPointMake(line.begin.x,line.end.y)];
    [path closePath];
    
    UIGraphicsBeginImageContext(self.imageView2.frame.size);
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 2.0f;
    [[UIColor redColor] setStroke];
    //[[UIColor redColor] setFill];
    
    double a[2];
    a[0] = 5.0;
    a[1] = 5.0;
    [path setLineDash:a count:2 phase:0.0];
    [path stroke];
    //[path fill];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView2.image = self.image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker
                       animated:YES
                     completion:NULL];
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker
                       animated:YES
                     completion:NULL];
}

- (IBAction)cropPhoto:(id)sender {
    
    UIImage *croppedImage;
    for(Square *square in self.finishedLines) {
        CGRect rect = CGRectMake(square.begin.x , square.begin.y, (square.end.x - square.begin.x),(square.end.y - square.begin.y));
        UIGraphicsBeginImageContext(self.view.frame.size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        [self.imageView.layer renderInContext:c];
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CGImageRef imageRef = CGImageCreateWithImageInRect([croppedImage CGImage], rect);
        croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        self.imageView.image = croppedImage;
    }
    
    self.imageView2.image = nil;
    [self.finishedLines removeAllObjects];
    [self.linesInProgress removeAllObjects];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(aMethod:) userInfo:nil repeats:YES];

    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self.view];
        
        Square *line = [[Square alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }

}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Square *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self.view];
    }
    
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Square *line = self.linesInProgress[key];
        self.finishedLines[0] = line;
        [self.linesInProgress removeObjectForKey:key];
    }

    
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }

}

@end
