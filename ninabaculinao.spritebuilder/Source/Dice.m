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
    int block = arc4random_uniform(6);
    Dice *die;
    switch(block)
    {
        case 0:
            die = (Dice*) [CCBReader load:@"Dice/One"];
            break;
        case 1:
            die = (Dice*) [CCBReader load:@"Dice/Two"];
            break;
        case 2:
            die = (Dice*) [CCBReader load:@"Dice/Three"];
            break;
        case 3:
            die = (Dice*) [CCBReader load:@"Dice/Four"];
            break;
        case 4:
            die = (Dice*) [CCBReader load:@"Dice/Five"];
            break;
        case 5:
            die = (Dice*) [CCBReader load:@"Dice/Six"];
            break;
        default:
            CCLOG(@"WHY IS IT AT DEFAULT");
            break;

    }
    return die;
}

//int main (int argc, const char * argv[])
//{
//    //  my int values
//    int valueOne = arc4random()%6+1;
//    int valueTwo = arc4random()%6+1;
//    
//    //  Wrapped into objects to add to my array
//    NSNumber* diceOne = [NSNumber numberWithInt:valueOne];
//    NSNumber* diceTwo = [NSNumber numberWithInt:valueTwo];
//    
//    //  my array called "myDice"
//    NSMutableArray* myDice = [[NSMutableArray alloc] initWithCapacity:6];
//    
//    //  add the objects
//    [myDice addObject:diceOne];
//    [myDice addObject:diceTwo];
//    
//    //  Sorting my array
//    int i;
//    NSNumber *myObject;
//    
//    for(i=0;i<[myDice count];i++)
//    {
//        myObject = [myDice objectAtIndex:i];
//        NSLog(@"\n\nyour die %d is %@.",i+1, myObject);
//    }
//    
//    
//    return 0;
//    
//}


@end
