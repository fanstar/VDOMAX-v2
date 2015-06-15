//
//  TextViewController.m
//  tincam
//
//  Created by yut on 7/16/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "ImageFilterViewController.h"

#define ImageFilterPreviewWidth 50
#define ImageFilterPreviewHeight 50
#define ImageFilterPreviewWidth_p5 60
#define ImageFilterPreviewHeight_p5 60
#define ImageFilterTag 7000

@interface ImageFilterViewController ()

@end

@implementation ImageFilterViewController
@synthesize delegate;
@synthesize imageforcreateshape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FilterCreateList = [[ NSMutableArray alloc] init];
    
    if (IS_DEVICE_MODEL_5) {
        frameX = ImageFilterPreviewWidth_p5;
        frameY = ImageFilterPreviewHeight_p5;
        shiftitem = 5.0f;
        font_size = 9.0f;
    }else{
        frameX = ImageFilterPreviewWidth;
        frameY = ImageFilterPreviewHeight;
        shiftitem = 5.0f;
        font_size = 7.0f;
    }
    
    if(self.imageforcreateshape == nil)self.imageforcreateshape = [UIImage imageNamed:@"demo.jpg"];
    
    [self LoadShapeList];
    
    [self SetUpScrollview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUiscrollview:nil];
    FilterCreateList = nil;
    [super viewDidUnload];
}

-(void)LoadShapeList{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CropImage" ofType:@"plist"];
    NSDictionary *openDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"openDict%@",openDict);
    
    FilterList =[openDict objectForKey:@"IMAGE_FILTER_NAME"];
    
}

-(void)SetUpScrollview{
    self.uiscrollview.showsHorizontalScrollIndicator = NO;
    self.uiscrollview.showsVerticalScrollIndicator = NO;
    
    //float shift = 5.0f;
    
    self.uiscrollview.contentSize = CGSizeMake(frameX * [FilterList count]+(shiftitem*[FilterList count]+shiftitem), self.uiscrollview.frame.size.height);
    
    int index = 0;
    for (NSDictionary * filter in FilterList) {
        
        UIImage * imageshape = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[filter objectForKey:@"filtername"]]];
        //create image shape
        if (imageshape !=nil) {
            //create image shape
            
            
            UIImage * imagepreview;
            if (index ==0) { //default remove frame
                imagepreview = imageshape;
            }else{
                imagepreview = [self CreateImage:self.imageforcreateshape WithShapeImage:imageshape AtSize:CGSizeMake(frameX, frameY)];
            }
            
            
            if (imagepreview != nil) {
                CGRect  postRect = CGRectMake(frameX*index+(shiftitem*(1+index)), 0, frameX, frameY);
                UIImageView * filterimageview = [[UIImageView alloc] initWithFrame:postRect];
                filterimageview.image = imagepreview;
                filterimageview.contentMode = UIViewContentModeScaleAspectFit;
                filterimageview.tag = ImageFilterTag + index;
                
                CGRect lbEndFrame = CGRectMake(filterimageview.frame.origin.x, filterimageview.frame.origin.y + filterimageview.frame.size.height + shiftitem, filterimageview.frame.size.width, 11.0f);
                
                UILabel *lbName = [[UILabel alloc] initWithFrame:lbEndFrame];
                
//
                lbName.textColor = [UIColor whiteColor];
                lbName.textAlignment = NSTextAlignmentCenter;
//                NSLog(@"name : %@", [filter objectForKey:@"filtershortname"]);
                lbName.text = [filter objectForKey:@"filtershortname"];
//                [lbName setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
                [lbName setFont:[UIFont systemFontOfSize:font_size]];
//                lbName.text = @"Test";
                //[lbName setFont:[UIFont systemFontOfSize:10.0f]];
//                [lbName adjustsFontSizeToFitWidth];

//                lbName.text = @"Test";
                
                if (index <10) {
                    CGRect formrect = CGRectMake(self.view.frame.size.width, 0, filterimageview.frame.size.width, filterimageview.frame.size.height);
                    CGRect lbStartFrame = CGRectMake(self.view.frame.size.width, filterimageview.frame.origin.y + filterimageview.frame.size.height, filterimageview.frame.size.width, 11.0f);
                    
                    [self AnimationAddImageShape:filterimageview FromFrame:formrect ToFrame:postRect LabelName:lbName FromStartRect:lbStartFrame EndRect:lbEndFrame TimeDelay:0.1f];
                    //[self AnimationAddImageShape:filterimageview LabelName:lbName FromFrame:formrect ToFrame:postRect TimeDelay:index*0.1f];
                }else{
                    [self.uiscrollview addSubview:filterimageview];
                    [self.uiscrollview addSubview:lbName];
                }
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self              action:@selector(ImageFilterSelect:)];
                
                filterimageview.userInteractionEnabled = YES;
                [filterimageview addGestureRecognizer:tap];
                
                
                
                
                [FilterCreateList addObject:filterimageview];
            }

            
        }
        
//        [self performSelector:@selector(scheduleCalldelegatesaveName:) withObject:shapename afterDelay:5];
        
        index ++;
    }
}

-(void)scheduleCalldelegatesaveName:(NSString *) name{
    
    [self.delegate ImageFilterCallSaveViewSelectFilterIndex:count Name:name];
    count++;
}

-(void)ImageFilterSelect:(UITapGestureRecognizer *) gestureRecognizer{
    UIImageView * imageview = (UIImageView *)[gestureRecognizer view];
    //set new frame
    //[imageview setFrame:CGRectMake(0, 0, 320, 320)];
    
//    [self.delegate ImageShapeViewSelectShapeImage:[self CreateImageFromView:imageview]];
    
//    UIImage * imageFrame = nil;
//    if ((imageview.tag - ImageShapeTag) > 0) {
//        imageFrame = [self GenerateImageAddFrameAtShapeIndex:(imageview.tag - ImageShapeTag)];
//    }
    
    [self.delegate ImageFilterViewSelectFilterIndex:(int)(imageview.tag - ImageFilterTag)];
    
}

-(void)AnimationAddImageShape:(UIImageView *) imageview FromFrame:(CGRect ) fromframe ToFrame:(CGRect ) toframe LabelName:(UILabel *)lbname FromStartRect:(CGRect) startrect EndRect:(CGRect) endrect TimeDelay:(float ) timedelay{
    
    [imageview setFrame:fromframe];
    [lbname setFrame:startrect];
    [self.uiscrollview addSubview:imageview];
    [self.uiscrollview addSubview:lbname];

    [UIView animateWithDuration:0.2
                              delay:timedelay
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [imageview setFrame:toframe];
                             [lbname setFrame:endrect];
                             //[label setAlpha:0.0f];
                         }
                         completion:^(BOOL finished){
                             
                         }];
}

-(UIImage *)Image:(UIImage *) image AddFrameImage:(UIImage *) frameimage{
    
    CGRect imagerect = CGRectMake(0,0,image.size.width,image.size.height);
    
    float scalecal = 1;
    if (image.size.width > image.size.height) {//use scale width
        scalecal = image.size.width/frameimage.size.width;
    }else{
        scalecal = image.size.height/frameimage.size.height;
    }
    
    //resize frame
    UIImage * frameresize = [self ResizeImage:frameimage AspectFitNewSize:CGSizeMake(frameimage.size.width*scalecal, frameimage.size.height*scalecal)];
    
//    NSLog(@"frameresize:%@",NSStringFromCGSize(frameresize.size));
//    NSLog(@"image:%@",NSStringFromCGSize(image.size));
    
    // Create a context containing the image.
    UIGraphicsBeginImageContextWithOptions(imagerect.size, NO, 0.0);
    // CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CGContextClearRect(context, imageExtent);
    
    //draw image to context
    //[image drawAtPoint:CGPointMake(0,0)];
    [frameresize drawAtPoint:CGPointMake(0,0)]; //shift pixel

    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
}

-(UIImage *)CreateImage:(UIImage *) image WithShapeImage:(UIImage * ) shapeimage AtSize:(CGSize) shapesize{
    
    UIImage * frameimage = [self ResizeImage:shapeimage AspectFitNewSize:shapesize];
    
    //add white bg
    UIImageView * imv = [[UIImageView alloc] initWithImage:[image copy]];
    imv.contentMode = UIViewContentModeScaleAspectFit;
    imv.frame = CGRectMake(imv.frame.origin.x, imv.frame.origin.y, shapesize.width, shapesize.height);
    imv.backgroundColor = [UIColor whiteColor];
    UIImage * imgtmp = [self CreateImageFromView:imv];
    
    UIImage * img = [self Image:imgtmp AddFrameImage:frameimage];
    
    //UIImage * imagecrop = [[self Image:imgtmp CropWithShape:maskImage] copy];

    //UIImage * img = [self AddShadowImage:imagecrop];
    
    return img;
}

-(UIImage *)ResizeImage:(UIImage *)image NewSize:(CGSize )newsize{
    
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // Create a new image from current context
    UIImage * imageresize = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    return imageresize;
}

-(UIImage *)ResizeImage:(UIImage *)image AspectFitNewSize:(CGSize )newsize{
    float ratio;
    float maxscale = newsize.width>newsize.height?newsize.width:newsize.height;
    if (image.size.width > image.size.height) {
        ratio = (float)(image.size.width)/maxscale;
    }else{
        ratio = (float)(image.size.height)/maxscale;
    }
    return [self ResizeImage:image NewSize:CGSizeMake(image.size.width/ratio, image.size.height/ratio)];
}


-(UIImage *)Image:(UIImage *) image CropWithShape:(UIImage *) maskshape{
    
    CGRect imagerect = CGRectMake(0,0,image.size.width,image.size.height);
    
    // Create a context containing the image.
    UIGraphicsBeginImageContextWithOptions(imagerect.size, NO, 0.0);
    // CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CGContextClearRect(context, imageExtent);
    
    //draw image to context
    [image drawAtPoint:CGPointMake(0,0)];
    
    //CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //crop Image
    [maskshape drawInRect:imagerect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
}


-(UIImage *)AddShadowImage:(UIImage *) image{
    
    CGRect imagerect = CGRectMake(0,0,image.size.width,image.size.height);
    
    // Create a context containing the image.
    UIGraphicsBeginImageContextWithOptions(imagerect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -imagerect.size.height);
    
    // CGContextClearRect(context, imageExtent);
    
    CGSize  sizeshadow = CGSizeMake(5, 5);
    
    CGContextSetShadow(context, sizeshadow, 10.0f);
    //CGContextSetShadowWithColor(context, sizeshadow, 10.0f , [UIColor blackColor].CGColor);
    CGContextDrawImage(context, imagerect, image.CGImage);
    
    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
}


-(UIImage *)CreateImageFromView:(UIView *)uiview{
    UIImage * image;
    
    
    UIGraphicsBeginImageContextWithOptions(uiview.bounds.size, NO, 0.0);
    
    [[uiview layer] renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}



-(UIImage *)GenerateImageAddFrameAtShapeIndex:(int) index{
    
    NSString * shapename = [FilterList objectAtIndex:index];
        
        UIImage * imageframe = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",shapename]];
        //create image shape
        if (imageframe !=nil) return [self Image:self.imageforcreateshape AddFrameImage:imageframe];
        else return nil;
}




@end
