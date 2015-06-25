//
//  RFMarkdownTextView.h
//  RFMarkdownTextViewDemo
//
//  Created by Rudd Fawcett on 12/1/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
@import RFKeyboardToolbar;

@class RFMarkdownTextView;

typedef void (^ImageBlock)(NSString *);

@protocol ImagePickerDelegate <NSObject>
- (void)textViewWantsImage:(RFMarkdownTextView *)textView completion:(ImageBlock)imageBlock;
@end

@interface RFMarkdownTextView : UITextView <UITextViewDelegate>

@property (nonatomic, weak) id<ImagePickerDelegate> imagePickerDelegate;

@end
