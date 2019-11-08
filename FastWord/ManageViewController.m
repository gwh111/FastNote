//
//  EditViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "ManageViewController.h"
#import "ManageTableViewCell.h"

@interface ManageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) CC_TableView *tableView;
@property (nonatomic, retain) NSArray *noteList;
@property (nonatomic, retain) NSMutableArray *summaryList;

@end

@implementation ManageViewController

- (void)cc_viewWillLoad {
    
    self.cc_title = Language.manageText;
   
    _tableView = ccs.TableView
    .cc_frame(0, 0, WIDTH(), self.cc_displayView.height)
    .cc_backgroundColor(UIColor.clearColor)
    .cc_delegate(self)
    .cc_dataSource(self)
    .cc_addToView(self);
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)cc_viewDidLoad {
	 // Do any additional setup after loading the view.
    
    [self update:^{
        
    }];
}

- (void)update:(void (^)(void))block {
    [ccs gotoThread:^{

        self->_noteList = [NoteStore getList];
        self->_summaryList = ccs.mutArray;
        int count = (int)self->_noteList.count;
        for (int i = 0; i < count; i++) {
            NoteModel *model = self->_noteList[i];
            [self->_summaryList addObject:model.summary];
        }
        [ccs gotoMain:^{
            [self->_tableView reloadData];
            block();
        }];
    }];
}

//tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _summaryList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ManageTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.text = _summaryList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.deleteButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        
        if (SettingManage.shared.deleteAsk) {
            [ccs showAltOn:self title:Language.noticeText msg:Language.youWantDeleteAskText bts:@[Language.noText, Language.yesText] block:^(int index, NSString *name) {
                if (index == 1) {
                    [self deleteIndex:indexPath.row];
                }
            }];
            return;
        }
        [self deleteIndex:indexPath.row];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)deleteIndex:(NSUInteger)index {
    [NoteStore deleteSummaryModel:self->_noteList[index]];
    [NoteStore deleteContentModel:self->_noteList[index]];
    
    [self update:^{
        [ccs showNotice:Language.deleteSuccessText];
    }];
}

@end
