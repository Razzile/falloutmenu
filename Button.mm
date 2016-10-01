//
//  Button.cpp
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#include "Button.h"
#include "Color.h"

static UIImage *imageForColor(UIColor *clr);

Button::Button(std::string title) : Element([UIButton new])
,title_(title), button_wrapper_([ButtonWrapper initWithButtonClass:this])
{
    
}

void Button::Setup()
{
    UIButton *button = this->obj_;
    [button setTitle:[NSString stringWithUTF8String:title_.c_str()] forState:UIControlStateNormal];
    [button addTarget:button_wrapper_ action:@selector(buttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    [button setAdjustsImageWhenHighlighted:NO];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
    button.layer.borderColor = [Color::ColorForHex("#DDDDDD") CGColor];
    [button setBackgroundImage:imageForColor([UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]) forState:UIControlStateHighlighted];
}

void Button::AddEventHandler(std::function<void(ButtonEvent)> handler) {
    this->button_event_listener_.AddListener(handler);
}

@implementation ButtonWrapper
@synthesize buttonClass;

+ (id)initWithButtonClass:(Button *)buttonClass {
    ButtonWrapper *wrapper = [ButtonWrapper new];
    wrapper.buttonClass = buttonClass;
    return wrapper;
}

- (void)buttonClickEvent {
    self.buttonClass->button_event_listener_(ButtonEvent::ButtonEventPush);
}

static UIImage *imageForColor(UIColor *clr) {
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [clr CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end