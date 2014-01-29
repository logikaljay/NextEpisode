//
//  NEGetShowsList.h
//  NextEpisode
//
//  Created by Jay Baker on 30/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEGetShowsList : NSObject
<NSXMLParserDelegate> {
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
}

- (NSMutableArray *)parseXMLFileAtURL:(NSURL *)URL;

@end
