//
//  NEGetShowsList.m
//  NextEpisode
//
//  Created by Jay Baker on 30/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEGetShowsList.h"

@implementation NEGetShowsList

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"File found and parsing started");
}

- (NSMutableArray *)parseXMLFileAtURL:(NSURL *)URL
{
    NSString *userAgent = @"Mozilla/5.0 (Macintosh; U; Intel Mac OSX 10_9_0; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    NSData *xmlFile = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    articles = [[NSMutableArray alloc] init];
    rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
    [rssParser setDelegate:self];
    [rssParser parse];
    errorParsing = NO;
    
    return articles;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSString *error = [NSString stringWithFormat:@"Parsing Error %i", [parseError code]];
    NSLog(@"%@", error);
    errorParsing = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributes
{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"show"]) {
        item = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [ElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"show"]) {
        [articles addObject:[item copy]];
    } else {
        [item setObject:ElementValue forKey:elementName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (!errorParsing) {
        NSLog(@"XML processing done");
    } else {
        NSLog(@"Error occured during XML processing");
    }
}

@end
