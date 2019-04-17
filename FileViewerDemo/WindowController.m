//
//  WindowController.m
//  FileViewerDemo
//
//  Created by finn on 2019/4/17.
//  Copyright © 2019 finn. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController


-(IBAction)openDocument:(id)sender{
    NSOpenPanel *openPanel = [[NSOpenPanel alloc]init];
    openPanel.showsHiddenFiles = false;
    openPanel.canChooseFiles = false;
    openPanel.canChooseDirectories = true;
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        
        if (result == NSModalResponseOK) {
            self.contentViewController.representedObject = openPanel.URL;
        }else{
            return;
        }
    }];
}

@end
