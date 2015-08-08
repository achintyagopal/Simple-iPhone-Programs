//
//  SolutionController.m
//  RowReducedEchelonForm
//
//  Created by Achintya Gopal on 3/20/15.
//  Copyright (c) 2015 Achintya Gopal\. All rights reserved.
//

#import "SolutionController.h"
#import "ViewController.h"

@interface SolutionController ()

@end

@implementation SolutionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createMatrix];
    [self printSolution];
}

-(void)printSolution{
    for(int i = 0; i<self.rows; i++){
        for(int j = 0; j<self.columns; j++){
            UILabel *a = [self getLabelFromArrayAtIndex:i*self.columns + j];
            NSString *result = [NSString stringWithFormat:@"%f",self.matrixArray[i][j]];
            NSMutableString *mutResult = [[NSMutableString alloc]initWithString:result];
            
            for(int i = (int)result.length - 1; i >=0; i--){
                if([result characterAtIndex:i] == '0'){
                    [mutResult deleteCharactersInRange:NSMakeRange(i, 1)];
                }
                else if([result characterAtIndex:i] == '.'){
                    [mutResult deleteCharactersInRange:NSMakeRange(i, 1)];
                }
                else{
                    break;
                }
            }
            a.text = mutResult;
        }
    }
}

-(UILabel *)getLabelFromArrayAtIndex:(NSInteger)index{
    
    for (UIView *v in self.view.subviews){
        if ([v isKindOfClass:[UILabel class]]){
            if (v.tag ==  index){
                return (UILabel *)v;
            }
        }
    }
    return nil;
}

-(void)createMatrix{
    if(self.rows != 0 && self.columns != 0){
        CGRect bounds = self.view.bounds;
        // starting x 16, highest y 16, lowest y bounds - 60
        int startx = 16;
        int starty = 66;
        int endx = bounds.size.width - 16;
        int endy = bounds.size.height - 16;
        
        int width = (endx - startx)/self.columns;
        int height = (endy - starty)/self.rows;
        if((height - 2)>32){
            height = 32;
        }
        for (NSInteger i=0; i<self.rows; i++){
            for(NSInteger j = 0; j < self.columns; j++){
                UILabel *newLabel=[[UILabel alloc] initWithFrame: CGRectMake(j*width + bounds.origin.x+16, i*height + bounds.origin.y+66, width- 2, height - 2)]    ;
                newLabel.layer.borderColor = [[UIColor blackColor]CGColor];
                newLabel.layer.borderWidth = 2.0f;
                
                newLabel.tag=i*self.columns + j;
                [self.view addSubview:newLabel];
                newLabel=nil;
            }
        }
    }
}

-(void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
