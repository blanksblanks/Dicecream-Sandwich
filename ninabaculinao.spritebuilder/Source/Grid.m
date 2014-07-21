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
    
    [self spawnDice];
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
            
//            CCNodeColor *backgroundTile = [CCNodeColor nodeWithColor:[CCColor clearColor]];
//			backgroundTile.contentSize = CGSizeMake(_tileWidth, _tileHeight);
//			backgroundTile.position = ccp(x, y);
//			[self addChild:backgroundTile];
            
			x+= _tileWidth + _tileMarginHorizontal; // after positioning a block increase x variable
		}
		y+= _tileHeight + _tileMarginVertical; // after completing row increase y variable
	}
}

# pragma mark - spawn random tiles

- (CGPoint)positionForTile:(NSInteger)column row:(NSInteger)row {
	NSInteger x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _tileWidth);
	NSInteger y = _tileMarginVertical + row * (_tileMarginVertical + _tileHeight);
	return CGPointMake(x,y);
}

- (void)addDieAtTile:(NSInteger)column row:(NSInteger)row {
    Dice* die = [self randomizeNumbers];
	_gridArray[row][column] = die;
	die.scale = 0.f;
	[self addChild:die];
	die.position = [self positionForTile:column row:row];
	CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
	[die runAction:sequence];
}

-(Dice*) randomizeNumbers {
    int random = arc4random_uniform(5)+1;
    Dice *die;
    switch(random)
    {
        case 1:
            die = (Dice*) [CCBReader load:@"Dice/One"];
            CCLOG(@"Face: 1");
            break;
        case 2:
            die = (Dice*) [CCBReader load:@"Dice/Two"];
            CCLOG(@"Face: 2");
            break;
        case 3:
            die = (Dice*) [CCBReader load:@"Dice/Three"];
            CCLOG(@"Face: 3");
            break;
        case 4:
            die = (Dice*) [CCBReader load:@"Dice/Four"];
            CCLOG(@"Face: 4");
            break;
        case 5:
            die = (Dice*) [CCBReader load:@"Dice/Five"];
            CCLOG(@"Face: 5");
            break;
        case 6:
            die = (Dice*) [CCBReader load:@"Dice/Six"];
            CCLOG(@"Face: 6");
            break;
        default:
            die = (Dice*) [CCBReader load:@"Dice/Dice"];
            CCLOG(@"WHY IS IT AT DEFAULT");
            break;
    }
    return die;
}

- (void)spawnRandomTiles {
	BOOL spawned = FALSE;
	while (!spawned) {
		NSInteger randomRow = arc4random_uniform(12);
		NSInteger randomColumn = arc4random_uniform(6);
        CCLOG(@"Column %d, Row %d", (int)randomColumn, (int)randomRow);
		BOOL positionFree = (_gridArray[randomRow][randomColumn] == _noTile);
		if (positionFree) {
			[self addDieAtTile:randomColumn row:randomRow];
			spawned = TRUE;
		}
	}
}

- (void)spawnDice {
	for (int i = 0; i < 2; i++) {
		[self spawnRandomTiles];
	}
}
//    for (int i = 3; i < 5; i++) {
//        [self addDieAtColumn:i row:9];
//    }


@end
