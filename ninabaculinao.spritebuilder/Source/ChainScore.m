//
//  ChainScore.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ChainScore.h"

@implementation ChainScore {
    CCLabelTTF *_chainScoreLabel;
}

- (void) onEnter {
    _chainScoreLabel.string = self.scoreString;
    [super onEnter];
}

@end
