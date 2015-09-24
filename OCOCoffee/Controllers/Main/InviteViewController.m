//
//  InviteViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kTableviewCell       @"inviteCellIndentifier"
#define kTypeList            @[@"日 期：", @"时 间：",@"地 点：",@"备 注："]
#define kTipList             @[@"请选择日期",@"请选择时间",@"请选择地点"]
#define kDateTagList         @[@"1",@"2"]
#define kInviteURL           @"api/invite/send"

#import "InviteViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "UIColor+colorBuild.h"
#import "InfoViewController.h"
#import "Global.h"
#import "ViewStyles.h"
#import "InviteTableViewCell.h"
#import "TipView.h"
#import "BaiDuMapViewController.h"
#import "Common.h"


@interface InviteViewController (){
    UITableView *inviteTableview;
    DatePickerView *datePicker;
    NSIndexPath *selectedIndexPath;
    InviteSearchView *searchView;
    InviteSearchViewController *searchViewController;
    CGRect rect;
    NSString *inviteDate ;
    NSString *inviteTime;
    NSString *inviteAddress;
    NSString *inviteNotice;
    NSString *logitude;
    NSString *latitude;
}


@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"发出邀请";
    self.view.backgroundColor = [UIColor whiteColor];
    [ViewStyles setNaviControllerStyle:self.navigationController];
    [self initNavBarButton];
    [self initView];
    [self initdatePicker];
    
    searchViewController = [[InviteSearchViewController alloc] init];
    searchViewController.delegate = self;
    searchViewController.view.hidden = YES;
    searchViewController.view.frame =CGRectMake(65, 236, 245, 212);
    [self.view addSubview:searchViewController.view];
    
    rect = CGRectMake(self.view.center.x-100, self.view.frame.size.height - 100, 180, 30);

}

-(void)initdatePicker {
    if(datePicker == nil){
        datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        datePicker.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initView {
   
    if(inviteTableview == nil){
        inviteTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) style:UITableViewStylePlain];
        inviteTableview.backgroundColor = [UIColor whiteColor];
        //inviteTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        inviteTableview.delegate  = self;
        inviteTableview.dataSource = self;
        inviteTableview.scrollEnabled = NO;
        [self.view addSubview: inviteTableview];
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSTextAlignmentLeft];
    paragraph.minimumLineHeight = 15.0;
    paragraph.lineSpacing = 5;
    paragraph.maximumLineHeight = 25.0;
    paragraph.headIndent = 5.0;
    
    NSDictionary *firstStyle = @{
                                 NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:14.0],
                                 NSForegroundColorAttributeName:[UIColor redColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraph,
                                 };
    NSDictionary *secondStyle =@{
                                 NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.5],
                                 NSFontAttributeName :[UIColor lightGrayColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraph,
                                 };
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"f5f5f5"];
    
    NSString *tips = @"温馨提示：为确保邀约顺利进行，请给TA预留足够的准备时间";
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width,headerView.frame.size.height)];
    NSMutableAttributedString *mattriString = [[NSMutableAttributedString alloc] initWithString:tips];
    [mattriString setAttributes:firstStyle range:NSMakeRange(0, 5)];
    [mattriString setAttributes:secondStyle range:NSMakeRange(5, tips.length-5)];
    tipLabel.attributedText = mattriString;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 2;
    [headerView addSubview:tipLabel];
    inviteTableview.tableHeaderView = headerView;
    
    UIView *inviteView = ({
        UIView *inviteView = [UIView new];
        inviteView.backgroundColor = [UIColor colorFromHexString:@"#f16681"];
        inviteView.frame = CGRectMake(0, inviteTableview.frame.size.height + 50, self.view.frame.size.width - 40, 40);
        inviteView.center = self.view.center;
        inviteView;
    });
    
    UIButton *inviteBtn = ({
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(inviteView.center.x-70, 0, 100, 40);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"发送邀请" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [inviteView addSubview:inviteBtn];
    [self.view addSubview:inviteView];

}

-(void)initNavBarButton {

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(returnBack)
                                    ];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)invite:(NSString *)string {
    NSLog(@"clicked");
    if([self checkData]){
        [self sendInvition];
    }
}

//信息合法性检测
-(BOOL)checkData {
    if(inviteDate == nil){
        [TipView displayView:self.view withFrame:rect withString:@"请选择日期"];
        return FALSE;
    }
    
    if(inviteTime == nil){
        [TipView displayView:self.view withFrame:rect withString:@"请选择时间"];
        return FALSE;
    }
    if(inviteAddress == nil){
        
        [TipView displayView:self.view withFrame:rect withString:@"请选择地点"];
        return FALSE;
    }
    
    NSDate *now = [NSDate date];
    NSTimeInterval nowTimeStamp = [now timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%@ %@",inviteDate,inviteTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *ivDate = [dateFormatter dateFromString:time];
    NSTimeInterval inviteTimeStamp = [ivDate timeIntervalSince1970];
    if(inviteTimeStamp < nowTimeStamp){
        [TipView displayView:self.view withFrame:rect withString:@"邀请时间不能小于当前时间"];
        return FALSE;
    }
    
    InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:4] superview];
    inviteNotice = cell.textfield.text;
    return TRUE;
}

//发送邀请
-(void)sendInvition {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kInviteURL];
    NSLog(@"%@",urlString);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *options =@{
                             @"uid":_uid,
                             @"date":inviteDate,
                             @"time":inviteTime,
                             @"lng":logitude ,
                             @"lat":latitude,
                             @"address":inviteAddress,
                             @"descprition":inviteNotice
                             };
    [manager GET:urlString parameters:options success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"%@", responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {
            [self.delegate InviteSuccess];
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [TipView displayView:self.view withFrame:rect withString:responseObject[@"msg"]];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [TipView displayView:self.view withFrame:rect withString:@"发送邀请失败"];
    }];
}
-(void)returnBack {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Dismissed");
    }];
}
-(void)searchData{
    
}

#pragma  tableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = kTableviewCell;
    InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell== nil){
        cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = [indexPath row];
    cell.textfield.tag = row+1;
    cell.textfield.delegate = self;
    NSString *title = kTypeList[row];
    if(row < ([kTypeList count]-1)){
        NSMutableString *mutableTitle = [[NSMutableString alloc] initWithString:title];
        [mutableTitle insertString:@"*" atIndex:0];
        NSAttributedString *attributeString = [self getCellAttributedString:mutableTitle];
        cell.typeLabel.attributedText = attributeString;
        cell.textfield.placeholder =kTipList[row];

        if(row == 0){
            [datePicker setMode:UIDatePickerModeDate];
        }

        if(row == 2){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_address"]];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(location:)];
            [imageView addGestureRecognizer:tap];
            cell.accessoryView = imageView;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.typeLabel.text = title;
    }
    
    return cell;
}

-(void)location:(UITapGestureRecognizer *)tap {
    NSLog(@"Taped!");
    
    CGPoint point = [tap locationInView:inviteTableview];
    NSIndexPath *indexPath = [inviteTableview indexPathForRowAtPoint:point];
    InviteTableViewCell *cell = (InviteTableViewCell *)[inviteTableview cellForRowAtIndexPath:indexPath];
    NSString *address = cell.textfield.text;
    NSLog(@"%@",address);
    if(address.length == 0){
        [TipView displayView:self.view withFrame:rect withString:@"请输入地址信息！"];
        return;
    }
    NSLog(@"latitute:%@,logitude:%@",latitude,logitude);
    BaiDuMapViewController *baiduViewController = [[BaiDuMapViewController alloc] init];
    baiduViewController.address = address;
    baiduViewController.latitude = latitude;
    baiduViewController.logitute = logitude;
    [self.navigationController pushViewController:baiduViewController animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InviteTableViewCell *cell = (InviteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textfield becomeFirstResponder];
}


-(NSAttributedString *)getCellAttributedString:(NSMutableString *)mutString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mutString];
    NSDictionary *firstWorld = @{
                                 NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
                                 NSForegroundColorAttributeName :[UIColor redColor],
                                 };
    [attributedString setAttributes:firstWorld range:NSMakeRange(0, 1)];
    return attributedString;
}

#pragma datepicker delegate method

-(void)datePickerCancel {
    NSInteger tag = datePicker.tag;
    InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:tag] superview];
    [cell.textfield resignFirstResponder];
}

-(void)datePickerDone:(NSDate *)date {
    NSInteger tag = datePicker.tag;
    NSString *format = [[NSString alloc] init];
    if(tag == 1){
        format = @"yyyy-MM-dd";
    }else{
        format = @"HH:mm:ss";
    }
    NSString *dateString = [Common formatedDateString:date format:format];
    InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:tag] superview];
    cell.textfield.text = dateString;
    [cell.textfield resignFirstResponder];
    
    if(tag == 1){
        inviteDate = dateString;
    }else{
        inviteTime = dateString;
    }
}


#pragma textField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    if([kDateTagList containsObject:[NSString stringWithFormat:@"%ld",(long)tag]]){
        datePicker.tag = tag;
        if(tag == 1){
            [datePicker setMode:UIDatePickerModeDate];
        }else if (tag == 2){
            [datePicker setMode:UIDatePickerModeTime];
        }
        textField.inputView = datePicker;
        if(!searchViewController.view.isHidden){
            searchViewController.view.hidden = YES;
        }
    }
    
    if(tag == 3){
        [textField addTarget:self action:@selector(textFieldInfo:) forControlEvents:UIControlEventEditingChanged];
    }
    
    textField.placeholder = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Text End Editing");
    if([textField.text length] == 0){
        NSInteger row  = textField.tag -1;
        textField.placeholder = kTipList[row];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldInfo:(NSInteger )tagValue {
    InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:3] superview];
    NSLog(@"%@",cell.textfield.text);
    NSString *input = cell.textfield.text;
    if(input == nil){
        searchViewController = nil;
        cell.textfield.placeholder = @"请输入关键字";
        NSLog(@"empty");
    }else{
        searchViewController.view.hidden = NO;
        searchViewController.queryString = cell.textfield.text;
        if(searchViewController.queryString != nil){
            [searchViewController suggestionData];
        }
        
    }
}

#pragma IniviteSearchView Delegate Method

-(void)getSelectedData:(NSString *)msg latitude:(NSString *)lat logitude:(NSString *)lng{
    
    InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:3] superview];
    cell.textfield.text = msg;
    [cell.textfield resignFirstResponder];
    [UIView animateWithDuration:1.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [cell.textfield resignFirstResponder];
                         searchViewController.view.hidden = YES;
                     }completion:^(BOOL finished){
                         NSLog(@"finished!");
                         logitude = lng;
                         latitude = lat;
                         inviteAddress = msg;
                     }
     ];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch began");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch end");
    BOOL isHidden = searchViewController.view.isHidden;
    if(!isHidden){
        searchViewController.view.hidden = YES;
        InviteTableViewCell *cell = (InviteTableViewCell *)[[inviteTableview viewWithTag:3] superview];
        [cell.textfield resignFirstResponder];
    }
}
@end