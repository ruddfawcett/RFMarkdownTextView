//
//  RFImageToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFImageToolbarButton.h"

@implementation RFImageToolbarButton

- (NSString*)titleForButton {
    return @"Image";
}

- (void)buttonTarget {
    NSRange selectionRange = [RFToolbarButton textView].selectedRange;
    selectionRange.location = selectionRange.location + 2;
    [[RFToolbarButton textView] insertText:@"![]()"];
    [RFToolbarButton textView].selectedRange = selectionRange;
}

@end
