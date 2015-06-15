//
//  CommentTableViewCell.m
//  VDOMAX
//
//  Created by fanstar on 1/18/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // CGFloat height = [self heightContentBackgroundView:commentModel.content];
        self.backgroundColor = [UIColor clearColor];
        
        _imvProfile = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imvProfile.contentMode = UIViewContentModeScaleAspectFit;
        _imvProfile.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_imvProfile];
        
        //add GestureTap
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageThum)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        
//        _imvThumb.userInteractionEnabled = YES;
//        [_imvThumb addGestureRecognizer:tap];
        
        //Label Name Post
        _lbNamePost=[[UILabel alloc]initWithFrame:CGRectZero];
        _lbNamePost.numberOfLines=0;
        _lbNamePost.lineBreakMode=NSLineBreakByCharWrapping;
        _lbNamePost.backgroundColor=[UIColor clearColor];
        [self addSubview:_lbNamePost];
        
        _lbDatePost=[[UILabel alloc]initWithFrame:CGRectZero];
        _lbDatePost.numberOfLines=0;
        _lbDatePost.lineBreakMode=NSLineBreakByCharWrapping;
        _lbDatePost.backgroundColor=[UIColor clearColor];
        [self addSubview:_lbDatePost];
        
        _lbDescPost=[[UILabel alloc]initWithFrame:CGRectZero];
        _lbDescPost.numberOfLines=0;
        _lbDescPost.lineBreakMode=NSLineBreakByCharWrapping;
        _lbDescPost.backgroundColor=[UIColor clearColor];
        [self addSubview:_lbDescPost];
        
        _btLove = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btLove setTitle:@"  Love" forState:UIControlStateNormal];
        [_btLove addTarget:self action:@selector(buttonLoveSelect:) forControlEvents:UIControlEventTouchUpInside];
        _btLove.frame = CGRectMake(0, 0, 60, 30);
//        [_btLove setBackgroundColor:[UIColor blueColor]];
        [_btLove setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:_btLove];
        
        _imvLoveBottom = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imvLoveBottom.contentMode = UIViewContentModeScaleAspectFit;
        _imvLoveBottom.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imvLoveBottom];
        
        _lbLoveCount=[[UILabel alloc]initWithFrame:CGRectZero];
        _lbLoveCount.numberOfLines=0;
        _lbLoveCount.lineBreakMode=NSLineBreakByCharWrapping;
        _lbLoveCount.backgroundColor=[UIColor clearColor];
        [self addSubview:_lbLoveCount];
        
        //        for (UIView * v in _containView.subviews) {
        //            v.backgroundColor = [UIColor redColor];
        //        }
        
        
        //        [self AdjustCellWithWidth:self.size.width];
    }
    return self;
}

- (void)AdjustCellWithWidth:(float) width WithDataDict:(NSDictionary * ) dict{
    
    NSString *nameString = dict[@"name"];
    NSString *dateAgo = dict[@"date"];
    NSString *desc = dict[@"desc"];
    NSString *lovecount = dict[@"lovecount"];
    
    
    
    float offSetX = 0;
    float offSetY = 0;
    float paddingWidth = 5.0f;
    float containTotalHeight = paddingWidth;
    float shiftCell = 5.0f;
    float imageWidth = 50.0f;
    float lbHeight = 25.0f;
    float lbSmallWidth = 30.0f;
    float fontsmallsize = 10.0f;
    float fontNameSize = 13.0f;
    float smallImageHeight = 15.0f;
    float fontDescSize = 12.0f;
    
    float insetSizeWidth = self.frame.size.width - (2*shiftCell);
    
    //Add Subview Here
    _imvProfile.frame = CGRectMake(shiftCell, shiftCell, imageWidth, imageWidth);
    _imvProfile.image = [UIImage imageNamed:@"icon1.png"];
    containTotalHeight += _imvProfile.frame.size.height+shiftCell;
    
    _lbNamePost.frame = CGRectMake(_imvProfile.frame.origin.x+_imvProfile.frame.size.width + shiftCell, shiftCell, insetSizeWidth - (imageWidth+ shiftCell), lbHeight);
    _lbNamePost.text = nameString;
    _lbNamePost.font = [UIFont boldSystemFontOfSize:fontNameSize];
    _lbNamePost.textColor = [UIColor whiteColor];
    
    _lbDatePost.frame = CGRectMake(_lbNamePost.frame.origin.x, _lbNamePost.frame.origin.y+_lbNamePost.frame.size.height, insetSizeWidth - (imageWidth+ shiftCell), lbHeight);
    _lbDatePost.text = dateAgo;
    _lbDatePost.font = [UIFont systemFontOfSize:fontDescSize];
    _lbDatePost.textColor = [UIColor whiteColor];
//    _lbDatePost.backgroundColor= [UIColor greenColor];
    
    _lbDescPost.frame = CGRectMake(shiftCell, _imvProfile.frame.origin.y+_imvProfile.frame.size.height+shiftCell, insetSizeWidth, lbHeight);
    _lbDescPost.text = desc;
    _lbDescPost.font = [UIFont systemFontOfSize:fontDescSize];
    _lbDescPost.textColor = [UIColor whiteColor];
    _lbDescPost.textAlignment = NSTextAlignmentLeft;
    [_lbDescPost sizeToFit];
//    _lbDescPost.backgroundColor= [UIColor greenColor];
    
    containTotalHeight += _lbDescPost.frame.size.height + shiftCell;
    
    _btLove.frame = CGRectMake(_imvProfile.frame.origin.x + 3*_imvProfile.frame.size.width , _lbDatePost.frame.origin.y, imageWidth, lbHeight);
    //    [_btLove setTitle:@"Love" forState:UIControlStateNormal];
    //    [_btLove setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    //add image
    _imvLoveBottom.frame = CGRectMake(0, 0, smallImageHeight, smallImageHeight);
    float rangCenter = _btLove.frame.size.height/2.0f;
    _imvLoveBottom.center = CGPointMake( (_btLove.frame.origin.x+ _btLove.frame.size.width) + rangCenter, _btLove.frame.origin.y+rangCenter);
    _imvLoveBottom.image = [UIImage imageNamed:@"icon1.png"];
    
    
    _lbLoveCount.frame = CGRectMake(_imvLoveBottom.frame.origin.x + _imvLoveBottom.frame.size.width + shiftCell, _lbDatePost.frame.origin.y, imageWidth, lbHeight);
//    _lbLoveCount.center = CGPointMake(_lbLoveCount.center.x, _btLove.center.y);
    _lbLoveCount.text = lovecount;
    _lbLoveCount.font = [UIFont systemFontOfSize:fontDescSize];
    _lbLoveCount.textColor = [UIColor whiteColor];
    _lbLoveCount.textAlignment = NSTextAlignmentLeft;
//    [_lbLoveCount sizeToFit];
//    _lbLoveCount.backgroundColor= [UIColor greenColor];
    
    //End Add Subview
    
    //total cell heigth
    _cellheight = containTotalHeight;
    
}

- (float)GetCellHeight{
    
    return _cellheight;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
