//
//  ParseJson.m
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/7/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import "ParseJson.h"
#import "Foundation/Foundation.h"

@interface FirstJson : NSObject

@property (strong ,nonatomic) NSString *link;
@property (strong ,nonatomic) NSString *imageUrl;
@property (strong ,nonatomic) NSString *name;
@property ( nonatomic) NSUInteger Id;

@end

@implementation FirstJson


@end

@implementation ParseJson

-(id) init{
    self= [super init];
    if (!self) {
        return nil;
    }
        
    return self;
    
}

-(void) requestJSOnObject {
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"https://api.letsbuildthatapp.com/jsondecodable/course"];
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 
        ///Code
                                                 NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                                                 and print NSString in NSLog like below
                                                 NSLog(@"%@",strData);
                                                 
                                                 NSError * __autoreleasing *e = nil;
                                                 
                                                 NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:(data) options:NSJSONReadingMutableContainers
                                                     error:e];
    }];
    [task resume];
}


@end
