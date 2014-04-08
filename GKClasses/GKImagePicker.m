//
//  GKImagePicker.m
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import "GKImagePicker.h"
#import "GKImageCropViewController.h"
#import "ImageUtils.h"

@interface GKImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, GKImageCropControllerDelegate>
@property (nonatomic, strong, readwrite) UIImagePickerController *imagePickerController;
- (void)_hideController;
@end

@implementation GKImagePicker

#pragma mark -
#pragma mark Getter/Setter

@synthesize cropSize, delegate;
@synthesize imagePickerController = _imagePickerController;


#pragma mark -
#pragma mark Init Methods

- (id)init{
    if (self = [super init]) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;;
    }
    return self;
}

# pragma mark -
# pragma mark Private Methods

- (void)_hideController{
    
    if (![_imagePickerController.presentedViewController isKindOfClass:[UIPopoverController class]]){
        
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

#pragma mark -
#pragma mark UIImagePickerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if ([self.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
		
        [self.delegate imagePickerDidCancel:self];
        
    } else {
        
        [self _hideController];
		
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
    self.cropController = [[GKImageCropViewController alloc] init];
    self.cropController.contentSizeForViewInPopover = picker.contentSizeForViewInPopover;
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.cropController.sourceImage = [ImageUtils resizedImageForUpload:chosenImage];
    
    self.cropController.cropSize = self.cropSize;
    self.cropController.delegate = self;
    [picker pushViewController:self.cropController animated:YES];
    
}

#pragma mark -
#pragma GKImagePickerDelegate

- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage andZoomOffset:(CGPoint)zoomOffset zoomScale:(float)zoomScale andOriginal:(UIImage *)originalImage setFeatured:(BOOL)featured
{
    if ([self.delegate respondsToSelector:@selector(imagePicker:pickedImage:andZoomOffset:zoomScale:andOriginal:)]) {
        [self.delegate imagePicker:self pickedImage:croppedImage andZoomOffset:zoomOffset zoomScale:zoomScale andOriginal:originalImage];
    }
}

-(void)requestDeleteEditingImage
{
    NSLog(@"NOT NEEDED");
}

@end
