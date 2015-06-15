/*
	LTActionSheet - a UIActionSheet subclass to support customized fonts and alignment
	Copyright (C) 2011 by David Hoerl

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

#import "LTActionSheet.h"

#if ! __has_feature(objc_arc)
#error THIS CODE MUST BE COMPILED WITH ARC ENABLED!
#endif

@implementation LTActionSheet
{
	BOOL didShow;
}
@synthesize alignment;
@synthesize font;

- (void)showInView:(UIView *)view
{
	[super showInView:view];

	if(didShow) return;

	didShow = YES;
	CGFloat diff;
	for(UILabel *label in [super subviews]) {
		if([label isKindOfClass:[UILabel class]]) {
			//NSLog(@"Orig Label=%@ MASK=0x%x", NSStringFromCGRect(label.frame), label.autoresizingMask );
			CGRect frame = label.frame;

			label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			label.textAlignment = UITextAlignmentLeft;
			label.font = font;
			label.numberOfLines = 100;
			label.lineBreakMode = UILineBreakModeWordWrap;

			diff = frame.size.height;
			frame.size.height = 10000;
			CGRect r = [label textRectForBounds:frame limitedToNumberOfLines:1000];
			diff = rintf(r.size.height - diff);
			label.frame = r;
			//NSLog(@"OrigBounds=%@ computedBounds=%@", NSStringFromCGRect(frame), NSStringFromCGRect(r) );
			//NSLog(@"Label=%@", NSStringFromCGRect(label.frame) );
			break;
		}
	}
	CGRect frame = super.frame;
	frame.size.height += diff;
	frame.origin.y -= diff;
	super.frame = frame;

	for(UIView *sview in [super subviews]) {
		frame = sview.frame;
		if([sview isKindOfClass:[UILabel class]]) frame.origin.y -= rintf(diff/2);
		else frame.origin.y += diff;
		sview.frame = frame;
	}
}

@end