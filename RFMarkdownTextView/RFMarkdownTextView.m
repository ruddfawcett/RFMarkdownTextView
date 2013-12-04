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

- (IBAction)eachButtonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self insertText:@"#"];
            break;
        case 1:
            [self insertText:@"*"];
            break;
        case 2:
            [self insertText:@"_"];
            break;
        case 3:
            [self insertText:@"`"];
            break;
        case 4:
            [self insertText:@"@"];
            break;
        case 5: {
            NSRange selectionRange = self.selectedRange;
            selectionRange.location = selectionRange.location + 1;
            [self insertText:@"[]()"];
            self.selectedRange = selectionRange;
        }
            break;
        case 6:{
            NSRange selectionRange = self.selectedRange;
            if (self.text.length == 0) {
                selectionRange.location = selectionRange.location + 3;
                [self insertText:@"```\n```"];
            }
            else {
                selectionRange.location = selectionRange.location + 4;
                [self insertText:@"\n```\n```"];
            }
            self.selectedRange = selectionRange;
        }
            break;
        case 7:{
            NSRange selectionRange = self.selectedRange;
            selectionRange.location = selectionRange.location + 2;
            [self insertText:@"![]()"];
            self.selectedRange = selectionRange;
        }
            break;
        case 8:{
            NSRange selectionRange = self.selectedRange;
            selectionRange.location = selectionRange.location + 7;
            if (self.text.length == 0) {
                [self insertText:@"- [ ] "];
            }
            else {
                [self insertText:@"\n- [ ] "];
            }
            self.selectedRange = selectionRange;
        }
            break;
        case 9:{
            NSRange selectionRange = self.selectedRange;
            selectionRange.location = selectionRange.location + 3;
            if (self.text.length == 0) {
                [self insertText:@"> "];
            }
            else {
                [self insertText:@"\n> "];
            }
            self.selectedRange = selectionRange;
        }
            break;
            
        default:
            break;
    }
}

@end