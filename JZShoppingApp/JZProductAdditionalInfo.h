//
//  JZProductAdditionalInfo.h
//  JZShoppingApp
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZProductCell.h"

@class JZProductCell;

/** For display description, stores info
 */
@interface JZProductAdditionalInfo : UIViewController <UITextFieldDelegate>

/** hold all the product infomation @ref JZProductCell
 */
@property (nonatomic) JZProductCell *productCell;

/** init with product infomation:  productCell @ref JZProductCell
 */
 
-(id)initWithProductCell:(JZProductCell*)productCell;

@end

 
