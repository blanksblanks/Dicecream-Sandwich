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
    
    NSInteger actionIndex;
    BOOL stabilizing;
    
    CGFloat _tileWidth; //37
	CGFloat _tileMarginVertical; //0.9285714285714286
	CGFloat _tileMarginHorizontal; //0.6153846153846154 2
    
    NSMutableArray *_gridArray;
    NSNull *_noTile;
    
    float _timer;
    float _timeSinceDrop;
    float _dropInterval;
    float _timeSinceBottom;
    
    Dice *_currentDie1;
    Dice *_currentDie2;
    
    Dice *_leftDie;
    Dice *_rightDie;
    Dice *_aboveDie;
    Dice *_belowDie;
    NSInteger _face;
    
    Dice *_firstDie;
    Dice *_lastDie;
    
    CGPoint oldTouchPosition;
    NSTimeInterval oldTouchTime;
    NSTimeInterval newTouchTime;
    NSTimeInterval previousTouchTime;
    BOOL canSwipe;
    BOOL matchFound;
    BOOL noMoreHoles;
    
    CCLabelTTF *_chainScoreLabel;
}

// two constants to describe the number of rows and columns
static const NSInteger GRID_ROWS = 12;
static const NSInteger GRID_COLUMNS = 6;

- (void)didLoadFromCCB{
    
    _timer = 0;
    stabilizing = false;
    
    _chainScoreLabel.visible = FALSE;
    
    self.userInteractionEnabled = TRUE;
    
    [self setupGrid];
    
    // Populate array with null tiles
    _noTile = [NSNull null];
	_gridArray = [NSMutableArray array];
    
	for (NSInteger i = 0; i < GRID_ROWS; i++) {
		_gridArray[i] = [NSMutableArray array];
		for (NSInteger j = 0; j < GRID_COLUMNS; j++) {
			_gridArray[i][j] = _noTile;
		}
	}
    
    [self loadLevel];
    
    actionIndex = 0;
}

- (void)loadLevel {
    NSString*path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *levels = [root objectForKey: @"Levels"];
    
    if (self.score == 0) {
        self.level = 1;
    } else if (self.score >= self.targetScore) {
        self.level++;
    }
    
    NSDictionary *dict = levels[self.level-1];
    self.levelSpeed = [dict[@"levelSpeed"] floatValue];
    self.targetScore = [dict[@"targetScore"] intValue];
    self.possibilities = [dict[@"possibilities"] intValue];
}

# pragma mark - Update method

- (void) update:(CCTime) delta {
    _timer += delta;
    _timeSinceDrop += delta;
    
    switch (actionIndex%4) {
        case 0: { // spawn dice
            [self spawnDice];
            _timeSinceDrop = -0.2;
            _dropInterval = self.levelSpeed;
            CCLOG(@"Dice spawned"); [self trackGridState];
            actionIndex = 1; CCLOG(@"Going to case 1: dice falling down");
            break;
        }
        case 1: { // dice falling down
            if (_timeSinceDrop > _dropInterval) {
                [self dieFallDown];
                _timeSinceDrop = 0;
                if (![self canBottomMove]) {
                    CCLOG(@"Dice fell to bottom:"); [self trackGridState];
                    actionIndex = 2; CCLOG(@"Going to case 2: filling holes");
                }
            }
            break;
        }
        case 2: { // dice filling holes
            if (_timeSinceDrop > _dropInterval) {
                _timeSinceDrop = 0;
                [self dieFillHoles]; // --> stabilized
                stabilizing = [self checkGrid];
                if (!stabilizing) {
                    CCLOG(@"Holes filled:"); [self trackGridState];
                    actionIndex = 3; CCLOG(@"Going to case 3: handling matches");
                }
            }
            break;
        }
        case 3: { // handling matches
            [self handleMatches];
            [self loadLevel];
            stabilizing = [self checkGrid];
            if (stabilizing) { // implies matches found
                _dropInterval = 0.1;
                CCLOG(@"Matches handled:"); [self trackGridState];
                actionIndex = 2; CCLOG(@"Going to case 2: filling holes");
            } else if (!stabilizing) { // implies no matches found
                _dropInterval = self.levelSpeed;
                actionIndex = 0; CCLOG(@"Going to case 0: spawning dice");
            }
        break;
        }
    }
}

# pragma mark - Create initial grid and check grid state

- (void)setupGrid
{
	_tileWidth = 37.f;
    
	// calculate the margin by subtracting the block sizes from the grid size
	_tileMarginHorizontal = (self.contentSize.width - (GRID_COLUMNS * _tileWidth)) / (GRID_COLUMNS+1);
	_tileMarginVertical = (self.contentSize.height - (GRID_ROWS * _tileWidth)) / (GRID_ROWS+1);
	
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
        
		y+= _tileWidth + _tileMarginVertical; // after completing row increase y variable
	}
}

- (BOOL)checkGrid {
    stabilizing = false;
    for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (!positionFree) {
                Dice *die = _gridArray[row][column];
                if (!die.stable) {
                    stabilizing = TRUE;
                }
            }
        }
    }
    return stabilizing;
}

- (void)trackGridState {
    
    // copy current grid into gridstate array as 0's and 1-6's
    NSMutableArray *_gridStateArray = [NSMutableArray array];
    for (NSInteger row = 0; row < GRID_ROWS; row++) {
        _gridStateArray[row] = [NSMutableArray array];
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (positionFree) {
                _gridStateArray[row][column] = @0;
            } else {
                Dice *die = _gridArray[row][column];
                NSNumber *face = [NSNumber numberWithInt:die.faceValue];
                _gridStateArray[row][column] = face;
            }
        }
    }
    
    // Print out grid state at data level
    for (NSInteger row = GRID_ROWS - 1; row >= 0; row--) {
        CCLOG(@"[%@ %@ %@ %@ %@ %@] :%ld", _gridStateArray[row][0], _gridStateArray[row][1], _gridStateArray[row][2], _gridStateArray[row][3], _gridStateArray[row][4], _gridStateArray[row][5], (long)row);
    }
    CCLOG(@"--------------");
}

# pragma mark - Spawn random pair of dice

- (void)spawnDice {
        canSwipe = false;
        matchFound = false;
		
        NSInteger firstRow = GRID_ROWS-1;
		NSInteger firstColumn = arc4random_uniform(GRID_COLUMNS-2); // int bt 0 and 4
        NSInteger nextRow = firstRow - arc4random_uniform(2);
        NSInteger nextColumn;
        if (firstRow != nextRow) { // has to be vertical
            nextColumn = firstColumn;
        } else { // has to be horizontal
            nextColumn = firstColumn+1;
        }
        
        BOOL positionFree = ([_gridArray[firstRow][firstColumn] isEqual: _noTile]);
        BOOL nextPositionFree = ([_gridArray[nextRow][nextColumn] isEqual: _noTile]);
		if (positionFree && nextPositionFree) {
			_currentDie1 = [self addDieAtTile:firstColumn row:firstRow];
            _currentDie2 = [self addDieAtTile:nextColumn row:nextRow];
        } else {
//            DDLogInfo(@"Game Over");
            CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
            [[CCDirector sharedDirector] replaceScene:mainScene];
        }
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
}

-(Dice*) randomizeNumbers {
    NSInteger random = arc4random_uniform(self.possibilities)+1;
    Dice *die;
    switch(random)
    {
        case 1:
            die = (Dice*) [CCBReader load:@"Dice/One"];
            break;
        case 2:
            die = (Dice*) [CCBReader load:@"Dice/Two"];
            break;
        case 3:
            die = (Dice*) [CCBReader load:@"Dice/Three"];
            break;
        case 4:
            die = (Dice*) [CCBReader load:@"Dice/Four"];
            break;
        case 5:
            die = (Dice*) [CCBReader load:@"Dice/Five"];
            break;
        case 6:
            die = (Dice*) [CCBReader load:@"Dice/Six"];
            break;
        default:
            die = (Dice*) [CCBReader load:@"Dice/Dice"];
            break;
    }
    die.stable = true;
    return die;
}

# pragma mark - Convert position for tile from (column, row) to ccp(x,y)

- (CGPoint)positionForTile:(NSInteger)column row:(NSInteger)row {
	float x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _tileWidth) + (_tileWidth/2);
	float y = _tileMarginVertical + row * (_tileMarginVertical + _tileWidth) + (_tileWidth/2);
	return CGPointMake(x,y);
}

# pragma mark - Make pair of dice fall

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
    BOOL bottomCanMove;
    if (_currentDie1.row != _currentDie2.row) {
        if (_currentDie1.row > _currentDie2.row) {
            bottomCanMove = [self indexValidAndUnoccupiedForRow:_currentDie2.row-1 andColumn:_currentDie2.column];
        } else {
            bottomCanMove = [self indexValidAndUnoccupiedForRow:_currentDie1.row-1 andColumn:_currentDie1.column];
        }
    }
    else {
        bottomCanMove = [self indexValidAndUnoccupiedForRow:_currentDie2.row-1 andColumn:_currentDie2.column] && [self indexValidAndUnoccupiedForRow:_currentDie1.row-1 andColumn:_currentDie1.column];
    }
    return bottomCanMove;
}

# pragma mark - Touch handling - let player swipe left/right/down/rotate

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    oldTouchPosition = [touch locationInNode:self];
    oldTouchTime = touch.timestamp;
    canSwipe = true;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint newTouchPosition = [touch locationInNode:self];
    float ydifference = oldTouchPosition.y - newTouchPosition.y;
    float xdifference = oldTouchPosition.x - newTouchPosition.x;

    if (canSwipe == true) {
    // determine in which column touch ended, cannot go out of bounds
    NSInteger column = ((newTouchPosition.x - _tileMarginHorizontal) / (_tileWidth + _tileMarginHorizontal));
    if (column > GRID_COLUMNS-1) {
        column = GRID_COLUMNS-1;
    } else if (column < 0) {
        column = 0;
    }

    // soft drop
    if (ydifference > 0.2*(self.contentSize.height) && (newTouchPosition.y < _currentDie1.position.y) && (newTouchPosition.y < _currentDie2.position.y)) {
        _dropInterval = 0.03;
    } else if (xdifference > 0.5*(_tileWidth)) {
        [self swipeLeftTo:column];
//    } else if (xdifference > 0.1*(self.contentSize.width) && xdifference < 0.3*(self.contentSize.width)) {
//        [self swipeLeft];
    } else if (xdifference < -0.5*(_tileWidth)) {
        [self swipeRightTo:column];
//    } else if (xdifference < -0.1*(self.contentSize.width) && xdifference > -0.3*(self.contentSize.width)){
//        [self swipeRight];
    } else {
        _dropInterval = self.levelSpeed;
    }
}
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint newTouchPosition = [touch locationInNode:self];
    previousTouchTime = newTouchTime;
    newTouchTime = touch.timestamp;
        // calculate lengths of swipes
        float ydifference = oldTouchPosition.y - newTouchPosition.y;
        NSTimeInterval touchInterval = newTouchTime - oldTouchTime;
//        CCLOG(@"Touch interval %f", touchInterval);
    
    NSTimeInterval timeBetweenSwipes = newTouchTime - previousTouchTime;
//    CCLOG(@"Time between swipes %f", timeBetweenSwipes);
    
        // consider adjusting speed of fall with swiping
        // define types of swipes: swipe up or down, long swipe left, short swipe left,
        // long swipe right, short swipe right, tap to rotate
        if ((touchInterval > 0.2)  && (ydifference > 0.2*(self.contentSize.height))) {
            _dropInterval = self.levelSpeed;
        }
        else if ((touchInterval < 0.2) && (ydifference > 0.2*(self.contentSize.height))) {
            if (timeBetweenSwipes > 10.0) {
                _dropInterval = 0.01;
            }
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
    BOOL canMoveLeft = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column-1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column-1];
    if (canMoveLeft) {
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
    BOOL canMoveRight = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column+1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column+1];
    if (canMoveRight) {
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

- (void)rotate {
    BOOL bottomCanMove = [self canBottomMove];
    BOOL isRotating = true;
    
    if (isRotating && bottomCanMove) {
        if (_currentDie2.column > _currentDie1.column) {
            // [1][2] --> [1]
            //            [2]
            // check if new placement is occupied
           if ([_gridArray[_currentDie2.row-1][_currentDie2.column-1] isEqual: _noTile]) {
                _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                _currentDie2.row--; _currentDie2.column--;
                _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
           }
        } else if (_currentDie1.row > _currentDie2.row) {
            // [1]
            // [2] --> [2][1] means die1 moves when it's in rightmost column
            if (_currentDie2.column == 0) {
                if ([_gridArray[_currentDie1.row-1][_currentDie1.column+1] isEqual: _noTile]) {
                _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                _currentDie1.row--; _currentDie1.column++;
                _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
                }
            } else if (_currentDie1.row == GRID_ROWS-1) { // when die1 is on top row
                if ([_gridArray[_currentDie1.row-1][_currentDie1.column-1] isEqual: _noTile]) {
                    _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                    _currentDie1.row--; _currentDie1.column--;
                    _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                    _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
                }
            }
            else {
                if ([_gridArray[_currentDie2.row+1][_currentDie2.column-1] isEqual: _noTile]) {
                    _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                    _currentDie2.row++; _currentDie2.column--;
                    _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                    _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
                }
            }
        } else if (_currentDie1.column > _currentDie2.column) {
            // [2][1] --> [2]
            //            [1]
            if ([_gridArray[_currentDie2.row+1][_currentDie2.column+1] isEqual: _noTile]) {
                _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                _currentDie2.row++; _currentDie2.column++;
                _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
            }
        } else {
            // [2]
            // [1]  --> [1][2] means die1 moves when it's in leftmost column
            if (_currentDie2.column == GRID_COLUMNS-1) {
                if ([_gridArray[_currentDie1.row+1][_currentDie1.column-1] isEqual: _noTile]) {
                    _gridArray[_currentDie1.row][_currentDie1.column] = _noTile;
                    _currentDie1.row++; _currentDie1.column--;
                    _gridArray[_currentDie1.row][_currentDie1.column] = _currentDie1;
                    _currentDie1.position = [self positionForTile:_currentDie1.column row:_currentDie1.row];
                }
            } else {
                if ([_gridArray[_currentDie2.row-1][_currentDie2.column+1] isEqual: _noTile]) {
                    _gridArray[_currentDie2.row][_currentDie2.column] = _noTile;
                    _currentDie2.row--; _currentDie2.column++;
                    _gridArray[_currentDie2.row][_currentDie2.column] = _currentDie2;
                    _currentDie2.position = [self positionForTile:_currentDie2.column row:_currentDie2.row];
                }
            }
        }
        isRotating = false;
    }
}

# pragma mark - Detect horizontal and vertical chains

- (NSArray *)detectHorizontalMatches {
    NSMutableArray *array = [NSMutableArray array];
    // go through every tile in the grid
    for (NSInteger row = 0; row < GRID_ROWS; row++) {
        for (NSInteger column = 0; column < GRID_COLUMNS - 2; column++) {
            // skip over any empty tiles
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (!positionFree) {
                _leftDie = _gridArray[row][column];
                NSInteger _rightColumn = _leftDie.faceValue+column+1;
                BOOL rowIsValid = false;
                // check if row is valid i.e. filled with dice
                for (NSInteger i = column; i <= _rightColumn; i++) {
                    rowIsValid = [self indexValidAndOccupiedForRow:row andColumn:i];
                    // if row is not filled, break loop
                    if (!rowIsValid) {
                        break;
                    }
                // if there is a valid row, check if right die has matching face
                } if (rowIsValid) {
                    _rightDie = _gridArray[row][_rightColumn];
                    // if there is a valid match, init chain
                    if (_leftDie.faceValue == _rightDie.faceValue) {
                        Chain *chain = [[Chain alloc] init];
                        chain.chainType = ChainTypeHorizontal;
                        // if there's a match, add each dice to the chain
                        for (NSInteger i = column; i <= _rightColumn; i++) {
                            Dice *die = _gridArray[row][i];
                            [chain addDice:die];
                        }
                        [array addObject:chain];
                        matchFound = true;
                        self.match = _rightDie.faceValue;
                    }
                }
            }
        }
    }
    return array;
}

- (NSArray *)detectVerticalMatches {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger row = 0; row < GRID_ROWS-2; row++) {
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (!positionFree) {
                _belowDie = _gridArray[row][column];
                NSInteger _aboveRow = _belowDie.faceValue+row+1;
                BOOL columnIsValid;
                for (NSInteger i = row; i <= _aboveRow; i++) {
                    columnIsValid = [self indexValidAndOccupiedForRow:i andColumn:column];
                    if (!columnIsValid) {
                        break;
                    }
                } if (columnIsValid) {
                    _aboveDie = _gridArray[_aboveRow][column];
                    if (_belowDie.faceValue == _aboveDie.faceValue) {
                        Chain *chain = [[Chain alloc] init];
                        chain.chainType = ChainTypeVertical;
                        for (NSInteger i = row; i <= _aboveRow; i++) {
                            Dice *die = _gridArray[i][column];
                            [chain addDice:die];
                        }
                        [array addObject:chain];
                        matchFound = true;
                        self.match = _belowDie.faceValue;
                    }
                }
            }
        }
    }
    return array;
}

# pragma mark - Remove and handle matches

- (NSArray *)removeMatches {
    NSArray *horizontalChains = [self detectHorizontalMatches];
    NSArray *verticalChains = [self detectVerticalMatches];
    
    //        iterate through die and set all to stable = false (unless row 0)
    //        set stabilizing = true
    if (matchFound) {
        for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
            for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
                BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
                if (positionFree == false) {
                    Dice *die = _gridArray[row][column];
                    //if ([die isEqual: _currentDie1] || [die isEqual: _currentDie2]) {
                    //    continue;
                    //} else {
                    die.stable = false;
                    //}
                }
            }
        }
    } else if (!matchFound) {
        [self resetCombo];
        stabilizing = false;
    }
    
//    DDLogInfo(@"Horizontal matches: %@", horizontalChains);
//    DDLogInfo(@"Vertical matches: %@", verticalChains);
//    DDLogInfo(@"Current streak: %d", self.combo);
    
    [self removeDice:horizontalChains];
    [self removeDice:verticalChains];
    
    [self calculateScores:horizontalChains];
    [self calculateScores:verticalChains];
    
    return [horizontalChains arrayByAddingObjectsFromArray:verticalChains];
}

- (void) handleMatches {
    NSArray *chains = [self removeMatches];
    [self animateMatchedDice:chains];
    
    for (Chain *chain in chains) {
        self.score += chain.score;
    }
}

- (void)animateMatchedDice:(NSArray *)chains {
    for (Chain *chain in chains) {
        [self animateScoreForChain:chain];
        _firstDie = [chain.dice firstObject];
        _lastDie = [chain.dice lastObject];
        for (Dice *die in chain.dice) {
            //TODO: Change this to a glow animation or something before the dice get cleared
            if ([die isEqual: _firstDie] || [die isEqual: _lastDie]) {
                CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
                explosion.autoRemoveOnFinish = TRUE;
                explosion.position = die.position;
                [self addChild:explosion];
            }
            // TODO: Figure out this can do a vert + horiz line at once without setting dice.sprite to nil
            CCActionEaseOut *easeOut = [CCActionEaseOut actionWithDuration:0.75f];
            CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.75f scale:0.1f];
            CCActionSequence *sequence = [CCActionSequence actionWithArray:@[easeOut, scaleDown]];
            [die runAction:sequence];
            [die removeFromParent];
        }
    }
}

- (void)removeDice:(NSArray *)chains {
    for (Chain *chain in chains) {
        for (Dice *die in chain.dice) {
            _gridArray[die.row][die.column] = _noTile;
        }
    }
}

# pragma mark - Calculate scores

- (void)calculateScores:(NSArray *)chains {
    self.combo = -1;
    
    for (Chain *chain in chains) {
        NSInteger face = ((Dice*) chain.dice[0]).faceValue;
        BOOL six = (face == 6);
        self.combo++;
        for (Dice *die in chain.dice) {
            BOOL perfectMatch = (die.faceValue == face);
            if (six && perfectMatch) {
                chain.score = 1000;
                // Perfect match score system: x2
            } else if (perfectMatch) {
                chain.score = face * 20 * ([chain.dice count]) + (50 * self.combo);
                // Regular score system: ones = 30, twos = 80, threes = 150, fours = 240, fives = 350, sixes = 480
            } else {
                chain.score = face * 10 * ([chain.dice count]) + (50 * self.combo);
            }
        }
        CCLOG(@"Face match: %d, chain score: %d, Combo: %ld", face, chain.score, (long)self.combo);
    }
}

- (void)resetCombo {
    self.combo = 0;
}

- (void)animateScoreForChain:(Chain *)chain {
    _firstDie = [chain.dice firstObject];
    _lastDie = [chain.dice lastObject];
    CGPoint centerPosition = CGPointMake(((_firstDie.position.x+_lastDie.position.x)/2), ((_firstDie.position.y+_lastDie.position.y)/2));
    CCLOG(@"Chain score position: %f, %f", centerPosition.x, centerPosition.y);
    
    _chainScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)chain.score];
    _chainScoreLabel.positionInPoints = CGPointMake(centerPosition.x, (centerPosition.y-15));
    _chainScoreLabel.visible = TRUE;
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:0.25f];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.75f position:centerPosition];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.75f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveTo, fadeOut]];
    [_chainScoreLabel runAction:sequence];
}

# pragma mark - Fill in holes

- (void) dieFillHoles {
    for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
		for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            BOOL bottomCanMove = [_gridArray[row-1][column] isEqual: _noTile];
            if (!positionFree) {
                Dice *die = _gridArray[row][column];
                if (bottomCanMove) {
                    die.row--;
                    _gridArray[die.row][die.column] = die; // set die to new row and column
                    die.position = [self positionForTile:die.column row:die.row];
                    _gridArray[row][column] = _noTile; // set old row and column to null
                } else if (!bottomCanMove) {
                    die.stable = true;
                }
            }
        }
    }
}

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
        BOOL unoccupied = [_gridArray[row][column] isEqual:_noTile] || [_gridArray[row][column] isEqual:_currentDie2]  || [_gridArray[row][column] isEqual:_currentDie1];
        return unoccupied;

    }
}

- (BOOL)indexValidAndOccupiedForRow:(NSInteger)row andColumn:(NSInteger)column {
    BOOL indexValid = [self indexValidForRow:row andColumn:column];
    if (!indexValid) {
        return FALSE;
    }
    else if ([_gridArray[row][column] isEqual: _noTile]) {
        return FALSE;
    } else {
        return TRUE;
    }
    
}

@end





//    CCActionMoveTo *fall = [CCActionMoveTo actionWithDuration:5.0f position:ccp(die.position.x, 0)];
//    CCActionMoveTo *fallSequence = [CCActionSequence actionWithArray:@[delay, fall]];
//    [die runAction:fallSequence];



//# pragma mark - Move dice

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
//
//- (void)scanForMatches {
//    [self detectHorizontalMatches];
//    [self detectVerticalMatches];
//    if (matchFound) {
//        //        iterate through die and set all to stable = false (unless row 0)
//        //        set stabilizing = true
//        for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
//            for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
//                BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
//                if (positionFree == false) {
//                    Dice *die = _gridArray[row][column];
//                    die.stable = false;
//                }
//            }
//        }
//        stabilizing = true;
//    }
//    
//    //    [self findMatchesForRow:_currentDie1.row andColumn:_currentDie1.column withFace:_currentDie1.faceValue];
//    //    [self findMatchesForRow:_currentDie2.row andColumn:_currentDie2.column withFace:_currentDie2.faceValue];
//    //    for (NSInteger row = 0; row < GRID_ROWS; row++) { // start from second row
//    //        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
//    //            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
//    //            if (!positionFree) {
//    //                Dice *die = _gridArray[row][column];
//    //                [self findMatchesForRow:die.row andColumn:die.column withFace:die.faceValue];
//    //            }
//    //        }
//    //
//    //    }
//}
//
//- (void)findMatchesForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
//    BOOL foundSouthMatch = [self checkSouthForRow:i andColumn:j withFace:face];
//    BOOL foundNorthMatch = [self checkNorthForRow:i andColumn:j withFace:face];
//    BOOL foundEastMatch = [self checkEastForRow:i andColumn:j withFace:face];
//    BOOL foundWestMatch = [self checkWestForRow:i andColumn:j withFace:face];
//    
//    BOOL foundMatch = (foundSouthMatch || foundNorthMatch || foundEastMatch || foundWestMatch);
//    if (foundMatch) {
//        //        iterate through die and set all to stable = false (unless row 0)
//        //        set stabilizing = true
//        for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
//            for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
//                BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
//                if (positionFree == false) {
//                    Dice *die = _gridArray[row][column];
//                    die.stable = false;
//                }
//            }
//        }
//        stabilizing = true;
//    }
//    
//}
//
//- (BOOL)checkNorthForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
//    NSInteger _north = i+face+1;
//    BOOL foundMatch = false;
//    BOOL columnIsValid;
//    for (NSInteger k = i; k <= _north; k++) {
//        columnIsValid = [self indexValidAndOccupiedForRow:k andColumn:j];
//        if (columnIsValid == false) {
//            break;
//        }
//    }
//    if (columnIsValid) {
//        _northDie = _gridArray[_north][j];
//        if (face == _northDie.faceValue) {
//            for (NSInteger k = i; k <= _north; k++) {
//                [self removeDieAtRow:k andColumn:j];
//                _gridArray[k][j] = _noTile;
//                foundMatch = true;
//                self.match = face;
//            }
//            self.score += (face * (face+2));
//        }
//    }
//    return foundMatch;
//}
//
//- (BOOL)checkSouthForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
//    NSInteger _south = i-face-1;
//    BOOL foundMatch = false;
//    BOOL columnIsValid;
//    for (NSInteger k = i; k >= _south; k--) {
//        columnIsValid = [self indexValidAndOccupiedForRow:k andColumn:j];
//        if (columnIsValid == false) {
//            break;
//        }
//    }
//    if (columnIsValid) {
//        _southDie = _gridArray[_south][j];
//        if (face == _southDie.faceValue) {
//            for (NSInteger k = i; k >= _south; k--) {
//                [self removeDieAtRow:k andColumn:j];
//                _gridArray[k][j] = _noTile;
//                foundMatch = true;
//                self.match = face;
//            }
//            self.score += (face * (face+2));
//        }
//    }
//    return foundMatch;
//}
//
//- (BOOL)checkEastForRow:(NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
//    NSInteger _east = j+face+1;
//    BOOL foundMatch = false;
//    BOOL rowIsValid = false;
//    if (i < GRID_ROWS-1) {
//        for (NSInteger k = j; k <= _east; k++) {
//            rowIsValid = [self indexValidAndOccupiedForRow:i andColumn:k];
//            if (rowIsValid == false) {
//                break;
//            }
//        }
//    }
//    
//    if (rowIsValid) {
//        _eastDie = _gridArray[i][_east];
//        if (face == _eastDie.faceValue) {
//            for (NSInteger k = j; k <= _east; k++) {
//                [self removeDieAtRow:i andColumn:k];
//                _gridArray[i][k] = _noTile;
//                foundMatch = true;
//                self.match = face;
//            }
//            self.score += (face * (face+2));
//        }
//    }
//    return foundMatch;
//}
//
//- (BOOL)checkWestForRow: (NSInteger)i andColumn:(NSInteger)j withFace:(NSInteger)face {
//    NSInteger _west = j-face-1;
//    BOOL foundMatch = false;
//    BOOL rowIsValid;
//    for (NSInteger k = j; k >= _west; k--) {
//        rowIsValid = [self indexValidAndOccupiedForRow:i andColumn:k];
//        if (rowIsValid == false) {
//            break;
//        }
//    }
//    
//    if (rowIsValid) {
//        _westDie = _gridArray[i][_west];
//        if (face == _westDie.faceValue) {
//            for (NSInteger k = j; k >= _west; k--) {
//                [self removeDieAtRow:i andColumn:k];
//                _gridArray[i][k] = _noTile;
//                foundMatch = true;
//                self.match = face;
//            }
//            self.score += (face * (face+2));
//        }
//    }
//    return foundMatch;
//}
//
//
//# pragma mark - Remove chains and update score
//
//- (void) removeDieAtRow:(NSInteger)row andColumn:(NSInteger)column {
//    Dice* die = _gridArray[row][column];
//    die.row = row;
//    die.column = column;
//    
//    // load particle effect
//    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
//    // make the particle effect clean itself up once it's completed
//    explosion.autoRemoveOnFinish = TRUE;
//    // place the particle effect on the seal's position
//    explosion.position = die.position;
//    // add the particle effect to the same node the seal is on
//    [die.parent addChild:explosion];
//    
//    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
//	CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.3f scale:0.1f];
//	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleDown]];
//	[die runAction:sequence];
//	[self removeChild:die];
//}
//


# pragma mark - broken update


//- (void) update:(CCTime) delta {
//    _timer += delta;
//    _timeSinceDrop += delta;
//    _timeSinceBottom += delta;
//
//    if (!stabilizing) {
//        if (_timeSinceDrop > _dropInterval) {
//            _dropInterval = self.levelSpeed;
//            _timeSinceDrop = -0.2;
//            [self dieFallDown];
//            _timeSinceDrop = 0;
//            if (![self canBottomMove]) {
//                _timeSinceBottom = 0;
//                if (_timeSinceBottom > 0.8) {
//                    CCLOG(@"Dice fell to bottom");
//                    [self trackGridState];
//                    [self handleMatches];
//                    stabilizing = [self checkGrid];
//                    [self loadLevel];
//                    [self spawnDice];
//                }
//            }
//        } else while (stabilizing) {
//                                                        CCLOG(@"Matches handled");
//                                                        [self trackGridState];
//            _timeSinceDrop = 0;
//            _dropInterval = 0.1;
//            noMoreHoles = [self dieFillHoles];
//            if (noMoreHoles) {
//                                                        CCLOG(@"Holes filled in");
//                                                        [self trackGridState];
//            [self handleMatches];
//            }
//            stabilizing = [self checkGrid];
//        }
//    }
//}
//


//            {
//                _timeSinceBottom = 0;
//            } else if (_timeSinceBottom < 0.2) {
//                _timeSinceBottom += delta;
//            } else {
//
//            }


//            }
//            if (![self canBottomMove]) {
//                _timeSinceBottom = 0;
//                _timeSinceBottom += delta;
//            } if (_timeSinceBottom > 0.25) {







/* Original update method
 # pragma mark - Update method

- (void) update:(CCTime) delta {
    _timer += delta;
    _timeSinceDrop += delta;
    
    if (_timeSinceDrop > _dropInterval) {
        
        // if not stabilizing, let dice fall down
        if (!stabilizing) {
            [self dieFallDown];
            _timeSinceDrop = 0;
            if (![self canBottomMove]) {
                CCLOG(@"Dice fell to bottom");
                [self trackGridState];
                [self handleMatches]; // --> stabilizing
                [self loadLevel];
                [self spawnDice];
                _dropInterval = self.levelSpeed;
                _timeSinceDrop = 0.2;
            }
        } else if (stabilizing) {
            CCLOG(@"Matches handled");
            [self trackGridState];
            _timeSinceDrop = 0;
            _dropInterval = 0.1;
            [self dieFillHoles]; // --> stabilized
            stabilizing = [self checkGrid];
            if (!stabilizing) {
                CCLOG(@"Holes filled in");
                [self trackGridState];
                [self handleMatches]; // -> stabilizing
                _dropInterval = self.levelSpeed;
                _timeSinceDrop = 0;
                CCLOG(@"Grid stabilized");
                [self trackGridState];
            }
            
        }
    }
}*/