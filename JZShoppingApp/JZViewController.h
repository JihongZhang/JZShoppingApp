//
//  JZViewController.h
//  JihongHomeProducts
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZProductCell.h"
#import "JZProtocol.h"
#import "JZButtonAction.h"


@interface JZViewController : UITableViewController <EditItemDelegate, TableCellDelegate>

/** page type of editable or none editable 
 editable is for verder use, allowe add, delete, and edit
 none editable is for shopper, viwing only
 */
@property(nonatomic, assign) int buttonIndex;


@property(nonatomic) JZButtonAction *buttonAction;

@end
