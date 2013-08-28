//
//  CountryListVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;

@interface CountryListVC : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	UITableView		*myTable;
	NSMutableArray	*countriesArray;
    
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property  BOOL  isBannerAnimating;

- (void) loadTable;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

@end
