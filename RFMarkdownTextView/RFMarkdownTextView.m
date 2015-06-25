//
//  RFMarkdownTextView.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/1/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
//

#import "RFMarkdownTextView.h"
#import "RFMarkdownSyntaxStorage.h"

@interface RFMarkdownTextView ()

@property (strong,nonatomic) RFMarkdownSyntaxStorage *syntaxStorage;
@property (nonatomic, assign) UIEdgeInsets priorInset;

@end

@implementation RFMarkdownTextView
@synthesize imagePickerDelegate;
@synthesize priorInset;

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
    
    if (self = [super initWithFrame:frame textContainer:container]) {
        self.delegate = self;
        self.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:[self buttons]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    self.priorInset = self.contentInset;
    
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, keyboardRect.size.height, self.contentInset.right);
    self.scrollIndicatorInsets = self.contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.contentInset = priorInset;
    self.scrollIndicatorInsets = self.contentInset;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)wrapSelectedRangeWithString:(NSString *)string {
    [self wrapSelectedRangeWithStartString:string endString:string];
}

- (void)wrapSelectedRangeWithStartString:(NSString *)startString endString:(NSString *)endString {
    NSUInteger length = self.selectedRange.length;
    NSUInteger location = self.selectedRange.location;
    [self setSelectionRange:NSMakeRange(self.selectedRange.location, 0)];
    [self insertText:startString];
    NSUInteger endLocation = self.selectedRange.location + length;
    [self setSelectionRange:NSMakeRange(endLocation, 0)];
    [self insertText:endString];
    [self setSelectionRange:NSMakeRange(location + startString.length, length)];
}

- (NSArray *)buttons {
    return @[
             [self createButtonWithTitle:@"#" andEventHandler:^{ [self insertText:@"#"]; }],
             [self createButtonWithTitle:@"*" andEventHandler:^{
                 if (self.selectedRange.length > 0) {
                     [self wrapSelectedRangeWithString:@"*"];
                 } else {
                     [self insertText:@"*"];
                 }
             }],
             [self createButtonWithTitle:@"->|" andEventHandler:^{ [self insertText:@"  "]; }],
             [self createButtonWithTitle:@"[[" andEventHandler:^{
                 if (self.selectedRange.length > 0) {
                     [self wrapSelectedRangeWithStartString:@"[[" endString:@"]]"];
                     NSString *linkName = [self textInRange:self.selectedTextRange];
                     [self replaceRange:self.selectedTextRange withText:[linkName capitalizedString]];
                 } else {
                     NSRange selectionRange = self.selectedRange;
                     selectionRange.location += 2;
                     [self insertText:@"[[]]"];
                     [self setSelectionRange:selectionRange];
                 }
             }],
             [self createButtonWithTitle:@"`" andEventHandler:^{
                 if (self.selectedRange.length > 0) {
                     [self wrapSelectedRangeWithString:@"`"];
                 } else {
                     [self insertText:@"`"];
                 }
             }],
             [self createButtonWithTitle:@"Photo" andEventHandler:^{
                 ImageBlock block = ^(NSString *imagePath) {
                     NSRange selectionRange = self.selectedRange;
                     selectionRange.location += 2;
                     [self insertText:[NSString stringWithFormat:@"![](img/%@)", imagePath]];
                     [self setSelectionRange:self.selectedRange];
                 };
                 [imagePickerDelegate textViewWantsImage:self completion:block];
             }],
             [self createButtonWithTitle:@"Link" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 1;
                 [self insertText:@"[]()"];
                 [self setSelectionRange:selectionRange];
                 
             }],
             [self createButtonWithTitle:@"Quote" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 3;

                 [self insertText:self.text.length == 0 ? @"> " : @"\n> "];
                 [self setSelectionRange:selectionRange];
             }]];
}

- (void)setSelectionRange:(NSRange)range {
    UIColor *previousTint = self.tintColor;
    
    self.tintColor = UIColor.clearColor;
    self.selectedRange = range;
    self.tintColor = previousTint;
}

- (RFToolbarButton *)createButtonWithTitle:(NSString*)title andEventHandler:(void(^)())handler {
    return [RFToolbarButton buttonWithTitle:title andEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // Matches " *" and " - [ ]"
        NSString *pattern = @" *(\\*|- \\[( |x)\\]) ";
        NSError  *error = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
        
        if (range.location > 0) {
            NSRange oldRange = NSMakeRange(MAX(0, range.location - 1), range.length);
            
            // Don't match the previous line if the user is making a newline on an empty line
            if ([[self.text substringWithRange:NSMakeRange(oldRange.location, 1)] isEqualToString:@"\n"]) {
                return YES;
            }
            NSRange previousLineRange = [self.text lineRangeForRange:oldRange];
            
            NSArray *matches = [regex matchesInString:self.text options:0 range: previousLineRange];
            
            if (matches.count > 0) {
                NSString *previousPrefix = [self.text substringWithRange:[matches[0] rangeAtIndex:0]];
                [self insertText:[NSString stringWithFormat:@"\n%@", previousPrefix]];
                return NO;
            }
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [_syntaxStorage update:self.selectedRange];
}

@end
