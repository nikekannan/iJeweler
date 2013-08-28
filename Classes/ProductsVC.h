//
//  ProductsVC.h
//  MyJeweler
//
//  Created by Nik on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray      *productsArray;
    UITableView         *myTable;
}

@property (nonatomic, retain) NSArray      *productsArray;;

- (void) loadTable;

@end
