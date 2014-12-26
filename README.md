RFMarkdownTextView <br />[![Build Status](http://img.shields.io/travis/ruddfawcett/RFMarkdownTextView.svg?style=flat)](http://travis-ci.org/ruddfawcett/RFMarkdownTextView) [![RFMarkdownTextView Version](http://img.shields.io/cocoapods/v/RFMarkdownTextView.svg?style=flat)](http://cocoadocs.org/docsets/RFMarkdownTextView/1.4/) ![License MIT](http://img.shields.io/badge/license-MIT-orange.svg?style=flat) ![reposs](https://reposs.herokuapp.com/?path=ruddfawcett/RFMarkdownTextView&style=flat)
==================

This is a UITextView that is supposed to replicate the comment toolbar in iOctocat (http://ioctocat.com) with auto-insert markdown functionality.

###Screenshot of Markdown Syntax

<img src='http://i.imgur.com/3QDNlrj.png' width='320px'>

##Installation

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like RFMarkdownTextView in your projects.

#### Podfile

```ruby
platform :ios, '7.0'
pod "RFMarkdownTextView", "~> 1.4"
```

### Installation without CocoaPods

Just drag the RFMarkdownTextView and [RFKeyboardToolbar](http://github.com/ruddfawcett/RFKeyboardToolbar) folder into your project and import it.

```
#import 'RFMarkdownTextView.h'
```

## Use

RFMarkdownTextView is like any other UITextView - just set it up with `initWithFrame:` and you're good to go.

Hope you enjoy it!

##Screenshots
###Side by Side Comparison (with iOctocat)
![RFMarkdownTextView](http://i.imgur.com/NEAocbW.png)
![iOctocat Comment](http://i.imgur.com/P8eeXZf.png)
![RFMarkdownTextView 2](http://i.imgur.com/0jIR5vh.png)
![iOctocat Comment 2](http://i.imgur.com/qPCf2wQ.png)

Looking at these now, the text size seems smaller and the `*` and `` ` `` button titles don't seem to be centered.  Feel free to open a pull request to fix either, as I won't be doing so.

##License

The MIT License (MIT)

Copyright (c) 2013 Rudd Fawcett

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
