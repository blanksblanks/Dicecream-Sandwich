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
#import <OALSimpleAudio.h>

//#define convertTime(time) (time / 60)

@implementation Gameplay {
    OALSimpleAudio *audio;
    Grid *_grid;
    CCSprite *_rainbowBright;
    BOOL rainbowPastel;
    CCAnimationManager* animationManager;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_targetLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_matchLabel;
}

- (id)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = TRUE;
        // access audio object
        audio = [OALSimpleAudio sharedInstance];
        // play background sound
        [audio playBg:@"CATchy.wav" loop:TRUE];
         _timeLabel.string = [NSString stringWithFormat:@"%li", (long)_grid.timer];
  
    }
    
    return self;
}

- (void)didLoadFromCCB {
    
    animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"rainbowPastel"];
    rainbowPastel = true;
    
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"match" options:0 context:NULL];
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
    if ([keyPath isEqualToString:@"match"]) {
        _matchLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.match];
    }
    if ([keyPath isEqualToString:@"targetScore"]) {
        _targetLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.targetScore];
    }
    if ([keyPath isEqualToString:@"level"]) {
        _levelLabel.string = [NSString stringWithFormat:@"%li", (long) _grid.level];
        if (_grid.level > 1) {
            [animationManager runAnimationsForSequenceNamed:@"levelPulse"];
            if (rainbowPastel) {
                _rainbowBright.visible = true;
                rainbowPastel = false;
            } else {
                [animationManager runAnimationsForSequenceNamed:@"rainbowPastel"];
                _rainbowBright.visible = false;
                rainbowPastel = true;
            }
        }
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"match"];
    [_grid removeObserver:self forKeyPath:@"targetScore"];
    [_grid removeObserver:self forKeyPath:@"level"];
}

- (void)update:(CCTime)delta {
    
    [self convertAndUpdateTime];
    
    if (_grid.touchEnabled) {
        self.userInteractionEnabled = TRUE;
    } else {
        self.userInteractionEnabled = FALSE;
    }
}

- (void)convertAndUpdateTime {
    NSInteger seconds = (long)_grid.timer,
    forHours = seconds / 3600,
    remainder = seconds % 3600,
    forMinutes = remainder / 60,
    forSeconds = remainder % 60;
    
    NSString *hh = [self checkIfLeadingZeroNeeded:forHours];
    NSString *mm = [self checkIfLeadingZeroNeeded:forMinutes];
    NSString *ss = [self checkIfLeadingZeroNeeded:forSeconds];
    _timeLabel.string = [NSString stringWithFormat:@"%@ : %@ : %@", hh, mm, ss];
}

- (NSString*)checkIfLeadingZeroNeeded:(NSInteger)time {
    NSString *digits;
    if (time < 10) {
        digits = [NSString stringWithFormat:@"0%li", (long)time];
    } else {
        digits = [NSString stringWithFormat:@"%li", (long)time];
    }
    return digits;
}

- (void)pause {
    PauseMenu *pauseMenu = (PauseMenu*) [CCBReader load:@"PauseMenu"];
    audio.paused = TRUE;
    pauseMenu.position = ccp(51, 25);
    [self addChild:pauseMenu];
    [_grid pause];
    
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.05f];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:ccp(296, 25)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, moveTo]];
    [pauseMenu runAction:sequence];

    pauseMenu.grid = _grid;
    pauseMenu.audio = audio;
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchBegan:touch withEvent:event];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchMoved:touch withEvent:event];
    }
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    if (_grid.touchEnabled) {
        [_grid touchEnded:touch withEvent:event];
    }
}






@end
