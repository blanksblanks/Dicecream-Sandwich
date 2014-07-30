//
//  Chain.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Dice;

typedef NS_ENUM(NSInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface Chain : NSObject

@property (strong, nonatomic, readonly) NSArray *dice;

@property (assign, nonatomic) ChainType chainType;

- (void)addDice:(Dice *)die;

@end
