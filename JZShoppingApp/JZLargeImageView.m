//
//  JZLargeImageView.m
//  JZShoppingApp
//
//  Created by jihong zhang on 4/28/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZLargeImageView.h"
#import "JZProductAdditionalInfo.h"

@interface JZLargeImageView ()

@end

@implementation JZLargeImageView
 
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.view addSubview:self.imageView];
        
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

-(void) additionalInfo:(id)sender
{
    
    JZProductAdditionalInfo *additionalInfo = [[JZProductAdditionalInfo alloc] initWithProductCell:self.productCell];
    
    [self.navigationController pushViewController:additionalInfo animated:YES];

}


@end
