//
//  VideoTableViewCell.h
//  VDOMAX
//
//  Created by fanstar on 1/21/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@protocol VideoViewCellDelegate <NSObject>

@optional
-(void)videoDidSelectImageThumbWithDataDict:(NSDictionary *) dict;

@end

@interface VideoTableViewCell : UITableViewCell
@property (assign) id<VideoViewCellDelegate>delegate;
@property (strong,nonatomic) UILabel *lbNamePost;
@property (strong,nonatomic) UILabel *lbDescPost;
@property (strong,nonatomic) UILabel *lbViewCount;
@property (strong,nonatomic) UILabel *lbLoveCount;
@property (strong,nonatomic) UILabel *lbCommentCount;
@property (strong,nonatomic) UILabel *lbShareCount;
@property (retain,nonatomic) NSDictionary * datadict;

@property (strong,nonatomic) UIImageView *imvProfile;
@property (strong,nonatomic) UIImageView *imvThumb;
@property (strong,nonatomic) UIImageView *imvLoveTop;
@property (strong,nonatomic) UIImageView *imvComment;
@property (strong,nonatomic) UIImageView *imvLiveStatus;
@property (strong,nonatomic) UIImageView *imvShare;

@property (strong,nonatomic) UIButton * btFollow;
@property (retain, nonatomic) UIImageView * imvPlayLogo;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithSize:(CGSize ) size;
-(void)UpdateViewWithSize:(CGSize) size;
-(void)CellSetUpdataForDataDict:(NSDictionary *)dict;

@end
