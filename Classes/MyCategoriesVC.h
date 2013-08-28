//
//  MyCategoriesVC.h
//  MyJeweler
//
//  Created by Nik on 19/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCategoriesVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary        *infoDict;
    UITableView         *myTable;
}


- (void) loadTable;
- (void) loadData;

@end
