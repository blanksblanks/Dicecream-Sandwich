//
//  Grid.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Dice.h"

@implementation Grid {
    
    CGFloat _tileWidth;
	CGFloat _tileHeight;
	CGFloat _tileMarginVertical;
	CGFloat _tileMarginHorizontal;
    
    NSMutableArray *_gridArray; // a 2d array
    NSNull *_noTile;

}

// two constants to describe the amount of rows and columns
static const int GRID_ROWS = 12;
static const int GRID_COLUMNS = 6;

- (void)didLoadFromCCB{
    
    [self setupGrid];
    _noTile = [NSNull null];
	_gridArray = [NSMutableArray array];
    
	for (int i = 0; i < GRID_ROWS; i++) {
		_gridArray[i] = [NSMutableArray array];
		for (int j = 0; j < GRID_COLUMNS; j++) {
			_gridArray[i][j] = _noTile;
		}
        
	}
    [self spawnStartDice];
}

# pragma mark - Create grid

- (void)setupGrid
{
	_tileWidth = 37.f;
	_tileHeight = 37.f;
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
            
            CCNodeColor *backgroundTile = [CCNodeColor nodeWithColor:[CCColor clearColor]];
			backgroundTile.contentSize = CGSizeMake(_tileWidth, _tileHeight);
			backgroundTile.position = ccp(x, y);
			[self addChild:backgroundTile];
            
			x+= _tileWidth + _tileMarginHorizontal; // after positioning a block increase x variable
		}
		y += _tileHeight + _tileMarginVertical; // after completing row increase y variable
	}
}

# pragma mark - spawn random tiles

- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
	NSInteger x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _tileWidth);
	NSInteger y = _tileMarginVertical + row * (_tileMarginVertical + _tileHeight);
	return CGPointMake(x,y);
}

- (void)addDieAtColumn:(NSInteger)column row:(NSInteger)row {
    Dice *die = [[Dice alloc] initDice];
	_gridArray[column][row] = die;
	die.scale = 0.f;
	[self addChild:die];
	die.position = [self positionForColumn:column row:row];
	CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
	[die runAction:sequence];
}

- (void)spawnRandomDice {
	BOOL spawned = FALSE;
	while (!spawned) {
		NSInteger randomRow = arc4random_uniform(11);
		NSInteger randomColumn = arc4random_uniform(5);
        CCLOG(@"row, column: %ld,%ld", randomRow, randomColumn);
		BOOL positionFree = (_gridArray[randomColumn][randomRow] == _noTile);
		if (positionFree) {
			[self addDieAtColumn:randomColumn row:randomRow];
			spawned = TRUE;
		}
	}
}

- (void)spawnStartDice {
	for (int i = 0; i < 2; i++) {
		[self spawnRandomDice];
	}
    for (int i = 3; i < 5; i++) {
        [self addDieAtColumn:i row:9];
    }
}


@end
