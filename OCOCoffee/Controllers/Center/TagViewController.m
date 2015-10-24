//
//  TagViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/16.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TagViewController.h"
#import <SKTagView/SKTag.h>
#import <SKTagView/SKTagView.h>
#import <SKTagView/SKTagButton.h>
#import <Masonry/Masonry.h>
#import "TagItem.h"
#import "Common.h"
#import "ViewStyles.h"
#import "UIColor+colorBuild.h"
#import <AFNetworking/AFNetworking.h>


#define ktagListURL         @"/api/usertag/tags"
#define kTagCheck           @"/api/user/check_tag"
#define kTagsPost           @"api/usertag/usertags_post"

static const CGFloat kHeight = 48.6f;
static const CGFloat kTableLeftSide = 23.3f;
static const CGFloat kButtonHeight = 43;


@interface TagViewController ()<UITextFieldDelegate>{
    
    UITextField *_textField;
    SKTagView *_tagView;
    UIButton *_button;
    NSInteger _selectTagCount;
    NSMutableArray *_tags;
    NSMutableArray *_tag_ids;
    NSMutableArray *_tagData;
    NSMutableArray *_tagNames;
    NSMutableDictionary *_tagsDict;
    NSMutableArray *_userAddedTags;
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation TagViewController

-(id)init{
    
    if(self= [super init]){
        _tag_ids = [[NSMutableArray alloc] initWithCapacity:1];
        _tagNames = [[NSMutableArray alloc] initWithCapacity:1];
        _userAddedTags = [[NSMutableArray alloc] initWithCapacity:1];
        _manager = [[AFHTTPRequestOperationManager alloc]init];

    }
    return self;
}


-(void)viewDidLoad {
    
    self.title = @"选择标签";
    
    [ViewStyles setNaviControllerStyle:self.navigationController];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(returnBack)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    
    [self initlizeView];

    
    [self loadTags];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    _manager =nil;
}

-(void)initlizeView {
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT+PHONE_STATUSBAR_HEIGHT+10);
        make.height.mas_equalTo(PHONE_CONTENT_HEIGHT);
    }];
    
    _textField = ({
        UITextField *textField = [UITextField new];
        textField.placeholder = @"  添加自定义标签（2-5个字符）";
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 3;
        textField.returnKeyType = UIReturnKeyDone;
        textField.layer.masksToBounds = YES;
        textField;
    });
    _textField.delegate = self;
    [view addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(kHeight);
    }];
    
    UIImageView *plusView= [UIImageView new];
    plusView.userInteractionEnabled = YES;
    [plusView setImage:[UIImage imageNamed:@"regis_plus"]];
    [view addSubview:plusView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plus)];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setNumberOfTapsRequired:1];
    [plusView addGestureRecognizer:singleTap];
    
    
    [plusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_top);
        make.height.and.width.equalTo(_textField.mas_height);
        make.right.equalTo(_textField.mas_right).offset(-5);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = @"给TA印象更深，您可以选择1-5个标签";
    label.textColor = [UIColor colorFromHexString:@"#aaaaaa"];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textField.mas_left);
        make.height.mas_equalTo(kHeight);
        make.top.equalTo(_textField.mas_bottom);
    }];

  
   // _selectTagCount = 0;
    _tagView = ({
        SKTagView *view = [SKTagView new];
        view.padding    = UIEdgeInsetsMake(0, 0, 0, 0);
        view.insets    = 10;
        view.lineSpace = 10;
        __weak SKTagView *weakView = view;
        _selectTagCount = [_tagList count];
        //Handle tag's click event
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            SKTagButton *tagBtnView = [weakView.subviews objectAtIndex:index];
         
            NSUInteger sysTagsCount = [_tagData count];
            NSLog(@"%lu,%lu",(unsigned long)index,sysTagsCount);
        
            if(index >= sysTagsCount){ //用户手动添加的标签
                if(tagBtnView.tag == 1){
                    _selectTagCount--;
                    tagBtnView.backgroundColor = [UIColor whiteColor];
                    [tagBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_userAddedTags removeObject:tagBtnView.titleLabel.text];
                    tagBtnView.tag = 0;
                }else{
                    if (_selectTagCount < 5){
                        _selectTagCount++;
                        tagBtnView.backgroundColor = [UIColor colorFromHexString:@"hrer39"];
                        [tagBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_userAddedTags addObject:tagBtnView.titleLabel.text];
                        tagBtnView.tag = 1;
                    }else{
                        [Common showErrorDialog:@"最多只能选择5个标签"];
                    }
                }
            }else{ //系统原来自有标签
                NSDictionary *info = [_tagData objectAtIndex:index];
                if([_tag_ids containsObject:info[@"id"]]){
                    tagBtnView.tag = 1;
                }
                if(tagBtnView.tag == 1){
                    _selectTagCount--;
                    tagBtnView.backgroundColor = [UIColor whiteColor];
                    [tagBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_tag_ids removeObject:info[@"id"]];
                    tagBtnView.tag = 0;
                }else{
                    if(_selectTagCount < 5){
                        _selectTagCount++;
                        [tagBtnView setBackgroundColor:[UIColor colorFromHexString:info[@"bg_color"]]];
                        [tagBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_tag_ids addObject:info[@"id"]];
                        tagBtnView.tag = 1;
                    }else{
                        [Common showErrorDialog:@"最多只能选择5个标签"];
                    }
                }
                
            }
            
            NSLog(@"%@",_tag_ids);
            NSLog(@"%@",_userAddedTags);
            NSLog(@"%ld",(long)_selectTagCount);
            
//            if(tagBtnView.tag == 1){
//                _selectTagCount--;
//                tagBtnView.backgroundColor = [UIColor whiteColor];
//                [tagBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_tag_ids removeObject:info[@"id"]];
//                tagBtnView.tag = 0;
//            }else{
//                if(_selectTagCount == 5){
//                    [Common showErrorDialog:@"最多只能选择5个标签"];
//                }
//                
//                if(index >=[_tagData count]){ //如果选中的是用户手动添加的
//                    
//                }
//                
//            }
//            
            
            
        
            
            
            
//            //只能选中5个标签及标签选中、取消状态变化
//            if (tagBtnView.tag == 1) {
//                _selectTagCount--;
//                tagBtnView.backgroundColor = [UIColor whiteColor];
//                [tagBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                tagBtnView.tag = 0;
//                [_tag_ids removeObject:info[@"id"]];
//            } else {
//                if (_selectTagCount < 5) {
//                    if (tagBtnView.tag == 0) {
//                        _selectTagCount++;
//                        if (index >= [_tagData count]) {
//                            tagBtnView.backgroundColor = [UIColor colorFromHexString:@"#c9dd22"];
//                            [_tags addObject:tagBtnView.titleLabel.text];
//                        } else {
//                            [_tag_ids addObject:info[@"id"]];
//                            tagBtnView.backgroundColor = [UIColor colorFromHexString:info[@"bg_color"]];
//                        }
//                        [tagBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                        tagBtnView.tag = 1;
//                    }
//                } else {
//                    [Common showErrorDialog:@"只能选择5个标签"];
//                }
//            }
//            
//            NSLog(@"%@",_tag_ids);
        };
        
        view;
    });
    [view addSubview:_tagView];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_textField.mas_bottom).offset(kHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        //make.height.mas_equalTo(kButtonHeight+50);
    }];
    
    
    _button = ({
        UIButton *btn = [UIButton new];
        btn.backgroundColor = [UIColor colorFromHexString:@"#fb7180"];
        [btn setTitle:@"完  成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 2;
        btn;
    });
    [view addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_tagView.mas_bottom).offset(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(kHeight);
    }];
}

-(void)loadTags{
    if(_tagData == nil){
        _tagData = [[NSMutableArray alloc] initWithCapacity:1];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN, ktagListURL];
        NSDictionary *params = @{@"type_id":@1};
        [_manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
            if([obj[@"data"] count] >0){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    _tagData = [NSMutableArray arrayWithArray:obj[@"data"]];
                    [self initTags:_tagData];
                });
              
            }
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error){
           
            [Common showErrorDialog:@"数据加载失败"];
            
        }];

    }
}



-(void)initTags:(NSMutableArray *)tags {
    _tagsDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray *allTagIds = [[NSMutableArray alloc] initWithCapacity:0];
    if([_tagList count] >0){//原来已选中的Tag
        for (NSDictionary *tmp in _tagList) {
            [_tag_ids addObject:tmp[@"id"]];
            _tagsDict[tmp[@"id"]] = tmp;
        }
    }
    
    for (NSDictionary *dict  in tags) {
         SKTag *tag = [self oneTag:dict[@"name"]];
        if([_tag_ids containsObject:dict[@"id"]]){
            NSString *bgColor = _tagsDict[dict[@"id"]][@"bg_color"];
            tag.bgColor = [UIColor colorFromHexString:bgColor];
            tag.textColor = [UIColor whiteColor];
        }else{
            tag.bgColor = [UIColor whiteColor];
        }
        [_tagNames addObject:dict[@"name"]];
        [allTagIds addObject:dict[@"id"]];
        [_tagView addTag:tag];
    }
    
    for (NSDictionary *tagMsg in _tagList) {
        if(![allTagIds containsObject:tagMsg[@"id"]]){
            SKTag *tag = [self oneTag:tagMsg[@"name"]];
            tag.bgColor = [UIColor colorFromHexString:tagMsg[@"bg_color"]];
            tag.textColor = [UIColor whiteColor];
            [_tagView addTag:tag];
            [_tagNames addObject:tagMsg[@"name"]];
        }
    }
}


-(SKTag *)oneTag:(NSString *)name {

    SKTag *tag = [SKTag tagWithText:name];
    tag.font = [UIFont fontWithName:@"Helvica" size:16.0f];
    tag.cornerRadius = 3;
    tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    return tag;
}

-(void)plus {
    NSString *msg = _textField.text;
    if(msg == nil){
        [Common showErrorDialog:@"请输入标签名"];
        return;
    }
    
    if([msg length] > 10){
        [Common showErrorDialog:@"中文不要超过五个字，英文字母不要超过10个"];
        return;
    }

    if([_tagNames containsObject:msg]){
        [Common showErrorDialog:@"该标签已存在"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kTagCheck];
    NSDictionary *params  = @{@"name":msg};
    [_manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
        if([obj[@"success"] intValue]== 1){
            SKTag *tag = [self oneTag:msg];
            [_tagView addTag:tag];
            [_tagNames addObject:msg];
        }else{
            [Common showErrorDialog:obj[@"msg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Common showErrorDialog:[NSString stringWithFormat:@"%@",error]];
    }];
    
    return;

}


-(NSUInteger)unicodeLengthOfString:(NSString *)string {
    
    NSUInteger asciiLength = 0;
    for(NSUInteger i = 0;i<[string length]; i++){
        unichar uc = [string characterAtIndex:i];
        asciiLength += isascii(uc)?1:2;
    }
    NSLog(@"%lu",(unsigned long)asciiLength);
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength %2){
        unicodeLength++;
    }
    
    return unicodeLength;
}

-(void)returnBack{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"completed");
    }];
}


-(void)done{

    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kTagsPost];
    NSMutableArray *userTags = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *tagname in _userAddedTags) {
        NSString *bgColor = [self genRandColorString];
        NSDictionary *temp  = @{@"name":[NSString stringWithFormat:@"%@",tagname],@"bg_color":[NSString stringWithFormat:@"#%@",bgColor]};
        [userTags addObject:temp];
    }
    
    NSDictionary *params = @{@"tag_ids":_tag_ids,@"tags":userTags,@"type_id":@1};
    [_manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
        NSLog(@"num:%lu count:%@",(unsigned long)[_tag_ids count],userTags);
        if([obj[@"success"] intValue] == 1){
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
    }];
    
}

-(NSString *)genRandColorString {
    NSMutableArray *obj  = [[NSMutableArray alloc] initWithCapacity:6];
    NSString *str = @"abcde";
    int numberCount = arc4random()%4+1;
    for (int i = 0; i<numberCount; i++) {
        NSInteger randNum = arc4random()%10;
        [obj addObject:[NSNumber numberWithInteger:randNum]];
    }
    for (int j = 0; j< 6-numberCount; j++) {
        int index = arc4random()%[str length];
        
        NSRange range = [str rangeOfComposedCharacterSequenceAtIndex:index];
        NSString *ch = [str substringWithRange:range];
        [obj addObject:[NSString stringWithFormat:@"%@",ch]];
    }

    NSInteger count = [obj count];
    for (int m = 0; m < count; m++) {
        int n = (arc4random() % (count-m))+m;
        [obj exchangeObjectAtIndex:m withObjectAtIndex:n];
    }
    
    NSString *colorString  = [obj componentsJoinedByString:@""];
    return colorString;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch began");
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch end");
    _textField.text = @"";
    [_textField resignFirstResponder];
}
@end
