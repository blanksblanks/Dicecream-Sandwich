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
static const NSInteger GRID_ROWS = 12;
static const NSInteger GRID_COLUMNS = 6;

- (void)didLoadFromCCB{
    
    [self setupGrid];
    
    // Fill array with null tiles
    _noTile = [NSNull null];
	_gridArray = [NSMutableArray array];
    
	for (int i = 0; i < GRID_ROWS; i++) {
		_gridArray[i] = [NSMutableArray array];
		for (int j = 0; j < GRID_COLUMNS; j++) {
			_gridArray[i][j] = _noTile;
		}
	}
    
    [self spawnDice];
    
//    // listen for swipes to the left
//    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
//    // listen for swipes to the right
//    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
//    // listen for swipes down
//    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
//    // listen for swipes up
//    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
//    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
	
}

- (void) update:(CCTime) delta {
    //    _dice.position = ccp(_dice.position.x, _dice.position.y - delta*100.0);
    //    _seconddice.position = ccp(_seconddice.position.x, _seconddice.position.y - delta*100.0);
    //}
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
			x+= _tileWidth + _tileMarginHorizontal; // after positioning a block increase x variable
		}
		y+= _tileHeight + _tileMarginVertical; // after completing row increase y variable
	}
}

# pragma mark - Create random Dice

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
 
//    CCActionMoveTo *fall = [CCActionMoveTo actionWithDuration:5.0f position:ccp(die.position.x, 0)];
//    CCActionMoveTo *fallSequence = [CCActionSequence actionWithArray:@[delay, fall]];
//    [die runAction:fallSequence];
}

//
//- (void)fallingDie {
//    BOOL falling = FALSE;
//    while (!falling) {
//        _gridArray[newX][newY] = _gridArray[oldX][oldY];
//        _gridArray[oldX][oldY] = _noTile;
//    }
//}

- (void)spawnDice {
	BOOL spawned = FALSE;
	while (!spawned) {
		NSInteger firstRow = 11;
		NSInteger firstColumn = arc4random_uniform(5); // int bt 0 and 4
        CCLOG(@"First Column %ld, Row %ld", (long)firstColumn, (long)firstRow);
        NSInteger nextRow = firstRow - arc4random_uniform(2);
        NSInteger nextColumn;
        if (firstRow != nextRow) {
            nextColumn = firstColumn;
        } else {
            nextColumn = firstColumn+1;
        }
        CCLOG(@"Next Column %ld, Row %ld", (long)nextColumn, (long)nextRow);
        
        BOOL positionFree = (_gridArray[firstRow][firstColumn] == _noTile);
        BOOL nextPositionFree = (_gridArray[nextRow][nextColumn] == _noTile);
		if (positionFree && nextPositionFree) {
			[self addDieAtTile:firstColumn row:firstRow];
            [self addDieAtTile:nextColumn row:nextRow];
            spawned = TRUE;
        } else {
            CCLOG(@"Game Over");
            break;
        }
	}
}

# pragma mark - Swipe recognition

- (void)swipeLeft {
    [self move:ccp(-1, 0)];
}

- (void)swipeRight {
    [self move:ccp(1, 0)];
}

- (void)swipeDown {
    [self move:ccp(0, -1)];
}

- (void)swipeUp {
    [self move:ccp(1,0)];
}

# pragma mark - Move dice

- (void)move:(CGPoint)direction {
    // apply negative vector until reaching boundary, this way we get the tile that is the furthest away
    // bottom left corner
    NSInteger currentX = 0;
    NSInteger currentY = 0;
    // Move to relevant edge by applying direction until reaching border
    while ([self indexValid:currentX y:currentY]) {
        CGFloat newX = currentX + direction.x;
        CGFloat newY = currentY + direction.y;
        if ([self indexValid:newX y:newY]) {
            currentX = newX;
            currentY = newY;
        } else {
            break;
        }
    }
    // store initial row value to reset after completing each column
    NSInteger initialY = currentY;
    // define changing of x and y value (moving left, up, down or right?)
    NSInteger xChange = -direction.x;
    NSInteger yChange = -direction.y;
    if (xChange == 0) {
        xChange = 1;
    }
    if (yChange == 0) {
        yChange = 1;
    }
    // visit column for column
    while ([self indexValid:currentX y:currentY]) {
        while ([self indexValid:currentX y:currentY]) {
            // get tile at current index
            Dice *die = _gridArray[currentX][currentY];
            if ([die isEqual:_noTile]) {
                // if there is no tile at this index -> skip
                currentY += yChange;
                continue;
            }
            // store index in temp variables to change them and store new location of this tile
            NSInteger newX = currentX;
            NSInteger newY = currentY;
            /* find the farthest position by iterating in direction of the vector until we reach border of grid or an occupied cell*/
            while ([self indexValidAndUnoccupied:newX+direction.x y:newY+direction.y]) {
                newX += direction.x;
                newY += direction.y;
            }
            if (newX != currentX || newY !=currentY) {
                [self moveDice:die fromIndex:currentX oldY:currentY newX:newX newY:newY];
            }
            // move further in this column
            currentY += yChange;
        }
        // move to the next column, start at the inital row
        currentX += xChange;
        currentY = initialY;
    }
}

- (void)moveDice:(Dice *)die fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {
    _gridArray[newX][newY] = _gridArray[oldX][oldY];
    _gridArray[oldX][oldY] = _noTile;
    CGPoint newPosition = [self positionForTile:newX row:newY];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:2.0f position:newPosition];
    [die runAction:moveTo];
}

# pragma mark - Check indexes

- (BOOL)indexValid:(NSInteger)x y:(NSInteger)y {
//    BOOL indexValid = TRUE;
//    indexValid &= x >= 0;
//    indexValid &= y >= 0;
//    if (indexValid) {
//        indexValid &= x < GRID_ROWS;
//        if (indexValid) {
//            indexValid &= y < GRID_COLUMNS;
//        }
//    }
    BOOL indexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        indexValid = NO;
    }
    return indexValid;
}

- (BOOL)indexValidAndUnoccupied:(NSInteger)x y:(NSInteger)y {
    BOOL indexValid = [self indexValid:x y:y];
    if (!indexValid) {
        return FALSE;
    }
    BOOL unoccupied = [_gridArray[x][y] isEqual:_noTile];
    return unoccupied;
}

@end
