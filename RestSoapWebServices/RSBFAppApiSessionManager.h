//
//  RSBFAppApiSessionManager.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/3/17.
//

#import "AFNetworking.h"

@interface RSBFAppApiSessionManager : AFHTTPSessionManager

+ (RSBFAppApiSessionManager *)sharedParseApiClientInstance;

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;

@end
