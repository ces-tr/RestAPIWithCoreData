//
//  User.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/3/17.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "B4AppClassAttribute.h"

RF_ATTRIBUTE(B4AppClassAttribute, Name=@"_User" )
@interface User : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, assign) BOOL  emailVerified;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * email;


@end
