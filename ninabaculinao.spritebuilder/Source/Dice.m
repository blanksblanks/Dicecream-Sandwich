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
//        self.faceValue = arc4random_uniform(5)+1;
//        switch(self.faceValue)
//        {
//            case 1:
//                self = (Dice*) [CCBReader load:@"Dice/One"];
//                CCLOG(@"Face: 1");
//                break;
//            case 2:
//                self = (Dice*) [CCBReader load:@"Dice/Two"];
//                CCLOG(@"Face: 2");
//                break;
//            case 3:
//                self = (Dice*) [CCBReader load:@"Dice/Three"];
//                CCLOG(@"Face: 3");
//                break;
//            case 4:
//                self = (Dice*) [CCBReader load:@"Dice/Four"];
//                CCLOG(@"Face: 4");
//                break;
//            case 5:
//                self = (Dice*) [CCBReader load:@"Dice/Five"];
//                CCLOG(@"Face: 5");
//                break;
//            case 6:
//                self = (Dice*) [CCBReader load:@"Dice/Six"];
//                CCLOG(@"Face: 6");
//                break;
//            default:
//                self = (Dice*) [CCBReader load:@"Dice/Dice"];
//                CCLOG(@"WHY IS IT AT DEFAULT");
//                break;
//        }

    }
    return self;
}


@end
