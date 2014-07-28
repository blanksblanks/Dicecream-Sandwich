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
    
    CGFloat _tileWidth; //37
	CGFloat _tileHeight; //37
	CGFloat _tileMarginVertical; //0.9285714285714286
	CGFloat _tileMarginHorizontal; //0.6153846153846154 2
    
    NSMutableArray *_gridArray; // a 2d array
    NSNull *_noTile;
    
    float _timer;
    float _timeSinceDrop;
    float _dropInterval;
    
    Dice *_currentDie1;
    Dice *_currentDie2;
    
    NSMutableArray *_matchPoints;
    Dice *_checkDie;
    Dice *_eastDie;
    Dice *_westDie;
    Dice *_northDie;
    Dice *_southDie;
    NSInteger _face;
    
    CGPoint oldTouchPosition;
}

// two constants to describe the amount of rows and columns
static const NSInteger GRID_ROWS = 12;
static const NSInteger GRID_COLUMNS = 6;

- (void)didLoadFromCCB{
    
    _timer = 0;
    _timeSinceDrop = -0.2;
    _dropInterval = 0.5;
    
    self.userInteractionEnabled = TRUE;
    
    [self setupGrid];
    
    // Fill array with null tiles
    _noTile = [NSNull null];
	_gridArray = [NSMutableArray array];
    
	for (NSInteger i = 0; i < GRID_ROWS; i++) {
		_gridArray[i] = [NSMutableArray array];
		for (NSInteger j = 0; j < GRID_COLUMNS; j++) {
			_gridArray[i][j] = _noTile;
		}
	}
    
    [self spawnDice];
    
}

# pragma mark - Update method

- (void) update:(CCTime) delta {
    _timer += delta;
    _timeSinceDrop += delta;

    if (_timeSinceDrop > _dropInterval) {
        [self dieFallDown];
        _timeSinceDrop = 0;
        if (![self canBottomMove]) {
            [self scanForMatches];
            [self spawnDice];
            _timeSinceDrop = -0.2;
            _dropInterval = 1.0;
        }

    }
}

# pragma mark - Create grid

- (void)setupGrid
{
	_tileWidth = 37.f;
	_tileHeight = 37.f;
    
	// calculate the margin by subtracting the block sizes from the grid size
	_tileMarginHorizontal = (self.contentSize.width - (GRID_COLUMNS * _tileWidth)) / (GRID_COLUMNS+1);
	_tileMarginVertical = (self.contentSize.height - (GRID_ROWS * _tileHeight)) / (GRID_ROWS+1);
	
    // set up initial x and y positions
	float x = _tileMarginHorizontal;

	float y = _tileMarginVertical;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
	for (NSInteger i = 0; i < GRID_ROWS; i++) {
        // iterate through each row
        // create 2d array by putting array into array
        _gridArray[i] = [NSMutableArray array];
		x = _tileMarginHorizontal;
        
		for (NSInteger j = 0; j < GRID_COLUMNS; j++) {
			//  iterate through each column in the current row
			x+= _tileWidth + _tileMarginHorizontal; // after positioning a block increase x variable
		}
        
		y+= _tileHeight + _tileMarginVertical; // after completing row increase y variable
	}
}

# pragma mark - Create random dice at random columns

-(Dice*) randomizeNumbers {
    NSInteger random = arc4random_uniform(2)+1;
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

- (Dice*) addDieAtTile:(NSInteger)column row:(NSInteger)row {
    Dice* die = [self randomizeNumbers];
	_gridArray[row][column] = die;
    die.row = row;
    die.column = column;
	die.scale = 0.f;
	[self addChild:die];
	die.position = [self positionForTile:column row:row];
	CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
	[die runAction:sequence];
    return die;
 
//    CCActionMoveTo *fall = [CCActionMoveTo actionWithDuration:5.0f position:ccp(die.position.x, 0)];
//    CCActionMoveTo *fallSequence = [CCActionSequence actionWithArray:@[delay, fall]];
//    [die runAction:fallSequence];
    
}

- (void)spawnDice {
	BOOL spawned = FALSE;
	while (!spawned) {
		NSInteger firstRow = GRID_ROWS-1;
		NSInteger firstColumn = arc4random_uniform(GRID_COLUMNS-2); // int bt 0 and 4
        CCLOG(@"First Column %ld, Row %ld", (long)firstColumn, (long)firstRow);
        NSInteger nextRow = firstRow - arc4random_uniform(2);
        NSInteger nextColumn;
        if (firstRow != nextRow) { // has to be vertical
            nextColumn = firstColumn;
        } else { // has to be horizontal
            nextColumn = firstColumn+1;
        }
        
        BOOL positionFree = (_gridArray[firstRow][firstColumn] == _noTile);
        BOOL nextPositionFree = (_gridArray[nextRow][nextColumn] == _noTile);
		if (positionFree && nextPositionFree) {
			_currentDie1 = [self addDieAtTile:firstColumn row:firstRow];
            _currentDie2 = [self addDieAtTile:nextColumn row:nextRow];
            spawned = TRUE;
        } else {
            CCLOG(@"Game Over");
            CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
            [[CCDirector sharedDirector] replaceScene:mainScene];
            break;
        }
        
	}
}

# pragma mark - Position for tile from (column, row) to ccp(x,y)

- (CGPoint)positionForTile:(NSInteger)column row:(NSInteger)row {
	float x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _tileWidth);
	float y = _tileMarginVertical + row * (_tileMarginVertical + _tileHeight);
	return CGPointMake(x,y);
}

# pragma mark - Falling dice

- (void) dieFallDown {
    BOOL bottomCanMove = [self canBottomMove];
    if (bottomCanMove) {
        _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
        _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
        
        _currentDie1.row--;
        _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
        _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
        
        _currentDie2.row--;
        _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
        _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
    }
    
}

- (BOOL) canBottomMove {
    if (_currentDie1.row != _currentDie2.row) {
        if (_currentDie1.row > _currentDie2.row) {
            return [self indexValidAndUnoccupiedForRow:_currentDie2.row-1 andColumn:_currentDie2.column];
        } else {
            
            return [self indexValidAndUnoccupiedForRow:_currentDie1.row-1 andColumn:_currentDie1.column];
        }
    }
    else {
        return [self indexValidAndUnoccupiedForRow:_currentDie2.row-1 andColumn:_currentDie2.column] && [self indexValidAndUnoccupiedForRow:_currentDie1.row-1 andColumn:_currentDie1.column];
    }
}

//- (void) dieFalling: Dice*(die) fromColumn:(NSInteger)column andRow: (NSInteger)row {
//    for (NSInteger i = row; i >= 0; i++) {
//        _gridArray[column][row-i] = _gridArray[column][row];
//        _gridArray[column][row] = _noTile;
//        CGPoint newPosition = [self positionForTile:column row:row];
//        CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:newPosition];
//        [die runAction:moveTo];
//    }
//}

# pragma mark - Touch and swipe handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    oldTouchPosition = [touch locationInNode:self];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint newTouchPosition = [touch locationInNode:self];
    float xdifference = oldTouchPosition.x - newTouchPosition.x;
    float ydifference = oldTouchPosition.y - newTouchPosition.y;
    NSInteger column = ((newTouchPosition.x - _tileMarginHorizontal) / (_tileWidth + _tileMarginHorizontal));
    if (column > GRID_COLUMNS-1) {
        column = GRID_COLUMNS-1;
    } else if (column < 0) {
        column = 0;
    }
    
    // consider adjusting speed of fall with swiping
    if (ydifference > 0.1*(self.contentSize.height) || ydifference < -0.1*(self.contentSize.height)) {
        [self dropDown];
    } else if (xdifference > 0.3*(self.contentSize.width)) {
        [self swipeLeftTo:column];
    } else if (xdifference > 0.1*(self.contentSize.width) && xdifference < 0.3*(self.contentSize.width)) {
        [self swipeLeft];
    } else if (xdifference < -0.3*(self.contentSize.width)) {
        [self swipeRightTo:column];
    } else if (xdifference < -0.1*(self.contentSize.width) && xdifference > -0.3*(self.contentSize.width)){
        [self swipeRight];
    } else {
        [self rotate];
    }
}

- (void)swipeLeftTo:(NSInteger)column {
    while (_currentDie1.column > column && _currentDie2.column > column) {
        [self swipeLeft];
    }
}

- (void)swipeLeft {
    BOOL bottomCanMove = [self canBottomMove];
    BOOL canMoveLeft = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column-1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column-1];
    if (bottomCanMove && canMoveLeft) {
        _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
        _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
        
        _currentDie1.column--;
        _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
        _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
        
        _currentDie2.column--;
        _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
        _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
        //CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:2.0f position:_currentDie2.position];
        //[_currentDie2 runAction:moveTo];
    }
}

- (void)swipeRightTo:(NSInteger)column {
    while (_currentDie1.column < column && _currentDie2.column < column) {
        [self swipeRight];
    }
}

- (void)swipeRight {
//    [self move:ccp(1, 0)];
    BOOL bottomCanMove = [self canBottomMove];
    BOOL canMoveRight = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column+1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column+1];
    if (bottomCanMove && canMoveRight) {
        _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
        _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
        
        _currentDie1.column++;
        _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
        _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
        
        _currentDie2.column++;
        _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
        _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
    }
}

- (void)dropDown {
    _dropInterval= 0.001;
}

- (void)rotate {
    BOOL bottomCanMove = [self canBottomMove];
    BOOL isRotating = true;
//    if (isRotating) {
//        [self unschedule:@selector(dieFallDown)];
//    } else {
//        [self schedule:@selector(dieFallDown) interval:0.5f];
//    }
    
    if (isRotating && bottomCanMove) {
        if (_currentDie2.column > _currentDie1.column) {
            // [1][2] --> [1]
            //            [2]
            _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
            _currentDie2.row--; _currentDie2.column--;
            _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
            _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
        } else if (_currentDie1.row > _currentDie2.row) {
            // [1]
            // [2] --> [2][1]
            if (_currentDie2.column == 0) {
                _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                _currentDie1.row--; _currentDie1.column++;
                _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
            } else if (_currentDie1.row == GRID_ROWS-1) {
                _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                _currentDie1.row--; _currentDie1.column--;
                _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
            }
            else {
                _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                _currentDie2.row++; _currentDie2.column--;
                _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
            }
        } else if (_currentDie1.column > _currentDie2.column) {
            // [2][1] --> [2]
            //            [1]
            _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
            _currentDie2.row++; _currentDie2.column++;
            _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
            _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
        } else {
            // [2]
            // [1]  --> [1][2] means die2 moves
            if (_currentDie2.column == GRID_COLUMNS-1) {
                _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                _currentDie1.row++; _currentDie1.column--;
                _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
            } else {
                _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                _currentDie2.row--; _currentDie2.column++;
                _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
            }
        }
        isRotating = false;
    }
}



# pragma mark - Find matches

- (void)scanForMatches {
    [self findMatchesForRow:_currentDie1.row andColumn:_currentDie1.column withFace:_currentDie1.faceValue];
    [self findMatchesForRow:_currentDie2.row andColumn:_currentDie2.column withFace:_currentDie2.faceValue];
}
//    for (NSInteger i = 0; i < GRID_ROWS; i++) {
//		for (NSInteger j = 0; j < GRID_COLUMNS; j++) {

//            BOOL positionFree = (_gridArray[i][j] == _noTile);
//            if (! positionFree) {
//                _checkDie = _gridArray[i][j];

- (void)findMatchesForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
    BOOL foundSouthMatch = [self checkSouthForRow:i andColumn:j withFace:face];
    BOOL foundNorthMatch = [self checkNorthForRow:i andColumn:j withFace:face];
    BOOL foundEastMatch = [self checkEastForRow:i andColumn:j withFace:face];
    BOOL foundWestMatch = [self checkWestForRow:i andColumn:j withFace:face];
    
    BOOL foundMatch = foundSouthMatch || foundNorthMatch || foundEastMatch || foundWestMatch;
    if (foundMatch) {
        [self fillUpHoles];
    }

}
//
//- (void)detectHorizontalMatches {
//    for (NSInteger row = 0; row < GRID_ROWS; row++) {
//        for (NSInteger column = 0; column < GRID_COLUMNS;) {
//            if (_gridArray[row][column] != _noTile) {
//                NSInteger matchType = _gridArray[row][column].faceValue;
//                
//            }
//        }
//    }
//}

- (BOOL)checkNorthForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
    NSInteger _north = i+face+1;
    BOOL foundMatch = false;
    BOOL columnIsValid;
    for (NSInteger k = i; k <= _north; k++) {
        columnIsValid = [self indexValidAndOccupiedForRow:k andColumn:j];
        if (columnIsValid == false) {
            break;
        }
    }
    if (columnIsValid == true) {
            _northDie = _gridArray[_north][j];
            if (face == _northDie.faceValue) {
                for (NSInteger k = i; k <= _north; k++) {
                    [self removeDieAtRow:k andColumn:j];
                    _gridArray[k][j] = _noTile;
                    CCLOG(@"Dice removed!");
                    foundMatch = true;
                    self.match = face;
                }
            }
        }
    return foundMatch;
}

- (BOOL)checkSouthForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
    NSInteger _south = i-face-1;
    BOOL foundMatch = false;
    BOOL columnIsValid;
    for (NSInteger k = i; k >= _south; k--) {
        columnIsValid = [self indexValidAndOccupiedForRow:k andColumn:j];
        if (columnIsValid == false) {
            break;
        }
    }
    if (columnIsValid == TRUE) {
        _southDie = _gridArray[_south][j];
        if (face == _southDie.faceValue) {
            for (NSInteger k = i; k >= _south; k--) {
                [self removeDieAtRow:k andColumn:j];
                _gridArray[k][j] = _noTile;
                CCLOG(@"Dice removed!");
                foundMatch = true;
                self.match = face;
            }
        }
    }
    return foundMatch;
}

- (BOOL)checkEastForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
    NSInteger _east = j+face+1;
    BOOL foundMatch = false;
    BOOL rowIsValid = false;
    if (i < GRID_ROWS-1) {
        for (NSInteger k = j; k <= _east; k++) {
            rowIsValid = [self indexValidAndOccupiedForRow:i andColumn:k];
            if (rowIsValid == false) {
                break;
            }
        }
    }
    
    if (rowIsValid) {
        _eastDie = _gridArray[i][_east];
        if (face == _eastDie.faceValue) {
            for (NSInteger k = j; k <= _east; k++) {
                [self removeDieAtRow:i andColumn:k];
                _gridArray[i][k] = _noTile;
                CCLOG(@"Dice removed!");
                foundMatch = true;
                self.match = face;
            }
        }
    }
    return foundMatch;
}

- (BOOL)checkWestForRow: (NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
    NSInteger _west = j-face-1;
    BOOL foundMatch = false;
    BOOL rowIsValid;
    for (NSInteger k = j; k >= _west; k--) {
        rowIsValid = [self indexValidAndOccupiedForRow:i andColumn:k];
        if (rowIsValid == false) {
            break;
        }
    }
    
    if ([self indexValidAndOccupiedForRow:(i) andColumn:_west]) {
        _westDie = _gridArray[i][_west];
        if (face == _westDie.faceValue) {
            for (NSInteger k = j; k >= _west; k--) {
                [self removeDieAtRow:i andColumn:k];
                _gridArray[i][k] = _noTile;
                CCLOG(@"Dice removed!");
                foundMatch = true;
                self.match = face;
            }
        }
    }
    return foundMatch;
}

// fix bug where it loads die as nsnull
- (void) removeDieAtRow:(NSInteger)row andColumn:(NSInteger)column {
    Dice* die = _gridArray[row][column];
    die.row = row;
    die.column = column;
    
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
    // make the particle effect clean itself up once it's completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seal's position
    explosion.position = die.position;
    // add the particle effect to the same node the seal is on
    [die.parent addChild:explosion];
    
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.3f scale:0.1f];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleDown]];
	[die runAction:sequence];
	[self removeChild:die];
    
    self.score += die.faceValue;
    
}

// fix bug with incremental fall and nulls being loaded
- (void) fillUpHoles {
    for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
		for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFilled = (_gridArray[row][column] != _noTile);
            NSInteger rowBelow = row-1;
            if (positionFilled) {
                while (rowBelow > 0) {
                    BOOL bottomEmpty = (_gridArray[rowBelow][column] == _noTile);
                    if (bottomEmpty) {
                        rowBelow--; // lower row by 1 each time it decrements
                    } else {
                        Dice* die = _gridArray[row][column]; // call existing die
                        die.row = rowBelow; // move it as far down as it can go
                        _gridArray[die.row][die.column] = die; // refer to die in new index
                        die.position = [self positionForTile:die.column row:die.row]; // moves object image to correct ccp point
                        _gridArray[row][column] = _noTile; // replaces old grid array index with null object
                    }
                }
            }
        }
    }
}

//for (NSInteger k = 1; k <= depth; k++) {
//    Dice* die = _gridArray[i][j];
//    die.position = [self positionForTile:j row:k];
//}
//
//Dice* die = _gridArray[i][j];
//die.row = depth;
//_gridArray[die.row][die.column] = die;
//_gridArray[i][j] = _noTile;

//BOOL positionFilled = (_gridArray[i][j] != _noTile);
//BOOL bottomEmpty = (_gridArray[i-1][j] == _noTile);
//while (positionFilled && bottomEmpty) {
//    Dice* die = _gridArray[i][j]; // [4][1] -> [1][1]
//    die.row--; // same as i--; same as i-1;
//    _gridArray[die.row][die.column] = die;
//    die.position = [self positionForTile:die.column row:die.row];
//    _gridArray[i][j] = _noTile;


# pragma mark - Check indexes

- (BOOL)indexValidForRow:(NSInteger)row andColumn:(NSInteger)column {
    BOOL indexValid = YES;
    if(row < 0 || column < 0 || row >= GRID_ROWS || column >= GRID_COLUMNS)
    {
        indexValid = NO;
    }
    return indexValid;
}

- (BOOL)indexValidAndUnoccupiedForRow:(NSInteger)row andColumn:(NSInteger)column {
    BOOL indexValid = [self indexValidForRow:row andColumn:column];
    if (!indexValid) {
        return FALSE;
    }
    else {
        BOOL unoccupied = [_gridArray[row][column] isEqual:_noTile] || [_gridArray[row][column] isEqual:_currentDie2]  || [_gridArray[row][column] isEqual:_currentDie1] ;
        return unoccupied;

    }
}

- (BOOL)indexValidAndOccupiedForRow:(NSInteger)row andColumn:(NSInteger)column {
    BOOL indexValid = [self indexValidForRow:row andColumn:column];
    if (!indexValid) {
        return FALSE;
    }
    else if (_gridArray[row][column] == _noTile) {
        return FALSE;
    } else {
        return TRUE;
    }
    
}

@end









# pragma mark - Move dice

//- (void)move:(CGPoint)direction {
//    // apply negative vector until reaching boundary, this way we get the tile that is the furthest away
//    // bottom left corner
//    NSInteger currentX = 0;
//    NSInteger currentY = 0;
//    // Move to relevant edge by applying direction until reaching border
//    while ([self indexValid:currentX y:currentY]) {
//        CGFloat newX = currentX + direction.x;
//        CGFloat newY = currentY + direction.y;
//        if ([self indexValid:newX y:newY]) {
//            currentX = newX;
//            currentY = newY;
//        } else {
//            break;
//        }
//    }
//    // store initial row value to reset after completing each column
//    NSInteger initialY = currentY;
//    // define changing of x and y value (moving left, up, down or right?)
//    NSInteger xChange = -direction.x;
//    NSInteger yChange = -direction.y;
//    if (xChange == 0) {
//        xChange = 1;
//    }
//    if (yChange == 0) {
//        yChange = 1;
//    }
//    // visit column for column
//    while ([self indexValid:currentX y:currentY]) {
//        while ([self indexValid:currentX y:currentY]) {
//            // get tile at current index
//            Dice *die = _gridArray[currentX][currentY];
//            if ([die isEqual:_noTile]) {
//                // if there is no tile at this index -> skip
//                currentY += yChange;
//                continue;
//            }
//            // store index in temp variables to change them and store new location of this tile
//            NSInteger newX = currentX;
//            NSInteger newY = currentY;
//            /* find the farthest position by iterating in direction of the vector until we reach border of grid or an occupied cell*/
//            while ([self indexValidAndUnoccupied:newX+direction.x y:newY+direction.y]) {
//                newX += direction.x;
//                newY += direction.y;
//            }
//            if (newX != currentX || newY !=currentY) {
//                [self moveDice:die fromIndex:currentX oldY:currentY newX:newX newY:newY];
//            }
//            // move further in this column
//            currentY += yChange;
//        }
//        // move to the next column, start at the inital row
//        currentX += xChange;
//        currentY = initialY;
//    }
//}
//
//- (void)moveDice:(Dice *)die fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {
//    _gridArray[newX][newY] = _gridArray[oldX][oldY];
//    _gridArray[oldX][oldY] = _noTile;
//    CGPoint newPosition = [self positionForTile:newX row:newY];
//    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:2.0f position:newPosition];
//    [die runAction:moveTo];
//}