//
//  Dice.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Dice.h"

@implementation Dice

- (instancetype)initDice {
    self = [super init];
    if (self) {
        CCLOG(@"Die created");
        [self performSelector:@selector(randomizeValues)];
        //[self randomizeValues];
    }
    return self;
}

-(void) randomizeValues {
    CCAnimationManager* animationManager = self.animationManager;
    int random = arc4random_uniform(5)+1;
    switch(random)
    {
        case 1:
            [animationManager runAnimationsForSequenceNamed:@"One"];
            break;
        case 2:
            [animationManager runAnimationsForSequenceNamed:@"Two"];
            break;
        case 3:
            [animationManager runAnimationsForSequenceNamed:@"Three"];
            break;
        case 4:
            [animationManager runAnimationsForSequenceNamed:@"Four"];
            break;
        case 5:
            [animationManager runAnimationsForSequenceNamed:@"Five"];
            break;
        case 6:
            [animationManager runAnimationsForSequenceNamed:@"Six"];
            break;
        default:
            CCLOG(@"WHY IS IT AT DEFAULT");
            break;
    }
}

@end
