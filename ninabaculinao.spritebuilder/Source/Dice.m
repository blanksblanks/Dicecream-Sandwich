//
//  Dice.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Dice.h"
#import "CCAnimationManager.h"

@implementation Dice

- (instancetype)initDice {
    self = [super init];
    if (self) {
        CCLOG(@"Die created");
        [self performSelector:@selector(randomizeNumbers)];
        //[self randomizeNumbers];
    }
    return self;
}

-(void) randomizeNumbers {
//    CCAnimationManager* animationManager = self.userObject;
    int random = arc4random_uniform(5)+1;
    switch(random)
    {
        case 1:
            [[self animationManager] runAnimationsForSequenceNamed:@"One"];
            CCLOG(@"Face: 1");
            break;
        case 2:
            [[self animationManager]runAnimationsForSequenceNamed:@"Two"];
            CCLOG(@"Face: 2");
            break;
        case 3:
            [[self animationManager]runAnimationsForSequenceNamed:@"Three"];
            CCLOG(@"Face: 3");
            break;
        case 4:
            [[self animationManager] runAnimationsForSequenceNamed:@"Four"];
            CCLOG(@"Face: 4");
            break;
        case 5:
            [[self animationManager] runAnimationsForSequenceNamed:@"Five"];
            CCLOG(@"Face: 5");
            break;
        case 6:
            [[self animationManager] runAnimationsForSequenceNamed:@"Six"];
            CCLOG(@"Face: 6");
            break;
        default:
            CCLOG(@"WHY IS IT AT DEFAULT");
            break;
    }
}

@end
