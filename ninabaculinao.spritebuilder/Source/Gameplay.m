//
//  Gameplay.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Grid.h"
#import "Dice.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    Grid *_grid;
    CCTimer *_timer;
    CCLabelTTF *_scoreLabel;
}

- (void)didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    [self makeNewDicePair];
    _physicsNode.debugDraw = TRUE;
}

- (void)makeNewDicePair{
 //   for (int i = 0; i > 2; i++) {
        Dice *_dice;
        _dice = [Dice makeNewDice];
        _dice.position = ccp(-18,200);
        [_physicsNode addChild:_dice];
        Dice *_seconddice;
        _seconddice = [Dice makeNewDice];
        _seconddice.position = ccp(18,200);
        [_physicsNode addChild:_seconddice];
    
   // }
}

- (void)update:(CCTime)delta{
 
}


//
//- (id) init
//{
//    self = [super init];
//    
//    if (self) {
//        _timer = [[CCTimer alloc] init];
//    }
//    
//    return self;
//}

- (void)play
{
    // this tells the game to call a method called 'step' every half sec
    // [self schedule:@selector(step) interval:0.5f];
    [self makeNewDicePair];
}

- (void)pause
{
   // [self unschedule:@selector(step)];
}

// this method will get called every half sec when you hit play
// and it will stop when you hit pause
//- (void)step
//{
//    [_grid setupGrid];
//    _scoreLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
//}






@end
