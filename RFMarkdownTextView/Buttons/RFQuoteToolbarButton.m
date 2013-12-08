//
//  RFQuoteToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFQuoteToolbarButton.h"

@implementation RFQuoteToolbarButton

- (NSString*)titleForButton {
    return @"Quote";
}

- (void)buttonTarget {
    NSRange selectionRange = [RFToolbarButton textView].selectedRange;
    selectionRange.location = selectionRange.location + 3;
    if ([RFToolbarButton textView].text.length == 0) {
        [[RFToolbarButton textView] insertText:@"> "];
    }
    else {
        [[RFToolbarButton textView] insertText:@"\n> "];
    }
    [RFToolbarButton textView].selectedRange = selectionRange;
}

@end
