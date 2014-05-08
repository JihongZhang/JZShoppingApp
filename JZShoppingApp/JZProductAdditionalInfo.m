//
//  JZProductAdditionalInfo.m
//  JZShoppingApp
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZProductAdditionalInfo.h"
#import "JZConstants.h"

@interface JZProductAdditionalInfo ()

@property (nonatomic, retain) UILabel *labelViewViewStoreList;
@property (nonatomic, retain) UILabel *labelViewDesription;
@property (nonatomic, retain) UILabel *labelViewDescriptionInfo;

@end

@implementation JZProductAdditionalInfo

#pragma mark - init
#pragma mark initWithProductCell
-(id)initWithProductCell:(JZProductCell*)productCell
{
    self = [super init];

    if(self){
        CGFloat lableX = myMargin;
        CGFloat lableY = myMargin;
        CGFloat lableWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat lableHeight = myLabelHight;
    
        self.labelViewDesription = [[UILabel alloc] init];
        self.labelViewDesription.frame = CGRectMake(lableX, lableY, lableWidth, lableHeight);
        self.labelViewDesription.text = @"Product description:";
        [self.view addSubview:self.labelViewDesription];
        
        
        lableY = lableY+lableHeight+myMargin;
        self.labelViewDescriptionInfo = [[UILabel alloc] init];
        self.labelViewDescriptionInfo.frame = CGRectMake(lableX, lableY, lableWidth, lableHeight);
        self.labelViewDescriptionInfo.numberOfLines = 0;
        self.labelViewDescriptionInfo.text = productCell.description;
        [self.labelViewDescriptionInfo sizeToFit];
        [self.view addSubview:self.labelViewDescriptionInfo];        
        
        lableY = lableY + self.labelViewDescriptionInfo.frame.size.height + myMargin*2;
        self.labelViewViewStoreList = [[UILabel alloc] init];
        self.labelViewViewStoreList.frame = CGRectMake(lableX, lableY, lableWidth, lableHeight);
        
        NSString *storeInfo = @"Stores:\n";
        for(id key in productCell.stores ){
            storeInfo = [storeInfo stringByAppendingFormat:@"%@\n%@\n", key, (NSString*)productCell.stores[key]];
        }

        self.labelViewViewStoreList.text = storeInfo;
        self.labelViewViewStoreList.numberOfLines = 0;
        [self.labelViewViewStoreList sizeToFit];
        [self.view addSubview:self.labelViewViewStoreList];
       

    }

    return self;
}

#pragma mark  initWithNibName
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.view.backgroundColor = [UIColor whiteColor];         
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
