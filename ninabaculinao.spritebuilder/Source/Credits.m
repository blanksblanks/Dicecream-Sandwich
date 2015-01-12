//
//  Credits.m
//  Dicecream Sandwich
//
//  Created by Nina Baculinao on 8/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Credits.h"
#import "GameAudio.h"

@implementation Credits

-(void) home {    
    [[GameAudio sharedHelper] playPopSound];
    [[CCDirector sharedDirector] popScene];
}

@end
