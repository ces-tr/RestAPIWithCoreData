//
//  RSUserDetailViewController.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/5/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SDCoreDataController.h"

@interface RSUserDetailViewController : UIViewController 

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@end
