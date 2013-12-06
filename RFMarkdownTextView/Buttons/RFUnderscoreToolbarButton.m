//
//  RFUnderscoreToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFUnderscoreToolbarButton.h"

@implementation RFUnderscoreToolbarButton

- (NSString*)titleForButton {
    return @"_";
}

- (void)buttonTarget {
    [[RFToolbarButton textView] insertText:@"_"];
}

@end
