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

// two constants to describe the amount of rows and columns
static const int GRID_ROWS = 12;
static const int GRID_COLUMNS = 6;

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    Grid *_grid;
    CCTimer *_timer;
    CCLabelTTF *_scoreLabel;
    Dice *_dice;
    Dice *_seconddice;
    
    NSMutableArray *_gridArray; // a 2d array
    float _cellWidth; // two vars used to place dice correctly
    float _cellHeight;
}

- (id)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

- (void)didLoadFromCCB{
    [self makeNewDicePair];
    _physicsNode.debugDraw = TRUE;
}

- (void)makeNewDicePair{
    _dice = [Dice makeNewDie];
    _dice.position = ccp(-20,200);
    [_physicsNode addChild:_dice];
    
    _seconddice = [Dice makeNewDie];
    _seconddice.position = ccp(20,200);
    [_physicsNode addChild:_seconddice];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    Dice *dice = [self diceForTouchPosition:touchLocation];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    _dice.position = touchLocation;
}

- (Dice *)diceForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Dice inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    return _gridArray[row][column];
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
