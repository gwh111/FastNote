//
//  ViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/4.
//  Copyright 2019 gwh. All rights reserved.
//

#import "HomeViewController.h"
#import "InputViewController.h"
#import "AboutViewController.h"
#import "ManageViewController.h"
#import "SettingViewController.h"
#import "MoreLib.h"
#import "BiGuanVC.h"
#import "KouZhaoVC.h"
#import "FastWord-Swift.h"

@interface HomeViewController () <CC_LabelGroupDelegate,UICollectionViewDataSource,HWCollectionViewFlowLayoutDelegate,UICollectionViewDelegate> {
    CC_ScrollView *noteScrollView;
    CC_LabelGroup *noteGroup;
    CC_LabelGroup *menuGroup;
    
    NSArray *noteList;
    NSArray *noteColorList;
    
    NSString *TEXT_NEW;
    NSString *TEXT_SETTING;
    NSString *TEXT_MANAGE;
    NSString *TEXT_RECOMMAND;
    NSString *TEXT_ABOUT;
    
    BOOL hasLoad;
}

@property (nonatomic, retain) NSMutableArray *summaryList;
@property (nonatomic, retain) UICollectionView *collectionView;

@end

@implementation HomeViewController

- (void)cc_viewDidPopFrom:(CC_ViewController *)viewController userInfo:(id)userInfo {
    
    NoteModel *summaryModel = NoteModel.new;
    NoteModel *contentModel = NoteModel.new;
    contentModel.content = userInfo;
    
    InputViewController *vc = [ccs init:InputViewController.class];
    vc.summaryModel = summaryModel;
    vc.contentModel = contentModel;
    [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
}

- (void)cc_dismisViewController {
    
    [self update];
}

- (void)cc_viewWillLoad {
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
//    self.cc_title = Language.fastNoteText;
    self.cc_navigationBarHidden = YES;
    
    HWCollectionViewFlowLayout *flow = HWCollectionViewFlowLayout.new;
    flow.delegate = self;
    CGRect frame = CGRectMake(0, 0, WIDTH(), self.cc_displayView.height - RH(150));
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flow];
    [collectionView registerClass:ItemCollectionView.class forCellWithReuseIdentifier:@"ggg"];
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.cc_displayView addSubview:collectionView];
    _collectionView = collectionView;
    
//    noteScrollView = ccs.ScrollView
//    .cc_frame(0, 0, WIDTH(), self.cc_displayView.height - RH(150))
//    .cc_addToView(self);
//
//    noteGroup = ccs.LabelGroup;
//    noteGroup.delegate = self;
//    [noteGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(10) sideX:RH(10) sideY:RH(10) itemHeight:RH(50) margin:RH(20)];
//    noteGroup.top = 0;
//    [noteScrollView cc_addSubview:noteGroup];
    
    CC_Button *btn = ccs.Button;
    btn.cc_frame(RH(10),self.cc_displayView.height - RH(149),WIDTH()-RH(20),RH(50))
    .cc_setTitleColorForState(UIColor.blackColor,UIControlStateNormal)
    .cc_setNormalTitle(Language.newText)
    .cc_backgroundColor(RGB(242, 242, 242))
    .cc_cornerRadius(4)
    .cc_addToView(self.cc_displayView);
//    [btn cc_setShadow:UIColor.grayColor];
    
//    ccs.ui.grayLine.cc_top(btn.top).cc_addToView(self.cc_displayView);
    
    [btn cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        [self presentNew];
    }];
    
    CC_View *menuView = ccs.View;
    menuView.cc_frame(0, self.cc_displayView.height - RH(100), WIDTH(), RH(150))
    .cc_addToView(self);

    menuGroup = ccs.LabelGroup;
    menuGroup.delegate = self;
    [menuGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(10) sideX:RH(10) sideY:RH(10) itemHeight:RH(60) margin:RH(30)];
    menuGroup.top = 0;
    [menuView cc_addSubview:menuGroup];
}

- (CGFloat)hw_setCellHeghtWithLayout:(HWCollectionViewFlowLayout *)layout indexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    NoteModel *model = noteList[indexPath.row];
    return model.height;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return noteList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *model = noteList[indexPath.row];
    ItemCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ggg" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = RGB(242, 242, 242);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InputViewController *vc = [ccs init:InputViewController.class];
    vc.summaryModel = noteList[indexPath.row];
    [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
    
}

- (void)cc_viewDidLoad {
    
    TEXT_NEW = [Language newText];
    TEXT_SETTING = [Language settingText];
    TEXT_MANAGE = [Language manageText];
    TEXT_RECOMMAND = [Language recommandText];
    TEXT_ABOUT = [Language aboutText];
    
    if (Language.isChinese) {
        [menuGroup updateLabels:@[TEXT_MANAGE, TEXT_RECOMMAND, TEXT_ABOUT] selected:nil];
    } else {
        [menuGroup updateLabels:@[TEXT_MANAGE, TEXT_ABOUT] selected:nil];
    }
    
    [self presentNew];
    
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            
            self.cc_navigationBar.backgroundColor = RGBA(100, 100, 100, .2);
        } else if (mode == UIUserInterfaceStyleLight) {
            
        }
    }
    
}

- (void)cc_viewWillAppear {
    
    if (hasLoad == NO) {
        hasLoad = YES;
    } else {
        [self update];
    }
}

- (void)update {
    [ccs gotoThread:^{

        self->noteList = [NoteStore getList];
        NSArray *colors = [ShareData noteColors];
        NSMutableArray *summaryList = ccs.mutArray;
        NSMutableArray *colorList = ccs.mutArray;
        int count = (int)self->noteList.count;
        for (int i = 0; i < count; i++) {
            NoteModel *model = self->noteList[i];
            NSString *summary = model.summary;
            CCLOG(@"%d", (int)SettingManage.shared.maxTextCount);
            if (summary.length > 100) {
                summary = [summary substringToIndex:SettingManage.shared.maxTextCount];
            }
            model.summary = summary;
            
            [summaryList addObject:summary];
            [colorList addObject:colors[model.colorIndex]];
        }
        self->noteColorList = colorList;
        self.summaryList = summaryList;
        
        [ccs gotoMain:^{
            
            float plusHeight = SettingManage.shared.fontSizeIndex * RH(5);
            float plusMargin = SettingManage.shared.fontSizeIndex * RH(7);
            [self.collectionView reloadData];
//            [self->noteGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(5) sideX:RH(10) sideY:RH(5) itemHeight:RH(40) + plusHeight margin:RH(20) + plusMargin];
//            [self->noteGroup updateLabels:summaryList selected:nil];
        }];
    }];
}

- (void)labelGroup:(CC_LabelGroup *)group button:(UIButton *)button tappedAtIndex:(NSUInteger)index {
    
    if (group == noteGroup) {
        
        InputViewController *vc = [ccs init:InputViewController.class];
        vc.summaryModel = noteList[index];
        [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
    
    } else if (group == menuGroup) {

        NSString *name = button.titleLabel.text;
        if ([name isEqualToString:TEXT_NEW]) {
            [self presentNew];
        } else if ([name isEqualToString:TEXT_ABOUT]) {
            AboutViewController *vc = [ccs init:AboutViewController.class];
            [ccs pushViewController:vc];
        } else if ([name isEqualToString:TEXT_MANAGE]) {
            ManageViewController *vc = [ccs init:ManageViewController.class];
            [ccs pushViewController:vc];
        } else if ([name isEqualToString:TEXT_SETTING]) {
            SettingViewController *vc = [ccs init:SettingViewController.class];
            [ccs pushViewController:vc];
        } else if ([name isEqualToString:TEXT_RECOMMAND]) {
            [MoreLib addMoreLibAt:self.view];
        } else if ([name isEqualToString:@"抢口罩"]) {
            [ccs pushViewController:KouZhaoVC.new];
//            [ccs pushViewController:BiGuanVC.new];
        }
    }
    
}

- (void)presentNew {
    InputViewController *vc = [ccs init:InputViewController.class];
    [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
}

- (void)labelGroup:(CC_LabelGroup *)group initWithButton:(UIButton *)button {
    if (group == noteGroup) {

        button.titleLabel.font = RF(SettingManage.shared.fontSize);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

        button.cc_cornerRadius(RH(5));
        UIColor *color = noteColorList[button.tag - 100];
        [button setBackgroundColor:color];
        if (!SettingManage.shared.hiddenBorder) {
            button.cc_borderWidth(1);
            button.cc_borderColor(UIColor.blackColor);
        } else {
            if (color == UIColor.whiteColor) {
                [button setBackgroundColor:RGB(242, 242, 242)];
            }
        }
        
        
    } else if (group == menuGroup) {

        button.backgroundColor = RGB(242, 242, 242);
        button.titleLabel.font = RF(18);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.cc_cornerRadius(RH(5));
//        button.cc_borderWidth(1);
//        button.cc_borderColor(UIColor.blackColor);
//        [button cc_setShadow:UIColor.grayColor];
    }
}

- (void)labelGroupInitFinish:(CC_LabelGroup *)group {
    
    if (group.height > noteScrollView.height) {
        noteScrollView.contentSize = CGSizeMake(WIDTH(), group.height);
    } else {
        noteScrollView.contentSize = CGSizeMake(WIDTH(), noteScrollView.height);
    }
}


@end
