//
//  HeaderView.m
//  FlowLayoutNoNIB
//
//  Created by Beau G. Bolle on 2012.10.29.
//
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor darkGrayColor]];
        
        _titlename = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titlename.font = [UIFont boldSystemFontOfSize:17.0f];
        _titlename.textColor = [UIColor whiteColor];
        _titlename.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titlename];
	}
	return self;
}

@end
