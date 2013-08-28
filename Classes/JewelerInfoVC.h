//
//  JewelerInfoVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;
@interface JewelerInfoVC : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	UITableView		*myTable;
	NSString		*userID;
	NSDictionary	*infoDict;
	UIActivityIndicatorView	*activityIndicator;
    
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property ( nonatomic, retain) NSString		*userID;
@property  BOOL  isBannerAnimating;

- (void) loadTable;
- (void) getInfo;
- (void) makeACall;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

@end
