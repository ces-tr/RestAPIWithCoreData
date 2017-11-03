//
//  Utils.m
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/2/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import "Utils.h"
#import "B4AppClassAttribute.h"

@implementation Utils
//@property (class, nonatomic, assign, readonly) NSInteger userCount;
static NSMapTable *objectToObjectMapping = nil;//[NSMapTable weakToWeakObjectsMapTable];

+ (NSMapTable *)objectToObjectMapping {
    if (objectToObjectMapping == nil) {
        objectToObjectMapping = [[NSMapTable weakToWeakObjectsMapTable] init];
    }
    return objectToObjectMapping;
}

+ (void)setObjectToObjectMapping:(NSMapTable *)newIdentifier {
    if (newIdentifier != objectToObjectMapping) {
        objectToObjectMapping = [newIdentifier copy];
    }
}

+(NSString*) HasCustomClassName :(NSString*)theClass  {
    NSString *ret= nil;
    Class aClass = NSClassFromString(theClass);
    SEL aSelector = NSSelectorFromString(@"RF_attributesForClass");
    if ([[aClass class] respondsToSelector:aSelector]) {
        NSArray *attributesList  = [[aClass class] performSelector: aSelector];
        
        for (NSObject *attribute in attributesList) {
            if ([attribute isKindOfClass:[B4AppClassAttribute class]]) {
                B4AppClassAttribute *ClassAttr = (B4AppClassAttribute *) attribute;
                ret=  [NSString stringWithFormat:@"%@", ClassAttr.Name] ;
                
            }
        }
        
    }
    
    return ret;
}


@end
