//
//  ViewController.m
//  RestSoapWebServices
//
//  Created by Cesar TR on 10/31/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import "RSUsersTableViewController.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "RSUsersTableViewCell.h"
#import "RSUserDetailViewController.h"
#import "User.h"

@interface RSUsersTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation RSUsersTableViewController

@synthesize dateFormatter;
@synthesize managedObjectContext;



-(IBAction)OnSyncBtnTapped:(id)sender {
    [[SDSyncEngine sharedEngine] startSync];
}


- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]]];
        self.UserDataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LifeCycleEvents

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
   [self loadRecordsFromCoreData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
    [self loadRecordsFromCoreData];
    [self.tableView reloadData];
}];
    
}

//End LifeCycle Events

#pragma mark  - TableSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//Context Action
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *date = [self.UserDataArray objectAtIndex:indexPath.row];
        [self.managedObjectContext performBlockAndWait:^{
            [self.managedObjectContext deleteObject:date];
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                NSLog(@"Error saving main context: %@", error);
            }
            
            [[SDCoreDataController sharedInstance] saveMasterContext];
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.UserDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSUsersTableViewCell *cell = nil;
    
    if ([self.entityName isEqualToString:@"User"]) {
        static NSString *CellIdentifier = @"UserCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[RSUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        User *user = [self.UserDataArray objectAtIndex:indexPath.row];
        cell.Usernamelbl.text = user.username;
//        cell.dateLabel.text = [self.dateFormatter stringFromDate:holiday.date];
//        if (holiday.image != nil) {
//            UIImage *image = [UIImage imageWithData:holiday.image];
//            cell.imageView.image = image;
//        } else {
//            cell.imageView.image = nil;
//        }
    }
//    else { // Birthday
//        static NSString *CellIdentifier = @"BirthdayCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//        Birthday *birthday = [self.dates objectAtIndex:indexPath.row];
//        cell.nameLabel.text = birthday.name;
//        cell.dateLabel.text = [self.dateFormatter stringFromDate:birthday.date];
//        if (birthday.image != nil) {
//            UIImage *image = [UIImage imageWithData:birthday.image];
//            cell.imageView.image = image;
//        } else {
//            cell.imageView.image = nil;
//        }
//    }
    
    
    return cell;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ShowDateDetailViewSegue"]) {
//        SDDateDetailViewController *dateDetailViewController = segue.destinationViewController;
//        SDTableViewCell *cell = (SDTableViewCell *)sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        Holiday *holiday = [self.dates objectAtIndex:indexPath.row];
//        dateDetailViewController.managedObjectId = holiday.objectID;
//
//    } else if ([segue.identifier isEqualToString:@"ShowAddDateViewSegue"]) {
//        SDAddDateViewController *addDateViewController = segue.destinationViewController;
//        [addDateViewController setAddDateCompletionBlock:^{
//            [self loadRecordsFromCoreData];
//            [self.tableView reloadData];
//        }];
//
//    }
//}

#pragma sege Details
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"UserDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"UserDetailSegue"])
    {
         RSUserDetailViewController *dateDetailViewController = segue.destinationViewController;
        RSUsersTableViewCell *cell = (RSUsersTableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        User *user = [self.UserDataArray objectAtIndex:indexPath.row];
        dateDetailViewController.managedObjectId = user.objectID;
    }
}

@end
