//
//  DialogueViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/24.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "DialogueViewController.h"
#import "NSUserDefaults+Settings.h"
#import <MJRefresh/MJRefresh.h>

@interface DialogueViewController (){
    
    NSMutableArray *chatRecords;
    
}

@end

@implementation DialogueViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"聊天记录";
    
    self.senderId = kJSQAvatarIdSelf;
    self.senderDisplayName =kJSQAvatarDisplayNameSelf;
    
    self.automaticallyScrollsToMostRecentMessage  = YES;
    //self.showLoadEarlierMessagesHeader = YES;
    self.showTypingIndicator = YES;
    
    self.modelData = [[DialogueModelData alloc] init];
    NSLog(@"modelData:%@",self.modelData.dataList);
    chatRecords = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.inputToolbar.contentView.textView.pagingEnabled = YES;
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    
    //聊天用户的图像
    if(![NSUserDefaults incomingAvatarSetting]){
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    }
    
    if(![NSUserDefaults outcomingAvatarSettings]){
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
    
    self.collectionView.header = [MJRefreshHeader headerWithRefreshingBlock:^(void){
        [self.modelData loadDataFromServer];
        [self loadEarlierMessage];
    }];
    
    [self.collectionView.header beginRefreshing];
    
    self.tabBarController.tabBar.hidden = YES;

}

-(void)loadEarlierMessage {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"refreshing");
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
}


#pragma JSQMessage collectionview datasoure mathod

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.modelData.dataList objectAtIndex:indexPath.item];
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {

    [self.modelData.dataList removeObjectAtIndex:indexPath.item];
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message  = [self.modelData.dataList objectAtIndex:indexPath.item];
    
    NSLog(@"%@",message.senderId);
    
    if([message.senderId isEqualToString:self.senderId]){
        return self.modelData.outgoingBubbleImageData ;
    }
    
    return self.modelData.incomingBubbleImageData;
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.modelData.dataList objectAtIndex:indexPath.item];
    
    if([message.senderId isEqualToString:self.senderId]){
        if(![NSUserDefaults outcomingAvatarSettings]){
            return nil;
        }
    }else {
        if(![NSUserDefaults incomingAvatarSetting]){
            return nil;
        }
    }
    
    return [self.modelData.avatars objectForKey:message.senderId];
}


-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.item %3 ==0){
        JSQMessage *message = [self.modelData.dataList objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.modelData.dataList objectAtIndex:indexPath.item];
    
    if([message.senderId isEqualToString:self.senderId]){
        return nil;
    }
    
    if(indexPath.item -1 >0) {
        JSQMessage *previousMessage = [self.modelData.dataList objectAtIndex:indexPath.item];
        if([previousMessage.senderId isEqualToString:self.senderId]){
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:self.senderDisplayName];
}



#pragma UICollectionView delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.modelData.dataList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath ];
    
    JSQMessage *message = [self.modelData.dataList objectAtIndex:indexPath.item];
    
    if(!message.isMediaMessage){
        if([message.senderId isEqualToString:self.senderId]){
            cell.textView.textColor = [UIColor blackColor];
        }else{
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:cell.textView.textColor,
                                             NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle| NSUnderlineStyleNone)};
        
    }
    
    return cell;
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return 3.0;
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.item % 3 == 0){
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0;
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *currentMessage = [self.modelData.dataList objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.modelData.dataList objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}


-(BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    return YES;
}


-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text
                           ];
    [self.modelData.dataList addObject:message];
    
     [self.modelData sendMessage:text friendId:11];
    
    [self finishSendingMessage];
}



@end
