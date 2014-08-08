//
//  Chain.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Chain.h"

@implementation Chain {
    NSMutableArray *_dice;
}

- (void)addDice:(Dice *)die {
    if (_dice == nil) {
        _dice = [NSMutableArray array];
    }
    [_dice addObject:die];
}

- (NSArray *)dice {
    return _dice;
}

@end
