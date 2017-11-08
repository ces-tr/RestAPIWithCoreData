//
//  RSUserDetailViewController.m
//  RestSoapWebServices
//
//  Created by Cesar TR on 11/5/17.
//  Copyright © 2017 Cesar TR. All rights reserved.
//

#import "RSUserDetailViewController.h"
#import "User.h"
#import "RecognitionCamera.h"
#import "RecognitionViewController.h"
#import "UIImageUtils.h"
#import "ParseJson.h"

@interface RSUserDetailViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) RecognitionCamera *camera;
@property (strong, nonatomic) RecognitionViewController<RecognitionCameraDelegate> * recogViewController;

@end

@implementation RSUserDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _context = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.managedObject = [_context objectWithID:self.managedObjectId];
    
    self.title = [self.managedObject valueForKey:@"username"];
//    self.imageView.image = [UIImage imageWithData:[self.managedObject valueForKey:@"image"]];
    if ([self.managedObject isKindOfClass:[User class]]) {
//        self.dateType = SDDateHoliday;
    } else {
//        self.dateType = SDDateBirthday;
    }
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
//    _camera = [[RecognitionCamera alloc] init];
//
//    _camera.delegate = _recogViewController; //we want to receive processNewCameraFrame messages
//    _camera.videoPreviewLayer.frame =CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);;
//    [self.view.layer addSublayer: _camera.videoPreviewLayer];
     _recogViewController= [RecognitionViewController alloc];
    
//    SEL aSelector = NSSelectorFromString(@"processNewCameraFrame:");
//        if([self.recogViewController respondsToSelector:aSelector]){
//
//    }
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self retrieveHomeDirectoryPath], "resources/foto.jpg"];
//    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"resources/foto.jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/resources/foto.jpg",[self applicationDocumentsDirectory]]];
//UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Foto.jpg" ofType:@"jpg"]];
    
    
//    CVImageBufferRef
    if([self.recogViewController activateLicense]){
        UIImage* myImage=[UIImage imageNamed:@"Foto.jpg"];
        CGImageRef imageRef=[myImage CGImage];
        CVImageBufferRef pixelBuffer = [UIImageUtils pixelBufferFromImage:imageRef];
//        [self.recogViewController processNewCameraFrame:pixelBuffer];
    }
    
    ParseJson *parseJson= [[ParseJson alloc] init];
    [parseJson requestJSOnObject];
    
}
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end
