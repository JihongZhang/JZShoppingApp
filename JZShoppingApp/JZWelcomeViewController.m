//
//  JZWelcomeViewController.m
//  JZShoppingApp
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZWelcomeViewController.h"
#import "JZProductsModel.h"
#import "JZViewController.h"
#import "JZConstants.h"


@interface JZWelcomeViewController ()

@end

@implementation JZWelcomeViewController

#pragma mark - button callback functions
#pragma mark buttonVenderCB
-(IBAction)buttonVenderCB:(id)sender
{
    JZViewController *tableViewProducts = [[JZViewController alloc] init];
    tableViewProducts.buttonIndex = buttonIndexTypeVernder;
    
    UIButton *barbuttonAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [barbuttonAdd addTarget:tableViewProducts action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    tableViewProducts.navigationItem.titleView = barbuttonAdd;

    tableViewProducts.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonEdit:)];    
    
    [self.navigationController pushViewController:tableViewProducts animated:YES];
     
}

#pragma mark buttonShopperCB
-(IBAction)buttonShopperCB:(id)sender
{
    JZViewController *productsListTable = [[JZViewController alloc] init];
    productsListTable.buttonIndex = buttonIndexTypeShopper;
    
    [self.navigationController pushViewController:productsListTable animated:YES];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"myNaviBar"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
