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


@implementation Gameplay {
    OALSimpleAudio *audio;
    Grid *_grid;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_targetLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_matchLabel;
    
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    NSString *s;
    NSString *m;
    NSString *h;
}

- (id)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = TRUE;
        // access audio object
        audio = [OALSimpleAudio sharedInstance];
        // play background sound
        [audio playBg:@"CATchy.wav" loop:TRUE];
         _timeLabel.string = [NSString stringWithFormat:@"%ld", (long)_grid.timer];
  
    }
    
    return self;
}

- (void)didLoadFromCCB {
    seconds = 0;
    minutes = 0;
    hours = 0;
    
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
        _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long) _grid.score];
    }
    if ([keyPath isEqualToString:@"match"]) {
        _matchLabel.string = [NSString stringWithFormat:@"%ld", (long) _grid.match];
    }
    if ([keyPath isEqualToString:@"targetScore"]) {
        _targetLabel.string = [NSString stringWithFormat:@"%ld", (long) _grid.targetScore];
    }
    if ([keyPath isEqualToString:@"level"]) {
        _levelLabel.string = [NSString stringWithFormat:@"%ld", (long) _grid.level];
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"match"];
    [_grid removeObserver:self forKeyPath:@"targetScore"];
    [_grid removeObserver:self forKeyPath:@"level"];
}

- (void)update:(CCTime)delta {
    
    //Calculate time
    seconds = (long)_grid.timer%60;
    minutes = (long)(_grid.timer - seconds)/60;

//    if (seconds < 10) {
//        h = [NSString stringWithFormat:@("0%ld", (long)seconds)];
//    } else {
//        h = [NSString stringWithformat:@("%ld", (long)seconds)];
//    }
//    _timeLabel.string = [NSString stringWithFormat:@"%ld : %ld : %ld", (long)hours, (long)minutes, (long)seconds];

    if (_grid.touchEnabled) {
        self.userInteractionEnabled = TRUE;
    } else {
        self.userInteractionEnabled = FALSE;
    }
}

- (void)pause {
    PauseMenu *pauseMenu = (PauseMenu*) [CCBReader load:@"PauseMenu"];
//    [pauseMenu setPositionType:CCPositionTypeNormalized];

    audio.paused = TRUE;
    pauseMenu.position = ccp(0, 25);
    [self addChild:pauseMenu];
    [_grid pause];
    
    pauseMenu.grid = _grid;
    pauseMenu.audio = audio;
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_grid touchBegan:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [_grid touchMoved:touch withEvent:event];
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    [_grid touchEnded:touch withEvent:event];
}






@end
