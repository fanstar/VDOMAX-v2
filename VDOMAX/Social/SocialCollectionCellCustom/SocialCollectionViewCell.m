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
    
    _imvProfile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imagewidth, imagewidth)];
    _imvProfile.contentMode = UIViewContentModeScaleAspectFit;
    _imvProfile.image = [UIImage imageNamed:@"photo1.jpg"];
    _imvProfile.layer.cornerRadius = _imvProfile.frame.size.width/2.0f;
    _imvProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    _imvProfile.layer.borderWidth = 0.5f;
    _imvProfile.layer.masksToBounds = YES;
   
    [self addSubview:_imvProfile];
    
    
    float offsetXlabel =_imvProfile.frame.origin.x+_imvProfile.frame.size.width + shiftCell;
    _lbName = [[UILabel alloc]initWithFrame:CGRectMake(offsetXlabel, 0, self.frame.size.width - (offsetXlabel+shiftCell),lbHeight)];
    _lbName.numberOfLines=1;
    _lbName.lineBreakMode=NSLineBreakByTruncatingTail;
    _lbName.backgroundColor=[UIColor clearColor];
    _lbName.font = [UIFont boldSystemFontOfSize:fontNameSize];
    
    [self addSubview:_lbName];
    
    
    _imvThumb = [[UIImageView alloc]initWithFrame:CGRectMake(0, _imvProfile.frame.origin.y+_imvProfile.frame.size.height+shiftCell, self.frame.size.width, self.frame.size.height-imagewidth)];
    _imvThumb.contentMode = UIViewContentModeScaleAspectFit;
    
//    _imvThumb.backgroundColor = [UIColor whiteColor];
    [self addSubview:_imvThumb];
    
    //add GestureTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageThumb)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    _imvThumb.userInteractionEnabled = YES;
    [_imvThumb addGestureRecognizer:tap];
    
    _btFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btFollow setTitle:@"    Follow" forState:UIControlStateNormal];
    [_btFollow addTarget:self action:@selector(buttonFollowSelect:) forControlEvents:UIControlEventTouchUpInside];
    _btFollow.frame = CGRectMake(offsetXlabel, _lbName.frame.origin.y+_lbName.frame.size.height, 50, 20);
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
    NSString * thumb = [dict objectForKey:@"thumb"];
//    NSString * url = [dict objectForKey:@"url"];
//    NSString * date = [dict objectForKey:@"date"];
    NSDictionary * durDict = [dict objectForKey:@"duration"];
    
    NSString * time = [NSString stringWithFormat:@"%@:%@:%@",[durDict objectForKey:@"hours"],[durDict objectForKey:@"minutes"],[durDict objectForKey:@"seconds"]];
    
//    _lbName.text = @"name lastname";
//    _imvProfile.image = [UIImage imageNamed:@"icon1.png"];
//    _imvThumb.image = [UIImage imageNamed:@"icon1.png"];
//    _imvStatus.image = [UIImage imageNamed:@"icon1.png"];
    
    _lbName.text = name;
    [_imvThumb sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:nil];
    
}

-(void)buttonFollowSelect:(id) sender{
    
    
    
}


-(void)didSelectImageThumb{
    if (self.delegate) {
        [self.delegate ChannelDidSelectCellThumbWithData:_datadict];
    }
}
@end
