//
//  RFLinkToolbarButton.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFLinkToolbarButton.h"

@implementation RFLinkToolbarButton

- (NSString*)titleForButton {
    return @"Link";
}

- (void)buttonTarget {
    NSRange selectionRange = [RFToolbarButton textView].selectedRange;
    selectionRange.location = selectionRange.location + 1;
    [[RFToolbarButton textView] insertText:@"[]()"];
    [RFToolbarButton textView].selectedRange = selectionRange;
}

@end
