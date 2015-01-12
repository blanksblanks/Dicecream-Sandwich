//
//  GameAudio.m
//  Dicewich
//
//  Created by Nina Baculinao on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameAudio.h"
#import "GameState.h"

@implementation GameAudio {
    OALSimpleAudio *audio;
}

+(id) sharedHelper {
    static GameAudio *sharedHelper = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{sharedHelper = [[self alloc] init];});
    return sharedHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        audio = [OALSimpleAudio sharedInstance];
    }
    return self;
}

/**
 * Background music
 */

-(void) playMainTheme {
    [audio playBg:@"Afterglow.wav" volume:0.8 pan:0.0 loop:TRUE];
}

-(void) playGameTheme {
    [audio playBg:@"CATchy.wav" volume:0.8 pan:0.0 loop:TRUE];
}

/**
 * Sound effects
 */
- (void)playPopSound {
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];
}

- (void)playMoveSound {
    [audio preloadEffect:@"click2.wav"];
    [audio playEffect:@"click2.wav"];
}

- (void) playHitBottom {
    [audio preloadEffect:@"pop5.wav"];
    [audio playEffect:@"pop5.wav"];
}

- (void)playSuccessSound {
    [audio preloadEffect:@"success.wav"];
    [audio playEffect:@"success.wav"];
}

- (void)playPowerUpSound {
    [audio preloadEffect:@"powerUp.wav"];
    [audio playEffect:@"powerUp.wav"];
}

-(void) playLevelUpSound {
    [audio preloadEffect:@"levelUp.wav"];
    [audio playEffect:@"levelUp.wav"];
}


- (void) playGameOverSound {
    [audio preloadEffect:@"oneBlastWhistle.wav"];
    [audio playEffect:@"oneBlastWhistle.wav"];
}

/**
 * Pause/stop
 */

-(void) checkSFX {
    audio.effectsPaused = [GameState sharedInstance].sfxPaused;
}

-(void) checkBGM {
    audio.bgPaused = [GameState sharedInstance].musicPaused;
}

-(void) stopBGM {
    [audio stopBg];
}



@end
