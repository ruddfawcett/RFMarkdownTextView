//
//  RFMarkdownTextView.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/1/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
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
        self.inputAccessoryView = [RFKeyboardToolbar toolbarViewWithButtons:[self buttons]];
    }
    return self;
}



- (NSArray*)buttons {
    return @[[self createButtonWithTitle:@"#" andEventHandler:^{ [self insertText:@"#"]; }],
             [self createButtonWithTitle:@"*" andEventHandler:^{ [self insertText:@"*"]; }],
             [self createButtonWithTitle:@"_" andEventHandler:^{ [self insertText:@"_"]; }],
             [self createButtonWithTitle:@"`" andEventHandler:^{ [self insertText:@"`"]; }],
             [self createButtonWithTitle:@"@" andEventHandler:^{ [self insertText:@"@"]; }],
             [self createButtonWithTitle:@"Link" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 1;
                 [self insertText:@"[]()"];
                 self.selectedRange = selectionRange;
             }],
             [self createButtonWithTitle:@"Codeblock" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 if (self.text.length == 0) {
                     selectionRange.location += 3;
                     [self insertText:@"```\n```"];
                 }
                 else {
                     selectionRange.location += 4;
                     [self insertText:@"\n```\n```"];
                 }
                 self.selectedRange = selectionRange;
             }],
             [self createButtonWithTitle:@"Image" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 2;
                 [self insertText:@"![]()"];
                 self.selectedRange = selectionRange;
             }],
             [self createButtonWithTitle:@"Task" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 7;
                 if (self.text.length == 0) {
                     [self insertText:@"- [ ] "];
                 }
                 else {
                     [self insertText:@"\n- [ ] "];
                 }
                 self.selectedRange = selectionRange;
             }],
             [self createButtonWithTitle:@"Quote" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 3;
                 if (self.text.length == 0) {
                     [self insertText:@"> "];
                 }
                 else {
                     [self insertText:@"\n> "];
                 }
                 self.selectedRange = selectionRange;
             }]];
}

- (RFToolbarButton*)createButtonWithTitle:(NSString*)title andEventHandler:(void(^)())handler {
    RFToolbarButton *button = [RFToolbarButton buttonWithTitle:title];
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)textViewDidChange:(UITextView *)textView {
    [_syntaxStorage update];
}

@end