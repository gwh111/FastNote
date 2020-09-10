//
//  Data.h
//  BiGuan
//
//  Created by gwh on 2020/2/6.
//  Copyright © 2020 gwh. All rights reserved.
//

#import "CC_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface Data : CC_Model

@property (nonatomic, assign) BOOL kouzhaoCountStart;
@property (nonatomic, assign) int kouzhaoCount;
@property (nonatomic, retain) NSArray *kouzhaoTexts;

+ (instancetype)shared;

- (NSArray *)stateList;
- (NSArray *)productsList;

@end

NS_ASSUME_NONNULL_END
