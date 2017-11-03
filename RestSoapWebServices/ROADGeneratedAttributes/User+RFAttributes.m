#import "B4AppClassAttribute.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
 
@interface User(RFAttribute)
 
@end
 
@implementation User(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)RF_attributesForClass {
    NSMutableArray *RF_attributes_list__class_User = [RFAttributeCacheManager objectForKey:@"RFAL__class_User"];
    if (RF_attributes_list__class_User != nil) {
        return RF_attributes_list__class_User;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    B4AppClassAttribute *attr1 = [[B4AppClassAttribute alloc] init];
    attr1.Name=@"_User";
    [attributesArray addObject:attr1];

    RF_attributes_list__class_User = attributesArray;
    [RFAttributeCacheManager setObject:attributesArray forKey:@"RFAL__class_User"];
    
    return RF_attributes_list__class_User;
}

#pragma mark - 

@end
