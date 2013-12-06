//
//  RFMarkdownTextView.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/1/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFMarkdownTextView.h"

@implementation RFMarkdownTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [RFKeyboardToolbar addToTextView:self withButtons:[self buttons]];
    }
    return self;
}

- (NSArray*)buttons {
    RFHeaderToolbarButton *headerButton = [RFHeaderToolbarButton new];
    RFAsteriskToolbarButton *asteriskButton = [RFAsteriskToolbarButton new];
    RFUnderscoreToolbarButton *underscoreButton = [RFUnderscoreToolbarButton new];
    RFCodeToolbarButton *codeButton = [RFCodeToolbarButton new];
    RFAtToolbarButton *atButton = [RFAtToolbarButton new];
    RFLinkToolbarButton *linkButton = [RFLinkToolbarButton new];
    RFCodeblockToolbarButton *codeblockButton = [RFCodeblockToolbarButton new];
    RFImageToolbarButton *imageButton = [RFImageToolbarButton new];
    RFTaskToolbarButton *taskButton = [RFTaskToolbarButton new];
    RFQuoteToolbarButton *quoteButton = [RFQuoteToolbarButton new];
    
    return @[headerButton,asteriskButton,underscoreButton,codeButton,atButton,linkButton,codeblockButton,imageButton, taskButton, quoteButton];
}

@end