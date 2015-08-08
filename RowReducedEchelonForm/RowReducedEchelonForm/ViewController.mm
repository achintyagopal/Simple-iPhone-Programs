//
//  ViewController.m
//  RowReducedEchelonForm
//
//  Created by Achintya Gopal on 3/19/15.
//  Copyright (c) 2015 Achintya Gopal\. All rights reserved.
//

#import "ViewController.h"
#import "SolutionController.h"

@interface ViewController () <UITextFieldDelegate>
{
    //float matrixArray[][];
    int maxRows;
    int maxColumns;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.rows = 0;
    self.columns = 0;
    self.button2.enabled = FALSE;
    
    int width = self.view.frame.size.width - 32;
    int height = self.view.frame.size.height - 76;
    maxColumns = width/55;
    maxRows = height/32;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createNewMatrix:(id)sender {
    [self removeMatrix];
    self.button2.enabled = false;
    [self newMatrix];
}

-(void)removeMatrix{
    //remove any matrix, if any exists
    for (int i = 0; i < self.rows*self.columns; i++) {
        UITextField *a = [self getTextFieldFromArrayAtIndex:i];
        if(a != nil){
            a.hidden = TRUE;
            [a removeFromSuperview];
        }
    }
}

-(void)newMatrix{
    
    NSString *string = [NSString stringWithFormat:@"How many rows? (1 - %d)",maxRows];
    
    UIAlertView *alertRows = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    alertRows.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertRows.tag = 0;
    
    UITextField *answer = [alertRows textFieldAtIndex:0];
    answer.keyboardType = UIKeyboardTypeNumberPad;
    answer.placeholder = @"rows";
    
    [alertRows show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        NSLog(@"Clicked button index 0");
        NSString *input = [alertView textFieldAtIndex:0].text;
        self.rows = [input intValue];
        
        if(self.rows > maxRows){
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:@"The number of rows is to large" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            errorAlert.tag = 2;
            [errorAlert show];
            return;
        }
        if(self.rows == 0){
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:@"There needs to be more than 0 rows" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            errorAlert.tag = 2;
            [errorAlert show];
            return;
        }
        
        NSString *string = [NSString stringWithFormat:@"How many columns? (1 - %d)",maxColumns];
        UIAlertView *alertColumns = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
        alertColumns.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertColumns.tag = 1;
        
        UITextField *answer = [alertColumns textFieldAtIndex:0];
        answer.keyboardType = UIKeyboardTypeNumberPad;
        answer.placeholder = @"columns";
        [alertColumns show];
    }
    else if (alertView.tag == 1) {
        NSString *input = [alertView textFieldAtIndex:0].text;
        self.columns = [input intValue];
        
        if(self.columns > maxColumns){
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:@"The number of columns is to large" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            errorAlert.tag = 2;
            [errorAlert show];
            return;
        }
        if(self.columns == 0){
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Create Matrix" message:@"There needs to be more than 0 columns" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            errorAlert.tag = 2;
            [errorAlert show];
            return;
        }
        
        if(self.rows == 0 || self.columns == 0){
            self.button2.enabled = FALSE;
        }
        else{
            self.button2.enabled = TRUE;
            [self.button2 setTintColor:[UIColor colorWithRed:250.0/255.0 green:62.0/255.0 blue:53.0/255.0 alpha:1.0]];
            [self createMatrix];
        }
    }
}

-(UITextField *)getTextFieldFromArrayAtIndex:(NSInteger)index{
    
    for (UIView *v in self.view.subviews){
        if ([v isKindOfClass:[UITextField class]]){
            if (v.tag ==  index){
                return (UITextField *)v;
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
        int starty = 16;
        int endx = bounds.size.width - 16;
        int endy = bounds.size.height - 60;
        int width = (endx - startx)/self.columns;
        int height = (endy - starty)/self.rows;
        if((height - 2)>32){
            height = 32;
        }
        for (int i=0; i<self.rows; i++){
            for(int j = 0; j < self.columns; j++){
                UITextField *newLabel=[[UITextField alloc] init]    ;
                newLabel.frame = CGRectMake(j*width + bounds.origin.x+16, i*height + bounds.origin.y+16, width- 2, height - 2);
                newLabel.tag=i*self.columns + j;
                newLabel.delegate = self;
                newLabel.keyboardType = UIKeyboardTypeDecimalPad;
                
                newLabel.layer.borderWidth = 1.0f;
                
                [self.view addSubview:newLabel];
                newLabel=nil;
            }
        }
    }
}

- (IBAction)solveMatrix:(id)sender {
    float **matrixArray = [self createMatrixArray];
    [self rrefWithArray:matrixArray];
    
    SolutionController *solutionController = [[SolutionController alloc] init];
    solutionController.rows = self.rows;
    solutionController.columns = self.columns;
    solutionController.matrixArray = matrixArray;
    
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:solutionController];
    [self presentViewController:navVC animated:YES completion:nil];
}

-(float **)createMatrixArray{
    NSLog(@"Create matrix array");
    
    float **matrixArray = new float*[self.rows];
    for(int h = 0; h < self.rows; h++){
        matrixArray[h] = new float[self.columns];
    }
    
    for(int i = 0; i<self.rows;i++){
        for(int j = 0; j<self.columns;j++){
            UITextField *a = [self getTextFieldFromArrayAtIndex:i*self.columns + j];
            matrixArray[i][j] = [a.text floatValue];
            NSLog(@"%f",matrixArray[i][j]);
        }
    }
    return matrixArray;
}

-(void)rrefWithArray: (float **)matrixArray{
    
    int x = 0;//rows (or usual y value)
    int y = 0;//columns (or usual x value)
    
    //if value is not zero, divide whole row by that value, and remove from the rest of the rows the value
    //if value is zero, interchange the row with the next row with nonzero value, if there is no other row with non zero value there, move to next column
    
    while(x < self.rows && y < self.columns){
        if(matrixArray[x][y] == 0){

            int k = 0;
            int j = 1;
            while(k == 0 && (x+j) < self.rows){
                k = matrixArray[x+j][y];
                j++;
            }
            j--;
            if(k == 0){
                y++;
                continue;
            }
            else{
                int search = x + j;
                for(int i = 0; i < self.columns; i++){
                    float temp = matrixArray[search][i];
                    matrixArray[search][i] = matrixArray[x][i];
                    matrixArray[x][i] = temp;
                }
            }
        }
        
        float a = matrixArray[x][y];
        for(int i = y;i<self.columns;i++){
            matrixArray[x][i] = (matrixArray[x][i])/a;
        }
        for(int i = 0; i<self.rows;i++){
            a = matrixArray[i][y];
            if(i == x){
                continue;
            }
            for(int j = 0; j<self.columns;j++){
                matrixArray[i][j] = matrixArray[i][j] - a * matrixArray[x][j];
            }
        }
        x++;
        y++;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for(int i = 0; i < self.rows *self.columns; i++){
        UITextField *field = [self getTextFieldFromArrayAtIndex:i];
        [field resignFirstResponder];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqual:@"."]){
        for(int i =0; i<textField.text.length; i++){
            if([textField.text characterAtIndex:i] == '.'){
                return NO;
            }
        }
    }
    return YES;
}

@end
