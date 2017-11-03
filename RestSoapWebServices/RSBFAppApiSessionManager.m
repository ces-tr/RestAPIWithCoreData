//
//  RSBFAppApiSessionManager.m
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/3/17.
//
//
#import <Foundation/Foundation.h>
#import "RSBFAppApiSessionManager.h"
#import "Utils.h"
#import "JSONResponseSerializerWithData.h"

static NSString * const kSDFParseAPIBaseURLString = @"https://parseapi.back4app.com/";

static NSString * const kSDFParseAPIApplicationId = @"yCV7RgWrogwHiEBhEbMwN4R3N24OyNe3xyR5ElWo";
static NSString * const kSDFParseAPIKey = @"LzKs6n01jPw1ZmbzdIOycysyMge4m3AjsfDqIGIG";

@implementation RSBFAppApiSessionManager


+ (RSBFAppApiSessionManager *) sharedParseApiClientInstance {
    
    static RSBFAppApiSessionManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[RSBFAppApiSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString]];
        
        sharedClient.responseSerializer = [JSONResponseSerializerWithData serializer];
    }); 
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        [[self requestSerializer] setStringEncoding:(NSUTF8StringEncoding)];
        [[self requestSerializer] setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [[self requestSerializer] setValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
        [[self requestSerializer] setValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        
//        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//        [self setParameterEncoding:AFJSONParameterEncoding];
//        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSDFParseAPIApplicationId];
//        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    
    
//    [self requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", _userObj.oAuth] forHTTPHeaderField:@"Authorization"];
//    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:self.baseURL];
//    URLString:[[NSURL URLWithString:[NSString stringWithFormat:@"classes/%@", className] relativeToURL:self.baseURL]
    
     NSString* CustomClassName= [Utils HasCustomClassName: className];
    if ([CustomClassName length]>0) {
        className= CustomClassName;
    }
    request= [[self requestSerializer] requestWithMethod:@"GET"  URLString:[[NSURL URLWithString:[NSString stringWithFormat:@"classes/%@", className] relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
//    request= [self GET:@"http://example.com/resources.json" parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

        NSString *jsonString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];

        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    
    request = [self GETRequestForClass:className parameters:paramters];
    
    
    
    return request;
}

@end
