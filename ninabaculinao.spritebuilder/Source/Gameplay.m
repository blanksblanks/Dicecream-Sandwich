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
#import <OALSimpleAudio.h>


@implementation Gameplay {
    Grid *_grid;
    CCLabelTTF *_scoreLabel;
    CCLabelBMFont *_timeLabel;
    CCLabelTTF *_matchLabel;
}

- (id)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = TRUE;
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play background sound
        [audio playBg:@"CATchy.wav" loop:TRUE];
         _timeLabel.string = [NSString stringWithFormat:@"%ld", (long)_grid.timer];
  
    }
    
    return self;
}

- (void)didLoadFromCCB {
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"match" options:0 context:NULL];
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
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"match"];
}

- (void)update:(CCTime)delta {
    _timeLabel.string = [NSString stringWithFormat:@"%ld", (long)_grid.timer];
}

- (void)play
{
    // this tells the game to call a method called 'step' every half sec
   // [self schedule:@selector(step) interval:0.5f];
}

- (void)pause
{
    CCScene *pause = [CCBReader loadAsScene:@"Pause"];
    [[CCDirector sharedDirector] pushScene:pause];
}

- (void)step
{
    
}






@end
