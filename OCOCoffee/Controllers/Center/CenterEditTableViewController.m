//
//  CenterEditTableViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kimageCollectionViewCell  @"imageCollectioinViewCell"
#define kUserInfo                 @"api/user/info"
#define kAttributeURL            @"api/user/attr"
#define kAttributeList            @[@"咖 啡 I D:",@"昵       称:",@"性       别:",@"出生日期:",@"所在行业:",@"学       历:"]
#define kPlaceHoldList            @[@"", @"请输入",@"暂无",@"请选择日期",@"请选择所在行业",@"请选择学历"]

#import "CenterEditTableViewController.h"
#import "UIColor+colorBuild.h"
#import "ViewStyles.h"
#import "Global.h"
#import "LoginViewController.h"
#import "InfoCollectionCell.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SKTagView/SKTagView.h>
#import "InviteTableViewCell.h"
#import "StringPickerView.h"
#import "StringPickerViewItem.h"
#import "DatePickerView.h"
#import "TagViewController.h"

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

-(void)formatUserData:(NSMutableDictionary *)dict {
    NSString *constellation = dict[@"constellation"]?dict[@"constellation"]:@"";
    NSString *uid = _userDict[@"uid"];
    NSString *nickname = dict[@"nickname"]?dict[@"nickname"]:@"";
    NSString *sex = ((int)dict[@"sex"] == 2)?@"女":@"男";
    NSString *birthday = @"";
    if(dict[@"age"] != nil){
        birthday = [self birthdayString:dict[@"age"]];
    }
    NSString *job = dict[@"job"]?dict[@"job"]:@"";
    NSString *edu = dict[@"education"]?dict[@"education"]:@"";
    NSArray *data = [[NSArray alloc] initWithObjects:constellation,uid,nickname,sex,birthday,job,edu, nil];
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
            NSDictionary *dict = @{@"img":[UIImage imageNamed:@"invite"]};
            [imgArr addObject:dict];
        }
    }else{
        NSDictionary *dict = @{@"img":[UIImage imageNamed:@"invite"]};
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
    NSLog(@"TableView Cell");
    
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
    NSLog(@"section:%ld row:%ld ",section,(long)row);
    
    if(row != 2){
        InviteTableViewCell *nameCell = (InviteTableViewCell *)[subTableView viewWithTag:2+10];
        if(nameCell.textfield.isFirstResponder){
            [nameCell.textfield resignFirstResponder];
            NSLog(@"text:%@",nameCell.textfield.text);
        }
    }
    
    CGRect rect = CGRectMake(0, self.view.frame.size.height- 200, self.view.frame.size.width, 200);
        if(section == 1){
            attrPickerView.tag = row;
        switch (row) {
             case 2:
                [cell.textfield becomeFirstResponder];
                break;
                
            case 3:
                [self showPickerViewWithKey:@"sex" withRect:rect];
                break;
              
            case 4:{
                datePickerView.tag = row;
                NSDate *birthday = [self getDrithday:userDictInfo[@"age"]];
                [datePickerView setDate:birthday];
                [DatePickerView showDatePicker:datePickerView rect:rect onView:self.view];
            }
                break;
              
            case 5:
                [self showPickerViewWithKey:@"job" withRect:rect];
                break;
            case 6:
                [self showPickerViewWithKey:@"education" withRect:rect];
                break;
                
            default:
                break;
        }
        
    }else if (section == 2){
        TagViewController *tagViewController = [[TagViewController alloc] init];
        //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tagViewController];
        [self.navigationController pushViewController:tagViewController animated:YES];
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
    NSLog(@"begin textfield edit");
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"end editing");
    [textField resignFirstResponder];
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

-(void)uploadImg:(UITapGestureRecognizer *)tap {
    [self showActionSheet];
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


-(void)changeHeadImage:(UITapGestureRecognizer *)tap {
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
    NSLog(@"Selected:%ld",(long)buttonIndex);
    
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if(picker.sourceType== UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        
    }
    //headImageView.image = image;
    //headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)savePhoto:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
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
