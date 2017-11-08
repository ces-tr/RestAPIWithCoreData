//
//  based on ColorTrackingCamera.m
//  from ColorTracking application
//  The source code for this application is available under a BSD license.
//  See ColorTrackingLicense.txt for details.
//  Created by Brad Larson on 10/7/2010.
//  Modified by Anton Malyshev on 6/21/2013.
//


#import <UIKit/UIKit.h>
#import "RecognitionCamera.h"
#import "RecognitionViewController.h"

@implementation RecognitionCamera

#pragma mark -
#pragma mark Initialization and teardown

- (id)init; 
{
	if (!(self = [super init]))
		return nil;
	
	// Grab the front-facing camera
	AVCaptureDevice * camera = nil;
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                          mediaType:AVMediaTypeVideo
                                                                         position:AVCaptureDevicePositionFront];
    NSArray *devices = [captureDeviceDiscoverySession devices];
	
	for (AVCaptureDevice *device in devices) {
		if ([device position] == AVCaptureDevicePositionFront) {
			camera = device;
		}
	}
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
     {
         if (granted == true)
         {
             //[self presentViewController           : picker animated:YES completion:NULL];
             //Do your stuff
             
         }
         else
         {
             UIAlertView *cameraAlert = [[UIAlertView alloc]initWithTitle:@"STR_APPLICATION_TITLE"
                                                                  message:@"STR_ALERT_CAMERA_DENIED_MESSAGE"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil,nil];
             [cameraAlert show];
             
             NSLog(@"denied");
         }
         
     }];
    
	
	// Create the capture session
	captureSession = [[AVCaptureSession alloc] init];
	
	// Add the video input	
	NSError *error = nil;
	videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error] ;
	if ([captureSession canAddInput:videoInput]) {
		[captureSession addInput:videoInput];
	}
	
	[self videoPreviewLayer];
    
    
    
    capturePhotoOutput= [[AVCapturePhotoOutput alloc] init];
    
    if ([captureSession canAddOutput:capturePhotoOutput]) {
        [captureSession addOutput :capturePhotoOutput ];
    }
	// Add the video frame output	
//    videoOutput = [[AVCaptureVideoDataOutput alloc] init];
//    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
	// Use RGB frames instead of YUV to ease color processing
    
//    [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    //NOT SUPPORTED:
    //[videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32RGBA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
	//dispatch_queue_t videoQueue = dispatch_queue_create("com.sunsetlakesoftware.colortracking.videoqueue", NULL);
    //[videoOutput setSampleBufferDelegate:self queue:videoQueue];
    
    //addOutput
//    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
//
//    if ([captureSession canAddOutput:videoOutput]) {
//        [captureSession addOutput:videoOutput];
//
//    }
//else {
//#if defined(DEBUG)
//        NSLog(@"Couldn't add video output");
//#endif
//    }

    // Start capturing
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType isEqualToString:@"iPhone"]
        && [camera supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
        
        [captureSession setSessionPreset:AVCaptureSessionPresetiFrame960x540];
        _width = 960;
        _height = 540;
    } else {
        _width = 640;
        _height = 480;
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    //DEBUG
    //[captureSession setSessionPreset:AVCaptureSessionPreset352x288];
    //[captureSession setSessionPreset:AVCaptureSessionPreset352x288];
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [captureSession addOutput:metadataOutput];
    NSArray *typeList = metadataOutput.availableMetadataObjectTypes;
    NSLog(@"availableMetadataObjectTypes : %@", typeList);
    // We're only interested in faces
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    // This VC is the delegate. Please call us on the main queue
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    
    if (![captureSession isRunning]) {
		[captureSession startRunning];
	};
	
	return self;
}

- (void)dealloc 
{
	[captureSession stopRunning];
//    [captureSession release];
//    [videoPreviewLayer release];
//    [videoOutput release];
//    [videoInput release];
//    [super dealloc];
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	[self.delegate processNewCameraFrame:pixelBuffer];
}

#pragma mark -
#pragma mark Accessors

@synthesize delegate;
@synthesize videoPreviewLayer;

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer;
{
	if (videoPreviewLayer == nil) {
		videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
        
        //isOrientationSupported & setOrientation are deprecated in iOS 6
        //if ([videoPreviewLayer isOrientationSupported]) {
        //    [videoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        //}
        
        [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	}
	return videoPreviewLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate methods
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *metadataObject in metadataObjects) {
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeFace]) {
            // Take an image of the face and pass to CoreImage for detection
//            AVCaptureConnection *stillConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//            [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//                if(error) {
//                    NSLog(@"There was a problem");
//                    return;
//                }
//
//                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
//                UIImage *smileyImage = [UIImage imageWithData:jpegData];
//                _previewLayer.hidden = YES;
//                [_session stopRunning];
//                self.imageView.hidden = NO;
//                self.imageView.image = smileyImage;
//                self.activityView.hidden = NO;
//                self.statusLabel.text = @"Processing";
//                self.statusLabel.hidden = NO;
                
//                CIImage *image = [CIImage imageWithData:jpegData];
////                [self imageContainsSmiles:image callback:^(BOOL happyFace) {
////                    if(happyFace) {
////                        self.statusLabel.text = @"Happy Face Found!";
////                    } else {
////                        self.statusLabel.text = @"Not a good photo...";
////                    }
////                    self.activityView.hidden = YES;
////                    self.retakeButton.hidden = NO;
////                }];
//            }];
            AVCapturePhotoSettings *capturephotoSettings= [AVCapturePhotoSettings photoSettings];
             [capturePhotoOutput capturePhotoWithSettings:capturephotoSettings delegate:self];
            NSLog(@"Foto taken %s",":D");
//            capturePhotoOutput.capturePhoto(with: settings, delegate: self)
            
            
        }
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{
    if (error) {
        NSLog(@"error : %@", error.localizedDescription);
    }
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(photoSampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    RecognitionViewController *recogViewController= [RecognitionViewController alloc];
//    [recogViewController processNewCameraFrame];
    
    
//    if (photoSampleBuffer) {
//        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
//            UIImage *image = [UIImage imageWithData:data];
//    }
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    NSLog(@"w: %zu h: %zu bytesPerRow:%zu", width, height, bytesPerRow);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little
                                                 | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage
                                         scale:1.0f
                                   orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}


@end
