//
//  RFMarkdownSyntaxStorage.m
//
//    Derived from RFMarkdownTextView Copyright (c) 2015 Rudd Fawcett
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RFMarkdownSyntaxStorage.h"

@interface RFMarkdownSyntaxStorage ()


@property (nonatomic, strong,readonly) NSDictionary *attributeDictionary;
@property (nonatomic, strong,readonly) NSDictionary *bodyAttributes;

@property (nonatomic,strong,readonly) UIFont* bodyFont;

@end

@implementation RFMarkdownSyntaxStorage {
    NSMutableAttributedString* _backingStore;
}

- (id)init {
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString*)str {
    [self beginEditing];
    
    [_backingStore replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    
    [_backingStore setAttributes:attrs range:range];
    
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing {
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSString* backingString = [_backingStore string];
    NSRange extendedRange = NSUnionRange(changedRange, [backingString lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [backingString lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    NSDictionary* attributeDictionary = self.attributeDictionary;
    NSString* backingString = [_backingStore string];
    NSDictionary* bodyAttributes  = self.bodyAttributes;
    [self addAttributes:bodyAttributes range:searchRange];
    [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(NSRegularExpression* regex, NSDictionary* attributes, BOOL* stop) {
        [regex enumerateMatchesInString:backingString options:0 range:searchRange
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                 NSRange matchRange = [match rangeAtIndex:1];
                                 [self addAttributes:attributes range:matchRange];
                             }];
        
    }];
}

#pragma mark Property Access

@synthesize bodyAttributes = _bodyAttributes;

-(NSDictionary *)bodyAttributes {
    if (!_bodyAttributes) {
        _bodyAttributes = @{NSFontAttributeName:self.bodyFont, NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone]};
    }
    return _bodyAttributes;
}

@synthesize bodyFont = _bodyFont;

-(UIFont *)bodyFont {
    if (!_bodyFont) {
        UIFontDescriptor* baseDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        CGFloat baseFontSize = baseDescriptor.pointSize;
        CGFloat bodyFontSize = ceilf(baseFontSize * 14 / 17 / 2) * 2;
        _bodyFont = [UIFont fontWithName:@"Menlo" size:bodyFontSize];
    }
    return _bodyFont;
}

@synthesize attributeDictionary = _attributeDictionary;

-(NSDictionary *)attributeDictionary {
    if (!_attributeDictionary) {
        UIFont* bodyFont = self.bodyFont;
        CGFloat bodyFontSize = bodyFont.pointSize;
        
        NSDictionary *boldAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Bold" size:bodyFontSize]};
        NSDictionary *italicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Italic" size:bodyFontSize]};
        NSDictionary *boldItalicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-BoldItalic" size:bodyFontSize]};
        
        NSDictionary *codeAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
        
        NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Bold" size:bodyFontSize], NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName:[UIColor colorWithWhite:0.933 alpha:1.0]};
        NSDictionary *headerTwoAttributes = headerOneAttributes;
        NSDictionary *headerThreeAttributes = headerOneAttributes;
        
        NSDictionary *strikethroughAttributes = @{NSFontAttributeName:bodyFont, NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)};
        
        /*
         NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
         NSDictionary *headerTwoAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
         NSDictionary *headerThreeAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.5]};
         
         Alternate H1 with underline:
         
         NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName:[UIColor colorWithWhite:0.933 alpha:1.0]};
         
         Headers need to be worked on...
         
         @"(\\#\\w+(\\s\\w+)*\n)":headerOneAttributes,
         @"(\\##\\w+(\\s\\w+)*\n)":headerTwoAttributes,
         @"(\\###\\w+(\\s\\w+)*\n)":headerThreeAttributes
         
         */
        
        NSRegularExpression* (^regex)(NSString*) = ^(NSString* regexString) {
            NSError* regexError = nil;
            NSRegularExpression* pattern = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:&regexError];
            if (regexError) {
                NSLog(@"Regex %@ error: %@",regexString,regexError);
            }
            return pattern;
        };
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.255 green:0.514 blue:0.769 alpha:1.00]};
        
        _attributeDictionary = @{
                                 regex(@"~~(\\w+(\\s\\w+)*)~~") :strikethroughAttributes,
                                 regex(@"\\**(?:^|[^*])(\\*\\*(\\w+(\\s\\w+)*)\\*\\*)") :boldAttributes,
                                 regex(@"\\**(?:^|[^*])(\\*(\\w+(\\s\\w+)*)\\*)") :italicAttributes,
                                 regex(@"(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)") :boldItalicAttributes,
                                 regex(@"(`\\w+(\\s\\w+)*`)") :codeAttributes,
                                 regex(@"(```\n([\\s\n\\d\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/]]*)\n```)") :codeAttributes,
                                 regex(@"(\\[\\w+(\\s\\w+)*\\]\\(\\w+\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/ \\w+]*\\))") :linkAttributes,
                                 regex(@"(\\[\\[\\w+(\\s\\w+)*\\]\\])") :linkAttributes,
                                 regex(@"(\\#\\s?\\w*(\\s\\w+)*\\n)") :headerOneAttributes,
                                 regex(@"(\\##\\s?\\w*(\\s\\w+)*\\n)") :headerTwoAttributes,
                                 regex(@"(\\###\\s?\\w*(\\s\\w+)*\\n)") :headerThreeAttributes
                                 };

    }
    return _attributeDictionary;
}

@end
