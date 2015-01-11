//
//  Icecream.m
//  Dicewich
//
//  Created by Nina Baculinao on 1/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Icecream.h"

@implementation Icecream

- (void) spinAway {
    [self performSelector:@selector(spin) withObject:nil afterDelay:0];
}

- (void)spin {
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = self.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"spinAway"];
}

@end
