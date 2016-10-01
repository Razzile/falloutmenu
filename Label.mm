//
//  Label.cpp
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#include "Label.h"

Label::Label(std::string text)
: Element([UITextView new], 80), text_(text)
{
    
}

void Label::Setup()
{
    UITextView *label = this->obj_;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithUTF8String:text_.c_str()]];
    label.textAlignment = NSTextAlignmentCenter;
    label.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    label.editable = NO;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
}