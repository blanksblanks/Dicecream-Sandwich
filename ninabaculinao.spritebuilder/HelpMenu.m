//
//  HelpMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HelpMenu.h"
#import "Dice.h"
#import "GameState.h"


@implementation HelpMenu {
    NSInteger step;
    CCNode *_help1;
    CCNode *_help2;
    CCNode *_help3;
    
    Dice *die1a;
    Dice *die3;
    Dice *die1b;
    Dice *die6a;
    Dice *die6b;
    Dice *die6c;
    Dice *die6d;
    Dice *die6e;
    Dice *die6f;
    Dice *die6g;
    Dice *die6h;
    
    OALSimpleAudio *audio;
}

-(void)didLoadFromCCB {
    step = 0;
    _help1.visible = true;
    _help2.visible = false;
    _help3.visible = false;
    audio = [OALSimpleAudio sharedInstance];
    
}

-(void)next {

    [self playPopSound];
    
    switch (step) {
        case 0: {
            _help1.visible = false;
            _help2.visible = true;
            [self clearDie:die1a];
            [self clearDie:die1b];
            break;
        }
        case 1: {
            _help2.visible = false;
            _help3.visible = true;
            [self clearDie:die6a];
            [self clearDie:die6h];
            break;
        }
        case 2: {
            [self removeFromParent];
            [GameState sharedInstance].popUp = FALSE;
            break;
        }
    }
    step++;
}

-(void)cancel {
    [self removeFromParent];
    [GameState sharedInstance].popUp = FALSE;
    
//    if (!_help3.visible) {
        [self playPopSound];
//    }
}

-(void)playPopSound {
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];
}

-(void)playSuccessSound {
    [audio preloadEffect:@"success.wav"];
    [audio playEffect:@"success.wav"];
}

-(void)clearDie:(Dice*)die{
    [self playSuccessSound];
    CCAnimationManager* animationManager = die.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"colorFill"];
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = die.position;
    [self addChild:explosion];
    [self scheduleBlock:^(CCTimer *timer) {
        die.visible = false;
    } delay:0.20];
    
    [self scheduleBlock:^(CCTimer *timer) {
        die.visible = true;
    } delay:0.20];

}

@end