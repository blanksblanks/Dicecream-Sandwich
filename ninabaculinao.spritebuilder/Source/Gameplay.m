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
#import "PauseMenu.h"
#import "GameState.h"
#import "GameAudio.h"

//#define convertTime(time) (time / 60)

@implementation Gameplay {
    OALSimpleAudio *audio;
    Grid *_grid;
//    CCSprite *_rainbowBright;
    CCAnimationManager* animationManager;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_target;
    CCLabelTTF *_targetLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_timeLabel;
    CCButton *_pauseButton;
}

- (id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

- (void)didLoadFromCCB {
    
    animationManager = self.animationManager;
    if (![GameState sharedInstance].musicPaused){
        [[GameAudio sharedHelper] playGameTheme];
    }
    [GameState sharedInstance].newHighScore = false;
    
    _timeLabel.string = [NSString stringWithFormat:@"%li", (long)_grid.timer];
//    _targetLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.targetScore];
    _levelLabel.string = [NSString stringWithFormat:@"%li", (long) [GameState sharedInstance].levelSelected];
    
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"targetScore" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"level" options:0 context:NULL];
    [_grid loadLevel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.score];
        [animationManager runAnimationsForSequenceNamed:@"scorePulse"];
    }
    if ([keyPath isEqualToString:@"targetScore"]) {
            _targetLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.targetScore];
    }
    if ([keyPath isEqualToString:@"level"]) {
        _levelLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.level];
        if (_grid.timer > 1) {
            [animationManager runAnimationsForSequenceNamed:@"levelPulse"];
        }
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"targetScore"];
    [_grid removeObserver:self forKeyPath:@"level"];
}

- (void)update:(CCTime)delta {

    _timeLabel.string = [Gameplay convertAndUpdateTime:_grid.timer];
    
    if (_grid.touchEnabled) {
        self.userInteractionEnabled = TRUE;
    } else {
        self.userInteractionEnabled = FALSE;
    }
    
    if (_grid.paused) {
        _pauseButton.visible = false;
    } else {
        _pauseButton.visible = true;
    }
    
    
    
//    if ([GameState sharedInstance].musicPaused || _grid.paused) {
//        [[GameAudio sharedHelper] pauseBG:true];
//    } else {
//        [[GameAudio sharedHelper] pauseBG:false];
//    }
    
////    [[GameAudio sharedHelper] pauseBG:([GameState sharedInstance].musicPaused || _grid.paused)];
    BOOL musicPaused = ([GameState sharedInstance].musicPaused || _grid.paused);
    [[GameAudio sharedHelper] pauseBG:musicPaused];
    [[GameAudio sharedHelper] pauseSFX:[GameState sharedInstance].sfxPaused];
    
    if (_grid.level == 20) { // goes into endless mode
        _target.visible = false;
        _targetLabel.visible = false; 
    }
    
}

+ (NSString*)convertAndUpdateTime:(NSInteger)seconds {
    NSInteger forHours = seconds / 3600,
    remainder = seconds % 3600,
    forMinutes = remainder / 60,
    forSeconds = remainder % 60;
    
    NSString *hh = [self checkIfLeadingZeroNeeded:forHours];
    NSString *mm = [self checkIfLeadingZeroNeeded:forMinutes];
    NSString *ss = [self checkIfLeadingZeroNeeded:forSeconds];
    NSString *timeString = [NSString stringWithFormat:@"%@ : %@ : %@", hh, mm, ss];
    return timeString;
}

+ (NSString*)checkIfLeadingZeroNeeded:(NSInteger)time {
    NSString *digits;
    if (time < 10) {
        digits = [NSString stringWithFormat:@"0%li", (long)time];
    } else {
        digits = [NSString stringWithFormat:@"%li", (long)time];
    }
    return digits;
}

- (void)pause {
    [MGWU logEvent:@"pause_pressed_in_gameplay" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    
    PauseMenu *pauseMenu = (PauseMenu*) [CCBReader load:@"PauseMenu"];
    pauseMenu.position = ccp(51, 25);
    [self addChild:pauseMenu];
    [_grid pause];
    
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.05f];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:ccp(296, 25)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, moveTo]];
    [pauseMenu runAction:sequence];

    pauseMenu.grid = _grid;
}


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchBegan:touch withEvent:event];
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchMoved:touch withEvent:event];
    }
}

- (void)touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchEnded:touch withEvent:event];
    }
}






@end
