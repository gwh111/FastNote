//
//  ccs+MoreC.m
//  MoreC
//
//  Created by gwh on 2020/2/28.
//  Copyright © 2020 gwh. All rights reserved.
//

#import "ccs+More.h"

@implementation ccs (More)

+ (More *)more {
    More *c = [ccs init:More.class];
    [c cc_setup];
    return c;
}

@end
