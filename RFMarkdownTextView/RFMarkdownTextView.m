//
//  RFMarkdownTextView.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/1/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFMarkdownTextView.h"

@interface RFMarkdownTextView ()

@property (strong,nonatomic) RFMarkdownSyntaxStorage *syntaxStorage;

@end

@implementation RFMarkdownTextView

- (id)initWithFrame:(CGRect)frame {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    
    _syntaxStorage = [RFMarkdownSyntaxStorage new];
    [_syntaxStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = frame;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    
    [layoutManager addTextContainer:container];
    [_syntaxStorage addLayoutManager:layoutManager];
    
    self = [super initWithFrame:frame textContainer:container];
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

- (void)textViewDidChange:(UITextView *)textView {
    [_syntaxStorage update];
}

@end