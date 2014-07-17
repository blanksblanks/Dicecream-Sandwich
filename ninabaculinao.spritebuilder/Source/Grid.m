//
//  Grid.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"
#import "Dice.h"

@implementation Grid {
    
    CGFloat _tileWidth;
	CGFloat _tileHeight;
	CGFloat _tileMarginVertical;
	CGFloat _tileMarginHorizontal;
    
    NSMutableArray *_gridArray; // a 2d array
    NSNull *_noTile;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_invisibleFloor;
    Grid *_grid;
    Dice *_firstdie;
    Dice *_seconddie;
}

// two constants to describe the amount of rows and columns
static const int GRID_ROWS = 12;
static const int GRID_COLUMNS = 6;


- (void)didLoadFromCCB{
    _physicsNode.debugDraw = TRUE;
    _invisibleFloor.physicsBody.sensor=TRUE;
}

- (void)onEnter // method to activate touch handling on the grid
{
    [super onEnter];
    [self setupGrid];
    self.userInteractionEnabled = true;
}

- (void)setupGrid
{
	// load one tile to read the dimensions
	CCNode *tile = [CCBReader load:@"Tile"];
	_tileWidth = tile.contentSize.width;;
	_tileHeight = tile.contentSize.width;;
    // this hotfix is needed because of issue #638 in Cocos2D 3.1 / SB 1.1 (https://github.com/spritebuilder/SpriteBuilder/issues/638)
    //[tile performSelector:@selector(cleanup)];
    
	// calculate the margin by subtracting the block sizes from the grid size
	_tileMarginHorizontal = (self.contentSize.width - (GRID_COLUMNS * _tileWidth)) / (GRID_COLUMNS+1);
	_tileMarginVertical = (self.contentSize.height - (GRID_ROWS * _tileWidth)) / (GRID_ROWS+1);
	// set up initial x and y positions
	float x = _tileMarginHorizontal;
	float y = _tileMarginVertical;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
	for (int i = 0; i < GRID_ROWS; i++) {
        // iterate through each row
        // create 2d array by putting array into array
        _gridArray[i] = [NSMutableArray array];
		x = _tileMarginHorizontal;
        
		for (int j = 0; j < GRID_COLUMNS; j++) {
			//  iterate through each column in the current row

//            Tile *tile = [[Tile alloc] initTile];
//            tile.position = ccp(x, y);
//            [self addChild:tile]; // problem here without initialization
//            // this is shorthand to access an array inside an array
//            _gridArray[i][j] = tile;
//            tile.isOccupied = TRUE; // debugging to see placement
            
            CCNodeColor *backgroundTile = [CCNodeColor nodeWithColor:[CCColor blackColor]];
			backgroundTile.contentSize = CGSizeMake(_tileWidth, _tileHeight);
			backgroundTile.position = ccp(x, y);
			[self addChild:backgroundTile];
            
			x+= _tileWidth + _tileMarginHorizontal; // after positioning a block increase x variable
		}
		y += _tileHeight + _tileMarginVertical; // after completing row increase y variable
	}
}

# pragma mark - Create new dice

- (void)makeNewDicePair{
    for (int i = 3; i < 4; i++) {
        _firstdie = [Dice makeNewDie];
        _firstdie.position = ccp(96,448);
        [_physicsNode addChild:_firstdie];
        _seconddie = [Dice makeNewDie]; //CCDragSprite
        _seconddie.position = ccp(37,18.5);
        [_firstdie addChild:_seconddie];
    }
}

# pragma mark - Touch handling

//get the x,y coordinates of the touch
//    CGPoint touchLocation = [touch locationInNode:self.parent];
//    self.position = touchLocation;
    //CCLOG(@"Self position is %d", self.position);


//- (Dice *)diceForTouchPosition:(CGPoint)touchPosition
//{
//    //get the row and column that was touched, return the Dice inside the corresponding cell
//    int row = touchPosition.y/_cellHeight;
//    int column = touchPosition.x/_cellWidth;
//    return _gridArray[row][column];
//}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    _firstdie.position = touchLocation;
    //_seconddie.position = ccpAdd(touchLocation, ccp(_seconddie.boundingBox.size.width, 0));
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    
    BOOL canTouch = YES;
    if (canTouch) {
        canTouch = NO;
        CCActionRotateBy *rotateDice = [CCActionRotateBy actionWithDuration:.4 angle:90];
        CCActionCallBlock *resetTouch = [CCActionCallBlock actionWithBlock:^{
            BOOL canTouch = YES;
            ;  }];
        [_firstdie runAction:[CCActionSequence actionOne:rotateDice two:resetTouch]];
        
//        CGPoint touchLocation = [touch locationInNode:self];
//        _firstdie.position = touchLocation;
//        _seconddie.position = ccpAdd(touchLocation, ccp(_seconddie.boundingBox.size.width, 0));
    }
}



@end
