//
//  UserProfile.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/7/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, assign) BOOL  isRechased;
@property (nonatomic, assign) BOOL  isActive;
@property (nonatomic, assign) BOOL  isVerified;
@property (nonatomic, assign) BOOL  hasPassword;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSDate * birthDay;
@property (nonatomic, retain) NSString * division;
@property (nonatomic, retain) NSString * ocesaNumber;
@property (nonatomic, assign) NSNumber * role;
@property (nonatomic, retain) NSString * rfc;
@property (nonatomic, retain) NSString * rechaseComment;

/*
 Address = Chapultepec;
 Area = Xamarinos;
 BirthDay =             {
 "__type" = Date;
 iso = "1986-09-18T16:52:39.000Z";
 };
 Division = Xamarinos;
 Email = "cesar@test.com";
 FirstName = Cesar;
 HasPassword = 0;
 IsActive = 1;
 IsRechased = 1;
 IsVerified = 0;
 Job = Dev;
 LastName = "Turrubiates Rivera";
 OcesaNumber = 111155;
 Owner =             {
 "__type" = Pointer;
 className = "_User";
 objectId = 1s9IbRhFtk;
 };
 PhoneNumber = 1111111111;
 Picture =             {
 "__type" = File;
 name = "347da50c09207c2b788bbde618919721_image.jpg";
 url = "https://parsefiles.back4app.com/yCV7RgWrogwHiEBhEbMwN4R3N24OyNe3xyR5ElWo/347da50c09207c2b788bbde618919721_image.jpg";
 };
 RFC = TURC860918JN3;
 RechaseComment = "<null>";
 Role = 1;
 createdAt = "2016-04-05T16:49:33.841Z";
 objectId = begp6WHqeT;
 updatedAt =
 
 */

@end
