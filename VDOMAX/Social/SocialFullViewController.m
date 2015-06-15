//
//  ChannelFullViewController.m
//  VDOMAX
//
//  Created by fanstar on 1/20/2558 BE.
//  Copyright (c) 2558 bizvizard. All rights reserved.
//

#import "ChannelFullViewController.h"

@interface ChannelFullViewController ()

@end

@implementation ChannelFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupView];
    
    if (_dict != nil) {
        
        NSString * name = [_dict objectForKey:@"name"];
        NSString * date = [_dict objectForKey:@"date"];
        NSDictionary * durDict = [_dict objectForKey:@"duration"];
        
        NSString * time = [NSString stringWithFormat:@"%@:%@:%@",[durDict objectForKey:@"hours"],[durDict objectForKey:@"minutes"],[durDict objectForKey:@"seconds"]];
        
        
        self.lbName.text = name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setupView{
    
    float shiftCell = 5.0f;
    float imagewidth = 50.0f;
    float lbHeight = 20.0f;
    float fontNameSize =11.0f;
    float shifY = 20.0f;
    float thumbHeight = 200.0f;
    
    _imvProfile = [[UIImageView alloc]initWithFrame:CGRectMake(0, shifY, imagewidth, imagewidth)];
    _imvProfile.contentMode = UIViewContentModeScaleAspectFit;
     _imvProfile.image = [UIImage imageNamed:@"icon1.png"];
    [self.view addSubview:_imvProfile];
    
    
    float offsetXlabel =_imvProfile.frame.origin.x+_imvProfile.frame.size.width + shiftCell;
    _lbName = [[UILabel alloc]initWithFrame:CGRectMake(offsetXlabel, shifY, self.view.frame.size.width - offsetXlabel,lbHeight)];
    _lbName.numberOfLines=1;
    _lbName.lineBreakMode=NSLineBreakByCharWrapping;
    _lbName.backgroundColor=[UIColor clearColor];
    _lbName.font = [UIFont boldSystemFontOfSize:fontNameSize];
    _lbName.text = @"name lastname";
    [self.view addSubview:_lbName];
    
    
    _imvThumb = [[UIImageView alloc]initWithFrame:CGRectMake(0, _imvProfile.frame.origin.y+_imvProfile.frame.size.height+shiftCell, self.view.frame.size.width, thumbHeight)];
    _imvThumb.contentMode = UIViewContentModeScaleAspectFit;
    _imvThumb.image = [UIImage imageNamed:@"icon1.png"];
    _imvThumb.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imvThumb];
    
    //add GestureTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageThumb)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    _imvThumb.userInteractionEnabled = YES;
    [_imvThumb addGestureRecognizer:tap];
    
    _btDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btDone setTitle:@"Close" forState:UIControlStateNormal];
    [_btDone addTarget:self action:@selector(buttonDoneSelect:) forControlEvents:UIControlEventTouchUpInside];
    _btDone.frame = CGRectMake(self.view.frame.size.width - (shiftCell + 60), _imvProfile.frame.origin.y+_imvProfile.frame.size.height-30, 60, 30);
    [_btDone setBackgroundColor:[UIColor blueColor]];
    [_btDone setFont:[UIFont systemFontOfSize:10.0f]];
    [self.view addSubview:_btDone];
    
    
    _btFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btFollow setTitle:@"+Follow" forState:UIControlStateNormal];
    [_btFollow addTarget:self action:@selector(buttonFollowSelect:) forControlEvents:UIControlEventTouchUpInside];
    _btFollow.frame = CGRectMake(_btDone.frame.origin.x - (shiftCell + 100), _btDone.frame.origin.y, 100, 30);
    [_btFollow setBackgroundColor:[UIColor blueColor]];
    [_btFollow setFont:[UIFont systemFontOfSize:10.0f]];
    [self.view addSubview:_btFollow];
}

//-(void)CellSetUpdataForDataDict:(NSString *)dict{
//    
//    _lbName.text = @"name lastname";
//    _imvProfile.image = [UIImage imageNamed:@"icon1.png"];
//    _imvThumb.image = [UIImage imageNamed:@"icon1.png"];
//}

-(void)buttonFollowSelect:(id) sender{
    
    
    
}

-(void)buttonDoneSelect:(id) sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectImageThumb{
//    if (self.delegate) {
//        [self.delegate ChannelDidSelectCellThumbWithData:nil];
//    }
}




@end
