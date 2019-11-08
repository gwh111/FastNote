//
//  ManageTableViewCell.h
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageTableViewCell : UITableViewCell

@property (nonatomic, retain) CC_Label *textLabel;
@property (nonatomic, retain) CC_Button *deleteButton;

@end

NS_ASSUME_NONNULL_END
