//
//  PersonalShoppingAsstVC.h
//  iJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;

@interface PersonalShoppingAsstVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView		*myTable;
	NSMutableArray	*infoArray;
    
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
- (void) addNewPerson;
- (void) getDataFromDB;
- (void) deletePSA:(NSString*)psaID;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;
@end
