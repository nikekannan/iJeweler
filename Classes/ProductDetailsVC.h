//
//  ProductDetailsVC.h
//  MyJeweler
//
//  Created by Nik on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductDetailsVC : UIViewController <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UILabel                        *code;
    IBOutlet UILabel                        *price;
    IBOutlet UIWebView                      *webView;
    IBOutlet UIActivityIndicatorView        *activity;
    
    UITableView                             *myTable;
    NSDictionary                            *infoDict;
    NSDictionary                          *detailsDict;
    UIBarButtonItem                         *infoButton;
    BOOL                                    showDetails;
}

@property (nonatomic, retain)  NSDictionary                            *infoDict;

- (void) loadTable;
- (void) prepareForm;
- (void) detailsView;
- (void) setNavigationTitleView:(NSString*) titleStr ;
@end
