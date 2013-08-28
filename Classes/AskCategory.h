//
//  AskCategory.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>
#import "MyJewelerAppDelegate.h"
#import "RootViewController.h"
#import "AskQuestionVC.h"

// MULTIPLE SELECTION ENABL
@interface AskCategory : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	UITableView				*myTable;
	NSMutableArray			*categoryArray;
	NSMutableArray			*idArray;
	NSMutableDictionary		*selectedItemDict;
    UIActivityIndicatorView *activityIndicator;
//	RootViewController		*obj_RootViewController;
//	UINavigationController	*nav1;
//	UINavigationBar			*nav;
	
	// comment this
	int						category;
	BOOL					isMultipleSelectionEnabled;
}

@property BOOL isMultipleSelectionEnabled;

- (void) loadTable;
- (void) reloadTableView;
- (NSString *)stringWithUrl:(NSURL *)url;
@end
