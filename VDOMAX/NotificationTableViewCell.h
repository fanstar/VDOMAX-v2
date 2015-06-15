//
//  CommentTableViewCell.h
//  VDOMAX
//
//  Created by fanstar on 1/18/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentTableViewCell;
@protocol CommentTableCellDelegate <NSObject>

-(void)didSelectImagePostCell:(CommentTableViewCell *) cell withDataDict:(NSDictionary *) dict;

@end

@interface CommentTableViewCell : UITableViewCell
@property (assign) id<CommentTableCellDelegate>delegate;

@property (strong,nonatomic) UILabel *lbNamePost;
@property (strong,nonatomic) UILabel *lbDatePost;
@property (strong,nonatomic) UILabel *lbDescPost;
@property (strong,nonatomic) UILabel *lbLoveCount;

@property (strong,nonatomic) UIImageView *imvProfile;
@property (strong,nonatomic) UIImageView *imvLoveBottom;

@property (strong,nonatomic) UIButton * btLove;
@property (retain, nonatomic) NSDictionary * datadict;

@property (assign) float cellheight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Sets up the cell with data
 */
- (void)AdjustCellWithWidth:(float) width WithDataDict:(NSDictionary * ) dict;
- (float)GetCellHeight;

@end
