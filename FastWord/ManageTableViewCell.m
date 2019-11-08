//
//  ManageTableViewCell.m
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "ManageTableViewCell.h"

@implementation ManageTableViewCell
@synthesize textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor clearColor];
        
        float width = WIDTH() - RH(90);
        float height = RH(35);
        
        CC_View *labelView = ccs.View;
        labelView
        .cc_frame(RH(10), 0, width, height)
        .cc_borderColor(UIColor.darkGrayColor)
        .cc_borderWidth(1)
        .cc_cornerRadius(4)
        .cc_addToView(self);
        
        textLabel = ccs.Label
        .cc_frame(RH(10), 0, width - RH(20), height)
        .cc_font(RF(16))
        .cc_textColor(UIColor.darkGrayColor)
        .cc_addToView(labelView);
        
        _deleteButton = ccs.Button
        .cc_frame(labelView.right + RH(10), 0, RH(60), RH(35))
        .cc_addToView(self)
        .cc_setTitleForState(Language.deleteText, UIControlStateNormal)
        .cc_setTitleColorForState(UIColor.darkGrayColor, UIControlStateNormal)
        .cc_borderColor(UIColor.darkGrayColor)
        .cc_borderWidth(1)
        .cc_cornerRadius(4);
        
    }
    return self;
}

@end
