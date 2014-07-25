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
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
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
   // [self unschedule:@selector(step)];
}

- (void)step
{
    
}






@end
