//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
}

- (void)play {
    CCLOG(@"play button pressed");
    [self performSelector:@selector(clearDicecream)];
    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    } delay:1.5];
}

- (void)clearDicecream
{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"clearDicecream"];
}


@end
