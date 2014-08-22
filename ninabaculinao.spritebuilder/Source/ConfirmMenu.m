//
//  ConfirmMenu.m
//  Dice Wich
//
//  Created by Nina Baculinao on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ConfirmMenu.h"
#import "GameState.h"

@implementation ConfirmMenu {
    CCLabelTTF *_confirmMessage;
}

-(void)didLoadFromCCB {

}

-(void)yes {

}

-(void)no {
    [self removeFromParent];
    [GameState sharedInstance].popUp = FALSE;
}


@end
