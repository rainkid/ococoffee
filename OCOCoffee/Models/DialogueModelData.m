//
//  DialogueModelData.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "DialogueModelData.h"
#import "NSUserDefaults+Settings.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>
#import "Global.h"

#define kMessageList @"api/message/my"
#define kMessageSend @"api/message/send"



@implementation DialogueModelData

-(instancetype)init {
    
    self.dataList = [[NSMutableArray alloc] initWithCapacity:0];
    if(self = [super init]){
        self.users   = @{kJSQAvatarIdSelf:kJSQAvatarDisplayNameSelf,
                         kJSQAvatarIdFriend:kJSQAvatarDisplayNameFriend};
        
        
        
        JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    return self;
}




-(void) loadDataFromServer {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kMessageList];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id response){
        //NSLog(@"%@",response[@"data"]);
        if([response[@"data"] isKindOfClass:[NSDictionary class]]){
            [self formatData:response[@"data"]];
        }

    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"error:%@",error);
    }];
}

-(void)formatData:(NSDictionary *)dict{
    
    if([dict[@"list"] count] >0 && [dict[@"list"] isKindOfClass:[NSArray class]]){
        for (NSDictionary *detail in dict[@"list"]) {
            id isMe = [detail objectForKey:@"isme"];
            int value = [isMe intValue];
            if(value){
                JSQMessage *message = [[JSQMessage alloc] initWithSenderId:kJSQAvatarIdSelf
                                                         senderDisplayName:kJSQAvatarDisplayNameSelf
                                                                      date:[NSDate distantPast]
                                                                      text:detail[@"message"]
                                       ];
                [ self.dataList addObject:message];
                
                if(_selfHeadImage == nil){
                    NSLog(@"load headimage");
                    NSURL *imageURL = [NSURL URLWithString:detail[@"from_headimgurl"]];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    //UIImage *image = [manager imageWithURL:imageURL];
                        [manager downloadImageWithURL:imageURL
                                              options:SDWebImageContinueInBackground
                                             progress:^(NSInteger receivedSize,NSInteger expectedSize){
                                                 NSLog(@"%ld:%ld",(long)receivedSize,(long)expectedSize);
                                                 
                                             }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                 if(finished == YES){
                                                     _selfHeadImage = [JSQMessagesAvatarImageFactory
                                                                       avatarImageWithImage:image
                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault
                                                                       ];
                                                 }
                                             }];
                    }
                
            }else{
                JSQMessage *message = [[JSQMessage alloc] initWithSenderId:kJSQAvatarIdFriend
                                                         senderDisplayName:kJSQAvatarDisplayNameFriend
                                                                      date:[NSDate distantPast]
                                                                      text:detail[@"message"]
                                       ];
                [self.dataList addObject:message];
                
                if(_frinedHeadImage == nil){
                    NSURL *imageURL = [NSURL URLWithString:detail[@"from_headimgurl"]];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    //UIImage *image = [manager imageWithURL:imageURL];
                    [manager downloadImageWithURL:imageURL
                                          options:SDWebImageContinueInBackground
                                         progress:^(NSInteger receivedSize,NSInteger expectedSize){
                                             NSLog(@"%ld:%ld",(long)receivedSize,(long)expectedSize);
                                             
                                         }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                             if(finished == YES){
                                                 _frinedHeadImage = [JSQMessagesAvatarImageFactory
                                                                   avatarImageWithImage:image
                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault
                                                                   ];
                                             }
                                         }];

                }
            }
        }
    }
    
    self.avatars = @{kJSQAvatarIdSelf:_selfHeadImage,
                     kJSQAvatarIdFriend:_frinedHeadImage};
}


-(void)setHeadImage:(NSString *)imageString{
    
}


-(BOOL)sendMessage:(NSString *)message friendId:(NSInteger)fid {
    
    __block BOOL result= FALSE ;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kMessageSend];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *params = @{@"message":message,@"to_uid":@11};
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
        
        if([obj isKindOfClass:[NSDictionary class]]){
            int flag  = [obj[@"success"] intValue];
            if(flag){
                result = TRUE;
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        result = TRUE;
        NSLog(@"%@",error);
    }];
    
    return result;
}
@end
