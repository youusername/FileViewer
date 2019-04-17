//
//  ViewController.m
//  FileViewerDemo
//
//  Created by finn on 2019/4/17.
//  Copyright © 2019 finn. All rights reserved.
//

#import "ViewController.h"
#import "Directory.h"

@interface ViewController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *statusLabel;


@property(nonatomic,strong) NSByteCountFormatter* sizeFormatter ;
@property(nonatomic,strong) Directory* directory;
@property(nonatomic,strong) NSMutableArray<Metadata*>* directoryItems;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(tableViewDoubleClick:);
    
    self.sizeFormatter = [NSByteCountFormatter new];
    
}
- (void)tableViewDoubleClick:(id)sender{
    if (self.tableView.selectedRow >= 0) {
        Metadata * item = self.directoryItems[self.tableView.selectedRow];
        if (item) {
            if (item.isFolder) {
                [self setRepresentedObject:item.url];
            }else{
                [[NSWorkspace sharedWorkspace] openURL:item.url];
            }
        }
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    if ([representedObject isKindOfClass:[NSURL class]]) {
        self.directory = [[Directory alloc]initFolderURL:representedObject];
        [self reloadFileList];
    }
    
}
- (void)reloadFileList{
    self.directoryItems = self.directory.files;
    [self.tableView reloadData];
}

- (void)updateStatus{
    NSString * text;
    
    NSInteger itemsSelected = self.tableView.selectedRowIndexes.count;
    
    if (self.directoryItems == nil) {
        text = @"NO Items";
    }else if (itemsSelected == 0){
        text = [NSString stringWithFormat:@"%ld items",self.directoryItems.count];
    }else{
        text = [NSString stringWithFormat:@"%ld of %ld selected",itemsSelected,self.directoryItems.count];
    }
    self.statusLabel.stringValue = text;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.directoryItems.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSImage * image;
    NSString * text = @"";
    NSString * cellIdentifier = @"";
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateIntervalFormatterLongStyle;
    dateFormatter.timeStyle = NSDateIntervalFormatterLongStyle;
    
    Metadata * item = self.directoryItems[row];
    if (!item) {
        return nil;
    }

    
    if (tableColumn == tableView.tableColumns[0]) {
        image = item.icon;
        text = item.name;
        cellIdentifier = @"NameCellID";
    }else if (tableColumn == tableView.tableColumns[1]){
        text = [dateFormatter stringFromDate:item.date];
        cellIdentifier = @"DateCellID";
    }else if (tableColumn == tableView.tableColumns[2]){
        text = item.isFolder ? @"--" : [self.sizeFormatter stringFromByteCount:item.size];
        cellIdentifier = @"SizeCellID";
    }
    NSTableCellView * cell = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    if (cell) {
        cell.textField.stringValue = text;
        cell.imageView.image = image ? image : nil;
        return cell;
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [self updateStatus];
}


@end
