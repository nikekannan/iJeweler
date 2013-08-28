//
//  Banner.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Banner : NSObject 
{
    UIImage  *bannerImage;
    NSString *bannerURL;
    NSString *bannerID;
    
    NSMutableData   *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) UIImage  *bannerImage;
@property (nonatomic, retain) NSString *bannerURL;
@property (nonatomic, retain) NSString *bannerID;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;


- (void)startDownload;
- (void)cancelDownload;
@end
