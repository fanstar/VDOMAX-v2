//
//  CollectionViewCell.m
//  FlowLayoutNoNIB
//
//  Created by Beau G. Bolle on 2012.10.29.
//
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, floor((CGRectGetHeight(self.bounds)-30)/2), CGRectGetWidth(self.bounds), 30)];
//		[label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
//		[label setTag:123];
//		[label setBackgroundColor:[UIColor greenColor]];
//		[label setTextAlignment:NSTextAlignmentCenter];
//		[self addSubview:label];
        
        [self setupView];
	}
	return self;
}


-(void)setupView{
    
    float shiftCell = 5.0f;
    float imagewidth = 50.0f;
    float lbHeight = 20.0f;
    float fontNameSize =11.0f;
    
    _imvProfile = [[UIImageView alloc]initWithFrame:CGRectMake(shiftCell, shiftCell, imagewidth, imagewidth)];
    _imvProfile.contentMode = UIViewContentModeScaleAspectFit;
    _imvProfile.image =  [self ResizeCropSquireImage:[UIImage imageNamed:@"01-splash.png"]];
    _imvProfile.layer.cornerRadius = _imvProfile.frame.size.width/2.0f;
    _imvProfile.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    _imvProfile.layer.borderWidth = 0.5f;
    _imvProfile.layer.masksToBounds = YES;
   
    [self addSubview:_imvProfile];
    
    
    float offsetXlabel =_imvProfile.frame.origin.x+_imvProfile.frame.size.width + shiftCell;
    _lbName = [[UILabel alloc]initWithFrame:CGRectMake(offsetXlabel, shiftCell, self.frame.size.width - (offsetXlabel+shiftCell),lbHeight)];
    _lbName.numberOfLines=2;
    _lbName.lineBreakMode=NSLineBreakByTruncatingTail;
    _lbName.backgroundColor=[UIColor clearColor];
    _lbName.font = [UIFont boldSystemFontOfSize:fontNameSize];
    
    
    [self addSubview:_lbName];
    
    
    _imvThumb = [[UIImageView alloc]initWithFrame:CGRectMake(shiftCell, _imvProfile.frame.origin.y+_imvProfile.frame.size.height+shiftCell, self.frame.size.width, self.frame.size.height-imagewidth)];
    _imvThumb.contentMode = UIViewContentModeScaleAspectFit;
    
//    _imvThumb.backgroundColor = [UIColor whiteColor];
    [self addSubview:_imvThumb];
    
    _imvPlayLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _imvPlayLogo.image = [self ResizeImage:[UIImage imageNamed:@"playlogo.png"] AspectFitNewSize:CGSizeMake(30, 30)];
    _imvPlayLogo.center = CGPointMake(_imvThumb.frame.origin.x+_imvThumb.frame.size.width/2.0f, _imvThumb.frame.origin.y+_imvThumb.frame.size.height*0.5f);
    [self addSubview:_imvPlayLogo];
    
    
    //add GestureTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageThumb)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    _imvThumb.userInteractionEnabled = YES;
    [_imvThumb addGestureRecognizer:tap];
    
    _btFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btFollow setTitle:@"   Follow" forState:UIControlStateNormal];
    [_btFollow addTarget:self action:@selector(buttonFollowSelect:) forControlEvents:UIControlEventTouchUpInside];
    _btFollow.frame = CGRectMake(offsetXlabel, _lbName.frame.origin.y+_lbName.frame.size.height, 65, 20);
    [_btFollow setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btFollow setBackgroundImage:[UIImage imageNamed:@"follow-button-bg.png"] forState:UIControlStateNormal];
    [_btFollow setFont:[UIFont systemFontOfSize:10.0f]];
    [self addSubview:_btFollow];
    
    UIImageView * imvPlus = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 6, 6)];
    imvPlus.contentMode = UIViewContentModeScaleAspectFit;
    imvPlus.image = [UIImage imageNamed:@"follow-icon.png"];
    
    [_btFollow addSubview:imvPlus];
    

    _imvStatus = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-25, _btFollow.frame.origin.y, 20, 20)];
    _imvStatus.contentMode = UIViewContentModeScaleAspectFit;
    _imvStatus.image = [UIImage imageNamed:@"online-icon.png"];
    [self addSubview:_imvStatus];
    
}

-(void)SetVideoOnLineState:(BOOL ) stateon{
    if (stateon) {
        _imvStatus.image = [UIImage imageNamed:@"online-icon.png"];
    }else{
        _imvStatus.image = [UIImage imageNamed:@"offline-icon.png"];
    }
}

-(void)CellSetUpdataForDataDict:(NSDictionary *)dict{
    
    _datadict = dict;
    
    NSString * name = [dict objectForKey:@"name"];
    NSString * urlImageProfile = [dict objectForKey:@"avatar_url"];
//    NSString * urlthumb = [dict objectForKey:@"thumbnail_url"];
    NSString * urlthumb = [dict objectForKey:@"live_cover"];
    if (urlthumb == nil || [urlthumb isEqualToString:@""]) {
        urlthumb = [dict objectForKey:@"live_cover_offline"];
    }
//    NSString * thumb = [dict objectForKey:@"thumb"];
//    NSString * url = [dict objectForKey:@"url"];
//    NSString * date = [dict objectForKey:@"date"];
    NSDictionary * durDict = [dict objectForKey:@"duration"];
    
    NSString * time = [NSString stringWithFormat:@"%@:%@:%@",[durDict objectForKey:@"hours"],[durDict objectForKey:@"minutes"],[durDict objectForKey:@"seconds"]];
    
//    _lbName.text = @"name lastname";
//    _imvProfile.image = [UIImage imageNamed:@"icon1.png"];
//    _imvThumb.image = [UIImage imageNamed:@"icon1.png"];
//    _imvStatus.image = [UIImage imageNamed:@"icon1.png"];
    
    [_imvProfile sd_setImageWithURL:[NSURL URLWithString:urlImageProfile] placeholderImage:[UIImage imageNamed:@"01-splash.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self updateImageViewWithImage:image];
        
    }];
    
    _lbName.text = name;
    [_lbName sizeToFit];
    [_imvThumb sd_setImageWithURL:[NSURL URLWithString:urlthumb] placeholderImage:nil];
    
    //update
    _btFollow.frame = CGRectMake(_imvProfile.frame.origin.x+_imvProfile.frame.size.width + 5.0f, _lbName.frame.origin.y+_lbName.frame.size.height, 65, 20);
    _imvStatus.frame = CGRectMake(self.frame.size.width-25, _btFollow.frame.origin.y, 20, 20);
}

-(void)buttonFollowSelect:(id) sender{
    
    
    
}


-(void)didSelectImageThumb{
    if (self.delegate) {
        [self.delegate ChannelDidSelectCellThumbWithData:_datadict];
    }
}


#pragma mark - self method
-(void)updateImageViewWithImage:(UIImage *) image{
    
    
    UIImage * imagecrop = [self ResizeCropSquireImage:image];
    _imvProfile.image = imagecrop;
    
}

-(UIImage *)ResizeCropSquireImage:(UIImage *)image{
    
    float minLenght =0;
    float diftX = 0;
    float diftY = 0;
    
    if (image.size.width > image.size.height) {
        minLenght = image.size.height;
        diftX = image.size.width - image.size.height;
    }else{
        minLenght = image.size.width;
        diftY = image.size.height - image.size.width;
    }
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(minLenght, minLenght), NO, 0.0);
    
    //    [image drawInRect:CGRectMake(0 - (diftX/2.0f), 0 - (diftY/2.0f), minLenght, minLenght)];
    [image drawAtPoint:CGPointMake(0 - (diftX/2.0f), 0 - (diftY/2.0f))];
    
    // Create a new image from current context
    UIImage * imageresize = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    return imageresize;
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


@end
