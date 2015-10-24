//
//  CenterEditTableViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kUserInfo                 @"api/user/info"
#define kAttributeURL             @"api/user/attr"
#define kProfilePost              @"api/user/profile_post"

#define kimageCollectionViewCell  @"imageCollectioinViewCell"
#define kAttributeList            @[@"咖 啡 I D:",@"昵       称:",@"性       别:",@"出生日期:",@"所在行业:",@"学       历:"]
#define kPlaceHoldList            @[@"", @"请输入",@"暂无",@"请选择日期",@"请选择所在行业",@"请选择学历"]
#define kCellIndexAndName         @{@"2":@"nickname",@"3":@"sex",@"4":@"age",@"5":@"job",@"6":@"education"}
#import "CenterEditTableViewController.h"
#import "UIColor+colorBuild.h"
#import "ViewStyles.h"
#import "Global.h"
#import "Common.h"
#import "LoginViewController.h"
#import "InfoCollectionCell.h"
#import "CenterViewController.h"
#import "InviteTableViewCell.h"
#import "StringPickerView.h"
#import "StringPickerViewItem.h"
#import "DatePickerView.h"
#import "TagViewController.h"
#import "NSString+MD5.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SKTagView/SKTagView.h>


@interface CenterEditTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,StringPickerViewDelegate,MBProgressHUDDelegate,MWPhotoBrowserDelegate,DatePickerViewDelegate>{
    MBProgressHUD       *_HUD;
    SKTagView           *_tagView;
    MWPhotoBrowser      *browser;
    MWPhoto             *photo;
    StringPickerView    *attrPickerView;
    DatePickerView      *datePickerView;
    
    UIImagePickerController *_imagePicker;
    UITableView *subTableView ;
    UICollectionView *imgCollectionView;
    NSMutableArray *browserImgs;
    NSMutableArray *imgArr;
    NSMutableArray *userInfo ;
    NSMutableDictionary *userDictInfo;
    NSMutableDictionary *attributeDict;
    NSMutableArray *mutablePickerArr;
    NSArray *tags;
    double collectionHeight;
    NSDictionary  *responseData;
    NSString *nickname;
    BOOL isNewHeadImg;
    NSInteger imagePickerViewTag;
}

@end

@implementation CenterEditTableViewController

-(void)viewDidLoad {
    
    [ViewStyles setNaviControllerStyle:self.navigationController];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(returnBack)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.title = @"个人资料";
    subTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    subTableView.delegate = self;
    subTableView.dataSource = self;
    subTableView.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    subTableView.scrollEnabled = YES;
    subTableView.bounces  = YES;
    subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:subTableView];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.delegate  = self;
    _HUD.labelText = @"努力加载中";
    [_HUD showWhileExecuting:@selector(loadImgsFromServer) onTarget:self withObject:nil animated:YES];
    
    [self initAttributePickerView];
    [self initDatePicker];
    [self loadAttributeListFromServer];

}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappeared");
    if(isNewHeadImg){
        [self.delegate loadNewDataFromServer];
    }
}

-(void)initAttributePickerView {
    if(attrPickerView == nil){
        attrPickerView = [[StringPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        attrPickerView.hidden = YES;
        attrPickerView.delegate = self;
        [self.view addSubview:attrPickerView];
    }
}

-(void)initDatePicker {
    if(datePickerView == nil){
        datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 230)];
        [datePickerView setMode:UIDatePickerModeDate];
        datePickerView.delegate = self;
        datePickerView.hidden = YES;
        [self.view addSubview:datePickerView];
    }
}

-(void)loadImgsFromServer {
    userInfo = [[NSMutableArray alloc] initWithCapacity:6];
    imgArr = [[NSMutableArray alloc] initWithCapacity:6];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kUserInfo];
    NSDictionary *params = @{@"id":_userDict[@"id"]};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
        if(obj[@"data"] !=nil){
            userDictInfo = [[NSMutableDictionary alloc] initWithDictionary:obj[@"data"]];
            
            [self formatUserData:userDictInfo];
            [self setupUserImgs:obj[@"data"][@"imgs"]];
            [subTableView reloadData];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
    }];
}

-(void)loadAttributeListFromServer {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kAttributeURL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id obj){
        if([obj[@"data"] isKindOfClass:[NSDictionary class]]){
            attributeDict = [[NSMutableDictionary alloc] initWithDictionary:obj[@"data"]];
        }
    }failure:^(AFHTTPRequestOperation *operation ,NSError *error){
        [Common showErrorDialog:[NSString stringWithFormat:@"%@",error]];
    }];
}


-(void)submitToServer:(NSString *)urlString params:(NSDictionary *)params {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *opteration,id obj){
        
    } failure:^(AFHTTPRequestOperation *operation ,NSError *error){
        [Common showErrorDialog:[NSString stringWithFormat:@"%@",error]];
    }];
}

-(void)formatUserData:(NSMutableDictionary *)dict {
    NSString *constellation = dict[@"constellation"]?dict[@"constellation"]:@"";
    NSString *uid = _userDict[@"uid"];
    NSString *name = dict[@"nickname"]?dict[@"nickname"]:@"";
    NSInteger sexType = [dict[@"sex"] integerValue];
    NSString *sex = (sexType == 2 ) ?@"女":@"男";
    userDictInfo[@"sex"] = sex;
    NSString *birthday = @"";
    if(dict[@"age"] != nil){
        birthday = [self birthdayString:dict[@"age"]];
    }
    NSString *job = dict[@"job"]?dict[@"job"]:@"";
    NSString *edu = dict[@"education"]?dict[@"education"]:@"";
    NSArray *data = [[NSArray alloc] initWithObjects:constellation,uid,name,sex,birthday,job,edu, nil];
    [userInfo addObjectsFromArray:data];
    tags = dict[@"tags"];
}

-(NSString *)birthdayString:(id)age {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthday = [self getDrithday:age];
    return  [formatter stringFromDate:birthday];
}

-(NSDate *)getDrithday:(id)age {
    NSString *ageString = [NSString stringWithFormat:@"%@",age];
    int ageval = [ageString intValue];
    NSDate *preDate = [NSDate dateWithTimeIntervalSinceNow:-ageval*365*24*3600];
    return preDate;
}

-(void) setupUserImgs:(NSArray *)imgList {
    NSInteger count = [imgList count];
    browserImgs = [[NSMutableArray alloc] initWithCapacity:count];
    if(count > 0){
        for (int i=0; i<imgList.count; i++) {
            NSDictionary *item = imgList[i];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:item[@"img"]]];
            [browserImgs addObject:photo];//用作查看大图
            [imgArr addObject:item];
        }
        if(count < 6){
            NSDictionary *dict = @{@"img":[UIImage imageNamed:@"more"]};
            [imgArr addObject:dict];
        }
    }else{
        NSDictionary *dict = @{@"img":[UIImage imageNamed:@"more"]};
        [imgArr addObject:dict];
    }
    
    double height = (SCREEN_WIDTH - (4 * 10))/3 ;
    NSInteger counts = [browserImgs count];
    if(counts != 6){
        counts +=1;
    }
    collectionHeight = height * (ceil((double)counts/3));
}


-(void)returnBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"completed");
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num =0;
    switch (section) {
        case 0:
            num = 1;
            break;
            
        case 1:
            num = 7;
            break;
            
        case 2:
            num = 2;
            break;
        default:
            break;
    }
    
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section  = indexPath.section;
    switch (section) {
        case 0: {
            CenterHeaderCell *cell = [[CenterHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerIdentifier"];
             cell.delegate = self;
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_userDict[@"headimgurl"]]];
            cell.imgCollectionView.delegate = self;
            cell.imgCollectionView.dataSource = self;
            [cell.imgCollectionView registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:kimageCollectionViewCell];
            [cell.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(collectionHeight);
            }];
            return cell;
        }
            break;
        case 1:{
            InviteTableViewCell *cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"attrIdentifier"];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
             NSInteger row = [indexPath row];
            if(row < 6){
                cell.underLineImageView.image = [UIImage imageNamed:@"underline"];
            }
           
            if(row == 0){
                UIImage *image = [UIImage imageNamed:@"col"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.center = cell.typeLabel.center;
                [imageView sizeToFit];
                [cell.typeLabel addSubview:imageView];
                cell.textfield.text = @"基本资料";
                cell.textfield.textColor = [UIColor grayColor];
                cell.textfield.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                cell.textfield.userInteractionEnabled = NO;
            }else{
                CGSize size = CGSizeMake(50, 20);
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
                [cell.typeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
                cell.typeLabel.textAlignment = NSTextAlignmentLeft;
                cell.typeLabel.text = kAttributeList[row - 1];
                cell.typeLabel.textColor = [UIColor grayColor];
                cell.textfield.delegate =self;
                cell.textfield.tag = row+1;
                cell.tag = row+10;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if(userInfo.count >0){
                    NSString *str = [userInfo objectAtIndex:row];
                    if(str.length >0){
                        cell.textfield.text = str;
                    }else{
                        cell.textfield.placeholder =kPlaceHoldList[row];
                    }
                }
                
                
                if(row == 2){ //只有昵称可编辑
                    cell.textfield.userInteractionEnabled = YES;
                    cell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                    cell.textfield.autoresizesSubviews = YES;
                    cell.textfield.autocorrectionType = UITextAutocorrectionTypeDefault;
                    cell.textfield.returnKeyType = UIReturnKeyDone;
                }else{
                     cell.textfield.userInteractionEnabled = NO;
                }
                
                
            }
            return cell;
        }
            break;
            
        case 2:{
            InviteTableViewCell *cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favoriteCellIdentifier"];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            NSInteger row = [indexPath row];
            if(row == 0){
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"col"]];
                imageView.center = cell.typeLabel.center;
                [imageView sizeToFit];
                [cell.typeLabel addSubview:imageView];
                cell.textfield.text = @"我的兴趣标签";
                cell.textfield.textColor = [UIColor grayColor];
                cell.textfield.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }else{
                cell.selectionStyle  = UITableViewCellSelectionStyleNone;
                SKTagView *tagView = ({
                    SKTagView *skView = [[SKTagView alloc] init];
                    skView.padding  = UIEdgeInsetsMake(3, 3, 3, 3);
                    skView.lineSpace = 2;
                    skView.insets = 5;
                    skView;
                });
                [cell addSubview:tagView];
                [tagView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.mas_equalTo(cell.mas_left).offset(12);
                    make.top.mas_equalTo(cell.mas_top).offset(1);
                    make.right.mas_equalTo(cell.mas_right).offset(5);
                    make.bottom.mas_equalTo(cell.mas_bottom).offset(-5);
                }];
                [self setupTagView:tags withView:tagView];
                
            }
            return cell;
        }
            
        default:
            break;
    }
    return nil;
}


- (void)setupTagView:(NSArray *)tagList withView:(SKTagView *)tagView
{
    //Add Tags
    for (NSDictionary *tagItem in tagList) {
        SKTag *tag = [SKTag tagWithText:tagItem[@"name"]];
        tag.textColor = [UIColor whiteColor];
        tag.bgColor = [UIColor colorFromHexString:tagItem[@"bg_color"]];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
        [tagView addTag:tag];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return 0.1;
    }else{
        return 1.0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section= indexPath.section;
    if(section == 0){
        return collectionHeight +PHONE_NAVIGATIONBAR_HEIGHT + 115 + 20;
    }else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 13.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InviteTableViewCell *cell = (InviteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if(row != 2){
        InviteTableViewCell *nameCell = (InviteTableViewCell *)[subTableView viewWithTag:2+10];
        if(nameCell.textfield.isFirstResponder){
            [nameCell.textfield resignFirstResponder];
        }
    }
    
    CGRect rect = CGRectMake(0, self.view.frame.size.height- 200, self.view.frame.size.width, 200);
        if(section == 1){
            attrPickerView.tag = row;
             NSString *name = kCellIndexAndName[[NSString stringWithFormat:@"%ld",(long)row]];
        switch (row) {
             case 2:
                [cell.textfield becomeFirstResponder];
                break;
                
            case 3:
                [self showPickerViewWithKey:name withRect:rect];
                break;
              
            case 4:{
                datePickerView.tag = row;
                NSDate *birthday = [self getDrithday:userDictInfo[@"age"]];
                [datePickerView setDate:birthday];
                [DatePickerView showDatePicker:datePickerView rect:rect onView:self.view];
            }
                break;
              
            case 5:
                [self showPickerViewWithKey:name withRect:rect];
                break;
            case 6:
                [self showPickerViewWithKey:name withRect:rect];
                break;
                
            default:
                break;
        }
        
    }else if (section == 2){
        TagViewController *tagViewController = [[TagViewController alloc] init];
        tagViewController.tagList = userDictInfo[@"tags"];
        [self.navigationController pushViewController:tagViewController animated:YES];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"set cell layout");
    CGFloat width = (SCREEN_WIDTH - (4 * 10))/3;
    return CGSizeMake(width, width);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imgArr count]?[imgArr count]:1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSString static *identifier = kimageCollectionViewCell;
    InfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger num = [browserImgs count];
    if(num >0){
        if(num < 6 && num == row){
            [self initlizeUploadCell:cell image:imgArr[row][@"img"]];
        }else{
            NSDictionary *dict = [imgArr objectAtIndex:row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
        }
    }else if([imgArr count] == 1){
        [self initlizeUploadCell:cell image:imgArr[row][@"img"]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    browser = [self setPhotoBroswer:row];
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)initlizeUploadCell:(InfoCollectionCell *)cell image:(UIImage *)image {
    cell.imageView.image = image;
    cell.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImg:)];
    [cell.imageView addGestureRecognizer:tapGesture];
}

#pragma textField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    nickname = textField.text;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"end editing");
    [textField resignFirstResponder];
    NSString *modifyName = textField.text;
    if(![modifyName isEqualToString:nickname]){
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kProfilePost];
        NSDictionary *dict = @{@"nickname":modifyName};
        [self submitToServer:urlString params:dict];
        _userDict[@"nickname"] = modifyName;
        
    }
}

-(void)showPickerViewWithKey:(NSString *)key withRect:(CGRect)rect {
    NSDictionary *dict = attributeDict[key];
    NSArray *sorted = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        NSNumber *num1 = [NSNumber numberWithInteger:[obj1 integerValue]];
        NSNumber *num2 = [NSNumber numberWithInteger:[obj2 integerValue]];
        NSComparisonResult result = [ num1 compare:num2];
        return result == NSOrderedDescending;
    }];
    NSString *selected = userDictInfo[key];
    NSInteger selectedIndex = 0;
    mutablePickerArr = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSNumber *index  in sorted) {
        StringPickerViewItem *item = [StringPickerViewItem new];
        item.itemId = [index intValue];
        item.name   = dict[index];
        [mutablePickerArr addObject:item];
        if([ selected isEqual:item.name]){
            selectedIndex = item.itemId;
        }
    }
    
    [attrPickerView selectedRow:selectedIndex-1 andComponent:0];
    [attrPickerView loadData:mutablePickerArr];
    [StringPickerView showPickerView:attrPickerView withRect:rect onView:self.view];
}

-(void)stringPickerCancel{
    NSLog(@"string picker cancel");
    [StringPickerView hiddenPickerView:attrPickerView withRect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200) onView:self.view];
}

-(void)stringPickerDone:(long)index {
    
    NSLog(@"@string picker done");
    [StringPickerView hiddenPickerView:attrPickerView withRect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200) onView:self.view];
    StringPickerViewItem *item = [mutablePickerArr objectAtIndex:index];
    NSInteger tagValue = attrPickerView.tag;
    InviteTableViewCell *cell = (InviteTableViewCell *)[subTableView viewWithTag:tagValue+10];
    NSIndexPath *indexPath = [subTableView indexPathForCell:cell];
    
    NSString *title = kCellIndexAndName[[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    NSDictionary *dict = @{title:[NSNumber numberWithInt:item.itemId]};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kProfilePost];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *opteration,id obj){
        if(obj[@"success"]){
            userDictInfo[title] = item.name;
        }
        
    } failure:^(AFHTTPRequestOperation *operation ,NSError *error){
        [Common showErrorDialog:[NSString stringWithFormat:@"%@",error]];
    }];
    cell.textfield.text = item.name;
}

-(void)datePickerCancel {
    [DatePickerView hiddenDatePicker:datePickerView rect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200) onView:self.view];
}

-(void)datePickerDone:(NSDate *)date {
     [DatePickerView hiddenDatePicker:datePickerView rect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200) onView:self.view];
    NSInteger tagValue = datePickerView.tag;
     InviteTableViewCell *cell = (InviteTableViewCell *)[subTableView viewWithTag:tagValue+10];
    NSString *dateString = [Common formatedDateString:date format:@"yyyy-MM-dd"];
    cell.textfield.text = dateString;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    InviteTableViewCell *cell = (InviteTableViewCell *)[subTableView viewWithTag:12];
    NSLog(@"x:%f,y:%f,w:%f,h:%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


//图片预览
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [browserImgs count];
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
 
    if(index < browserImgs.count){
        return [browserImgs objectAtIndex:index];
    }
    return nil;
}


-(MWPhotoBrowser *)setPhotoBroswer :(NSInteger)index {
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton     = NO;
    browser.displayNavArrows        = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill        = YES;
    browser.enableGrid              = YES;
    browser.enableSwipeToDismiss    = YES;
    browser.alwaysShowControls      = NO;
    browser.startOnGrid             = NO;
    browser.delayToHideElements     = YES;
    [browser setCurrentPhotoIndex:index];
    [browser setStartOnGrid:NO];
    return browser;
}

-(void)uploadImg:(UITapGestureRecognizer *)tap {
    imagePickerViewTag = 2;
    [self showActionSheet];
}


-(void)changeHeadImage:(UITapGestureRecognizer *)tap {
    imagePickerViewTag = 1;
    [self showActionSheet];
}

-(void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"相册中选取",@"图库中选取",
                                  nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self pickFromAlbum];
            break;
        case 2:
            [self pickFromGallery];
            break;
            
        default:
            break;
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"cancel sheet");
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"dismiss_%ld",buttonIndex);
}


//拍照
-(void)takePhoto {
    NSLog(@"take photo");
    if(![self isCameraAvailable]){
        [Common showErrorDialog:@"无法使用相机"];
    }else{
        if(_imagePicker == nil){
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate       = self;
            _imagePicker.sourceType     = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.allowsEditing  = YES;
        }
        [self presentViewController:_imagePicker animated:YES completion:^(void){
            NSLog(@"开始拍照");
        }];
    }
}

//相册中选择
-(void)pickFromAlbum {
    if(_imagePicker == nil){
        NSLog(@"pick from album");
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate       = self;

    }
    _imagePicker.view.tag       = imagePickerViewTag;
    _imagePicker.sourceType     = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
//图库中选择
-(void)pickFromGallery {
    if(_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

//摄像头是否可用
-(BOOL)isCameraAvailable {
    
    return [UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//前摄像头是否可用
-(BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
//后摄像头是否可用
-(BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


//是否支持拍照
-(BOOL)isSupportTakingPhoto {
    return [self canSupportMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

//是否支持摄像
-(BOOL)isSupportShottingVideo {
    return [self canSupportMedia:(NSString *)kUTTypeVideo sourceType:UIImagePickerControllerSourceTypeCamera];
}

//是否支持某一种媒体操作
-(BOOL)canSupportMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType {
    __block BOOL result = NO;
    if(mediaType.length == 0){
        return NO;
    }
    NSArray *availTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availTypes enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        
        NSString *selectedeida = obj;
        if([selectedeida isEqualToString:mediaType]){
            result = YES;
            *stop  = YES;
        }
    }];
    
    return result;
}


#pragma imagepickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSInteger tag = picker.view.tag;
    NSLog(@"%ld",(long)tag);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(picker.sourceType== UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        NSLog(@"相册");
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CenterHeaderCell *cell = (CenterHeaderCell *)[subTableView cellForRowAtIndexPath:indexPath];
     
        
        UIActivityIndicatorView *activityView = ({
            UIActivityIndicatorView *activityIndicatorView = [UIActivityIndicatorView new];
            activityIndicatorView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
            activityIndicatorView.hidesWhenStopped = YES;
            activityIndicatorView;
        });
        [cell.headImageView addSubview:activityView];
        [activityView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.mas_equalTo(cell.headImageView.mas_centerX);
            make.centerY.mas_equalTo(cell.headImageView.mas_centerY);
            make.width.mas_equalTo(@25);
            make.height.mas_equalTo(@25);
        }];
        [activityView startAnimating];
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *encodeImg = [data base64EncodedStringWithOptions:0];
        NSString *urlstring = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kProfilePost];
        NSString *base = @"data:image/png;base64,";
        NSString *imgtring = [NSString stringWithFormat:@"%@%@",base,encodeImg];
        NSDictionary *dict = @{@"headimg":imgtring};
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        [manager POST:urlstring parameters:dict success:^(AFHTTPRequestOperation *operation,id obj){
            if(obj[@"success"]){
                cell.headImageView.image = image;
                cell.headImageView.contentMode = UIViewContentModeScaleAspectFill;
                [activityView stopAnimating];
                isNewHeadImg = YES;
            }
        } failure:^(AFHTTPRequestOperation *operatoin,NSError *error){
            NSLog(@"%@",error);
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)savePhoto:(UIButton *)button {
    if(button.tag == 100){
        button.layer.borderColor = [UIColor redColor].CGColor;
        [button setTitle:@"完 成" forState:UIControlStateNormal];
        [button setTag:11];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    }else{
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setTitle:@"编 辑" forState:UIControlStateNormal];
        [button setTag:11];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

@end
