//
//  MyProductsVC.h
//  MyJeweler
//
//  Created by Nik on 19/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyProductsVC : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
    NSArray      *productsArray;
    UITableView         *myTable;
}

@property (nonatomic, retain) NSArray      *productsArray;;

- (void) loadTable;

@end
