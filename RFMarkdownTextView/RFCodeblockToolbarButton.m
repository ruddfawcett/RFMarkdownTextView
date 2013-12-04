//
//  RFCodeblockToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFCodeblockToolbarButton.h"

@implementation RFCodeblockToolbarButton

- (NSString*)titleForButton {
    return @"Codeblock";
}

- (void)buttonTarget {
    NSRange selectionRange = [RFToolbarButton textView].selectedRange;
    if ([RFToolbarButton textView].text.length == 0) {
        selectionRange.location = selectionRange.location + 3;
        [[RFToolbarButton textView] insertText:@"```\n```"];
    }
    else {
        selectionRange.location = selectionRange.location + 4;
        [[RFToolbarButton textView] insertText:@"\n```\n```"];
    }
    [RFToolbarButton textView].selectedRange = selectionRange;
}

@end
