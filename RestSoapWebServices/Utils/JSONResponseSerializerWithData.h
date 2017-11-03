//
//  JSONResponseSerializerWithData.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/3/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"

static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";
@interface JSONResponseSerializerWithData : AFJSONResponseSerializer
/// NSError userInfo key that will contain response data

@end
