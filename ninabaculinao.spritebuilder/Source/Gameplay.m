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
}

- (id)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = TRUE;
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play background sound
        [audio playBg:@"CATchy.wav" loop:TRUE];
  
    }
    
    return self;
}

- (void)play
{
    // this tells the game to call a method called 'step' every half sec
    [self schedule:@selector(step) interval:0.5f];
}

- (void)pause
{
    [self unschedule:@selector(step)];
}

- (void)step
{
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_grid.score];
    [_grid spawnDice];
}






@end
