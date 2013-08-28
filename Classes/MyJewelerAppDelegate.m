//
//  MyJewelerAppDelegate.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import "RegisterVC.h"
#import "RootViewController.h"
#import "BannerView.h"
#import "Constants.h"

@implementation MyJewelerAppDelegate

@synthesize window;
static int bannerIndex;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if(rect.size.height > 480)
    {
        iphone5 = YES;
    }
    else
    {
        iphone5 = NO;
    }
    [self showSplashScreen];

    [self getGPSLocation];
    
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] length] < 64)
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)]; 
	}
    
	
//	[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"myid"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firsttime"];
    [[NSUserDefaults standardUserDefaults] synchronize];

	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"]intValue] <= 0)
	{
		[self performSelector:@selector(getMyID) withObject:nil afterDelay:0.5];
	}
	else 
	{
        [self performSelector:@selector(getBannerAds) withObject:nil afterDelay:DELAY];
	}
    
    NSLog(@"myid - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"]);
    
	[self.window makeKeyAndVisible]; 
    return YES;
}

- (void) initiatePUSHRegister
{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)]; 
}

- (void) showSplashScreen
{
	UIImageView	*back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    [back setFrame:CGRectMake(0,0,320,480)];
    int h = 480;
    if([self isIPhone5])
    {
        h = 568;
        [back setFrame:CGRectMake(0,0,320,568)];
    }
	UIImage *logo = [UIImage imageNamed:@"logo.png"];
	logoView = [[UIImageView alloc] initWithFrame:CGRectMake((320-logo.size.width)/2, (h-logo.size.height)/2, logo.size.width, logo.size.height)];
	[logoView setImage:logo];
	[logoView setTag:999];
	[back addSubview:logoView];
	[window addSubview:back];
	[self.window makeKeyAndVisible];
	[back release];	
}

- (void) appStart 
{
	[logoView removeFromSuperview];
	[logoView release];
	[self loadTabView];
}

- (void) loadRegisterView
{
	obj_RegisterVC = [[RegisterVC alloc] init];
	nav1  = [[UINavigationController alloc] initWithRootViewController:obj_RegisterVC];
	[window addSubview:nav1.view];
	[window makeKeyAndVisible];	
}

- (void) loadTabView
{
	if(nav1 != nil)
	{
		[nav1.view removeFromSuperview];
		[nav1 release];
	}
	// User Version
	obj_RootViewController = [[RootViewController alloc] init];
	nav1  = [[UINavigationController alloc] initWithRootViewController:obj_RootViewController];
	[window addSubview:nav1.view];
	[window makeKeyAndVisible];			
}

+ (MyJewelerAppDelegate*) sharedInstance
{
    return (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark GPS Methods
-(void) getGPSLocation
{
	obj_Gps = [ [ CLLocationManager alloc ] init ];
	obj_Gps.delegate = self;
	obj_Gps.desiredAccuracy = kCLLocationAccuracyBest;
	obj_Gps.distanceFilter = kCLDistanceFilterNone;
	[self startUpdatingGpsLocation];
}

-(void) startUpdatingGpsLocation 
{
	[obj_Gps startUpdatingLocation];
}

-(void) stopUpdatingGpsLocation 
{
	[obj_Gps stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)locationManager 
    didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation;
{
	strGpsData = [ NSString stringWithFormat: @"You now at...\n\n"
				  "Description: %@\n"
				  "Coordinates: %f, %f\n"
				  "Altitude: %f\n"
				  "Updated: %@\n", 
				  newLocation.description,
				  newLocation.coordinate.latitude,
				  newLocation.coordinate.longitude,
				  newLocation.altitude,
				  newLocation.timestamp ];

#if TARGET_IPHONE_SIMULATOR
	[[NSUserDefaults standardUserDefaults] setFloat:12.97 forKey:@"mylat"];
	[[NSUserDefaults standardUserDefaults] setFloat:77.59 forKey:@"mylng"];	
#else
	[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:@"mylat"];
	[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:@"mylng"];	
#endif	
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self stopUpdatingGpsLocation];
	
	// never used
	if( ([[[NSUserDefaults standardUserDefaults] objectForKey:@"myaddrs"] length] <= 10) && ( [[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"] != 0.0 && [[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"] !=0.0) )
	{
		[self getAddress];
	}
    else
    {
        [self startUpdatingGpsLocation];
    }
}
#pragma mark -
#pragma mark Apple's Push Notification Service 
// Delegation methods 
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{ 
    NSMutableString *token = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",devToken]];
    [token replaceOccurrencesOfString:@"<" withString:@"" options:1 range:NSMakeRange(0, [token length])];
    [token replaceOccurrencesOfString:@">" withString:@"" options:1 range:NSMakeRange(0, [token length])];
    [token replaceOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(0, [token length])];
    
    NSLog(@"token = %@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];		
    [[NSUserDefaults standardUserDefaults] synchronize];
    [token release];
} 

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{ 
    NSLog(@"Error in registration. Error: %@", err); 
} 

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
	[obj_RootViewController downloadQuestions];
}

#pragma mark -
#pragma mark UIApplication methods

- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firsttime"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    isFirstTime = NO;
}


- (void)applicationWillEnterForeground:(UIApplication *)application 
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	*/
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] length] < 64)
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)]; 
	}

//    [self performSelector:@selector(updateToken) withObject:nil afterDelay:0.2];
//    [self performSelector:@selector(getPaths) withObject:nil afterDelay:0.2];
    
//    if(( [[[NSUserDefaults standardUserDefaults] objectForKey:@"myaddrs"] length] <= 10) && ([[NSUserDefaults standardUserDefaults] boolForKey:@"firsttime"] == NO))	
//    {
//		[self getAddress];
//	}

}


- (void)applicationWillTerminate:(UIApplication *)application 
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
//	not needed
//	[[NSUserDefaults standardUserDefaults] setObject:[self getDate:3] forKey:@"last_known_time"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark ASI support 

- (void) getMyID
{
    isBannerRequested = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/register.php", URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];

	[req setPostValue:@"0" forKey:@"option"];
	
	if(VERSION == 0)
	{
		// Supplier VERSION id
		[req setPostValue:@"0" forKey:@"type"];
	}	
	else if(VERSION == 1)
	{
		// jeweler VERSION id
		[req setPostValue:@"1" forKey:@"type"];
	}
	else if(VERSION == 2)
	{
		// user VERSION id
		[req setPostValue:@"2" forKey:@"type"];
	}
	[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"]] forKey:@"lat"];
	[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]] forKey:@"lng"];
    [req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myaddrs"] forKey:@"address"];
    [req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
	[req setDelegate:self];
	[req startAsynchronous];
	NSError *error = [req error];
	if (!error) 
    {
		//NSLog(@"response -",[req responseString]);
	}
	[req release];
	[url release];		
}

- (void) getBannerAds
{
    isBannerRequested = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = nil;
    if(VERSION == 0)
    {
        // Supplier VERSION id
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banners.php?type=0",URL]];
    }	
    else if(VERSION == 1)
    {
        // jeweler VERSION id
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banners.php?type=1",URL]];
    }
    else if(VERSION == 2)
    {
        // user VERSION id
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banners.php?type=2",URL]];
    }
    
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];

//    [req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"]] forKey:@"lat"];
//    [req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]] forKey:@"lng"];
    [req setDelegate:self];
    [req startAsynchronous];
    [req release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(isBannerRequested)
    {
        if(bannersArray != nil)
        {
            [bannersArray removeAllObjects];
            [bannersArray release];
            bannersArray  = nil;
        }
        bannersArray = [[NSMutableArray alloc] init];

        NSLog(@"banners - %@",[request responseString]);
        NSArray *responseArr = [[NSArray alloc] initWithArray:[[[request responseString] JSONValue] objectForKey:@"banners"]];
                
        for(int i = 0 ; i  < [responseArr count] ; i++)
        {
            Banner *o = [[Banner alloc] init];
            [o setBannerID:[[responseArr objectAtIndex:i] objectForKey:@"uid"]];
            [o setBannerURL:[[responseArr objectAtIndex:i] objectForKey:@"website"]];
            [o startDownload];
            [bannersArray addObject:o];
            [o release];            
        }
        [responseArr release];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"firsttime"])
        {
            [self performSelector:@selector(appStart) withObject:nil afterDelay:2];
        }
    }
    else 
    {
        NSLog(@"response - %@, length - %d",[request responseString],[[request responseString] length]);
        NSLog(@"deviceToken: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
        NSLog(@"latlng: %f,%f", [[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"],[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]);
        
        if([[request responseString] intValue] > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[request responseString] forKey:@"myid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self performSelector:@selector(getBannerAds) withObject:nil afterDelay:0.2];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"error - %@\n",error);
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network error" message:@"Check your network settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark Store image to Gallery
- (void) getPaths
{
	NSError *error;
	NSArray *documentsdirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *completePath = [documentsdirectory objectAtIndex:0];
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:completePath error:&error];
	NSMutableArray *gridNameArray = [[NSMutableArray alloc] init];
	
	for (NSString *fileName in contents) 
	{
		NSRange r1 = [fileName rangeOfString:@"."];
		NSRange r2 = [fileName rangeOfString:@"_"];
		if(r1.location == 0 || r2.location == 0) 
		{ 
			// it may be a system file so don't store.
		}
		else 
		{
			if([fileName isEqualToString:@"edit.MyJeweler.sqlite"] || [fileName isEqualToString:@"logo.png"]) {	}
			else 
			{
				r1 = [fileName rangeOfString:@"jpg"];r2 = [fileName rangeOfString:@"png"];
				if(r1.location > 0 || r2.location > 0) 
				{
					NSString *tempPath = [completePath stringByAppendingPathComponent:fileName];
					UIImage *img = [UIImage imageWithContentsOfFile:tempPath];
					UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
					[[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
					[gridNameArray addObject:fileName];						
				}
			}
		}
	}
	[gridNameArray release];
}

#pragma mark -

#pragma mark NSURLRequest
-(void) getAddress
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%f,%f&sensor=false",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"],[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]  initWithURL:url];
    NSHTTPURLResponse * returnResponse = nil;
    NSError * returnError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:req returningResponse:&returnResponse error:&returnError];
    NSString    *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *results = [str JSONValue];
    if([[results objectForKey:@"status"] isEqualToString:@"OK"])
    {
        NSArray *arr = [results objectForKey:@"results"];
        if([arr count] > 0)
        {
            NSDictionary *dict = [arr objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"formatted_address"] forKey:@"myaddrs"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"address - %@",[dict objectForKey:@"formatted_address"]);
        }
	}
	[req release];
	[str release];
}
#pragma mark -

#pragma mark Utilities
- (NSString*) getDate:(int)option {								// 1 - date,          2 - time,           3 - date_time
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSString *dateString;
	if(option == 1) {
		[dateFormat setDateFormat:@"MM/dd/yyyy"];
		dateString = [dateFormat stringFromDate:today];
	}
	if(option == 2) {
		[dateFormat setDateFormat:@"HH:mm:ss"];
		dateString = [dateFormat stringFromDate:today];
	}
	if(option == 3) {
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		dateString = [dateFormat stringFromDate:today];
	}
	
	[dateFormat release];
	return dateString;
}

- (void) updateToken
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] intValue] > 0)
	{
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/register.php", URL]];
		ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
		[req setPostValue:@"0" forKey:@"option"];
		[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"uid"];
		[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"]] forKey:@"lat"];
		[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]] forKey:@"lng"];
		[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myaddrs"] forKey:@"address"];
		[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [req setDidFinishSelector:@selector(tokenUpdated:)];
        [req setDelegate:self];
		[req startAsynchronous];		
        [req release];
		[url release];				
	}
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firsttime"])
    {
        [self performSelector:@selector(getBannerAds) withObject:nil afterDelay:0.5];
    }
}

- (void) tokenUpdated:(ASIHTTPRequest *)request
{
//    NSLog(@"lat lng - %f,%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"],[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]);
    NSLog(@"updateToken - %@",[request responseString]);
}

#pragma mark -
#pragma mark Banner Ads

- (Banner*) getAd
{
    if([bannersArray count] > 0)
    {
        bannerIndex++;
        if(bannerIndex > [bannersArray count] - 1)
        {
            bannerIndex = 0;
        }
//        int randomNumber = (arc4random() % [bannersArray count]);
//        NSLog(@"random num = %d uid - %@",randomNumber,[[bannersArray objectAtIndex:randomNumber] uid]);
        return [bannersArray objectAtIndex:bannerIndex];
    }
    return nil;
}
#pragma mark -
- (BOOL) isIPhone5
{
    return iphone5;
}
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
#pragma mark -

- (void)dealloc 
{
	if(obj_RootViewController != nil)
	{
		[obj_RootViewController release];
	}
    
    if(bannersArray != nil)
    {
        [bannersArray removeAllObjects];
        [bannersArray release];
        bannersArray  = nil;
    }
    
    [obj_Gps release];
    [window release];
    [nav1 release];
    [super dealloc];
}


@end
