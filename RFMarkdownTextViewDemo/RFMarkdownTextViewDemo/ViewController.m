//
//  ViewController.m
//  RFMarkdownTextViewDemo
//
//  Created by Rex Finn on 12/1/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) RFMarkdownTextView *textView;

@end

@implementation ViewController

-(void)viewDidLoad  {
    [super viewDidLoad];
    
    self.title = @"RFMarkdownTextView";
    
    _textView = [[RFMarkdownTextView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
