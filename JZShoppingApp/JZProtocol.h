//
//  JZProtocol.h
//  JZShoppingApp
//
//  Created by jihong zhang on 5/7/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZProductCell.h"
#import "JZCheckBox.h"


/** table cell tap event protocol
 */
@protocol TableCellDelegate <NSObject>
@optional
-(void) buttonImageTappedOnCell:(id)sender;
-(void) buttonDetailTappedOnCell:(id)sender;
@end



/** product edit event protocol
 */
@protocol EditItemDelegate <NSObject>
@optional
-(void) onAddSuccess:(JZProductCell *)item;
-(void) onSaveEditSuccess:(JZProductCell *)item;
@end

