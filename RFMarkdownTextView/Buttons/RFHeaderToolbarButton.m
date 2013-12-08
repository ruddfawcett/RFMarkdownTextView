//
//  RFHeaderToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFHeaderToolbarButton.h"

@implementation RFHeaderToolbarButton

- (NSString*)titleForButton {
    return @"#";
}

- (void)buttonTarget {
    [[RFToolbarButton textView] insertText:@"#"];
}

@end
