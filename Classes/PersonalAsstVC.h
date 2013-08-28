//
//  PersonalAsstVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;

@interface PersonalAsstVC : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	UITableView		*myTable;
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
- (void) loadMetalPrices;
- (void) loadPersonalShoppingAssistantVC;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;


@end
