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
    
// TODO: Add _ to var names here and in SB
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
            [self scheduleBlock:^(CCTimer *timer) {
                [self clearDie1:die1a andDie2:die1b];
                [self respawn1];
            } delay:1.00];
            break;
        }
        case 1: {
            _help2.visible = false;
            _help3.visible = true;
            [self showInnerDice];
            [self scheduleBlock:^(CCTimer *timer) {
                [self clearDie1:die6a andDie2:die6h];
                [self respawn2];
            } delay:1.00];
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

-(void)clearDie1:(Dice*)die1 andDie2:(Dice*)die2{
    [self playSuccessSound];
    CCAnimationManager* animationManager = die1.animationManager;
    CCAnimationManager* animationManager2 = die2.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"colorFill"];
    [animationManager2 runAnimationsForSequenceNamed:@"colorFill"];
//    CCParticleSystem *explosion1 = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
//    CCParticleSystem *explosion2 = (CCParticleSystem *)[CCBReader load:@"Sparkle"];
//    explosion1.autoRemoveOnFinish = TRUE;
//    explosion2.autoRemoveOnFinish = TRUE;
//    explosion1.position = die1.position;
//    explosion2.position = die2.position;
//    [self addChild:explosion1];
//    [self addChild:explosion2];
    [self scheduleBlock:^(CCTimer *timer) {
        die1.visible = false;
        die2.visible = false;
        [self hideInnerDice];
    } delay:1.00];
}

-(void)hideInnerDice {
        die3.visible = false;
        die6b.visible = false;
        die6c.visible = false;
        die6d.visible = false;
        die6e.visible = false;
        die6f.visible = false;
        die6g.visible = false;
}

-(void)showInnerDice {
    die6b.visible = true;
    die6c.visible = true;
    die6d.visible = true;
    die6e.visible = true;
    die6f.visible = true;
    die6g.visible = true;
}

-(void)respawn1 {
    [self scheduleBlock:^(CCTimer *timer) {
        CCAnimationManager* animationManager = die1a.animationManager;
        CCAnimationManager* animationManager2 = die1b.animationManager;
        [animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
        [animationManager2 runAnimationsForSequenceNamed:@"Default Timeline"];
        die1a.visible = true;
        die3.visible = true;
        die1b.visible = true;
    } delay:2.00];
}

-(void)respawn2 {
    [self scheduleBlock:^(CCTimer *timer) {
        CCAnimationManager* animationManager = die6a.animationManager;
        CCAnimationManager* animationManager2 = die6h.animationManager;
        [animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
        [animationManager2 runAnimationsForSequenceNamed:@"Default Timeline"];
        die6a.visible = true;
        die6b.visible = true;
        die6c.visible = true;
        die6d.visible = true;
        die6e.visible = true;
        die6f.visible = true;
        die6g.visible = true;
        die6h.visible = true;
    } delay:2.00];
}

@end