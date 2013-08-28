//
//  JewelersVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JewelersVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTable;
    NSMutableArray      *ownersArray;
}

- (void) loadTable;
- (void) loadData;

@end
