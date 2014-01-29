//
//  NEShow.m
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEShow.h"
#import "NEShowDatabase.h"
#define kDataKey        @"Shows"
#define kDataFile       @"shows.plist"

@implementation NEShow

@synthesize docPath = _docPath;

- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    
    return self;
}

- (id)initShowWithName:(NSString*)name {
    if (self == nil) {
        self = [[NEShow alloc] init];
    }
    
    self.showName = name;
    return self;
}

- (id)initShowWithName:(NSString *)name
                   andId:(NSInteger)identifier {
    if (self == nil) {
        self = [[NEShow alloc] init];
    }
    
    self.showName = name;
    self.showId = identifier;
    
    return self;
}

- (id)initShowWithName:(NSString *)name andId:(NSInteger)identifier andDate:(NSDate*)date {
    if (self == nil) {
        self = [[NEShow alloc] init];
    }
    
    self.showName = name;
    self.showId = identifier;
    self.showDate = date;
    
    return self;
}

- (BOOL) createDataPath {
    if (_docPath == nil) {
        self.docPath = [NEShowDatabase nextShowDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    
    return success;
}

- (NEShow *)show {
    if (self != nil) return self;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NEShow *show = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return show;
}

- (void)saveData {
    if (_showName == nil) return;
    
    [self createDataPath];
    NSString *dataPath = [_docPath stringByAppendingString:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)deleteShow {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

#pragma mark NSCoding
#define kShowName @"ShowName"
#define kShowId @"ShowId"
#define kShowDate @"ShowDate"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_showName forKey:kShowName];
    [encoder encodeInteger:_showId forKey:kShowId];
    [encoder encodeObject:_showDate forKey:kShowDate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *showName = [decoder decodeObjectForKey:kShowName];
    NSInteger showId = [decoder decodeObjectForKey:kShowId];
    NSDate *showDate = [decoder decodeObjectForKey:kShowDate];
    
    return [self initShowWithName:showName andId:showId andDate:showDate];
}

- (void)dealloc
{
    //[_docPath release];
    _docPath = nil;
}

@end
