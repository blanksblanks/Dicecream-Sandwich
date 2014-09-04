//
//  Leaderboard.m
//  Dicewich
//
//  Created by Nina Baculinao on 9/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Leaderboard.h"

@implementation Leaderboard

-(void)home {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
