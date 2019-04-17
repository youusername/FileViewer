//
//  Directory.m
//  FileViewerDemo
//
//  Created by finn on 2019/4/17.
//  Copyright © 2019 finn. All rights reserved.
//

#import "Directory.h"

@implementation Metadata
- (instancetype)initName:(NSString*)name Date:(NSDate*)date Size:(NSInteger)size Icon:(NSImage*)icon Color:(NSColor*)color isFolder:(BOOL)isFolder URL:(NSURL*)url{
    self = [super init];
    if (self) {
        self.name = name;
        self.date = date;
        self.size = size;
        self.icon = icon;
        self.color = color;
        self.isFolder = isFolder;
        self.url    = url;
    }
    return self;
}

@end


@implementation Directory

- (NSMutableArray<Metadata *> *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

- (instancetype)initFolderURL:(NSURL*)url{
    self = [super init];
    if (self) {
        self.url = url;

        NSArray * requiredAttributes = @[NSURLLocalizedNameKey,NSURLEffectiveIconKey,NSURLTypeIdentifierKey,NSURLContentModificationDateKey,NSURLFileSizeKey,NSURLIsDirectoryKey,NSURLIsPackageKey];
        
        NSDirectoryEnumerator<NSURL *> * enumerator = [[NSFileManager defaultManager] enumeratorAtURL:url includingPropertiesForKeys:requiredAttributes options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
        
        for (NSURL * url in enumerator) {
            if ([url isKindOfClass:[NSURL class]]) {
                NSDictionary * properties = [url resourceValuesForKeys:requiredAttributes error:nil];
                NSString * name = [NSString stringWithFormat:@"%@",properties[NSURLLocalizedNameKey]];
                NSDate * date = properties[NSURLContentModificationDateKey] ?  properties[NSURLContentModificationDateKey] : [NSDate date];
                NSInteger size = [properties[NSURLFileSizeKey] integerValue] ? [properties[NSURLFileSizeKey] integerValue] : 0;
                NSImage * icon = properties[NSURLEffectiveIconKey] ? properties[NSURLEffectiveIconKey] : [NSImage new];
                BOOL isFolder = [properties[NSURLIsDirectoryKey] boolValue];
                NSColor * color = [NSColor new];
                
                Metadata * meta = [[Metadata alloc]initName:name Date:date Size:size Icon:icon Color:color isFolder:isFolder URL:url];
                [self.files addObject:meta];
            }
        }
        
    }
    return self;
}
@end
