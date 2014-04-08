//
//  GKImageCropViewController.h
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GKImageCropControllerDelegate;

@interface GKImageCropViewController : UIViewController{
    UIImage *_croppedImage;
}

@property (assign) CGPoint zoomOffset;
@property (assign) float zoomScale;
@property (assign) BOOL featured;
@property (assign) BOOL trashcanEnabled;
@property (assign) BOOL retakePhotoDisabled;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGSize cropSize; //size of the crop rect, default is 320x320
@property (nonatomic, strong) id<GKImageCropControllerDelegate> delegate;

@end


@protocol GKImageCropControllerDelegate <NSObject>
@required
- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage andZoomOffset:(CGPoint)zoomOffset zoomScale:(float)zoomScale andOriginal:(UIImage *)originalImage setFeatured:(BOOL)featured;
- (void)requestDeleteEditingImage;
@end