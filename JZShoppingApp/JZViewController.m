//
//  JZViewController.m
//  JihongHomeProducts
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZViewController.h"
#import "JZProductsModel.h"
#import "JZProductCell.h"
#import "JZLargeImageView.h"
#import "JZProductAdditionalInfo.h"
#import "JZProductEdit.h"
#import "JZConstants.h"



@interface JZViewController ()

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic)   int currentSelectRow;

@end

@implementation JZViewController

static NSString *CellIdentifier = @"UITableViewCell";

#pragma mark - Edit product Delegate
#pragma mark onAddSuccess Delegate
-(void)onAddSuccess:(JZProductCell *)item
{
    NSLog(@"onAddSuccess called");
    //add data
    [self.data addObject:item];
    //update data in the tableView
    [self.tableView reloadData];
    
}
#pragma mark onSaveEditSuccess Delegate
-(void)onSaveEditSuccess:(JZProductCell *)item
{
    //update data in the tableView
    [self.tableView reloadData];
}

#pragma mark - edit button callback
#pragma mark addItem Delegate
-(void) addItem
{
    
    JZProductCell *productCell = [[JZProductCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    productCell.product.name = [[NSString alloc] init];
    productCell.colors =[[NSMutableArray alloc] init];
    productCell.images = [[NSMutableArray alloc] init];
    productCell.description = [[NSString alloc] init];
    productCell.stores = [[NSMutableDictionary alloc] init];
    productCell.regPrice = 0.0;
    productCell.salePrice = 0.0;
    productCell.productId = -1;
    
    
    JZProductEdit *productEdit = [[JZProductEdit alloc] initWithProductCell:productCell];
    productEdit.pageTypeIsAdding = TRUE;
    productEdit.delegate = self;
    productEdit.navigationItem.title = @"Add new product";
    
    //navigation bar back button callback
    productEdit.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:productEdit action:@selector(checkIfPageEdited)];
    
    
    //ToolBar
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, mainScreen.applicationFrame.size.height- myTableViewCellHight/2-44, mainScreen.applicationFrame.size.width, myTableViewCellHight/2)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *buttonReset = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:productEdit action:@selector(resetChanges:)];
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:productEdit action:@selector(saveChanges:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *barbuttonItems = @[flexibleItem, buttonReset, flexibleItem, buttonSave, flexibleItem];
    [toolBar setItems:barbuttonItems];
    [productEdit.view addSubview:toolBar];
    
    
    [self.navigationController pushViewController:productEdit animated:YES];
    
}

#pragma mark buttonDelete
-(void)buttonDelete:(id)sender
{
    UITableView *tableView = (UITableView *)self.view;
    
    if(tableView.isEditing){
        [tableView setEditing:NO animated:YES];
    }else{
        [tableView setEditing:YES animated:YES];
    }
}


#pragma mark buttonBack
-(void)buttonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table cell init
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
#ifdef KVCKVO
        self.buttonAction = [[JZButtonAction alloc] init];
        [self.buttonAction addObserver:self forKeyPath:@"action" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
#endif
    }
    return self;
}

#ifdef KVCKVO
// this is just an exercise for KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[JZButtonAction class]]){
        JZButtonAction *buttonAction = (JZButtonAction *)object;
        NSString *action = [change objectForKey:@"new"];
        if(action == @"edit"){
            NSLog(@"observeValueForKeyPath*****action is:EDIT---%@", buttonAction.action);
            [self onSaveEditSuccess:nil];  
        }
    }
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup navigation bar according to the request button(buttonIndex)
    //if the index == 0, means verder button then
    //need to add edit buttons in the navigationBart
    //otherwise no edit buttons
    if(self.buttonIndex == buttonIndexTypeVernder){
        //add button
        UIButton *barbuttonAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [barbuttonAdd addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];        ;
        self.navigationItem.titleView = barbuttonAdd;
        //delete button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonDelete:)];
    }
    
    self.data = [JZProductsModel getProductsData]; //get all the products info
    self.currentSelectRow = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
#ifdef KVCKVO
    [self.buttonAction removeObserver:self forKeyPath:@"action"];
#endif
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;  //could be more than 1 section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JZProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JZProductCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //setProductListCellInfo:
    cell.product = [self.data objectAtIndex:indexPath.row];
    
    //add buttonImage click callback (image enlarge)
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.   
    
}


#pragma mark - Data manipulation
#pragma mark reorder / moving support
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //exchange data
    [self.data exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark commit dataSource change
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        //1. update data.  2. update UI
        JZProductCell *item = [self.data objectAtIndex:indexPath.row] ;
        int productId = item.productId;       
        //delete product data from DB
        [JZProductsModel deleteOneProductFromDb:(int)productId];
        
        [self.data removeObjectAtIndex:indexPath.row];
        
        //2. update UI
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}


#pragma mark - Tabel Cell Delegate
#pragma mark hight of the row at the indexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return myTableViewCellHight;
}



#pragma mark - TableCell Tap Delegate
#pragma mark buttonImageTappedOnCell
-(void) buttonImageTappedOnCell:(id)sender
{
    NSIndexPath *indepath = [self.tableView indexPathForCell:sender];
    
    JZLargeImageView *largeImageView = [[JZLargeImageView alloc] init];
    largeImageView.imageView.image = [UIImage imageNamed:[[[self.data objectAtIndex:indepath.row] images] objectAtIndex:0]];
    
    largeImageView.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MoreInfo" style:UIBarButtonItemStyleBordered target:largeImageView action:@selector(additionalInfo:)];
    
    largeImageView.productCell = [self.data objectAtIndex:indepath.row];
    
    [self.navigationController pushViewController:largeImageView animated:YES];
}

#pragma mark buttonDetailTappedOnCell
-(void)buttonDetailTappedOnCell:(id)sender
{
    if(self.buttonIndex == buttonIndexTypeShopper){ //shopper
        [self buttonImageTappedOnCell:sender];
        return;
    }
    //vender
    NSIndexPath *indepath = [self.tableView indexPathForCell:sender];
    JZProductEdit *productEdit = [[JZProductEdit alloc] initWithProductCell:[self.data objectAtIndex:indepath.row]];
    productEdit.pageTypeIsAdding = FALSE;
    productEdit.delegate = self;
    productEdit.navigationItem.title = @"Edit";
    //navigation bar back button callback
    productEdit.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:productEdit action:@selector(checkIfPageEdited)];
    
    //#ifdef KVCKVO
    productEdit.buttonAction = self.buttonAction;

    //ToolBar for save and cacel button
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, mainScreen.applicationFrame.size.height- myTableViewCellHight/2-44, mainScreen.applicationFrame.size.width, myTableViewCellHight/2)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *buttonReset = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:productEdit action:@selector(resetChanges:)];
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:productEdit action:@selector(saveChanges:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *barbuttonItems = @[flexibleItem, buttonReset, flexibleItem, buttonSave, flexibleItem];
    [toolBar setItems:barbuttonItems];
    [productEdit.view addSubview:toolBar];
    
    [self.navigationController pushViewController:productEdit animated:YES];
    
}


@end
