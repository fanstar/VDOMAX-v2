//
//  TimeLineDetailsViewController.m
//  VDOMAXCHAT
//
//  Created by yut on 8/24/56 BE.
//  Copyright (c) 2556 biz. All rights reserved.
//

#import "TimeLineDetailsViewController.h"

#define INPUT_HEIGHT 40.0f

@interface TimeLineDetailsViewController ()

@end

@implementation TimeLineDetailsViewController
@synthesize titlename;
@synthesize datadict;
@synthesize delegate;
@synthesize inputToolBarView;
@synthesize uiScrollViewContain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (titlename != nil) {
        self.navigationItem.title = self.titlename;
    }
    
    [self customNavBar];
    
    if (self.datadict != nil) {
        [self SetupTimeLineDetailsWithDict:self.datadict];
    }
    
    [self setup];
    
    [self performSelector:@selector(registerkeyboard) withObject:nil afterDelay:0.1];
    
    //add gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.uiScrollViewContain addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavBar{
    
    
//    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithTitle:@"Time Line" style:UIBarButtonItemStyleDone target:self action:@selector(BackToTimeLine)];
    
    UIButton *lButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setFrame:CGRectMake(0,0,20,33)];
    lButton.showsTouchWhenHighlighted = YES;
    [lButton setBackgroundImage:[UIImage imageNamed:@"back_nav_button.png"] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(BackToTimeLine) forControlEvents:UIControlEventTouchUpInside];//back
    
    UIBarButtonItem * leftbutton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    
    self.navigationItem.leftBarButtonItem = leftbutton;
    
}

-(void)BackToTimeLine{
    
    if (tattooview !=nil) {
        [tattooview.view removeFromSuperview];
        tattooview = nil;
    }
    
    [self.delegate TimeLineDelegateDidClose];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    //CGPoint touchPoint=[gesture locationInView:scrollView];
    
    if (flagshowkeyboard) {
        [self.inputToolBarView.textView resignFirstResponder ];
    }
}

-(void)SetupTimeLineDetailsWithDict:(NSDictionary *) timelinedict{
    
    float sumviewheight = 0;
    float shiftCell = 5.0f;
    
    ///////////////////////////////////////////////////////////
    ////Header view
    ///////////////////////////////////////////////////////////
    NSString * urlImageProfile = [timelinedict objectForKey:@"IMAGEPROFILE"];
    NSString * userName = [timelinedict objectForKey:@"USERNAME"];
    NSString * dateTime = [timelinedict objectForKey:@"DATETIME"];
    
    //set my profile title
    CGRect rectProfile = CGRectMake(2, 2, 40, 40);
    CGRect rectUserName = CGRectMake(50, 2, 200, 25);
    CGRect rectDateTime = CGRectMake(50, 27, 200, 15);
    sumviewheight = rectProfile.size.height + shiftCell;
    //sumviewheight += rectUserName.size.height;
    //sumviewheight += rectDateTime.size.height;
    
    UIImageView * imageProfile = [[UIImageView alloc] initWithFrame:rectProfile];
    [imageProfile setImageWithURL:[NSURL URLWithString:urlImageProfile] placeholderImage:[UIImage imageNamed:@""]];
    
    UILabel * lbUserName = [[UILabel alloc] initWithFrame:rectUserName];
    lbUserName.text = userName;
    lbUserName.textAlignment = NSTextAlignmentLeft;
    lbUserName.font = [UIFont systemFontOfSize:14];
    
    UILabel * lbDatePost = [[UILabel alloc] initWithFrame:rectDateTime];
    lbDatePost.text = dateTime;
    lbDatePost.textAlignment = NSTextAlignmentLeft;
    lbDatePost.font = [UIFont systemFontOfSize:14];
    
    
    ///////////////////////////////////////////////////////////
    ////Image or Tattoo view
    ///////////////////////////////////////////////////////////
     int flagImagePost = [[timelinedict objectForKey:@"POSTIMAGETYPE"] intValue];
    UIImageView * imagePost;
    if (flagImagePost == 0) {//not post Image
        
    }else if (flagImagePost == 1) {//Image
        
        NSString * urlImagePost = [timelinedict objectForKey:@"IMAGEPOSTPATH"];
        
        CGRect rectImagePost = CGRectMake(2, sumviewheight, 300, 200);
        sumviewheight += (rectImagePost.size.height + shiftCell);
        imagePost = [[UIImageView alloc] initWithFrame:rectImagePost];
        [imagePost setImageWithURL:[NSURL URLWithString:urlImagePost] placeholderImage:[UIImage imageNamed:@""]];
        
    }else if (flagImagePost == 2) {//Tattoo Image
        NSString * urlTattooImagePost = [timelinedict objectForKey:@"IMAGEPOSTPATH"];
        
        CGRect rectImagePost = CGRectMake(2, sumviewheight, 100, 100);
        sumviewheight += (rectImagePost.size.height + shiftCell);
        imagePost = [[UIImageView alloc] initWithFrame:rectImagePost];
        [imagePost setImageWithURL:[NSURL URLWithString:urlTattooImagePost] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    
    ///////////////////////////////////////////////////////////
    ////Description view
    ///////////////////////////////////////////////////////////
    NSString * desc = [timelinedict objectForKey:@"DESCRIPTIONPOST"];
    int countlike = [[timelinedict objectForKey:@"NUMOFLIKE"] intValue];
    int countComment = [[timelinedict objectForKey:@"NUMOFCOMMENT"] intValue];
    CGRect rectDesc = CGRectMake(2, sumviewheight, 300, 45);
    
    UITextView * txtviewDesc = [[UITextView alloc] initWithFrame:rectDesc];
    txtviewDesc.userInteractionEnabled = NO;
    txtviewDesc.backgroundColor = [UIColor clearColor];
    txtviewDesc.text = desc;
    [txtviewDesc sizeToFit];
    
    sumviewheight += (txtviewDesc.frame.size.height + shiftCell);
    
    ///////////////////////////////////////////////////////////
    ////like and Comment menu view
    ///////////////////////////////////////////////////////////
    UIButton * btLike = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectBtLike = CGRectMake(2, sumviewheight, 50, 30);
    [btLike setBackgroundImage:[UIImage imageNamed:@"tattoo.png"] forState:UIControlStateNormal];
    btLike.frame = rectBtLike;
    btLike.titleLabel.text = @"ถูกใจ";
    
    UIButton * btComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [btComment setBackgroundImage:[UIImage imageNamed:@"tattoo.png"] forState:UIControlStateNormal];
    CGRect rectBtComment = CGRectMake(100, sumviewheight, 50, 30);
    btComment.frame = rectBtComment;
    btComment.titleLabel.text = @"ถูกใจ";
    
    sumviewheight += (btLike.frame.size.height + shiftCell);
    ///////////////////////////////////////////////////////////
    ////like view
    ///////////////////////////////////////////////////////////
    NSArray * likeArr = [timelinedict objectForKey:@"LIKELIST"];
    CGRect rectLike = CGRectMake(2, sumviewheight, 300, 60);
    float likewidth = 60;
    float likeheight = 60;
    
    UIScrollView * uiscrollviewlike = [[UIScrollView alloc] initWithFrame:rectLike];
    uiscrollviewlike.scrollEnabled = YES;
    uiscrollviewlike.showsHorizontalScrollIndicator = NO;
    uiscrollviewlike.showsVerticalScrollIndicator = NO;
    uiscrollviewlike.contentSize = CGSizeMake(likewidth * [likeArr count], rectLike.size.height);
    
    int indexlike = 0;
    for (NSDictionary * dictlike in likeArr) {
        NSString * urlImageLike = [dictlike objectForKey:@"IMAGEPROFILE"];
        CGRect rectImageLike = CGRectMake(likewidth*indexlike, 0, likewidth, likeheight);
        UIImageView * imageProfileLike = [[UIImageView alloc] initWithFrame:rectImageLike];
        [imageProfileLike setImageWithURL:[NSURL URLWithString:urlImageLike] placeholderImage:[UIImage imageNamed:@""]];
        
        [uiscrollviewlike addSubview:imageProfileLike];
        
        indexlike++;
    }
    
    sumviewheight += (uiscrollviewlike.frame.size.height + shiftCell);
    
    ///////////////////////////////////////////////////////////
    ////Comment view
    ///////////////////////////////////////////////////////////
    
    NSArray * arrComment = [timelinedict objectForKey:@"COMMENTLIST"];
    
    NSMutableArray * tmpCommentView = [[NSMutableArray alloc] initWithCapacity:[arrComment count]];
    
    for (NSDictionary * dictcomment in arrComment) {
        
        NSString * urlImageProfileComment = [dictcomment objectForKey:@"IMAGEPROFILE"];
        NSString * userNameComment = [dictcomment objectForKey:@"USERNAMECOMMENT"];
        NSString * dateTimeComment = [dictcomment objectForKey:@"COMMENTDATETIME"];
        
        //set my profile title
        CGRect rectProfileComment = CGRectMake(2, sumviewheight, 40, 40);
        CGRect rectUserNameComment = CGRectMake(50, sumviewheight, 200, 30);
        //CGRect rectDateTimeComment = CGRectMake(44, sumviewheight, 200, 15);
        //sumviewheight = rectProfile.size.height + shiftCell;
        //sumviewheight += rectUserName.size.height;
        //sumviewheight += rectDateTime.size.height;
        
        UIImageView * imageProfileComment = [[UIImageView alloc] initWithFrame:rectProfileComment];
        [imageProfileComment setImageWithURL:[NSURL URLWithString:urlImageProfileComment] placeholderImage:[UIImage imageNamed:@""]];
        [tmpCommentView addObject:imageProfileComment];
        
        UILabel * lbUserNameComment = [[UILabel alloc] initWithFrame:rectUserNameComment];
        lbUserNameComment.text = userNameComment;
        lbUserNameComment.textAlignment = NSTextAlignmentLeft;
        lbUserNameComment.font = [UIFont systemFontOfSize:14];
        [lbUserNameComment sizeToFit];
        [tmpCommentView addObject:lbUserNameComment];
        
        CGRect rectDateTimeComment = CGRectMake(lbUserNameComment.frame.origin.x + lbUserNameComment.frame.size.width, sumviewheight, 200, 30);
        
        UILabel * lbDateComment = [[UILabel alloc] initWithFrame:rectDateTimeComment];
        lbDateComment.text = dateTimeComment;
        lbDateComment.textAlignment = NSTextAlignmentLeft;
        lbDateComment.font = [UIFont systemFontOfSize:14];
        [lbDateComment sizeToFit];
        [tmpCommentView addObject:lbDateComment];
        
        sumviewheight += (lbUserNameComment.frame.size.height + shiftCell);
        

        //Gen Comment
        int flagImageComment = [[dictcomment objectForKey:@"FLAGCOMMENTTYPE"] intValue];
        
        if (flagImageComment == 0) {//Comment
            
            NSString * desccomment = [dictcomment objectForKey:@"COMMENTDESCRIPTION"];
            CGRect rectDescComment = CGRectMake(lbUserNameComment.frame.origin.x, sumviewheight, 260, 45);
            
            UITextView * txtviewCommentDesc = [[UITextView alloc] initWithFrame:rectDescComment];
            txtviewCommentDesc.userInteractionEnabled = NO;
            txtviewCommentDesc.backgroundColor = [UIColor clearColor];
            txtviewCommentDesc.text = desccomment;
            [txtviewCommentDesc sizeToFit];
            
            sumviewheight += (txtviewCommentDesc.frame.size.height + shiftCell);
            
            [tmpCommentView addObject:txtviewCommentDesc];
            
        }else if (flagImageComment == 1) {//Tattoo Image
            NSString * urlTattooImageComment = [dictcomment objectForKey:@"TATTOOIMAGEPATH"];
            
            CGRect rectImageComment = CGRectMake(lbUserNameComment.frame.origin.x, sumviewheight, 100, 100);
            sumviewheight += (rectImageComment.size.height + shiftCell);
            UIImageView * imageTaatooComment = [[UIImageView alloc] initWithFrame:rectImageComment];
            [imageTaatooComment setImageWithURL:[NSURL URLWithString:urlTattooImageComment] placeholderImage:[UIImage imageNamed:@""]];
            
            [tmpCommentView addObject:imageTaatooComment];
        }
    }
    
    //create view contain in scrollview
//    uiScrollViewContain = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    uiScrollViewContain.contentSize = CGSizeMake(self.view.frame.size.width, sumviewheight);
//    uiScrollViewContain.showsHorizontalScrollIndicator = NO;
//    uiScrollViewContain.showsVerticalScrollIndicator = NO;
//    uiScrollViewContain.scrollEnabled = YES;
    
    //set new content
    self.uiScrollViewContain.contentSize = CGSizeMake(self.uiScrollViewContain.frame.size.width, sumviewheight);
    
    //title
    [self.uiScrollViewContain addSubview:imageProfile];
    [self.uiScrollViewContain addSubview:lbUserName];
    [self.uiScrollViewContain addSubview:lbDatePost];
    
    //image or tattoo post
    if(imagePost != nil)[self.uiScrollViewContain addSubview:imagePost];
    
    //add menu like and comment
    [self.uiScrollViewContain addSubview:btLike];
    [self.uiScrollViewContain addSubview:btComment];
    
    //add like list
    [self.uiScrollViewContain addSubview:uiscrollviewlike];
    
    //add comment
    for (UIView * v in tmpCommentView) {
        [self.uiScrollViewContain addSubview:v];
    }
    
    //add scrollview to view
    [self.view addSubview:self.uiScrollViewContain];
    
    //set image or tattoo, if has
    
    //set description, if has
    
    
    //set like button and comment button
    
    //display like people
    
    //display comment object
        //1. desccription only
        //2. description + tattoo
    
    
    
//    int numofitem = [menuarr count];
//    int row = ceilf((float)(numofitem) / NUMPERROW);
//    
//    int x=0;
//    int y=0;
//    self.uiscrollviewpreview.contentSize = CGSizeMake(self.uiscrollviewpreview.frame.size.width,STICKERPREVIEWHEIGHT * row);
//    for (NSDictionary * dict in menuarr) {
//        
//        CGRect rect = CGRectMake(STICKERPREVIEWWIDTH * x, STICKERPREVIEWHEIGHT * y, STICKERPREVIEWWIDTH, STICKERPREVIEWHEIGHT);
//        NSString * imagepath = [dict objectForKey:@"IMAGEPATH"];
//        
//        UIImageView * menuview = [[UIImageView alloc] initWithFrame:rect];
//        [menuview setImageWithURL:[NSURL URLWithString:imagepath]];
//        menuview.contentMode = UIViewContentModeScaleAspectFit;
//        [self.uiscrollviewpreview addSubview:menuview];
//        
//        if (x>=NUMPERROW-1) {
//            x = 0;
//            y++;
//        }else{
//            x++;
//        }
//    }
    
    
}

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;

    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self withMenuLeftAreaWidth:40];
    
    //self.inputToolBarView.widthforlefticonarea = 75;
    
    // TODO: refactor
    //self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    
    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    [self.view addSubview:self.inputToolBarView];
    
    //add
    UIButton *tattooButton = (UIButton *)[UIButton tattooButton];
    //tattooButton.enabled = NO;
    tattooButton.frame = CGRectMake(5.0f, 8.0f, 30.0f, 26.0f);
    [tattooButton addTarget:self
                     action:@selector(tattooPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setTattooButton:tattooButton];
    [self.view addSubview:self.inputToolBarView];
    
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

//add
- (void)tattooPressed:(UIButton *)sender
{
    if(!flagshowkeyboard)[self.inputToolBarView.textView becomeFirstResponder];
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            if (tattooview == nil) {
                //created subview
                tattooview = [[TattooViewController alloc] initWithNibName:@"TattooViewController_iPhone" bundle:nil];
                keyboard = [[keyboard subviews] objectAtIndex:1];
                [keyboard addSubview:tattooview.view];
            }else{
                [tattooview.view removeFromSuperview];
                tattooview = nil;
            }
            
        }
        
    }
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
//    [self.delegate sendPressed:sender
//                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}


- (void)registerkeyboard
{
    //[self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    //[self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        if(!isShrinking)
            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
//                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                    0.0f,
//                                                                    self.tableView.contentInset.bottom + changeInHeight,
//                                                                    0.0f);
//                             
//                             self.tableView.contentInset = insets;
//                             self.tableView.scrollIndicatorInsets = insets;
//                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             
                             CGRect newRect = CGRectMake(0, 0, self.uiScrollViewContain.frame.size.width , self.uiScrollViewContain.frame.size.height-changeInHeight);
                             self.uiScrollViewContain.frame = newRect;
                         }
                         completion:^(BOOL finished) {
                             if(isShrinking)
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             
                             CGRect scrollRect = CGRectMake(0, self.uiScrollViewContain.contentSize.height-INPUT_HEIGHT , self.uiScrollViewContain.frame.size.width , INPUT_HEIGHT);
                             [self.uiScrollViewContain scrollRectToVisible:scrollRect animated:YES];
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    flagshowkeyboard = YES;
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    flagshowkeyboard = NO;
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    NSLog(@"KeyBoard Frame: %@",NSStringFromCGRect(keyboardRect));
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         if (flagshowkeyboard) {
                             CGRect newRect = CGRectMake(0, 0, self.uiScrollViewContain.frame.size.width , self.view.frame.size.height-(self.inputToolBarView.frame.size.height + keyboardRect.size.height));
                             self.uiScrollViewContain.frame = newRect;
                         }else{
                             CGRect newRect = CGRectMake(0, 0, self.uiScrollViewContain.frame.size.width , self.view.frame.size.height-self.inputToolBarView.frame.size.height );
                             self.uiScrollViewContain.frame = newRect;
                         }
                         
//                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                0.0f,
//                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
//                                                                0.0f);
//                         
//                         self.tableView.contentInset = insets;
//                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                         
                         CGRect scrollRect = CGRectMake(0, self.uiScrollViewContain.contentSize.height-INPUT_HEIGHT , self.uiScrollViewContain.frame.size.width , INPUT_HEIGHT);
                         [self.uiScrollViewContain scrollRectToVisible:scrollRect animated:YES];
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.inputToolBarView.textView.becomeFirstResponder) {
//        [self.inputToolBarView.textView resignFirstResponder];
//    }
//}



@end
