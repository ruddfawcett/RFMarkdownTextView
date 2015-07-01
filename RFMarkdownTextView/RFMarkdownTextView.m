//
//  RFMarkdownTextView.m
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/1/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
//

#import "RFMarkdownTextView.h"
#import "RFMarkdownSyntaxStorage.h"

@interface RFMarkdownTextView_DelegateProxy : NSProxy<UITextViewDelegate>

@property (nonatomic,weak) id<UITextViewDelegate> delegateTarget;

@end


@interface RFMarkdownTextView () {
    RFMarkdownTextView_DelegateProxy* _delegateProxy;
}

@property (strong,nonatomic) RFMarkdownSyntaxStorage *syntaxStorage;
@property (nonatomic, assign) UIEdgeInsets priorInset;

@end

// ---

@implementation RFMarkdownTextView
@synthesize imagePickerDelegate;
@synthesize priorInset;

- (id)initWithFrame:(CGRect)frame {
    
    _syntaxStorage = [RFMarkdownSyntaxStorage new];
    
    CGRect newTextViewRect = frame;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    
    [layoutManager addTextContainer:container];
    [_syntaxStorage addLayoutManager:layoutManager];
    
    if (self = [super initWithFrame:frame textContainer:container]) {
        _delegateProxy = [RFMarkdownTextView_DelegateProxy alloc];
        [super setDelegate:_delegateProxy];
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
    RFMarkdownTextView __weak* weakSelf = self;
    return @[
             [self createButtonWithTitle:@"#" andEventHandler:^{ [weakSelf insertText:@"#"]; }],
             [self createButtonWithTitle:@"*" andEventHandler:^{
                if(!weakSelf) {
                    return;
                }
                 if (weakSelf.selectedRange.length > 0) {
                     [weakSelf wrapSelectedRangeWithString:@"*"];
                 } else {
                     [weakSelf insertText:@"*"];
                 }
             }],
             [self createButtonWithTitle:@"->|" andEventHandler:^{ [weakSelf insertText:@"  "]; }],
             [self createButtonWithTitle:@"[[" andEventHandler:^{                
                 if(!weakSelf) {
                     return;
                 }
                 if (weakSelf.selectedRange.length > 0) {
                     [weakSelf wrapSelectedRangeWithStartString:@"[[" endString:@"]]"];
                     NSString *linkName = [weakSelf textInRange:weakSelf.selectedTextRange];
                     [weakSelf replaceRange:weakSelf.selectedTextRange withText:[linkName capitalizedString]];
                 } else {
                     NSRange selectionRange = weakSelf.selectedRange;
                     selectionRange.location += 2;
                     [weakSelf insertText:@"[[]]"];
                     [weakSelf setSelectionRange:selectionRange];
                 }
             }],
             [self createButtonWithTitle:@"`" andEventHandler:^{
                 if(!weakSelf) {
                     return;
                 }
                 if (weakSelf.selectedRange.length > 0) {
                     [weakSelf wrapSelectedRangeWithString:@"`"];
                 } else {
                     [weakSelf insertText:@"`"];
                 }
             }],
             [self createButtonWithTitle:@"Photo" andEventHandler:^{
                 if(!weakSelf) {
                     return;
                 }
                 ImageBlock block = ^(NSString *imagePath) {
                     NSRange selectionRange = weakSelf.selectedRange;
                     selectionRange.location += 2;
                     [weakSelf insertText:[NSString stringWithFormat:@"![](img/%@)", imagePath]];
                     [weakSelf setSelectionRange:weakSelf.selectedRange];
                 };
                 [weakSelf.imagePickerDelegate textViewWantsImage:weakSelf completion:block];
             }],
             [self createButtonWithTitle:@"Link" andEventHandler:^{
                 if(!weakSelf) {
                     return;
                 }
                 NSRange selectionRange = weakSelf.selectedRange;
                 selectionRange.location += 1;
                 [weakSelf insertText:@"[]()"];
                 [weakSelf setSelectionRange:selectionRange];
                 
             }],
             [self createButtonWithTitle:@"Quote" andEventHandler:^{
                 if(!weakSelf) {
                     return;
                 }
                 NSRange selectionRange = weakSelf.selectedRange;
                 selectionRange.location += 3;

                 [weakSelf insertText:weakSelf.text.length == 0 ? @"> " : @"\n> "];
                 [weakSelf setSelectionRange:selectionRange];
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

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!self.inputAccessoryView) {
        self.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:[self buttons]];
    }
}

#pragma mark Property Access

-(void)setDelegate:(id<UITextViewDelegate> __nullable)delegate {
    _delegateProxy.delegateTarget = delegate;
}

@end

@implementation RFMarkdownTextView_DelegateProxy

@synthesize delegateTarget = _delegateTarget;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL (^forwardCurrentInvocation)() =  ^{
        id<UITextViewDelegate> target = self.delegateTarget;
        if ([target respondsToSelector:_cmd]) {
            return [target textView:textView shouldChangeTextInRange:range replacementText:text];
        }
        return YES;
    };
    if ([text isEqualToString:@"\n"]) {
        static NSRegularExpression* regex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // Matches " *" and " - [ ]"
            NSString *pattern = @" *(\\*|- \\[( |x)\\]) ";
            NSError  *error = nil;
            regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
            if (error) {
                NSLog(@"Error parsing regex '%@' error: %@'",pattern,error);
            }
        });
        
        if (range.location > 0) {
            NSRange oldRange = NSMakeRange(MAX(0, range.location - 1), range.length);
            NSString* text = textView.text;
            // Don't match the previous line if the user is making a newline on an empty line
            if ([[text substringWithRange:NSMakeRange(oldRange.location, 1)] isEqualToString:@"\n"]) {
                return forwardCurrentInvocation();
            }
            NSRange previousLineRange = [text lineRangeForRange:oldRange];
            
            NSArray *matches = [regex matchesInString:text options:0 range: previousLineRange];
            
            if (matches.count > 0) {
                NSString *previousPrefix = [text substringWithRange:[matches[0] rangeAtIndex:0]];
                [textView insertText:[NSString stringWithFormat:@"\n%@", previousPrefix]];
                return NO;
            }
        }
    }
    return forwardCurrentInvocation();
}


-(void)forwardInvocation:(nonnull NSInvocation *)invocation {
    [invocation setTarget:self.delegateTarget];
    [invocation invoke];
}

-(nullable NSMethodSignature *)methodSignatureForSelector:(nonnull SEL)sel {
    const SEL mySelector = @selector(methodSignatureForSelector:);

    id<NSObject> target = self.delegateTarget;
    if (target && [target respondsToSelector:mySelector]) {
        return [(NSObject*)target methodSignatureForSelector:sel];
    } else {
        NSMethodSignature* sig = [NSObject instanceMethodSignatureForSelector:sel];
        return sig;
    }
}

-(BOOL) respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(textView:shouldChangeTextInRange:replacementText:)) {
        return YES;
    } else {
        id<NSObject> target = self.delegateTarget;
        if (target) {
            return [target respondsToSelector:aSelector];
        }
    }
    return NO;
}
@end

