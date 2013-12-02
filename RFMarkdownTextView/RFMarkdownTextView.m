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
        
    }
    return self;
}

- (UIView*)inputAccessoryView {
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    inputAccessoryView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.0];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.678 alpha:1.0].CGColor;
    
    [inputAccessoryView.layer addSublayer:topBorder];
    
    [inputAccessoryView addSubview:[self fakeToolbar]];
    
    return inputAccessoryView;
}

- (UIScrollView*)fakeToolbar {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    scrollView.backgroundColor = [UIColor clearColor];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentInset = UIEdgeInsetsMake(6.0f, 7.0f, 7.0f, 6.0f);
    
    NSString *textForButton;
    
    int originX;
    int i;
    
    for (i=0; i < 10; i++) {
        switch (i) {
            case 0:
                textForButton = @"#";
                
                originX = [self scrollViewButtons:textForButton withXOrigin:0 andTag:NSNotFound].frame.size.width+8;
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:0 andTag:0]];
                break;
            case 1:
                textForButton = @"*";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:1]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:1].frame.size.width+8;
                break;
            case 2:
                textForButton = @"_";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:2]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:2].frame.size.width+8;
                break;
            case 3:
                textForButton = @"`";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:3]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:3].frame.size.width+8;
                break;
            case 4:
                textForButton = @"@";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:4]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:4].frame.size.width+8;
                break;
            case 5:
                textForButton = @"Link";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:5]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:5].frame.size.width+8;
                break;
            case 6:
                textForButton = @"Codeblock";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:6]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:6].frame.size.width+8;
                break;
            case 7:
                textForButton = @"Image";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:7]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:7].frame.size.width+8;
                break;
            case 8:
                textForButton = @"Task";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:8]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:8].frame.size.width+8;
                break;
            case 9:
                textForButton = @"Quote";
                
                [scrollView addSubview:[self scrollViewButtons:textForButton withXOrigin:originX andTag:9]];
                originX = originX + [self scrollViewButtons:textForButton withXOrigin:0 andTag:9].frame.size.width+8;
                break;
                
            default:
                break;
        }
    }
    
    CGSize contentSize = scrollView.contentSize;
    contentSize.width = originX-8;
    scrollView.contentSize = contentSize;
    
    return scrollView;
}

- (UIButton*)scrollViewButtons:(NSString*)text withXOrigin:(float)origin andTag:(NSInteger)tag {
    CGSize sizeOfText = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
    
    UIButton *eachButton = [[UIButton alloc] initWithFrame:CGRectMake(origin, 0, sizeOfText.width+18.104, sizeOfText.height+10.298)];
    
    eachButton.tag = tag;
    
    eachButton.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.0];
    eachButton.contentEdgeInsets = UIEdgeInsetsMake(8.0f, 9.0f, 8.0f, 9.0f);
    
    eachButton.layer.cornerRadius = 3.0f;
    eachButton.layer.borderWidth = 1.0f;
    eachButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    
    [eachButton setTitle:text forState:UIControlStateNormal];
    [eachButton setTitleColor:[UIColor colorWithWhite:0.500 alpha:1.0] forState:UIControlStateNormal];
    
    eachButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    eachButton.titleLabel.textColor = [UIColor colorWithWhite:0.500 alpha:1.0];
    
    [eachButton addTarget:self action:@selector(eachButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return eachButton;
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