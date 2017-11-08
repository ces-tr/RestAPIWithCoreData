//
//  ViewController.h
//  RestSoapWebServices
//
//  Created by Cesar TR on 10/31/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSUsersTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *UserDataArray;
@property (nonatomic, strong) NSString *entityName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SyncBtn;


-(IBAction)OnSyncBtnTapped:(id)sender;
@end



