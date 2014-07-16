//
//  Dice.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Dice : CCSprite

- (id)initDice;
+ (Dice*)makeNewDie;

@property (nonatomic, assign) int faceValue;

@end
