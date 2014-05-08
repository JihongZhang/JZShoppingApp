//
//  JZProductCell.h
//  DIYCell
//
//  Created by jihong zhang on 4/22/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** All the information for the product
 *  it including product name, regular price, sale price,
 *  product colors, product images,product description,
 *  and product store infomation
 *  there are two main parts:
 */
@interface JZProductCell : UITableViewCell 

@property (nonatomic, strong) id delegate;

//product info in cell for tableview UI
@property (nonatomic) NSString *name;
@property (nonatomic) double   regPrice;
@property (nonatomic) double   salePrice;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *images;


//product info for addtional display
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSMutableDictionary *stores;



//for internal use only, the unit indentity for the product
@property (nonatomic) int productId;

@property (nonatomic, assign) JZProductCell *product;

/** Button Image callback function
 */
-(void) buttonImageEnlargeCB:(id)sender;


@end
