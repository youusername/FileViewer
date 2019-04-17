//
//  Directory.h
//  FileViewerDemo
//
//  Created by finn on 2019/4/17.
//  Copyright © 2019 finn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Metadata : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSDate *   date;
@property (nonatomic,assign) NSInteger  size;
@property (nonatomic,strong) NSImage *  icon;
@property (nonatomic,strong) NSColor *  color;
@property (nonatomic,assign) BOOL       isFolder;
@property (nonatomic,strong) NSURL  *   url;

- (instancetype)initName:(NSString*)name Date:(NSDate*)date Size:(NSInteger)size Icon:(NSImage*)icon Color:(NSColor*)color isFolder:(BOOL)isFolder URL:(NSURL*)url;
@end

typedef NS_ENUM(NSInteger,FileOrder){
    fName = 0,
    fDate,
    fSize
};
@interface Directory : NSObject
@property (nonatomic,strong) NSMutableArray <Metadata*> * files;
@property (nonatomic,strong) NSURL  *   url;

- (instancetype)initFolderURL:(NSURL*)url;
@end

NS_ASSUME_NONNULL_END
