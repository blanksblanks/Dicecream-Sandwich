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
    Dice *_dice;
    _dice = [Dice makeNewDice];
    _dice.position = ccp(2,5);
    [_physicsNode addChild:_dice];
}

- (void)update:(CCTime)delta{
 
}

- (void)makeNewDice{
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
    [self schedule:@selector(step) interval:0.5f];
}

- (void)pause
{
    [self unschedule:@selector(step)];
}

// this method will get called every half sec when you hit play
// and it will stop when you hit pause
//- (void)step
//{
//    [_grid setupGrid];
//    _scoreLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
//}






@end
