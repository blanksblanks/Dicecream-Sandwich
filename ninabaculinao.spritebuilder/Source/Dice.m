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
    return self;
}

+ (Dice*) makeNewDie {
    Dice *die;
    int random = arc4random_uniform(6)+1;
    switch(random)
    {
        case 1:
            die = (Dice*) [CCBReader load:@"Dice/One"];
            die.faceValue = 1;
            break;
        case 2:
            die = (Dice*) [CCBReader load:@"Dice/Two"];
            die.faceValue = 2;
            break;
        case 3:
            die = (Dice*) [CCBReader load:@"Dice/Three"];
            die.faceValue = 3;
            break;
        case 4:
            die = (Dice*) [CCBReader load:@"Dice/Four"];
            die.faceValue = 4;
            break;
        case 5:
            die = (Dice*) [CCBReader load:@"Dice/Five"];
            die.faceValue = 5;
            break;
        case 6:
            die = (Dice*) [CCBReader load:@"Dice/Six"];
            die.faceValue = 6;
            break;
        default:
            CCLOG(@"WHY IS IT AT DEFAULT");
            break;
    }
    CCLOG(@"Face value: %d", die.faceValue);
    return die;
}

-(void) stepGravity:(CCTime)dt
{
    //    CGSize screenSize = [[CCDirector sharedDirector] screenSize];
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    
    if (self.position.y > (screenSize.height - [self contentSize].height/2)) {
        self.velocity = ccp(0, -30.f);
    } else {
        if (self.velocity.y == 0.f) {
            self.velocity = ccp(0, -50.f);
        } else {
            // magic number allows for smooth acceleration dependent on dt
            self.velocity = ccp(0, self.velocity.y * 63.42f * dt);
        }
    }
}

-(void) desiredPositionFromVelocity:(CCTime)dt
{
    CGPoint minMovement = ccp(-120.0, -450.0);
    CGPoint maxMovement = ccp(120.0, 450.0);
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}

-(void) update:(CCTime)delta
{
    [self stepGravity:delta];
    [self desiredPositionFromVelocity:delta];
}

-(CGRect) collisionBox
{
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(self.boundingBox, diff.x, diff.y);
    return returnBoundingBox;
}

@end
