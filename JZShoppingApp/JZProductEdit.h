//
//  JZProductEdit.h
//  JZShoppingApp
//
//  Created by jihong zhang on 4/30/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZProductCell.h"
#import "JZProtocol.h"


@protocol CheckBoxDelegate;


/** This page is for edit and add product
 */
@interface JZProductEdit : UIViewController <UITextFieldDelegate, UITextViewDelegate, EditItemDelegate, CheckBoxDelegate>

/** This page is sharded by edit and add product
 *  when pageTypeIsEditable is true, it is for edit, otherwise
 *  for add product
 */
@property (nonatomic) bool pageTypeIsAdding;

@property (nonatomic) UIButton *buttonSave;
@property (nonatomic) UIButton *buttonCacel;

/** item hold all the product information
 *  @ref JZProductCell
 */
@property (nonatomic) JZProductCell *item;

@property (nonatomic, retain) id<EditItemDelegate> delegate;

-(id)initWithProductCell:(JZProductCell*)productCell;

/** callback function for save the changes for editing or   
 *  save the new added product info
 */
-(void)saveChanges:(id)sender;

/** callback for cancel the changes or adding the product
 */
-(void)resetChanges:(id)sender;

@end



 