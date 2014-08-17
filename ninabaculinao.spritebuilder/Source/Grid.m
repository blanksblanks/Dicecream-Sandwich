//
//  Grid.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Dice.h"
#import "GameState.h"
#import "GameEnd.h"
#import "Gameplay.h"

@implementation Grid {
    
    NSInteger actionIndex;
    BOOL stabilizing;
    NSInteger _counter;
    
    
    CGFloat _tileWidth; //37, same as tile height
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
//    Dice *_ghostDie1;
//    Dice *_ghostDie2;
    
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
    BOOL specialFound;
    BOOL matchFound;
    BOOL animationFinished;
    BOOL comboCondition; // dice spawned but match found false
    BOOL specialsAllowed;

//    CCSlider *slider;
}

// two constants to describe the number of rows and columns
static const NSInteger GRID_ROWS = 12;
static const NSInteger GRID_COLUMNS = 6;

- (void)didLoadFromCCB{
    
    // Initialize values
    _timer = 0;
    _counter = 0;
    stabilizing = false;
    specialsAllowed = false;
    self.score = 0;
    self.chains = 0;
    self.sixChains = 0;
    self.perfectMatches = 0;
    self.combo = 0;
    self.streak = 0;
    self.allClear = 0;
    
    self.gameOver = false;
    self.paused = false;
    self.touchEnabled = TRUE;
    
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

# pragma mark - Update method

- (void) update:(CCTime) delta {
    
    if (!self.paused) {
        _timer += delta;
        _timeSinceDrop += delta;
        
        switch (actionIndex%5) {
            case 0: { // spawn dice
                [self spawnDice];
//                [self resetValue:slider];
//                [self spawnGhost];
                self.touchEnabled = TRUE;
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
                        [self playHitBottom];
                        CCLOG(@"Dice fell to bottom:"); [self trackGridState];
                        //                    [self removeGhost];
                        self.touchEnabled = FALSE;
                        _dropInterval = 0.05;
                        actionIndex = 2; CCLOG(@"Going to case 2: filling holes");
                    }
                    
                }
                break;
            }
            case 2: { // dice filling holes
                if (_timeSinceDrop > _dropInterval) {
                    [self dieFillHoles]; // --> stabilized
                    _timeSinceDrop = 0;
                    stabilizing = [self checkGrid];
                    if (!stabilizing && !specialFound) {
                        CCLOG(@"Holes filled:"); [self trackGridState];
                        actionIndex = 3; CCLOG(@"Going to case 3: activating specials");
                    } else if (!stabilizing && specialFound) {
                        CCLOG(@"Holes filled:"); [self trackGridState];
                        actionIndex = 4; CCLOG(@"Going to case 4: handling matches");
                    }
                }
                break;
            }
            case 3: { // activating specials
                [self handleSpecials];
                [self loadLevel];
                if (specialFound && animationFinished) {
                    CCLOG(@"Specials activated:"); [self trackGridState];
                    _timeSinceDrop = -0.2;
                    _dropInterval = 0.05;
                    actionIndex = 2; CCLOG(@"Special found. Going to case 2: filling holes");
                } else if (!specialFound) {
                    actionIndex = 4; CCLOG(@"No specials found. Going to case 4: handling matches");
                }
                break;
            }
            case 4: { // handling matches
                [self handleMatches];
                [self loadLevel];
                if (matchFound && animationFinished) {
                    CCLOG(@"Matches handled:"); [self trackGridState];
                    _timeSinceDrop = -0.2;
                    _dropInterval = 0.05;
                    actionIndex = 2; CCLOG(@"Match found. Going to case 2: filling holes");
                } else if (!matchFound) {
                    _dropInterval = self.levelSpeed;
                    actionIndex = 0; CCLOG(@"No matches found. Going to case 0: spawning dice");
                }
                break;
            }
                
        }
    }
}

# pragma mark - Pause methods

- (void)pause {
    self.paused = true;
    self.touchEnabled = false;
}

- (void)unpause {
    self.paused = false;
    self.touchEnabled = true;
}

# pragma mark - Create initial grid and check grid state

- (void)setupGrid {
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

- (void) checkIfAllClear {
    BOOL allClear = false;
    for (NSInteger row = 0; row < GRID_ROWS; row++) {
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (positionFree) {
                allClear = true;
            } else {
                break;
            }
        }
    }
    if (allClear) {
        self.allClear++;
    }
}

- (void)trackGridState { // aka my beautiful debugging log
    
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

# pragma mark - Check indexes

- (BOOL)indexValidForRow:(NSInteger)row andColumn:(NSInteger)column {
    BOOL indexValid = YES;
    if(row < 0 || column < 0 || row >= GRID_ROWS || column >= GRID_COLUMNS) {
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
        BOOL unoccupied = [_gridArray[row][column] isEqual:_noTile] || [_gridArray[row][column] isEqual:_currentDie1]  || [_gridArray[row][column] isEqual:_currentDie2];
        //        || [_gridArray[row][column] isEqual:_ghostDie1] || [_gridArray[row][column] isEqual:_ghostDie2];
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

# pragma mark - Spawn random pair of dice

- (void)spawnDice {
    
    specialFound = false;
    comboCondition = false;

    // Commented out code for random spawn location
    NSInteger firstRow = GRID_ROWS-1;
    NSInteger firstColumn = arc4random_uniform(GRID_COLUMNS-2); // int bt 0 and 4 // GRID_COLUMNS/2)-1; for center
    NSInteger nextRow = firstRow - arc4random_uniform(2);
    NSInteger nextColumn = firstColumn+1;

    if (firstRow != nextRow) { // has to be vertical
        nextColumn = firstColumn;
    } else { // has to be horizontal
        nextColumn = firstColumn+1;
    }
    
    BOOL positionFree = ([_gridArray[firstRow][firstColumn] isEqual: _noTile]);
    BOOL nextPositionFree = ([_gridArray[nextRow][nextColumn] isEqual: _noTile]);
    if (positionFree && nextPositionFree) {
        _currentDie1 = [self randomizeDice];
        _currentDie1 = [self addDie:_currentDie1 atColumn:firstColumn andRow:firstRow];
        _currentDie2 = [self randomizeDice];
        _currentDie2 = [self addDie:_currentDie2 atColumn:nextColumn andRow:nextRow];
    } else {
        [self gameEnd];
    }
}


-(Dice*) addDie:(Dice*)die atColumn:(NSInteger)column andRow:(NSInteger)row {
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

-(Dice*)randomizeDice {
    Dice *die;
    if (!specialsAllowed) {
        die = [self randomizeNumbers];
    } else {
        die = [self randomizeSpecials];
    }
    return die;
}

-(Dice*) randomizeNumbers {
    Dice *die;
    NSInteger randomNumber = arc4random_uniform(self.possibilities)+1;
    switch(randomNumber)
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

/* Specials are only allowed in level 6 and above, and only called
 every five dice with a 5% chance of spawning
 */
-(Dice*) randomizeSpecials {
    Dice *die;
    NSInteger chance = arc4random_uniform(100);
    if ((_counter%5 == 0) && (chance <= 5)) {
        NSInteger randomSpecial = arc4random_uniform(3)+7;
        switch(randomSpecial){
            case 7 :
                die = (Dice*) [CCBReader load:@"Dice/Bomb"];
                break;
            case 8:
                die = (Dice*) [CCBReader load:@"Dice/Laser"];
                break;
            case 9:
                die = (Dice*) [CCBReader load:@"Dice/Mystery"];
                break;
            default:
                die = (Dice*) [CCBReader load:@"Dice/Bomb"];
                break;
        }
    }
    else {
        die = [self randomizeNumbers];
    }
    _counter++;
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

- (void) playHitBottom {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"pop5.wav"];
    // play sound effect
    [audio playEffect:@"pop5.wav"];
}

# pragma mark - Touch handling - let player swipe left/right/down/rotate

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    oldTouchPosition = [touch locationInNode:self];
    oldTouchTime = touch.timestamp;
/*
// No longer using slider
    float x = slider.sliderValue * self.contentSize.width;
    
    if (oldTouchPosition.y < _tileWidth) {
        CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.5f];
        [slider runAction:fadeIn];
        slider.visible = TRUE;
        [self resetValue:slider];
    } else if (oldTouchPosition.y > _tileWidth) {
        CCAction *fadeOut = [CCActionFadeOut actionWithDuration:1.5f];
        [slider runAction:fadeOut];
        [self scheduleBlock:^(CCTimer *timer) {
            slider.visible = FALSE;
            
        } delay:1.5];
    }
 */
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint newTouchPosition = [touch locationInNode:self];
    float ydifference = oldTouchPosition.y - newTouchPosition.y;
    float xdifference = oldTouchPosition.x - newTouchPosition.x;
    
    // determine to which column touch goes, cannot go past columns 0 and 5
    NSInteger column = ((newTouchPosition.x - _tileMarginHorizontal) / (_tileWidth + _tileMarginHorizontal));
    if (column > GRID_COLUMNS-1) {
        column = GRID_COLUMNS-1;
    } else if (column < 0) {
        column = 0;
    }
    
    if ((ydifference > 0.2*(self.contentSize.height)) && (newTouchPosition.y < _currentDie1.position.y) && (newTouchPosition.y < _currentDie2.position.y)) {
        _dropInterval = 0.03;
    } else if ((xdifference > 0.5*(_tileWidth))) {
        [self swipeLeftTo:column];
    } else if ((xdifference < -0.5*(_tileWidth))) {
        [self swipeRightTo:column];
    } else {
        _dropInterval = self.levelSpeed;
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint newTouchPosition = [touch locationInNode:self];
    float ydifference = oldTouchPosition.y - newTouchPosition.y;
    float xdifference = oldTouchPosition.x - newTouchPosition.x;
    
    newTouchTime = touch.timestamp;
    NSTimeInterval touchInterval = newTouchTime - oldTouchTime;
    
    if ((touchInterval > 0.2)  && (ydifference > 0.2*(self.contentSize.height))) {
        _dropInterval = self.levelSpeed; // soft drop
    } else if ((touchInterval < 0.2) && (ydifference > 0.2*(self.contentSize.height))) {
        _dropInterval = 0.01; // hard drop
    } else if ((touchInterval < 0.2) && (xdifference < 0.5*(_tileWidth)) && (xdifference > -0.5*(_tileWidth))) {
        [self rotate];
    }
}

/* TODO: Figure out if tapping the slider button can trigger rotation
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (oldTouchPosition.y < slider.handle.position.y+10 && oldTouchPosition.y > slider.handle.position.y-10 && oldTouchPosition.x < slider.handle.position.x+10 & oldTouchPosition.y > slider.handle.position.x-10) {
        CCLOG(@"%f %f", slider.handle.position.x, slider.handle.position.y);
        for (UITouch *touch in touches) {
            if (touch.tapCount >= 2) {
                [self rotate];
            }
        }
    }
}
*/

# pragma mark - Swipe and rotate methods

- (void)playMoveSound {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"click2.wav"];
    // play sound effect
    [audio playEffect:@"click2.wav"];
}

- (void)swipeLeftTo:(NSInteger)column {
//    __block
    BOOL canMoveLeft = TRUE;
    while (_currentDie1.column > column && _currentDie2.column > column && canMoveLeft) {
            canMoveLeft = [self swipeLeft];
    }
}


- (BOOL)swipeLeft {
    BOOL canMoveLeft = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column-1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column-1];
    if (canMoveLeft) {
        [self moveDie:_currentDie1 inDirection:ccp(-1, 0)];
        [self moveDie:_currentDie2 inDirection:ccp(-1, 0)];
        [self playMoveSound];
        //        [self moveGhostDice];
    }
    return canMoveLeft;
}

- (void)swipeRightTo:(NSInteger)column {
    BOOL canMoveRight = TRUE;
    while (_currentDie1.column < column && _currentDie2.column < column && canMoveRight) {
        canMoveRight = [self swipeRight];
    }
}
// TODO: try to do ccaction move animation again - determine how much it can move ie 5 col and then move by in one action
// Don't use it on rotate though, that's weird

- (BOOL)swipeRight {
    BOOL canMoveRight = [self indexValidAndUnoccupiedForRow:_currentDie2.row andColumn:_currentDie2.column+1] && [self indexValidAndUnoccupiedForRow:_currentDie1.row andColumn:_currentDie1.column+1];
    if (canMoveRight) {
        [self moveDie:_currentDie1 inDirection:ccp(1, 0)];
        [self moveDie:_currentDie2 inDirection:ccp(1, 0)];
        [self playMoveSound];
        //        [self moveGhostDice];
    }
    return canMoveRight;
}

- (void)rotate {
    BOOL bottomCanMove = [self canBottomMove];
    
    if (bottomCanMove) {
        [self playMoveSound];
        if (_currentDie2.column > _currentDie1.column) {
            // [1][2] --> [1]
            //            [2]
            // check if new placement is occupied
            if ([_gridArray[_currentDie2.row-1][_currentDie2.column-1] isEqual: _noTile]) {
                [self moveDie:_currentDie2 inDirection:ccp(-1,-1)];
            }
        } else if (_currentDie1.row > _currentDie2.row) {
            // [1]
            // [2] --> [2][1] means die1 moves when it's in rightmost column
            if (_currentDie2.column == 0) {
                if ([_gridArray[_currentDie1.row-1][_currentDie1.column+1] isEqual: _noTile]) {
                    [self moveDie:_currentDie1 inDirection:ccp(1, -1)];
                }
            } else if (_currentDie1.row == GRID_ROWS-1) { // when die1 is on top row
                if ([_gridArray[_currentDie1.row-1][_currentDie1.column-1] isEqual: _noTile]) {
                    [self moveDie:_currentDie1 inDirection:ccp(-1, -1)];
                }
            }
            else {
                if ([_gridArray[_currentDie2.row+1][_currentDie2.column-1] isEqual: _noTile]) {
                    [self moveDie:_currentDie2 inDirection:ccp(-1, 1)];
                }
            }
        } else if (_currentDie1.column > _currentDie2.column) {
            // [2][1] --> [2]
            //            [1]
            if ([_gridArray[_currentDie2.row+1][_currentDie2.column+1] isEqual: _noTile]) {
                [self moveDie:_currentDie2 inDirection:ccp(1, 1)];
            }
        } else {
            // [2]
            // [1]  --> [1][2] means die1 moves when it's in leftmost column
            if (_currentDie2.column == GRID_COLUMNS-1) {
                if ([_gridArray[_currentDie1.row+1][_currentDie1.column-1] isEqual: _noTile]) {
                    [self moveDie:_currentDie1 inDirection:ccp(-1, 1)];
                }
            } else {
                if ([_gridArray[_currentDie2.row-1][_currentDie2.column+1] isEqual: _noTile]) {
                    [self moveDie:_currentDie2 inDirection:ccp(1, -1)];
                }
            }
        }
    }
    //    [self moveGhostDice];
}


- (void) moveDie:(Dice*)die inDirection:(CGPoint)direction {
    NSInteger newRow = die.row + direction.y;
    NSInteger newColumn = die.column + direction.x;
    BOOL indexValid = [self indexValidForRow:newRow andColumn:newColumn];
    if (indexValid) {
        _gridArray[die.row][die.column] = _noTile; // Set old index of the die in the array to null
        die.row += direction.y; // Change die row and column properties based on direction coordinates
        die.column += direction.x;
        _gridArray[die.row][die.column] = die; // Set new index in the grid array to the die
        die.position = [self positionForTile:die.column row:die.row];
        //        CGPoint newPosition = [self positionForTile:die.column row:die.row]; // Position dice object in the visual grid
        //        CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:newPosition];
        //        [die runAction:moveTo];
    }
}

/*
 
# pragma mark - Slider controls - obsolete

- (void)resetValue:(CCSlider*)sliderBar {
    NSInteger column = _currentDie1.column;
    float x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _tileWidth) + (_tileWidth/2);
    slider.sliderValue = x / self.contentSize.width;
}

- (void)valueChanged:(CCSlider *)sliderBar {
    slider = sliderBar;
    float x = slider.sliderValue * self.contentSize.width;
    NSInteger column = ( x - _tileMarginHorizontal) / (_tileMarginHorizontal + _tileWidth);
    if (column > _currentDie1.column && column > _currentDie2.column) {
        [self swipeRightTo:column];
    } else {
        [self swipeLeftTo:column];
    }
    CCLOG(@"%f col:%ld", slider.sliderValue, (long)column);
}
 
 */


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
                            comboCondition = true;
                            matchFound = true;
                            self.combo++;
                            break;
                        }
                    }
                }
            }
        }
    return array;
}

- (NSArray *)detectVerticalMatches {
    NSMutableArray *array = [NSMutableArray array];
    // For loops have to be in this order to break out of for loop when vertical match is made
    // If we don't break out of "for row" loop it will continue to look at dice in row above
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            for (NSInteger row = 0; row < GRID_ROWS-2; row++) {
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
                            comboCondition = true;
                            self.combo++;
                            break;
                    }
                }
            }
        }
    }
    return array;
}

# pragma mark - Activate specials

- (void) handleSpecials{
    NSArray *chains = [self removeSpecialMatches];
    [self animateSpecialDice:chains];
    
    for (Chain *chain in chains) {
        self.score += chain.score;
    }
}

- (NSArray *)removeSpecialMatches {
    NSArray *specialChains = [self detectSpecialMatches];
    
    if (specialFound) {
        for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
            for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
                BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
                if (!positionFree) {
                    Dice *die = _gridArray[row][column];
                    die.stable = false;
                }
            }
        }
    }
    
    [self removeDice:specialChains];
    
    [self calculateScores:specialChains];
    
    [self checkIfAllClear];
    
    return specialChains;
}

// TODO: only need to check current dice 1 and 2
- (NSArray *)detectSpecialMatches {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger row = 0; row < GRID_ROWS; row++) {
        for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            if (!positionFree) {
                Dice *die = _gridArray[row][column];
                if (die.faceValue > 6) {
                    Chain *chain = [[Chain alloc] init];
                    switch(die.faceValue) {
                        case 7:
                            chain.chainType = ChainTypeBomb;
                            // go through the row on top, below and where the special item is
                            for (NSInteger x = (row-1); x <= (row+1); x++) {
                                // go through the column to left, right and where the special item is
                                for (NSInteger y = (column-1); y <= (column+1); y++) {
                                    BOOL indexValidAndOccupied = [self indexValidAndOccupiedForRow:x andColumn:y];
                                    // skip over all tiles that are off screen
                                    if (indexValidAndOccupied) {
                                        Dice *neighbor = _gridArray[x][y];
                                        [chain addDice:neighbor];
                                    }
                                }
                            }
                            break;
                        case 8:
                            chain.chainType = ChainTypeLaser;
                            // go through all the tiles that share the laser column
                            for (NSInteger x = 0; x < GRID_ROWS; x++) {
                                BOOL indexValidAndOccupied = [self indexValidAndOccupiedForRow:x andColumn:column];
                                if (indexValidAndOccupied) {
                                    Dice *columnMate = _gridArray[x][column];
                                    [chain addDice:columnMate];
                                }
                            }
                            // go through all the tiles that share the laser row
                            for (NSInteger y = 0; y < GRID_COLUMNS; y++) {
                                BOOL indexValidAndOccupied = [self indexValidAndOccupiedForRow:row andColumn:y];
                                if (indexValidAndOccupied && y != column) {
                                    Dice *rowMate = _gridArray[row][y];
                                    [chain addDice:rowMate];
                                }
                            }
                            break;
                        case 9:
                            chain.chainType = ChainTypeMystery;
                            // Add mystery die to the chain so it's deleted even if there's no face matches
                            [chain addDice:die];
                            // Assign a random face value to mystery die
                            _face = arc4random_uniform(6)+1;
                            for (NSInteger x = 0; x < GRID_ROWS; x++) {
                                for (NSInteger y = 0; y < GRID_COLUMNS; y++) {
                                    BOOL indexValidAndOccupied = [self indexValidAndOccupiedForRow:x andColumn:y];
                                    if (indexValidAndOccupied) {
                                        Dice *faceMate = _gridArray[x][y];
                                        if (faceMate.faceValue == _face) {
                                            [chain addDice:faceMate];
                                        }
                                    }
                                }
                            }
                            break;
                    }
                    [array addObject:chain];
                    specialFound = true;
                }
            }
        }
    }
    return array;
}

- (void)animateSpecialDice:(NSArray *)chains {
    
    for (Chain *chain in chains) {
        [self animateScoreForChain:chain];
        [self animateGameMessage];
        [self playPowerUpSound];
        for (Dice *die in chain.dice) {
            CCAnimationManager* animationManager = die.animationManager;
            [animationManager runAnimationsForSequenceNamed:@"colorFill"];
            CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
            explosion.autoRemoveOnFinish = TRUE;
            explosion.position = die.position;
            [self addChild:explosion];
            [self scheduleBlock:^(CCTimer *timer) {
                [die removeFromParent];
                animationFinished = true;
                
            } delay:1.5];
        }
    }
}

- (void)playSuccessSound {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"success.wav"];
    // play sound effect
    [audio playEffect:@"success.wav"];
}

- (void)playPowerUpSound {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"powerUp.wav"];
    // play sound effect
    [audio playEffect:@"powerUp.wav"];
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
                if (!positionFree) {
                    Dice *die = _gridArray[row][column];
                    die.stable = false;
                }
            }
        }
    } else if (!comboCondition && !matchFound) {
        self.combo = 0; // reset combo
    }
    
    [self removeDice:horizontalChains];
    [self removeDice:verticalChains];
    
    [self calculateScores:horizontalChains];
    [self calculateScores:verticalChains];
    
    [self checkIfAllClear];
    
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
        [self playSuccessSound];
        [self animateScoreForChain:chain];
        [self animateGameMessage];
        _firstDie = [chain.dice firstObject];
        _lastDie = [chain.dice lastObject];
        for (Dice *die in chain.dice) {
            if ([die isEqual: _firstDie] || [die isEqual: _lastDie]) {
                CCAnimationManager* animationManager = die.animationManager;
                [animationManager runAnimationsForSequenceNamed:@"colorFill"];
            }
            CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
            explosion.autoRemoveOnFinish = TRUE;
            explosion.position = die.position;
            [self addChild:explosion];
            [self scheduleBlock:^(CCTimer *timer) {
                [die removeFromParent];
                animationFinished = true;
                
            } delay:1.5];
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

# pragma mark - Calculate scores and animate them

- (void)calculateScores:(NSArray *)chains {
    for (Chain *chain in chains) {
        BOOL perfectMatch = false;
        NSInteger face = ((Dice*) chain.dice[0]).faceValue;
        if (face == 6) {
            self.sixChains++;
        }
        
        for (Dice *die in chain.dice) {
            perfectMatch = (die.faceValue == face);
            if (!perfectMatch) {
                break;
            }
        }
        
        if (perfectMatch) { // double the score!
            chain.score = face * 20 * ([chain.dice count]);
            self.perfectMatches++;
            self.chains++;
        } else {
            chain.score = face * 10 * ([chain.dice count]);
            self.chains++;
        }
    }
}

- (void)animateScoreForChain:(Chain *)chain {
    // Set string and position
    _firstDie = [chain.dice firstObject];
    _lastDie = [chain.dice lastObject];
    CGPoint centerPosition = CGPointMake(((_firstDie.position.x+_lastDie.position.x)/2), ((_firstDie.position.y+_lastDie.position.y)/2));
    CGPoint endPosition = CGPointMake(centerPosition.x, (centerPosition.y+15));
    NSString *scoreString = [NSString stringWithFormat:@"+ %ld", (long)chain.score];
    
    // Create chain score
    CCLabelTTF *chainScore = [CCLabelTTF labelWithString:scoreString fontName:@"Marker Felt" fontSize:18];
    chainScore.outlineColor = [CCColor purpleColor];
    chainScore.outlineWidth = 3.0f;
    chainScore.positionInPoints = centerPosition;
    [self addChild:chainScore];
   
    // Remove chain score
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:0.25f];
    CCActionMoveTo *moveToEnd = [CCActionMoveTo actionWithDuration:0.75f position:endPosition];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.75f];
    CCActionSequence *chainSequence = [CCActionSequence actionWithArray:@[fadeIn, moveToEnd, fadeOut]];
    [chainScore runAction:chainSequence];
    
    [self scheduleBlock:^(CCTimer *timer) {
        [chainScore removeFromParent];
    } delay:1.75];
    
/* TODO: Deal with combos later
 
    if (self.combo > 0) {
        
        if (self.combo > self.streak) {
            self.streak = self.combo;
        }
    
        CGPoint beginPosition = CGPointMake(centerPosition.x, (centerPosition.y+15));
        NSString *comboString = [NSString stringWithFormat:@"+50 x %ld", (long)self.combo];
        
        CCLabelTTF *comboScore = [CCLabelTTF labelWithString:comboString fontName:@"GillSans-Bold" fontSize:18];
        comboScore.outlineColor = [CCColor purpleColor];
        comboScore.outlineWidth = 3.0f;
        comboScore.positionInPoints = beginPosition;
        [self addChild:comboScore];
        
        CCActionMoveTo *moveToCenter = [CCActionMoveTo actionWithDuration:0.75f position:centerPosition];
        CCActionSequence *comboSequence = [CCActionSequence actionWithArray:@[fadeIn, moveToCenter, fadeOut]];
        [comboScore runAction:comboSequence];
        
        [self scheduleBlock:^(CCTimer *timer) {
            [chainScore removeFromParent];
            [comboScore removeFromParent];
        } delay:1.75];
*/

}

- (void)animateGameMessage {
    if (self.combo > 10) {
        
        if (self.combo > self.streak) {
            self.streak = self.combo;
        }
        
        CGPoint beginPosition = CGPointMake(self.contentSize.width/2, _tileWidth * 5.5);
        CGPoint endPosition = CGPointMake(self.contentSize.width/2, _tileWidth * 8.5);
        NSString *scoreString = [NSString stringWithFormat:@"+50x%ld", (long)self.combo];

        CCLabelTTF *gameMessage = [CCLabelTTF labelWithString:scoreString fontName:@"Marker Felt" fontSize:36];
        gameMessage.outlineColor = [CCColor purpleColor];
        gameMessage.outlineWidth = 3.0f;
        gameMessage.position = beginPosition;
    
        [self addChild:gameMessage];
        
        CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:0.25f];
        CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.75f position:endPosition];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.75f];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveTo, fadeOut]];
        [gameMessage runAction:sequence];
        
        [self scheduleBlock:^(CCTimer *timer) {
            [gameMessage removeFromParent];
            
        } delay:1.75];
    }
}

- (void)animateLevelUp {
    
    [self playLevelUpSound];

    CGPoint beginPosition = CGPointMake(self.contentSize.width/2, _tileWidth * 3.5);
    CGPoint endPosition = CGPointMake(self.contentSize.width/2, _tileWidth * 5.5);
    NSString *scoreString = [NSString stringWithFormat:@"Level Up!"];
    
    CCLabelTTF *gameMessage = [CCLabelTTF labelWithString:scoreString fontName:@"Marker Felt" fontSize:48];
    gameMessage.outlineColor = [CCColor purpleColor];
    gameMessage.outlineWidth = 3.0f;
    gameMessage.position = beginPosition;
    
    [self addChild:gameMessage];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:0.25f];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.75f position:endPosition];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.75f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveTo, fadeOut]];
    [gameMessage runAction:sequence];
    
    
    [self scheduleBlock:^(CCTimer *timer) {
        [gameMessage removeFromParent];
        
    } delay:1.75];
}

-(void) playLevelUpSound {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"levelUp.wav"];
    // play sound effect
    [audio playEffect:@"levelUp.wav"];
}

# pragma mark - Fill in holes

- (void) dieFillHoles {
    matchFound = false; // reset before checking matches
    animationFinished = false;
    for (NSInteger row = 1; row < GRID_ROWS; row++) { // start from second row
		for (NSInteger column = 0; column < GRID_COLUMNS; column++) {
            BOOL positionFree = [_gridArray[row][column] isEqual: _noTile];
            BOOL bottomCanMove = [_gridArray[row-1][column] isEqual: _noTile];
            if (!positionFree) {
                Dice *die = _gridArray[row][column];
                die.stable = false;
                if (bottomCanMove) {
                    die.row--;
                    _gridArray[die.row][die.column] = die; // set die to new row and column
                    die.position = [self positionForTile:die.column row:die.row];
                    _gridArray[row][column] = _noTile; // set old row and column to null
                } else {
                    die.stable = true;
                }
            }
        }
    }
}


# pragma mark - Load levels and new parameters

- (void)loadLevel {
    NSString*path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *levels = [root objectForKey: @"Levels"];
    
    if (self.score == 0) {
        self.level = 1;
    } else if (self.score >= self.targetScore) {
        self.level++;
        [self animateLevelUp];
    }
    
    if (self.level > 9) {
        specialsAllowed = TRUE;
    }
    
    NSDictionary *dict = levels[self.level-1];
    self.levelSpeed = (0.4/self.level)+0.1;
    self.targetScore = [dict[@"targetScore"] intValue];
    self.possibilities = [dict[@"possibilities"] intValue];
}


# pragma mark - Game over

- (void) gameEnd {
    [self pause];
    [self playGameOverSound];
    [self scheduleBlock:^(CCTimer *timer) {
        self.gameOver = true;
        self.touchEnabled = false;
        //    [self.audio stopEverything];
        [self assignStats];
        GameEnd *gameEnd = (GameEnd*) [CCBReader load:@"GameEnd"];
        [gameEnd setPositionType:CCPositionTypeNormalized];
        gameEnd.position = ccp(0.5, 0.5);
        [self.parent addChild:gameEnd];
    } delay:1.0f];
}

- (void) playGameOverSound {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"oneBlastWhistle.wav"];
    // play sound effect
    [audio playEffect:@"oneBlastWhistle.wav"];
}

-(void) assignStats {
    // Set game state values to those in game
    [GameState sharedInstance].currentScore = self.score;
    [GameState sharedInstance].currentLevel = self.level;
    [GameState sharedInstance].currentTime = self.timer;
    [GameState sharedInstance].currentChains = self.chains;
    [GameState sharedInstance].currentChainsPerMin = self.chains/(self.timer/60);
    [GameState sharedInstance].current6Chains = self.sixChains;
    [GameState sharedInstance].currentPerfectMatches = self.perfectMatches;
    [GameState sharedInstance].currentStreak = self.streak;
    [GameState sharedInstance].currentAllClear = self.allClear;
    
    if ([GameState sharedInstance].bestScore < self.score) {
        [GameState sharedInstance].bestScore = self.score;
        [GameState sharedInstance].bestLevel = self.level;
        [GameState sharedInstance].bestTime = self.timer;
        [GameState sharedInstance].bestChains = self.chains;
        [GameState sharedInstance].bestChainsPerMin = self.chains/(self.timer/60);
        [GameState sharedInstance].best6Chains = self.sixChains;
        [GameState sharedInstance].bestPerfectMatches = self.perfectMatches;
        [GameState sharedInstance].bestStreak = self.streak;
        [GameState sharedInstance].bestAllClear = self.allClear;
    }
}

-(void) endGame {
    [self gameEnd];
}

/*
 
 # pragma mark - Spawn ghost (obsolete - maybe work on it later)
 
 - (void)spawnGhost {
 NSInteger ghostRow1;
 NSInteger ghostRow2;
 
 if (_currentDie1.row > _currentDie2.row) {
 ghostRow2 = [self findBottomforColumn:_currentDie2.column];
 ghostRow1 = ghostRow2 + 1;
 } else {
 ghostRow1 = [self findBottomforColumn:_currentDie1.column];
 ghostRow2 = [self findBottomforColumn:_currentDie2.column];
 }
 
 BOOL same1 = ((_ghostDie1.row == _currentDie1.row) && (_ghostDie1.column == _currentDie1.column));
 BOOL same2 = ((_ghostDie2.row == _currentDie2.row) && (_ghostDie2.column == _currentDie2.column));
 
 if (!same1 && !same2) {
 _ghostDie1 = (Dice*) [CCBReader load:@"Dice/Dice"];
 _ghostDie2 = (Dice*) [CCBReader load:@"Dice/Dice"];
 _ghostDie1 = [self addDie:_ghostDie1 atColumn:_currentDie1.column andRow:ghostRow1];
 _ghostDie2 = [self addDie:_ghostDie2 atColumn:_currentDie2.column andRow:ghostRow2];
 }
 }
 
 - (NSInteger)findBottomforColumn:(NSInteger)column {
 NSInteger ghostRow = 0;
 for (NSInteger row = GRID_ROWS-3; row >= 0; row--) {
 if([_gridArray[row][column] isEqual:_noTile] || [_gridArray[row][column] isEqual:_ghostDie1] || [_gridArray[row][column] isEqual:_ghostDie2]) {
 ghostRow = row;
 }
 }
 return ghostRow;
 }
 
 - (void)moveGhostDice{
 NSInteger ghostRow1;
 NSInteger ghostRow2;
 NSInteger ghostColumn1 = _currentDie1.column;
 NSInteger ghostColumn2 = _currentDie2.column;
 
 if (_currentDie1.row > _currentDie2.row) {
 ghostRow2 = [self findBottomforColumn:ghostColumn2];
 ghostRow1 = ghostRow2 + 1;
 } else if (_currentDie2.row > _currentDie1.row) {
 ghostRow1 = [self findBottomforColumn:ghostColumn1];
 ghostRow2 = ghostRow1 + 1;
 } else {
 ghostRow1 = [self findBottomforColumn:ghostColumn1];
 ghostRow2 = [self findBottomforColumn:ghostColumn2];
 }
 
 NSInteger x1 = _ghostDie1.column - ghostColumn1;
 NSInteger x2 = _ghostDie2.column - ghostColumn2;
 
 NSInteger y1 = _ghostDie1.row - ghostRow1;
 NSInteger y2 = _ghostDie2.row - ghostRow2;
 
 [self moveDie:_ghostDie1 inDirection:ccp(-x1, -y1)];
 [self moveDie:_ghostDie2 inDirection:ccp(-x2, -y2)];
 }
 
 - (void)removeGhost {
 if (_gridArray[_ghostDie1.row][_ghostDie1.column] != _currentDie1 && _gridArray[_ghostDie1.row][_ghostDie1.column] != _currentDie2 && _gridArray[_ghostDie2.row][_ghostDie2.column] != _currentDie1 && _gridArray[_ghostDie2.row][_ghostDie2.column] != _currentDie2) {
 _gridArray[_ghostDie1.row][_ghostDie1.column] = _noTile;
 _gridArray[_ghostDie2.row][_ghostDie2.column] = _noTile;
 }
 
 CCActionEaseOut *easeOut = [CCActionEaseOut actionWithDuration:0.75f];
 CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.75f scale:0.1f];
 CCActionSequence *sequence = [CCActionSequence actionWithArray:@[easeOut, scaleDown]];
 [_ghostDie1 runAction:sequence];
 [_ghostDie2 runAction:sequence];
 
 [_ghostDie1 removeFromParent];
 [_ghostDie2 removeFromParent];
 }
 
 */

@end