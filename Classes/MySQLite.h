//
//  MySQLite.h
//  THC
//
//  Created by Nikesh Kannan on 10/08/10.
//  Copyright Deemag Infotech Pvt Ltd 2010. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MySQLite : NSObject 
{
	NSString						*SQLFilePath;
	sqlite3							*rdb;					
	int								success;					// if DB Connection Success
	int								rowid;
	int								dbSizeCount;				
}

- (id) initWithSQLFile:(NSString *)sqlfile;
- (void) openDb;
- (void) readDb:(NSString *)sqlQuery;
- (void) updateDb:(NSString *)sqlQuery;
- (NSString *) getColumn:(int)colnum type:(NSString *)text_or_int;
- (BOOL) hasNextRow;
- (BOOL) stepQuery;
- (int) getRowId;
- (void) closeDb;
- (int)getDbSize:(NSString *)tableName; 

@end
