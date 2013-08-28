//
//  MyProductDetailsVC.h
//  MyJeweler
//
//  Created by Nik on 19/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyProductDetailsVC : UIViewController <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIWebView                      *webView;
    IBOutlet UITextField                    *codeTxt;
    IBOutlet UITextField                    *priceTxt;
    IBOutlet UIActivityIndicatorView        *activity;
    
    UITableView                             *myTable;
    NSDictionary                            *infoDict;
    NSMutableDictionary                     *detailsDict;
    UIBarButtonItem                         *infoButton;
    BOOL                                    showDetails;
}

@property (nonatomic, retain)  NSDictionary                            *infoDict;

- (void) loadTable;
- (void) prepareForm;
- (void) detailsView;
- (void) setNavigationTitleView:(NSString*) titleStr ;
@end
