
#import "GKImageCropViewController.h"
#import "GKImageCropView.h"

#import "Keys.h"

@interface GKImageCropViewController ()

@property (nonatomic, strong) GKImageCropView *imageCropView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *useButton;

@property (nonatomic, strong) UIButton *makeFeaturedButton;
@property (nonatomic, strong) UIButton *trashCanBtn;

- (void)_actionCancel;
- (void)_actionUse;
- (void)_setupCropView;

@end

@implementation GKImageCropViewController

#pragma mark -
#pragma mark Getter/Setter

@synthesize sourceImage, cropSize, delegate;
@synthesize imageCropView;
@synthesize toolbar;
@synthesize cancelButton, useButton;

#pragma mark -
#pragma Private Methods


- (void)_actionCancel{
    if (self.retakePhotoDisabled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_actionUse{
    _croppedImage = [self.imageCropView croppedImage];
    CGPoint offset = [self.imageCropView croppedImageZoomOffset];
    [self.delegate imageCropController:self didFinishWithCroppedImage:_croppedImage andZoomOffset:offset zoomScale:self.imageCropView.scrollView.zoomScale andOriginal:self.imageCropView.imageToCrop setFeatured:_featured];
}

-(void)trashPhoto
{
    [self.delegate requestDeleteEditingImage];
}

- (void)_setupCropView{
    
    self.imageCropView = [[GKImageCropView alloc] initWithFrame:self.view.bounds];
    [self.imageCropView setImageToCrop:sourceImage];
    [self.imageCropView setCropSize:cropSize];
    [self.imageCropView setZoomOffset:self.zoomOffset];
    [self.imageCropView setZoomScale:self.zoomScale];
    [self.view addSubview:self.imageCropView];
}

- (void)_setupCancelButton{
    

    
    UIImage *buttonImage;
    if (self.retakePhotoDisabled) {
        buttonImage = [UIImage imageNamed:@"Button_Close"];
    } else {
        buttonImage = [UIImage imageNamed:@"Button_Camera"];
    }
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:buttonImage forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(-15, 0, buttonImage.size.width, buttonImage.size.height)];
    [self.cancelButton  addTarget:self action:@selector(_actionCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_setupUseButton{

    
    UIImage *buttonImage = [UIImage imageNamed:@"Button_Made-One_Done"];
    
    self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.useButton setImage:buttonImage forState:UIControlStateNormal];
    [self.useButton setFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [self.useButton  addTarget:self action:@selector(_actionUse) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_setupToolbar{
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];

    [self.toolbar setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:243.0/255.0 alpha:1.0]];

    [self.view addSubview:self.toolbar];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];

    negativeSpacer.width = -15;

    
    [self _setupCancelButton];
    [self _setupUseButton];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
    info.text = @"Scale and Crop";
    info.textColor = [UIColor colorWithRed:0.173 green:0.173 blue:0.173 alpha:1];
    info.backgroundColor = [UIColor clearColor];
    info.shadowColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.839 alpha:1];
    info.shadowOffset = CGSizeMake(0, 1);
    info.font = fontAntenaBold(16);
    [info sizeToFit];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *lbl = [[UIBarButtonItem alloc] initWithCustomView:info];
    UIBarButtonItem *use = [[UIBarButtonItem alloc] initWithCustomView:self.useButton];
    [self.toolbar setItems:[NSArray arrayWithObjects:negativeSpacer, cancel, flex, lbl, flex, use, negativeSpacer, nil]];
}

#pragma mark -
#pragma Super Class Methods

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"GKIchoosePhoto", @"");
	
    [self _setupCropView];
    [self _setupToolbar];
    
    self.trashCanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trashCanBtn setImage:[UIImage imageNamed:@"trash-can"] forState:UIControlStateNormal];
    [self.trashCanBtn setFrame:CGRectMake(270, [[UIScreen mainScreen] bounds].size.height - 50, 40, 40)];
    [self.trashCanBtn addTarget:self action:@selector(trashPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trashCanBtn];
    [self.trashCanBtn setEnabled:_trashcanEnabled];
    if (_featured) {
        UIImage *featuredButtonImage = [UIImage imageNamed:@"featured_button_icon"];
        UIImageView *featuredBtnIcon = [[UIImageView alloc] initWithImage:featuredButtonImage];
        [featuredBtnIcon setFrame:CGRectMake((320 - 142)/2,[[UIScreen mainScreen] bounds].size.height - 40,142,22)];
        [self.view addSubview:featuredBtnIcon];
    } else if (!self.featured && self.retakePhotoDisabled) {
        UIImage *makefeaturedButtonImage = [UIImage imageNamed:@"featured_button_icon_make"];
        self.makeFeaturedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.makeFeaturedButton setBackgroundImage:makefeaturedButtonImage forState:UIControlStateNormal];
        [self.makeFeaturedButton setFrame:CGRectMake((320 - 142)/2,[[UIScreen mainScreen] bounds].size.height - 40,142,22)];
        [self.makeFeaturedButton addTarget:self action:@selector(makeFeaturedPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.makeFeaturedButton];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)makeFeaturedPressed
{
    if (!_featured) {
        _featured = YES;
        
        [self.makeFeaturedButton setBackgroundImage:[UIImage imageNamed:@"featured_button_icon"] forState:UIControlStateNormal];
        [self.makeFeaturedButton setUserInteractionEnabled:NO];
        [self.trashCanBtn setEnabled:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.imageCropView.frame = self.view.bounds;
    self.toolbar.frame = CGRectMake(0, 0, 320, 44);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
