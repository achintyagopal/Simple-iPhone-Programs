//
//  DatabaseSearch.m
//  BOGOpal
//
//  Created by Achintya Gopal on 5/29/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import "DatabaseSearch.h"

extern NSString *kBaseURL;
int a;

@implementation DatabaseSearch 

/***************INITIALIZE***********/

-(instancetype)init {
    
    self = [super init];
    if(self){
        self.query = @"";
        a = 0;
        self.objects = [[NSMutableArray alloc]init];
        self.requests =[[NSMutableArray alloc]init];
    }
    
    return  self;
}

/***************QUERY***********/

-(void)createQueryInField: (NSString *)field
                withQuery: (NSString *)query {
    
    NSString *nameQuery = [NSString stringWithFormat:@"{\"$eq\":\"%@\"}",query];
    NSString *userInQuery = [NSString stringWithFormat:@"{\"%@\":%@}", field, nameQuery];
    NSString* escName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef) userInQuery,
                                                                                              NULL,
                                                                                              (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                              kCFStringEncodingUTF8));
    self.query = [NSString stringWithFormat:@"?query=%@",escName];
}

-(void)createQueryInField: (NSString *)field1
                withQuery: (NSString *)query1
             anotherField: (NSString *)field2
         withAnotherQuery: (NSString *)query2 {

    [self createQueryInField:field1 withQuery:query1];
    [self appendAndField:field2 withQuery:query2];
}

-(void)clearQuery {
    self.query = @"";
}

-(void)createQueryFromRegion: (MKCoordinateRegion)region {
    CLLocationDegrees x0 = region.center.longitude - region.span.longitudeDelta; //2
    CLLocationDegrees x1 = region.center.longitude + region.span.longitudeDelta;
    CLLocationDegrees y0 = region.center.latitude - region.span.latitudeDelta;
    CLLocationDegrees y1 = region.center.latitude + region.span.latitudeDelta;
    
    NSString* boxQuery = [NSString stringWithFormat:@"{\"$geoWithin\":{\"$box\":[[%f,%f],[%f,%f]]}}",x0,y0,x1,y1]; //3
    NSString* locationInBox = [NSString stringWithFormat:@"{\"location\":%@}", boxQuery]; //4
    NSString* escBox = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef) locationInBox,
                                                                                             NULL,
                                                                                             (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                             kCFStringEncodingUTF8)); //5
    
    self.query= [NSString stringWithFormat:@"?query=%@", escBox]; //6
}

-(void)createQueryInField: (NSString *)field1 withQuery: (NSString *)query1 orField: (NSString *)field2 withQuery: (NSString *)query2 {
    
    [self createQueryInField:field1 withQuery:query1];
    [self appendOrField:field2 withQuery:query2];
}

-(void)appendOrField: (NSString *)field withQuery: (NSString *)query {
    //]}
    if([self.query containsString:@"%22%24or"]){
        NSString *nameQuery = [NSString stringWithFormat:@",{\"%@\":{\"$eq\":\"%@\"}}",field,query];
        NSString* escName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef) nameQuery,
                                                                                                  NULL,
                                                                                                  (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                                  kCFStringEncodingUTF8));
        NSLog(@"%@", escName);
        NSMutableString *string = [[NSMutableString alloc]initWithString: self.query];
        NSString *endString = [string substringWithRange:NSMakeRange(self.query.length - 6, 6)];
        NSLog(@"%@",endString);
        [string deleteCharactersInRange:NSMakeRange(self.query.length - 6, 6)];
        [string appendString:escName];
        [string appendString:endString];
        self.query = string;
        NSLog(@"%@", self.query);
    }
    else{
        NSMutableString *tempQuery = [[NSMutableString alloc]initWithString:self.query];
        [tempQuery deleteCharactersInRange:NSMakeRange(0, 7)];
        NSString *nameQuery = [NSString stringWithFormat:@"{\"%@\":{\"$eq\":\"%@\"}}", field, query];
        NSString *orQuery = [NSString stringWithFormat:@"{\"$or\":[%@]}", nameQuery];
        NSString* escName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef) orQuery,
                                                                                                  NULL,
                                                                                                  (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                                  kCFStringEncodingUTF8));
        NSString *endString = [escName substringWithRange:NSMakeRange(escName.length-6, 6)];
        NSMutableString *mutEscName = [escName mutableCopy];
        [mutEscName deleteCharactersInRange:NSMakeRange(escName.length-6, 6)];
        self.query = [NSString stringWithFormat:@"?query=%@%%2C%@%@",mutEscName,tempQuery,endString];
    }
}

-(void)appendAndField:(NSString *)field withQuery:(NSString *)query {
    if([self.query containsString:@"%22%24and"]){
        
        NSString *nameQuery = [NSString stringWithFormat:@",{\"%@\":{\"$eq\":\"%@\"}}",field,query];
        NSString* escName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef) nameQuery,
                                                                                                  NULL,
                                                                                                  (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                                  kCFStringEncodingUTF8));
        NSLog(@"%@", escName);
        NSMutableString *string = [[NSMutableString alloc]initWithString: self.query];
        NSString *endString = [string substringWithRange:NSMakeRange(self.query.length - 6, 6)];
        NSLog(@"%@",endString);
        [string deleteCharactersInRange:NSMakeRange(self.query.length - 6, 6)];
        [string appendString:escName];
        [string appendString:endString];
        self.query = string;
        NSLog(@"%@", self.query);
        
    }
    else{
        NSMutableString *tempQuery = [[NSMutableString alloc]initWithString:self.query];
        [tempQuery deleteCharactersInRange:NSMakeRange(0, 7)];
        NSString *nameQuery = [NSString stringWithFormat:@"{\"%@\":{\"$eq\":\"%@\"}}", field, query];
        NSString *orQuery = [NSString stringWithFormat:@"{\"$and\":[%@]}", nameQuery];
        NSString* escName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef) orQuery,
                                                                                                  NULL,
                                                                                                  (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                                  kCFStringEncodingUTF8));
        NSString *endString = [escName substringWithRange:NSMakeRange(escName.length-6, 6)];
        NSMutableString *mutEscName = [escName mutableCopy];
        [mutEscName deleteCharactersInRange:NSMakeRange(escName.length-6, 6)];
        self.query = [NSString stringWithFormat:@"?query=%@%%2C%@%@",mutEscName,tempQuery,endString];
    }
}

-(void)invertEqualtoNotEqual{
    NSMutableString *string = [[NSMutableString alloc]initWithString:self.query];
    [string replaceOccurrencesOfString:@"%22%24eq" withString:@"%22%24eq" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    self.query = string;
}

/***************GET***********/

-(void)getFromCollection:(NSString *)kField {
    
    NSURL *url = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:kField]stringByAppendingString:self.query]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    __block NSArray *responseArray = [[NSArray alloc]init];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSLog(@"Complete");
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            self.objects = [responseArray mutableCopy];
            NSLog(@"count %ld", responseArray.count);
            NSLog(@"%@", self.objects);
            NSLog(@"class %@", self.objects.class);
            if(self.delegate) {
                [self.delegate viewUpdated];
            }
            [dataTask cancel];
        }
    }];
    NSLog(@"resume");
    [dataTask resume];
}

/********************DEAL***************/

-(void)loadImageWithId: (NSString *)imageId {
    
    NSURL* url = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:@"files"] stringByAppendingPathComponent:imageId]]; //1
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    __block BOOL finished = false;
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:url completionHandler:^(NSURL *fileLocation, NSURLResponse *response, NSError *error) { //2
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:fileLocation]; //3
            UIImage* image = [UIImage imageWithData:imageData];
            
            if (!image) {
                NSLog(@"unable to build image");
            }
            
            finished =true;
        }
    }];
    
    [task resume];
    while(!finished);
}

/***************DELETE***********/

-(void)deleteId:(NSString *)_id inField:(NSString *)kField{
    NSString *users = [[kBaseURL stringByAppendingPathComponent:kField]stringByAppendingPathComponent:_id];
    NSURL *url = [NSURL URLWithString:users];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSLog(@"delete");
    }];
    [dataTask resume];
}

-(void)deleteQueryinField:(NSString *)kField{
    
    NSURL *url = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:kField]stringByAppendingString:self.query]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
    }];
    [dataTask resume];
}

-(void)deleteAllFromField: (NSString *)kField {
    NSString *users = [kBaseURL stringByAppendingString:kField];
    NSURL *url = [NSURL URLWithString:users];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        [dataTask cancel];
        
    }];
    [dataTask resume];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [dataTask resume];
    });
}

/***************SAVE***********/

-(void)saveDictionary:(NSDictionary *)dictionary inField:(NSString *)kField{
    
    NSString* users = [kBaseURL stringByAppendingPathComponent:kField];
    
    BOOL isExistingLocation = dictionary[@"_id"]!= nil;
    NSURL* url = isExistingLocation ? [NSURL URLWithString:[users stringByAppendingPathComponent:dictionary[@"_id"]]] :
    [NSURL URLWithString:users]; //1
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = isExistingLocation ? @"PUT" : @"POST"; //2
    NSLog(@"%@",request.HTTPMethod);
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL]; //3
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    __block BOOL finished = false;
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            finished = true;
        }
        [dataTask cancel];
        
    }];
    
    [dataTask resume];
}
@end
