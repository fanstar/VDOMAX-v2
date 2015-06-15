//
//  VideoTableViewCell.m
//  VDOMAX
//
//  Created by fanstar on 1/21/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithSize:(CGSize ) size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // CGFloat height = [self heightContentBackgroundView:commentModel.content];
       
        [self setupViewWithSize:size];
    }
    return self;
}


-(void)setupViewWithSize:(CGSize) size{
    
     self.backgroundColor = [UIColor clearColor];
//    float tt = self.frame.size.height;
    
    float shifx = 5.0f;
    float minshifx = 2.0f;
    float thumbWidth = size.width * 0.4f;
    float imagewidth = 50.0f;
    float lbHeight = 20.0f;
    float itemHeight = 15.0f;
    float lbItemWith = 25.0f;
    float lbSmallSize = 10.0f;
    float lbNameSize = 12.0f;
    float lbDescSize = 10.0f;
    
    _imvThumb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, thumbWidth, size.height - shifx)];
    _imvThumb.contentMode = UIViewContentModeScaleToFill;
//    _imvThumb.image = [UIImage imageNamed:@"photo1.jpg"];
    [self addSubview:_imvThumb];
    
    //add GestureTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageThum)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    _imvThumb.userInteractionEnabled = YES;
    [_imvThumb addGestureRecognizer:tap];
    
    _imvPlayLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _imvPlayLogo.image = [self ResizeImage:[UIImage imageNamed:@"playlogo.png"] AspectFitNewSize:CGSizeMake(30, 30)];
    //    _imvPlayLogo.hidden = YES;
    _imvPlayLogo.center = CGPointMake(_imvThumb.frame.origin.x+_imvThumb.frame.size.width/2.0f, _imvThumb.frame.origin.y+_imvThumb.frame.size.height*0.5f+shifx);
    [self addSubview:_imvPlayLogo];
    
    
    _imvProfile = [[UIImageView alloc]initWithFrame:CGRectMake(_imvThumb.frame.origin.x+_imvThumb.frame.size.width+shifx, 0, imagewidth, imagewidth)];
    _imvProfile.contentMode = UIViewContentModeScaleAspectFit;
    _imvProfile.layer.cornerRadius = _imvProfile.frame.size.width/2.0f;
    _imvProfile.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
    _imvProfile.layer.borderWidth = 0.3f;
    _imvProfile.layer.masksToBounds = YES;
    [self addSubview:_imvProfile];
    
    //Label Name Post
    float offsetlbX = _imvProfile.frame.origin.x+imagewidth+shifx;
    _lbNamePost=[[UILabel alloc]initWithFrame:CGRectMake(offsetlbX, 0, size.width-offsetlbX, lbHeight)];
    _lbNamePost.numberOfLines=1;
    _lbNamePost.lineBreakMode=NSLineBreakByTruncatingTail;
    _lbNamePost.backgroundColor=[UIColor clearColor];
    _lbNamePost.text = @"name lastname";
    _lbNamePost.font = [UIFont boldSystemFontOfSize:lbNameSize];
    [self addSubview:_lbNamePost];
    
    _imvLiveStatus = [[UIImageView alloc]initWithFrame:CGRectMake(size.width - 15, 0, 15, 15)];
    _imvLiveStatus.contentMode = UIViewContentModeScaleAspectFit;
    _imvLiveStatus.image = [UIImage imageNamed:@"online-icon.png"];
    [self addSubview:_imvLiveStatus];
    
    _lbDescPost=[[UILabel alloc]initWithFrame:CGRectMake(_imvProfile.frame.origin.x, imagewidth+shifx, size.width-(thumbWidth+shifx), lbHeight)];
    _lbDescPost.numberOfLines=1;
    _lbDescPost.lineBreakMode=NSLineBreakByCharWrapping;
    _lbDescPost.backgroundColor=[UIColor clearColor];
    _lbDescPost.text = @"";//@"New Single - Epic [Official MV - HD]";
    _lbDescPost.font = [UIFont systemFontOfSize:lbDescSize];
    [self addSubview:_lbDescPost];
    
    //
    _lbLoveCount=[[UILabel alloc]initWithFrame:CGRectMake(thumbWidth+shifx, size.height - (itemHeight+shifx), lbItemWith, itemHeight)];
    _lbLoveCount.numberOfLines=1;
    _lbLoveCount.lineBreakMode=NSLineBreakByTruncatingTail;
//    _lbLoveCount.backgroundColor=[UIColor yellowColor];
    _lbLoveCount.textAlignment = NSTextAlignmentRight;
    _lbLoveCount.text = @"";
    _lbLoveCount.font = [UIFont systemFontOfSize:lbSmallSize];
    _lbLoveCount.minimumFontSize = 8.0f;
    _lbLoveCount.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lbLoveCount];
    
    _lbCommentCount=[[UILabel alloc]initWithFrame:CGRectMake(_lbLoveCount.frame.origin.x+_lbLoveCount.frame.size.width+itemHeight, _lbLoveCount.frame.origin.y, lbItemWith, itemHeight)];
    _lbCommentCount.numberOfLines=1;
    _lbCommentCount.lineBreakMode=NSLineBreakByTruncatingTail;
//    _lbCommentCount.backgroundColor=[UIColor greenColor];
    _lbCommentCount.textAlignment = NSTextAlignmentRight;
    _lbCommentCount.text = @"";
    _lbCommentCount.font = [UIFont systemFontOfSize:lbSmallSize];
    _lbCommentCount.minimumFontSize = 8.0f;
    _lbCommentCount.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lbCommentCount];
    
    _lbShareCount=[[UILabel alloc]initWithFrame:CGRectMake(_lbCommentCount.frame.origin.x+_lbCommentCount.frame.size.width+itemHeight, _lbCommentCount.frame.origin.y, lbItemWith, itemHeight)];
    _lbShareCount.numberOfLines=1;
    _lbShareCount.lineBreakMode=NSLineBreakByTruncatingTail;
//    _lbShareCount.backgroundColor=[UIColor redColor];
    _lbShareCount.textAlignment = NSTextAlignmentRight;
    _lbShareCount.text = @"";
    _lbShareCount.font = [UIFont systemFontOfSize:lbSmallSize];
    _lbShareCount.minimumFontSize = 8.0f;
    _lbShareCount.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lbShareCount];

    
    
    //
    _imvLoveTop = [[UIImageView alloc]initWithFrame:CGRectMake(_lbLoveCount.frame.origin.x+_lbLoveCount.frame.size.width+minshifx, _lbLoveCount.frame.origin.y, itemHeight, itemHeight)];
    _imvLoveTop.contentMode = UIViewContentModeScaleAspectFit;
    _imvLoveTop.image = [UIImage imageNamed:@"love-icon-grey.png"];
    [self addSubview:_imvLoveTop];
    
    _imvComment = [[UIImageView alloc]initWithFrame:CGRectMake(_lbCommentCount.frame.origin.x+_lbCommentCount.frame.size.width+minshifx, _lbCommentCount.frame.origin.y, itemHeight, itemHeight)];
    _imvComment.contentMode = UIViewContentModeScaleAspectFit;
    _imvComment.image = [UIImage imageNamed:@"comment-icon-grey.png"];
    [self addSubview:_imvComment];
    
    _imvShare = [[UIImageView alloc]initWithFrame:CGRectMake(_lbShareCount.frame.origin.x+_lbShareCount.frame.size.width+minshifx, _lbShareCount.frame.origin.y, itemHeight, itemHeight)];
    _imvShare.contentMode = UIViewContentModeScaleAspectFit;
    _imvShare.image = [UIImage imageNamed:@"share-icon-grey.png"];
    [self addSubview:_imvShare];
    

    _lbViewCount=[[UILabel alloc]initWithFrame:CGRectMake(size.width-2*lbItemWith, _imvShare.frame.origin.y, 2*lbItemWith, itemHeight)];
    _lbViewCount.numberOfLines=1;
    _lbViewCount.lineBreakMode=NSLineBreakByTruncatingTail;
//    _lbViewCount.backgroundColor=[UIColor clearColor];
    _lbViewCount.textAlignment = NSTextAlignmentLeft;
    _lbViewCount.text = @"";
    _lbViewCount.font = [UIFont systemFontOfSize:lbSmallSize];
    _lbViewCount.minimumFontSize = 8.0f;
    _lbViewCount.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lbViewCount];

    
    
    _btFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    _btFollow.frame = CGRectMake(_lbNamePost.frame.origin.x, _lbNamePost.frame.origin.y+_lbNamePost.frame.size.height, 100, 30);
    [_btFollow setTitle:@"    Follow" forState:UIControlStateNormal];
    [_btFollow addTarget:self action:@selector(buttonShareSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_btFollow setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btFollow setBackgroundImage:[UIImage imageNamed:@"follow-button-bg.png"] forState:UIControlStateNormal];
    [_btFollow setFont:[UIFont systemFontOfSize:13.0f]];
    [self addSubview: _btFollow];
    
    UIImageView * imvPlus = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 10, 10)];
    imvPlus.contentMode = UIViewContentModeScaleAspectFit;
    imvPlus.image = [UIImage imageNamed:@"follow-icon.png"];
    
    [_btFollow addSubview:imvPlus];
}



-(void)UpdateViewWithSize:(CGSize) size{
    
//    self.backgroundColor = [UIColor clearColor];
    //    float tt = self.frame.size.height;
    
    float shifx = 5.0f;
    float minshifx = 2.0f;
    float thumbWidth = size.width * 0.4f;
    float imagewidth = 50.0f;
    float lbHeight = 20.0f;
    float itemHeight = 15.0f;
    float lbItemWith = 25.0f;
    float lbSmallSize = 10.0f;
    float lbNameSize = 12.0f;
    float lbDescSize = 10.0f;
    
    _imvThumb.frame = CGRectMake(shifx, shifx, thumbWidth, size.height - shifx);

    _imvProfile.frame = CGRectMake(_imvThumb.frame.origin.x+_imvThumb.frame.size.width+shifx, shifx, imagewidth, imagewidth);

    //Label Name Post
    float offsetlbX = _imvProfile.frame.origin.x+imagewidth+shifx;
    _lbNamePost.frame = CGRectMake(offsetlbX, shifx, size.width-offsetlbX, lbHeight);
    _imvLiveStatus.frame = CGRectMake(size.width - (15+shifx), shifx, 15, 15);

    _lbDescPost.frame = CGRectMake(_imvProfile.frame.origin.x, imagewidth+shifx, size.width-(thumbWidth+shifx), lbHeight);

    _lbLoveCount.frame = CGRectMake(thumbWidth+shifx, size.height - (itemHeight+shifx), lbItemWith, itemHeight);
 
    
    _lbCommentCount.frame = CGRectMake(_lbLoveCount.frame.origin.x+_lbLoveCount.frame.size.width+itemHeight, _lbLoveCount.frame.origin.y, lbItemWith, itemHeight);
    
    _lbShareCount.frame = CGRectMake(_lbCommentCount.frame.origin.x+_lbCommentCount.frame.size.width+itemHeight, _lbCommentCount.frame.origin.y, lbItemWith, itemHeight);
    
    //
    _imvLoveTop.frame = CGRectMake(_lbLoveCount.frame.origin.x+_lbLoveCount.frame.size.width+minshifx, _lbLoveCount.frame.origin.y, itemHeight, itemHeight);
    
    _imvComment.frame = CGRectMake(_lbCommentCount.frame.origin.x+_lbCommentCount.frame.size.width+minshifx, _lbCommentCount.frame.origin.y, itemHeight, itemHeight);
    
    _imvShare.frame = CGRectMake(_lbShareCount.frame.origin.x+_lbShareCount.frame.size.width+minshifx, _lbShareCount.frame.origin.y, itemHeight, itemHeight);
    
    _lbViewCount.frame = CGRectMake(size.width-2*lbItemWith, _imvShare.frame.origin.y, 2*lbItemWith, itemHeight);

    _btFollow.frame = CGRectMake(_lbNamePost.frame.origin.x, _lbNamePost.frame.origin.y+_lbNamePost.frame.size.height, 100, 30);

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)didSelectImageThum{
    if (self.delegate) {
        [self.delegate videoDidSelectImageThumbWithDataDict:_datadict];
    }
}

-(void)CellSetUpdataForDataDict:(NSDictionary *)dict{
    
    _datadict = dict;
    
    /*
     {
     active = 1;
     author =             {
     avatar =                 {
     id = 331;
     url = "photos/2014/10/YszbK_331_6da37dd3139aa4d9aa55b8d237ec5d4a.jpg";
     };
     "avatar_id" = 331;
     id = 158;
     name = VRZO;
     username = VRZO;
     };
     clip = "<null>";
     comment = "<null>";
     "comment_count" = 0;
     follow = "<null>";
     "follow_count" = 0;
     "google_map_name" = "<null>";
     hidden =             (
     );
     id = 1465;
     "link_title" = "<null>";
     love = "<null>";
     "love_count" = 0;
     media =             {
     active = 1;
     "album_id" = 0;
     "clip_id" = 0;
     extension = jpg;
     id = 507;
     name = "407468_329823493718377_1420689246_n.jpg";
     "post_id" = 0;
     temp = 0;
     "timeline_id" = 0;
     type = photo;
     url = "photos/2014/10/EfM6k_507_2d6cc4b2d139a53512fb8cbb3086ae2e";
     };
     "media_type" = media;
     "post_id" = 1465;
     "recipient_id" = 0;
     seen = 0;
     soundcloud = "<null>";
     text = "\U0e1c\U0e21\U0e43\U0e2b\U0e493\U0e1e\U0e22\U0e32\U0e07\U0e04\U0e4c\U0e40\U0e25\U0e22\U0e27\U0e48\U0e32 &quot;\U0e04\U0e32\U0e23\U0e32\U0e27\U0e30&quot; <br>#[11]";
     time = 1414421505;
     "timeline_id" = 158;
     timestamp = "2015-02-12 12:18:56";
     type1 = story;
     type2 = none;
     view = 25382;
     youtube = "<null>";
     }
     
     
     "clip": {
     "id": "94381",
     "active": "1",
     "album_id": "0",
     "clip_id": "0",
     "extension": "mp4",
     "name": "h264.mp4",
     "post_id": "0",
     "temp": "0",
     "timeline_id": "0",
     "type": "clip",
     "url": "clips\/2015\/01\/Oowli_94381_e4d20a29427669b29e864aaf1a544e9f",
     "thumbnail": "https:\/\/www.vdomax.com\/clips\/thumbs\/media_clip_94381.jpeg"
     },
     
     */
    
    NSDictionary * author = [dict objectForKey:@"author"];
    NSString * imageAuthor = [author objectForKey:@"avatar"];
    NSString * imageurl = [NSString stringWithFormat:@"%@/%@",kIPIMAGE,imageAuthor];
    NSString * nameAuthor = [author objectForKey:@"name"];
    
    NSDictionary * cilpDict = [dict objectForKey:@"clip"];
    NSString * thumbnail = [cilpDict objectForKey:@"thumbnail"];
    NSString * desc = ([[dict objectForKey:@"text"] isKindOfClass:[NSNull class]])?@"":[dict objectForKey:@"text"];
    NSString * clipurl = [NSString stringWithFormat:@"%@/%@_ori.%@",kIPIMAGE,[cilpDict objectForKey:@"url"],[cilpDict objectForKey:@"extension"]];
    
    int followcount =[[dict objectForKey:@"follow_count"] intValue];
    int viewcount =[[dict objectForKey:@"view"] intValue];
    int lovecount =[[dict objectForKey:@"love_count"] intValue];
    int commentcount =[[dict objectForKey:@"comment_count"] intValue];
    int sharecount =[[dict objectForKey:@"share_count"] intValue];
    
    _lbNamePost.text = nameAuthor;
    [_imvProfile sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"01-splash.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
//        [self performSelector:@selector(updateImageViewWithImage:) withObject:image afterDelay:0.1];
        
        [self updateImageViewWithImage:image];
        
    }];
    [_imvThumb sd_setImageWithURL:[NSURL URLWithString:thumbnail] placeholderImage:[UIImage imageNamed:@"01-splash.png"]];
    
    _lbDescPost.text = desc;
    _lbViewCount.text = [NSString stringWithFormat:@"View: %d",viewcount];
    _lbLoveCount.text = [NSString stringWithFormat:@"%d",lovecount];
    _lbCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
    _lbShareCount.text = [NSString stringWithFormat:@"%d",sharecount];
    
}


-(void)updateImageViewWithImage:(UIImage *) image{
    
    
    UIImage * imagecrop = [self ResizeCropSquireImage:image];
    _imvProfile.image = imagecrop;
    
}

#pragma mark - self method
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


