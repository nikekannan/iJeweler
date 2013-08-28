//
//  MySQLite.m
//  THC
//
//  Created by Nikesh Kannan on 10/08/10.
//  Copyright Deemag Infotech Pvt Ltd 2010. All rights reserved.
//


#import "MySQLite.h"
static sqlite3_stmt *r_query_statement = nil;
static sqlite3_stmt *count_statement = nil;

@implementation MySQLite

-(id) initWithSQLFile:(NSString *)sqlfile 
{
	NSString *editableSQLfile = [[[NSString alloc] initWithFormat:@"edit.%@", sqlfile]autorelease];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	SQLFilePath = [documentsDirectory stringByAppendingPathComponent:editableSQLfile];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	success = [fileManager fileExistsAtPath:SQLFilePath];
    if (!success) 
	{
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlfile];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:SQLFilePath error:&error];
		if (!success)
		{
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
    }
 	success = 0;
	rowid = 0;
	return self;
}

-(void)openDb 
{
 	if (sqlite3_open([SQLFilePath UTF8String], &rdb) == SQLITE_OK) 
	{
 		//printf("\nOpened db - %s \n",[SQLFilePath UTF8String]);					// need this printf to know atleaset the DB got opened or not
	} 
	else 
	{
		printf("ERROR: Unable to open db - %s\n", [SQLFilePath UTF8String]);
	}
}

-(void) readDb:(NSString *)sqlQuery 
{
	if (r_query_statement == nil) 
	 {
        const char *sql = [sqlQuery UTF8String];
        if (sqlite3_prepare_v2(rdb, sql, -1, &r_query_statement, NULL) != SQLITE_OK) 
		 {
			printf(" ERROR !! \n\n");
            NSAssert1(0, @"Error: failed to prepare statement with message -'%s'", sqlite3_errmsg(rdb));
        }
    }
}

-(void) updateDb:(NSString *)sqlQuery 
{
 	if (r_query_statement == nil) 
	 {
        const char *sql = [sqlQuery UTF8String];
        if (sqlite3_prepare_v2(rdb, sql, -1, &r_query_statement, NULL) != SQLITE_OK) 
		 {
			printf(" ERROR !! \n\n");
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(rdb));
        }
    }
	[self hasNextRow];
}

-(BOOL) hasNextRow 
{
	if (r_query_statement != nil) 
	 {
		success = sqlite3_step(r_query_statement);
		rowid++;
	}
	return (success == SQLITE_ROW) ? YES : NO;
}

-(BOOL) stepQuery 
{
	return [self hasNextRow];
}

// Should run hasNextRow before getColumn
-(NSString *) getColumn:(int)colnum type:(NSString *)text_or_int 
{
	NSString *value = nil;
	
	if (success == SQLITE_ROW) {
		if ([text_or_int isEqualToString:@"text"])
		{
			const unsigned char *colVal = sqlite3_column_text(r_query_statement, colnum);
			value = (colVal == NULL) ? @"" : [NSString stringWithUTF8String:(char *)colVal];
 		} 
		else if ([text_or_int isEqualToString:@"int"])
		{
			value = [NSString stringWithUTF8String:(char *)sqlite3_column_int(r_query_statement, colnum)];
		}
    }
	return value;
}

-(int) getRowId 
{
	return rowid;
}

-(int)getDbSize:(NSString *)tableName 
{

	if (count_statement == nil) 
	 {
		const char *sql = "SELECT count(rowid) FROM GamesList WHERE rowid>0";
        if (sqlite3_prepare_v2(rdb, sql, -1, &count_statement, NULL) != SQLITE_OK) 
		 {
             NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(rdb));
        }
    }
	// Execute the query.
    success = sqlite3_step(count_statement);
     if (success == SQLITE_ROW) 
	{
		dbSizeCount = sqlite3_column_int(count_statement, 0);
	}
	// Reset the query for the next use.
	sqlite3_reset(count_statement);
	sqlite3_finalize(count_statement);
	count_statement=nil;
 	return dbSizeCount;	
}

-(void) closeDb 
{
 	sqlite3_reset(r_query_statement);
	sqlite3_finalize(r_query_statement);
	
	// Close the database
	int retClose = sqlite3_close(rdb);
	if (retClose != SQLITE_OK) 
	{
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(rdb));
	}
	r_query_statement = nil;
	rowid=0;
	success=0;
}


@end
