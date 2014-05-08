//
//  JZProductsModel.h
//  sqliteTest
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZProductCell.h"


@interface JZProductsModel : NSObject

/** This is interface for the control to get all the products data
 */
+(id)getProductsData;

/** This is the interface for the control to insert one product into DB
 *  The product data is hold in product @ref JZProductCell
 */
+(void)insertOneProductToDb:(JZProductCell*)product;

/** This is the interface for the control to delete one product from DB
 *  productId should be > 0, otherwise do nothing
 */
+(void)deleteOneProductFromDb:(int)productId;

@end
