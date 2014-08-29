//
//  Credits.m
//  Dicecream Sandwich
//
//  Created by Nina Baculinao on 8/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Credits.h"
#import "MainScene.h"

@implementation Credits

-(void) home {
    
    OALSimpleAudio* audio = [OALSimpleAudio sharedInstance];
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];
    
    [[CCDirector sharedDirector] popScene];
}

@end
