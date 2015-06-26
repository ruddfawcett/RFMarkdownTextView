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

#define FONT_SIZE 14
#define BODY_FONT [UIFont fontWithName:@"Menlo" size:FONT_SIZE]

@interface RFMarkdownSyntaxStorage ()


@property (nonatomic, strong) NSDictionary *attributeDictionary;
@property (nonatomic, strong) NSDictionary *bodyFont;

@end

@implementation RFMarkdownSyntaxStorage {
    NSMutableAttributedString* _backingStore;
}

- (id)init {
    if (self = [super init]) {
        
        _bodyFont = @{NSFontAttributeName:BODY_FONT, NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone]};
        _backingStore = [NSMutableAttributedString new];
        
        [self createHighlightPatterns];
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

- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    
    [super addAttributes:attrs range:range];
    
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

- (void)createHighlightPatterns {
    NSDictionary *boldAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Bold" size:FONT_SIZE]};
    NSDictionary *italicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Italic" size:FONT_SIZE]};
    NSDictionary *boldItalicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-BoldItalic" size:FONT_SIZE]};
    
    NSDictionary *codeAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    
    NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Bold" size:FONT_SIZE], NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName:[UIColor colorWithWhite:0.933 alpha:1.0]};
    NSDictionary *headerTwoAttributes = headerOneAttributes;
    NSDictionary *headerThreeAttributes = headerOneAttributes;
    
    NSDictionary *strikethroughAttributes = @{NSFontAttributeName:BODY_FONT, NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)};
    
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
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.255 green:0.514 blue:0.769 alpha:1.00]};
    
    _attributeDictionary = @{
                      @"[a-zA-Z0-9\t\n ./<>?;:\\\"'`!@#$%^&*()[]{}_+=|\\-]":_bodyFont,
                      @"~~(\\w+(\\s\\w+)*)~~":strikethroughAttributes,
                      @"\\**(?:^|[^*])(\\*\\*(\\w+(\\s\\w+)*)\\*\\*)":boldAttributes,
                      @"\\**(?:^|[^*])(\\*(\\w+(\\s\\w+)*)\\*)":italicAttributes,
                      @"(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)":boldItalicAttributes,
                      @"(`\\w+(\\s\\w+)*`)":codeAttributes,
                      @"(```\n([\\s\n\\d\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/]]*)\n```)":codeAttributes,
                      @"(\\[\\w+(\\s\\w+)*\\]\\(\\w+\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/ \\w+]*\\))":linkAttributes,
                      @"(\\[\\[\\w+(\\s\\w+)*\\]\\])":linkAttributes,
                      @"(\\#\\s?\\w*(\\s\\w+)*\\n)":headerOneAttributes,
                      @"(\\##\\s?\\w*(\\s\\w+)*\\n)":headerTwoAttributes,
                      @"(\\###\\s?\\w*(\\s\\w+)*\\n)":headerThreeAttributes
                      };
}

- (void)update:(NSRange)range {
    [self createHighlightPatterns];
    
    [self addAttributes:_bodyFont range:NSMakeRange(0, self.length)];
    
    [self applyStylesToRange:[[self string] lineRangeForRange:range]];
}

- (void)update {
    [self update:NSMakeRange(0, self.length)];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    for (NSString *key in _attributeDictionary) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];
        
        NSDictionary *attributes = _attributeDictionary[key];
        
        [regex enumerateMatchesInString:[_backingStore string] options:0 range:searchRange
            usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                NSRange matchRange = [match rangeAtIndex:1];
                [self addAttributes:attributes range:matchRange];
                
                if (NSMaxRange(matchRange)+1 < self.length) {
                     [self addAttributes:_bodyFont range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                }
        }];
    }
}

#pragma mark Property Access


@end
