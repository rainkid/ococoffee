//
//  DialogueViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/24.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "DialogueModelData.h"

@interface DialogueViewController :JSQMessagesViewController<UIActionSheetDelegate,JSQMessagesComposerTextViewPasteDelegate>

@property(nonatomic,strong)DialogueModelData *modelData;



@end
