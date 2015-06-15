//
//  IGLDropDownItem.m
//  IGLDropDownMenuDemo
//
//  Created by Galvin Li on 8/30/14.
//  Copyright (c) 2014 Galvin Li. All rights reserved.
//

#import "IGLDropDownItem.h"

@interface IGLDropDownItem ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation IGLDropDownItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _paddingLeft = 5;
        [self initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.bgView setFrame:self.bounds];
    
    [self updateLayout];
}

- (void)initView
{
    self.bgView = [[UIView alloc] init];
    self.bgView.userInteractionEnabled = NO;
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowOpacity = 0.2;
    self.bgView.layer.shouldRasterize = YES;
    [self.bgView setFrame:self.bounds];
    [self addSubview:self.bgView];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.iconImageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 1;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.adjustsFontSizeToFitWidth  = YES;
    [self addSubview:self.textLabel];
    
    [self updateLayout];
    
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
//    CGFloat selfHeight = CGRectGetHeight(self.bounds);
//    UIImage * resizeImage = [self ResizeImage:iconImage AspectFitNewSize:CGSizeMake(selfHeight, selfHeight)];
//    _iconImage = resizeImage;
    [self.iconImageView setImage:_iconImage];
    
    [self updateLayout];
}

- (void)updateLayout
{
    
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    
//    [self.iconImageView setFrame:CGRectMake(self.paddingLeft, 0, selfHeight, selfHeight)];
    [self.iconImageView setFrame:CGRectMake(0, 0, selfHeight+self.paddingLeft, selfHeight)];
    if (self.iconImage) {
        [self.textLabel setFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+5, 0, selfWidth - CGRectGetMaxX(self.iconImageView.frame)-5, selfHeight)];
    } else {
        [self.textLabel setFrame:CGRectMake(self.paddingLeft+5, 0, selfWidth-5, selfHeight)];
    }
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    _paddingLeft = paddingLeft;
    
    [self updateLayout];
}

- (void)setObject:(id)object
{
    _object = object;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = self.text;
}

- (id)copyWithZone:(NSZone *)zone
{
    IGLDropDownItem *itemCopy = [[IGLDropDownItem alloc] init];
    
    itemCopy.index = _index;
    itemCopy.iconImage = _iconImage;
    itemCopy.object = _object;
    itemCopy.text = _text;
    itemCopy.paddingLeft = _paddingLeft;
    
    return itemCopy;
}



#pragma mark - self method
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
