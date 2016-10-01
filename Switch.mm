//
//  Switch.cpp
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#include "Switch.h"
#include "UIView+Facade.h"

Switch::Switch(std::string label) : Element([UIView new])
,label_(label), switch_wrapper_([SwitchWrapper initWithSwitchClass:this])
{
    
}

void Switch::Setup()
{
    /* super class */
    Element::Setup();
    
    UIView *switchView = this->obj_;
    UILabel *switchLabel = [UILabel new];
    [switchLabel setText:[NSString stringWithUTF8String:label_.c_str()]];
    [switchLabel setTextColor:[UIColor whiteColor]];
    [switchView addSubview:switchLabel];
    
    UISwitch *switchMain = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchMain addTarget:switch_wrapper_ action:@selector(switchToggleEvent:) forControlEvents:UIControlEventValueChanged];
    [switchView addSubview:switchMain];
    
    switchMain.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [switchMain setOnTintColor:[UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1]];
}

void Switch::AddEventHandler(std::function<void (SwitchEvent)> handler)
{
    switch_toggle_listener_.AddListener(handler);
}

@implementation SwitchWrapper
@synthesize switchClass;

+ (id)initWithSwitchClass:(Switch *)switchClass {
    SwitchWrapper *wrapper = [SwitchWrapper new];
    wrapper.switchClass = switchClass;
    return wrapper;
}

- (void)switchToggleEvent:(UISwitch *)sender {
    SwitchEvent event;
    event = (sender.on) ? SwitchEvent::SwitchEventToggleOn : SwitchEvent::SwitchEventToggleOff;
    switchClass->switch_toggle_listener_(event);
}

@end

