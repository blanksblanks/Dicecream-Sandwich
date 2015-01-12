//
//  GameAudio.h
//  Dicewich
//
//  Created by Nina Baculinao on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAudio : NSObject

/**
 * Always access class through this singleton
 * Call it once on application start
 */

+(id) sharedHelper;

/**
 * Background music
 */

-(void) playMainTheme;
-(void) playGameTheme;

/**
 * Sound effects
 */
-(void) playPopSound;
-(void) playMoveSound;
-(void) playHitBottom;
-(void) playSuccessSound;
-(void) playLevelUpSound;
-(void) playPowerUpSound;
-(void) playGameOverSound;

/**
 * Pause/stop
 */

-(void) pauseSFX:(BOOL)condition;
-(void) pauseBG:(BOOL)condition;
-(void) stopBG;

@end
