//
//  Grid.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Dice.h"
//#import "CCDragSprite.h"

// two constants to describe the amount of rows and columns
static const int GRID_ROWS = 12;
static const int GRID_COLUMNS = 6;

@implementation Grid {
    NSMutableArray *_gridArray; // a 2d array
    float _cellWidth; // two vars used to place dice correctly
    float _cellHeight;
    
    CCPhysicsNode *_physicsNode;
    Grid *_grid;
    Dice *_dice;
    Dice *_seconddice;
}

- (void)didLoadFromCCB{
    _physicsNode.debugDraw = TRUE;
}

- (void)onEnter // method to activate touch handling on the grid
{
    [super onEnter];
    [self setupGrid];
    self.userInteractionEnabled = true;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Dice
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Dice *dice = [[Dice alloc] initDice];
            dice.anchorPoint = ccp(0, 0);
            dice.position = ccp(x, y);
            [self addChild:dice];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = dice;
            
            x+=_cellWidth; // after positinioning a Creature we increase x variable
        }
        
        y += _cellHeight; // after completing row we increase y variable
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    Dice *dice = [self diceForTouchPosition:touchLocation];
    //get the x,y coordinates of the touch
//    CGPoint touchLocation = [touch locationInNode:self.parent];
//    self.position = touchLocation;
    //CCLOG(@"Self position is %d", self.position);
}

- (Dice *)diceForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Dice inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    return _gridArray[row][column];
}

- (void)makeNewDicePair{
    _dice = [Dice makeNewDie];
    _dice.position = ccp(96,448);
    [_physicsNode addChild:_dice];
    _seconddice = [Dice makeNewDie]; //CCDragSprite
    _seconddice.position = ccp(134,448);
    [_physicsNode addChild:_seconddice];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    _dice.position = touchLocation;
}


@end
