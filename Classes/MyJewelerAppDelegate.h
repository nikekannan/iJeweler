//
//  MyJewelerAppDelegate.h
//  iJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class RegisterVC;
@class RootViewController;
@class  BannerView;
@class  Banner;

@interface MyJewelerAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow				*window;
	
	RegisterVC				*obj_RegisterVC;
	RootViewController		*obj_RootViewController;
	MKMapView				*mapView;
	UIImageView				*logoView;
    
    NSMutableArray          *bannersArray;
	
	UINavigationController	*nav1;
	
	CLLocationManager		*obj_Gps;				//--- Core getting Gps Data ----
	NSString				*strGpsData;
    BOOL                    isBannerRequested;
    BOOL                    isFirstTime;
    BOOL                    iphone5;
 }

@property (nonatomic, retain) IBOutlet UIWindow *window;

+(MyJewelerAppDelegate*) sharedInstance;
// to get GPS location
-(void) getGPSLocation;
-(void) startUpdatingGpsLocation;
-(void) stopUpdatingGpsLocation;
-(void) getAddress;

- (void) initiatePUSHRegister;

// to get my unique id from server
- (void) getMyID;


// to load splash screen
- (void) showSplashScreen;

// start the app
- (void) appStart ;
- (void) loadRegisterView;


// load the Home page
- (void) loadTabView;


// to get current date;
- (NSString*) getDate:(int)option;

// gallery support
- (void) getPaths;

- (void) updateToken;

// to get banner ads
- (void) getBannerAds;
- (Banner*) getAd;

- (BOOL) isIPhone5;
@end

