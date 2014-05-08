//
//  JZProductsModel.m
//  sqliteTest
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZProductsModel.h"
#import <sqlite3.h>
#import "JZProductCell.h"
#import "JZConstants.h"


@implementation JZProductsModel

NSString * const myDataBase = @"productsTestDB";
sqlite3 *productsDb = nil;

#pragma mark  getProductsData
+(id)getProductsData
{    
    NSMutableArray *data=[self readData];
    return data;
    
}

#pragma mark readData
+(id)readData
{
    NSMutableArray *productsData = [[NSMutableArray alloc] init];
    productsData = [self readDataFromDB];
    if(productsData.count==0){
        productsData = [self paserData:@"products.json"];
    }
    
    return productsData;
    
}

#pragma mark paserData
+(id)paserData:(NSString *)fileName
{
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:fileName];
    NSData *data =[NSData dataWithContentsOfFile:path];
    
    //get data from json file 
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSArray *productsArray = [jsonData objectForKey:@"products"];
    
    NSMutableArray *productsAllData = [[NSMutableArray alloc] init];
    for(int i=0; i< productsArray.count; i++){
        NSDictionary *product = [productsArray objectAtIndex:i];
        int productId = [[product objectForKey:@"id"] integerValue];
        NSString *name = [product objectForKey:@"name"];
        NSString *description = [product objectForKey:@"description"];
        double regPrice = [[product objectForKey:@"regular price"] doubleValue];
        double salePrice = [[product objectForKey:@"sale price"] doubleValue];
        NSArray *images = [product objectForKey:@"product photos"];
        NSArray *colors = [product objectForKey:@"colors"];
        NSDictionary *stores = [product objectForKey:@"stores"];
        
        JZProductCell *productCell = [[JZProductCell alloc] init];
        productCell.productId = productId;
        productCell.name = name;
        productCell.regPrice = regPrice;
        productCell.salePrice = salePrice;
        productCell.description = description;
        productCell.colors = [colors mutableCopy];
        productCell.images = [images mutableCopy];
        productCell.stores = [stores mutableCopy];
        
        [productsAllData addObject:productCell];

    }
    
    [self inserProductsData:(NSMutableArray*)productsAllData];
    return productsAllData;
}

#pragma mark execDbSQL
/* this is interal commen function for all the drop table functions
 */
+(void)execDbSQL:(char*)sql
{
    char *errorMsg;
    if (sqlite3_exec(productsDb, sql, NULL, NULL, &errorMsg) != SQLITE_OK){
        NSLog(@"Error: %s", errorMsg);
    }else{
        NSLog(@"%s",sql);
    }
}

#pragma mark getProductsCountFromProductsTable
+(int)getProductsCountFromProductsTable;
{
    int count = 0;
    sqlite3_stmt *stmt;
    char *sql = "select count(*) from t_products;";
    int returnStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return 0; //no data
    }else{
       if (sqlite3_step(stmt) == SQLITE_ROW){
            count = sqlite3_column_int(stmt, 0);           
        }
    }
    return count;
}

#pragma mark getCoreInfoFromProductsTable
+(NSMutableArray*)getCoreInfoFromProductsTable;
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    char *sql = "select productId, name, regPrice, salePrice, description from t_products;";
    int returnStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return tableData; //no data
    }else{
        while (sqlite3_step(stmt) == SQLITE_ROW){
            int productId = sqlite3_column_int(stmt, 0);
            char *name = (char *)sqlite3_column_text(stmt, 1);
            double regPrice = sqlite3_column_double(stmt, 2);
            double salePrice = sqlite3_column_double(stmt, 3);
            char *description = (char *)sqlite3_column_text(stmt, 4);
            //get product basic info from t_products
            JZProductCell *item = [[JZProductCell alloc] init];
            item.productId = productId;
            item.name =  [[NSString alloc] initWithUTF8String:name];
            item.regPrice = regPrice ;
            item.salePrice = salePrice;
            item.description = [[NSString alloc] initWithUTF8String:description];
            [tableData addObject:item];
        }
    }
    return tableData;
}

#pragma mark getColorsFromColorsTableForProductId
+(NSMutableArray*)getColorsFromColorsTableForProductId:(int)productId
{

    sqlite3_stmt *stmtColor;
    NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSString *querySQL = [NSString stringWithFormat:
                          @"select totalColors, color1, color2, color3, color4, color5 from t_colors where productId =%d",productId];
        const char *sqlColor = [querySQL UTF8String];
        if( sqlite3_prepare_v2(productsDb, sqlColor, -1, &stmtColor, NULL) == SQLITE_OK){
            if(sqlite3_step(stmtColor) == SQLITE_ROW){
                int count = sqlite3_column_int(stmtColor, 0);
                for(int i=1; i<=count; i++){
                    char *color = (char *)sqlite3_column_text(stmtColor, i);
                    if(color != nil){
                        [colors addObject:[[NSString alloc] initWithUTF8String:color]];
                    }else{
                        colors[i] = @"clearColor";
                    }
                }
            }
        }
    sqlite3_finalize(stmtColor);
    return colors;
}

#pragma mark getImagesFromImagesTableForProductId
+(NSMutableArray*)getImagesFromImagesTableForProductId:(int)productId
{
    
    sqlite3_stmt *stmtImage;
    NSMutableArray *images = [[NSMutableArray alloc] init];
        NSString *querySQL = [NSString stringWithFormat:
                              @"select totalImages, Image1, Image2, Image3, Image4, Image5 from t_Images where productId =%d",productId];
        const char *sqlImage = [querySQL UTF8String];
        if( sqlite3_prepare_v2(productsDb, sqlImage, -1, &stmtImage, NULL) == SQLITE_OK){
            if(sqlite3_step(stmtImage) == SQLITE_ROW){
                int count = sqlite3_column_int(stmtImage, 0);
                for(int i=1; i<=count; i++){
                    char *image = (char *)sqlite3_column_text(stmtImage, i);
                    if(image != nil){
                        [images addObject:[[NSString alloc] initWithUTF8String:image]];
                    }else{
                        break;
                    }
                }
            }
        }
    sqlite3_finalize(stmtImage);
    return images ;
}

#pragma mark getStoresFromStoresTableForProductId
+(NSMutableDictionary*)getStoresFromStoresTableForProductId:(int)productId
{
    
    sqlite3_stmt *stmtStore;
    NSMutableDictionary *stores =[[NSMutableDictionary alloc] init];
        NSString *querySQL = [NSString stringWithFormat:
                              @"select totalStores, store1, store1Address, store2, store2Address, store3, store3Address, store4, store4Address, store5, store5Address from t_stores where productId =%d", productId];
        const char *sqlStore = [querySQL UTF8String];
        if( sqlite3_prepare_v2(productsDb, sqlStore, -1, &stmtStore, NULL) == SQLITE_OK){
            if(sqlite3_step(stmtStore) == SQLITE_ROW){
                int count = sqlite3_column_int(stmtStore, 0);
                NSArray *keyArray = [[NSArray alloc] init];
                NSArray *valueArray = [[NSArray alloc] init];
                for(int i=1; i<=count*2; i=i+2){
                    char *store = (char *)sqlite3_column_text(stmtStore, i);
                    char *address = (char *)sqlite3_column_text(stmtStore, i+1);
                    if((store != nil) & (address != nil)){
                        keyArray = [keyArray arrayByAddingObject:[NSString stringWithUTF8String: store]];
                        valueArray = [valueArray arrayByAddingObject:[NSString stringWithUTF8String:address]];
                    }else{
                        break;
                    }
                }
                if(keyArray.count >= 1 & valueArray.count >= 1){
                    stores = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
                }
            }
        }
    sqlite3_finalize(stmtStore);
    return stores;
}


#pragma mark readDataFromDB
+(NSMutableArray *)readDataFromDB
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    [self openDatabase];
    int productsCount = [self getProductsCountFromProductsTable];
        if(productsCount == 0){
        //no data, need to read data from Json file
        //make the tables ready for the new data, and then read data from Json file
        //TODO: This is for testing only,
        //in the real envirement need to be very carefull in drop any tables
        char *sqlDropColorsTable = "DROP TABLE IF EXISTS t_colors;";
        [self execDbSQL:sqlDropColorsTable];
        char *sqlDropImagesTable = "DROP TABLE IF EXISTS t_images;";
        [self execDbSQL:sqlDropImagesTable];
        char *sqlDropStoresTable = "DROP TABLE IF EXISTS t_stores;";
        [self execDbSQL:sqlDropStoresTable];
        char *sqlDropProductsTable = "DROP TABLE IF EXISTS t_products;";
        [self execDbSQL:sqlDropProductsTable];
        return tableData;  
    }
    
    //data is ready in the database
    //get products data
    //1. get product basic info(core info) from t_products
    tableData = [self getCoreInfoFromProductsTable];
    
    for(int i=0; i< tableData.count; i++){
        JZProductCell *item = [tableData objectAtIndex:i];
        //get colors for the products from t_colors
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        colors = [self getColorsFromColorsTableForProductId:item.productId];
        item.colors = [[NSMutableArray alloc] initWithArray:colors];
        
        //get images for the product from t_images
        NSMutableArray *images = [[NSMutableArray alloc] init];
        images = [self getImagesFromImagesTableForProductId:item.productId];
        item.images = [[NSMutableArray alloc] initWithArray:images];
        
        //get stores/address for the item(procuct)
        NSDictionary *stores = [[NSDictionary alloc] init];
        stores = [[self getStoresFromStoresTableForProductId:item.productId] mutableCopy];
        item.stores = [[NSMutableDictionary alloc] initWithDictionary:stores];
          
  
    }
    return tableData;
}



#pragma mark - insert data to DB
#pragma mark inserProductsData
+(void) inserProductsData:(NSMutableArray*)productsAllData
{
    [self openDatabase];
    [self createProductsTables];
    
    for(int i=0; i< productsAllData.count; i++){
        JZProductCell *productCell = [[JZProductCell alloc] init];
        productCell = productsAllData[i];
        int productId = productCell.productId;
        
        //insert product data into database
        [self insertProductId:(int)productId name:(NSString*)productCell.name regPrice:(double)productCell.regPrice  salePrice:(double)productCell.salePrice description:(NSString*)productCell.description];
        
        //insert product colors into database
        [self insertColors:(NSArray*)productCell.colors forProductId:(int)productId];
        
        //insert product images into database
        [self insertImages:(NSArray*)productCell.images forProductId:(int)productId];
        
        //insert product stores into database
        [self insertStores:(NSDictionary*)productCell.stores forProductId:(int)productId];
    }
}

#pragma mark insertOneProductToDb
+(void)insertOneProductToDb:(JZProductCell*)product
{
    if(product.productId <= 0){
        product.productId = [self getProductsLastIdNumberFromDB] + 1;
    }
    [self insertProductIdToDB:product.productId name:product.name regPrice:product.regPrice  salePrice:product.salePrice description:product.description];
    [self insertColors:product.colors forProductId:product.productId];
    [self insertImages:product.images forProductId:product.productId];
    [self insertStores:product.stores forProductId:product.productId];
}

#pragma mark deleteOneProductFromDb
+(void)deleteOneProductFromDb:(int)productId
{
    if(productId <= 0)
        return;
    [self deleteProductCoreInfoinDBforProductId:productId];
    [self deleteColorsInDBforProductId:productId];
    [self deleteImagesInDBforProductId:productId];
    [self deleteStoresInDBforProductId:productId];
}


#pragma mark insertProductIdToDB
/** This is the wrap up function for:
 * insertProductId:(int)productId name:(NSString*)name regPrice:(double)regPrice  salePrice:(double)salePrice description:(NSString*)description
 * The diffrence is that the function here gets the productId from the DB sqlite_sequence table
 */
+(int)insertProductIdToDB:(int)productId name:(NSString*)name regPrice:(double)regPrice  salePrice:(double)salePrice description:(NSString*)description
{
    if(productId <= 0){
        productId = [self getProductsLastIdNumberFromDB] + 1;
    }
    [self insertProductId:(int)productId name:(NSString*)name regPrice:(double)regPrice  salePrice:(double)salePrice description:(NSString*)description];
    
    return productId;
}

#pragma mark getProductsLastIdNumberFromDB
+(int)getProductsLastIdNumberFromDB;
{
    int count = 0;
    sqlite3_stmt *stmt;
    char *sql = "select seq from sqlite_sequence;";
    int returnStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return 0; //no data
    }else{
        if (sqlite3_step(stmt) == SQLITE_ROW){
            count = sqlite3_column_int(stmt, 0);
        }
    }
    return count;
}

#pragma mark insertProductId
/** Insert product main infomation to t_products table 
 *  the main info are: 
 *  productId name regPrice salePrice description
 */
+(void)insertProductId:(int)productId name:(NSString*)name regPrice:(double)regPrice  salePrice:(double)salePrice description:(NSString*)description
{
    sqlite3_stmt *stmt;
    char *sql;
    if(productId > 0){        
        char *sqlHasId = "insert into t_products(productId, name, regPrice, salePrice, description) values(?, ?, ?, ?, ?);";
        sql = sqlHasId;
    }else{
        char *sqlNoId = "insert into t_products(name, regPrice, salePrice, description) values(?, ?, ?, ?);";
        sql = sqlNoId;
    }
    
    int prepareStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if(prepareStatus == SQLITE_OK){ //if no error
        //binding
        int i = 1;
        if(productId > 0){
            sqlite3_bind_int(stmt, 1, productId); // id field
            i = 2;
        }
        sqlite3_bind_text(stmt, i++, [name UTF8String], -1, NULL); //name field
        sqlite3_bind_double(stmt, i++, regPrice);   //regPrice
        sqlite3_bind_double(stmt, i++, salePrice);   //salePrice
        sqlite3_bind_text(stmt, i++, [description UTF8String], -1, NULL); //description
        //insert
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Table insert failed");
        }
        //release stmt
        sqlite3_finalize(stmt);
    }
    NSLog(@"INSERT: %s", sql);
}


#pragma mark insertColors
/** MAX colors allowed for each product is 5 */
+(void)insertColors:(NSArray*)colors forProductId:(int)productId
{
    sqlite3_stmt *stmt;
    char *sql = "insert into t_colors(productId, totalColors, color1, color2, color3, color4, color5) values(?, ?, ?, ?, ?, ?, ?);";
    int prepareStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if(prepareStatus == SQLITE_OK){ //if statement has no error
        //binding
        sqlite3_bind_int(stmt, 1, productId); // id field
        sqlite3_bind_int(stmt, 2, colors.count); // total count field
        int fieledIndex = 3;
        for(int i=0; i<colors.count && i<maxColorsAllowedForEachProduct; i++){
            sqlite3_bind_text(stmt, fieledIndex++, [colors[i] UTF8String], -1, NULL); //color field
        }
        
        //insert
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Table insert failed");
        }
        //release stmt
        sqlite3_finalize(stmt);
    }
    
}


#pragma mark insertImages
//productId(primary key), totalNumberOfImages, image1, image2, image3, image4, image5
/** MAX images allowed for each product is 5 */
+(void)insertImages:(NSArray*)images forProductId:(int)productId
{
    sqlite3_stmt *stmt;
    char *sql = "insert into t_images(productId, totalImages, image1, image2, image3, image4, image5) values(?, ?, ?, ?, ?, ?, ?);";
    int prepareStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if(prepareStatus == SQLITE_OK){ //if statement has no error
        //binding
        sqlite3_bind_int(stmt, 1, productId); // id field
        sqlite3_bind_int(stmt, 2, images.count); // total count field
        int fieledIndex = 3;
        for(int i=0; i<images.count && i<maxImagesAllowedForEachProduct; i++){
            sqlite3_bind_text(stmt, fieledIndex++, [images[i] UTF8String], -1, NULL); //image field
        }
        
        //insert
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Table insert failed");
        }
        //release stmt
        sqlite3_finalize(stmt);
    }
    
}


#pragma mark insertStores
/** MAX stores listed allowed for each product is 5 */
+(void)insertStores:(NSDictionary*)stores forProductId:(int)productId
{
    sqlite3_stmt *stmt;
    char *sql = "insert into t_stores(productId, totalStores, store1, store1Address, store2, store2Address, store3, store3Address, store4, store4Address, store5, store5Address) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    int prepareStatus = sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL);
    if(prepareStatus == SQLITE_OK){ //if statement has no error
        //binding
        sqlite3_bind_int(stmt, 1, productId); // id field
        sqlite3_bind_int(stmt, 2, stores.count); // total count field
        
        int fieledIndex = 3;
        for(id key in stores){
            sqlite3_bind_text(stmt, fieledIndex++, [key UTF8String], -1, NULL); //store name
            sqlite3_bind_text(stmt, fieledIndex++, [stores[key] UTF8String], -1, NULL); //store address
        }
    
        //insert
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Table insert failed");
        }
        //release stmt
        sqlite3_finalize(stmt);
    }
    
}

#pragma mark deleteProductCoreInfoinDBforProductId
/** Delete one row from t_products where the productId = productId
 *  [in] productId:  The row with productId=[in]productId will be deleted
 */
+(void)deleteProductCoreInfoinDBforProductId:(int)productId
{
    sqlite3_stmt *stmt; 
    NSString *querySQL = [NSString stringWithFormat:
                          @"delete from t_products where productId =  %d", productId];
    const char *sql = [querySQL UTF8String];
    if( sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Data delete failed in t_products for productId = %i", productId);
        }else{
            NSLog(@"Data delete success in t_products for productId = %i", productId);
        }
    }
    //release stmt
    sqlite3_finalize(stmt);
}

#pragma mark deleteColorsInDBforProductId
/** Delete one row from t_colors where the productId = productId
 *  [in] productId:  The row with productId=[in]productId will be deleted
 */
+(void)deleteColorsInDBforProductId:(int)productId
{
    sqlite3_stmt *stmt;
    NSString *querySQL = [NSString stringWithFormat:
                          @"delete from t_colors where productId =  %d", productId];
    const char *sql = [querySQL UTF8String];
    if( sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Data delete failed in t_colors for productId = %i", productId);
        }else{
            NSLog(@"Data delete success in t_colors for productId = %i", productId);
        }
    }
        //release stmt
        sqlite3_finalize(stmt);    
}

#pragma mark deleteImagesInDBforProductId
/** Delete one row from t_images where the productId = productId
 *  [in] productId:  The row with productId=[in]productId will be deleted
 */
+(void)deleteImagesInDBforProductId:(int)productId
{
    sqlite3_stmt *stmt;
    NSString *querySQL = [NSString stringWithFormat:
                          @"delete from t_images where productId =  %d", productId];
    const char *sql = [querySQL UTF8String];
    if( sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Data delete failed in t_images for productId = %i", productId);
        }else{
            NSLog(@"Data delete success in t_images for productId = %i", productId);
        }
    }
    //release stmt
    sqlite3_finalize(stmt);
}

#pragma mark deleteStoresInDBforProductId
/** Delete one row from t_stores where the productId = productId
 *  [in] productId:  The row with productId=[in]productId will be deleted
 */
+(void)deleteStoresInDBforProductId:(int)productId
{
    sqlite3_stmt *stmt;
    NSString *querySQL = [NSString stringWithFormat:
                          @"delete from t_stores where productId =  %d", productId];
    const char *sql = [querySQL UTF8String];
    if( sqlite3_prepare_v2(productsDb, sql, -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Data delete failed in t_stores for productId = %i", productId);
        }else{
            NSLog(@"Data delete success in t_stores for productId = %i", productId);
        }
    }
    //release stmt
    sqlite3_finalize(stmt);
}




#pragma mark createProductsTables
/** Tables name and fiels:
 table of t_products:
 productId(primary key), name, regPrice, salePrice, description
 
 table of t_colors
 productId(primary key), totalColors, color1, color2, color3, color4, color5
 
 table of t_stores 
 productId, totalStores, store1, store1Address, store2, store2Address, store3, store3Address, store4, store4Address, store5, store5Address
 
 table of t_images
 productId(primary key), totalImages, image1, image2, image3, image4, image5
 
*/
 
+(void)createProductsTables{
    char *sql = "create table if not exists t_products(productId integer primary key AUTOINCREMENT, name text, regPrice double, salePrice double, description text);";
    char *error;
    int execStatus = sqlite3_exec(productsDb, sql, NULL, NULL, &error);
    if(execStatus != SQLITE_OK){
        NSLog(@"Table t_products create error: %s", error);
    }else{
        NSLog(@"Table t_products create sucessful");
    }
    
    sql = "create table if not exists t_colors(productId integer primary key, totalColors integer, color1 text, color2 text, color3 text, color4 text, color5 text );";
    execStatus = sqlite3_exec(productsDb, sql, NULL, NULL, &error);
    if(execStatus != SQLITE_OK){
        NSLog(@"Table t_colors create error: %s", error);
    }else{
        NSLog(@"Table t_colors create sucessful");
    }
    
    sql = "create table if not exists t_stores(productId integer primary key, totalStores integer, store1 text, store1Address text, store2 text, store2Address text, store3 text, store3Address text, store4 text, store4Address text, store5 text, store5Address text);";
    execStatus = sqlite3_exec(productsDb, sql, NULL, NULL, &error);
    if(execStatus != SQLITE_OK){
        NSLog(@"Table t_stores create error: %s", error);
    }else{
        NSLog(@"Table t_stores create sucessful");
    }
    
    sql = "create table if not exists t_images(productId integer primary key, totalImages integer, image1 text, image2 text, image3 text, image4 text, image5 text );";
    execStatus = sqlite3_exec(productsDb, sql, NULL, NULL, &error);
    if(execStatus != SQLITE_OK){
        NSLog(@"Table t_images create error: %s", error);
    }else{
        NSLog(@"Table t_images create sucess");
    }
    
}

#pragma mark openDatabase
+(void)openDatabase{
    if(productsDb != nil)
        return;
    
    NSString *documentsRootDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *path = [@"sqlite.productsDb" documentsAppend];
    
    NSString *dbPath = [documentsRootDir stringByAppendingPathComponent:myDataBase];
    int dbOpenStatus = sqlite3_open([dbPath UTF8String], &productsDb);
    //int dbOpenStatus = sqlite3_open_v2([dbPath UTF8String], &productsDb, SQLITE_OPEN_READWRITE, NULL);
    if(dbOpenStatus != SQLITE_OK){
        NSLog(@"Database open failed");
    }else{
        NSLog(@"Database open success");
    }
}


@end

