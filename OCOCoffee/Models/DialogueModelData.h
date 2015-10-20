//
//  DialogueModelData.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import <UIKit/UIKit.h>

static  NSString *  kJSQAvatarIdSelf = @"003-453-755-865";
static  NSString *  kJSQAvatarIdFriend = @"005-757-989-332";

static NSString  *  kJSQAvatarDisplayNameSelf = @"文胆剑心";
static NSString  *  kJSQAvatarDisplayNameFriend=@"Jacky";


@interface DialogueModelData : NSObject

@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) NSDictionary *avatars;
@property(nonatomic,strong) NSDictionary *users;


@property(nonatomic,strong)  JSQMessagesAvatarImage *selfHeadImage;
@property(nonatomic,strong)  JSQMessagesAvatarImage *frinedHeadImage;
@property(nonatomic,strong)  JSQMessagesBubbleImage *outgoingBubbleImageData;
@property(nonatomic,strong)  JSQMessagesBubbleImage *incomingBubbleImageData;

-(void)loadDataFromServer;

-(BOOL)sendMessage:(NSString *)message friendId:(NSInteger)fid;

@end
