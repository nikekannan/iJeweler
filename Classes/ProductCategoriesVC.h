//
//  ProductCategoriesVC.h
//  MyJeweler
//
//  Created by Nik on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCategoriesVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString            *ownerID;
    NSDictionary        *infoDict;
    UITableView         *myTable;
}

@property (nonatomic, retain) NSString        *ownerID;

- (void) loadTable;
- (void) loadData;

@end
