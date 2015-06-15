//
//  CollectionViewCell.h
//  FlowLayoutNoNIB
//
//  Created by Beau G. Bolle on 2012.10.29.
//
//

#import "PSTCollectionView.h"
#import "UIImageView+WebCache.h"

@protocol ChannelCellDelegate<NSObject>

-(void) ChannelDidSelectCellThumbWithData:(NSDictionary *) data;

@end

@interface CollectionViewCell : PSUICollectionViewCell
@property (assign) id<ChannelCellDelegate>delegate;
@property (strong,nonatomic) UIImageView *  imvProfile;
@property (strong,nonatomic) UIImageView *  imvThumb;
@property (strong,nonatomic) UIImageView *  imvStatus;
@property (strong,nonatomic) UILabel *  lbName;
@property (strong,nonatomic) UIButton *  btFollow;
@property (retain,nonatomic) NSDictionary * datadict;


-(void)CellSetUpdataForDataDict:(NSDictionary *) dict;
-(void)SetVideoOnLineState:(BOOL ) stateon;

@end
