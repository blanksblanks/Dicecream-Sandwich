//
//  Dice.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Dice : CCSprite

@property (nonatomic, assign) int faceValue;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint deltaPosition;
@property (nonatomic, assign) BOOL falling;

- (id)initDice;
+ (Dice*)makeNewDie;
-(CGRect) collisionBox;

@end
