//
//  DatabaseSearch.h
//  BOGOpal
//
//  Created by Achintya Gopal on 5/29/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol DatabaseSearchDelegate <NSObject>

-(void)viewUpdated: (NSArray *)objects;
-(void)error:(NSError *)error;

@end

@interface DatabaseSearch : NSObject

@property(nonatomic, copy)NSString *query;
@property(nonatomic, retain) NSMutableArray *objects;
@property (nonatomic, weak) id<DatabaseSearchDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *requests;

-(instancetype)init;

//queries
-(void)createQueryInField: (NSString *)field
                withQuery: (NSString *)query;
-(void)createQueryInField: (NSString *)field1
                withQuery: (NSString *)query1
             anotherField: (NSString *)field2
         withAnotherQuery: (NSString *)query2;
-(void)createQueryFromRegion: (MKCoordinateRegion)region;
-(void)invertEqualtoNotEqual;

-(void)createQueryInField: (NSString *)field1
                withQuery: (NSString *)query1
                  orField: (NSString *)field2
                withQuery: (NSString *)query2;
-(void)appendOrField: (NSString *)field withQuery: (NSString *)query;
-(void)appendAndField: (NSString *)field withQuery: (NSString *)query;
-(void)clearQuery;

//GET
-(void)getFromCollection:(NSString *)kField;
-(void)loadImageWithId: (NSString *)imageId;

//PUT/POST
-(void)saveDictionary: (NSDictionary *)dictionary inField: (NSString *)kField;

//DELETE
-(void)deleteId: (NSString *)_id inField: (NSString *)kField;
-(void)deleteQueryinField:(NSString *)kField;
-(void)deleteAllFromField: (NSString *)kField;

@end
