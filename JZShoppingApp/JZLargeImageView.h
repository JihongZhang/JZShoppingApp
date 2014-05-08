//
//  JZLargeImageView.h
//  JZShoppingApp
//
//  Created by jihong zhang on 4/28/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZProductCell.h"

@interface JZLargeImageView : UIViewController

/** large image view of the product
 */
@property (nonatomic) UIImageView *imageView;

/** hold all the product information @see JZProductCell
 */
@property (nonatomic) JZProductCell *productCell;


@end
