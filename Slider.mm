//
//  Slider.cpp
//  CIV3_Menu
//
//  Created by callum taylor on 11/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#include "Slider.h"

Slider::Slider() : Element([UISlider new])
, slider_wrapper_([SliderWrapper initWithSliderClass:this])
{
    
}

void Slider::Setup()
{
    UISlider *slider = this->obj_;
    [slider setTintColor:[UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1]];
    [slider addTarget:slider_wrapper_ action:@selector(sliderValueChangedEvent:) forControlEvents:UIControlEventValueChanged];
}

void Slider::AddEventHandler(std::function<void (float)> handler)
{
    slider_changed_listener_.AddListener(handler);
}

@implementation SliderWrapper
@synthesize sliderClass;

+ (id)initWithSliderClass:(Slider *)sliderClass {
    SliderWrapper *wrapper = [SliderWrapper new];
    wrapper.sliderClass = sliderClass;
    
    return wrapper;
}

- (void)sliderValueChangedEvent:(UISlider *)sender {
    float value = sender.value;
    sliderClass->slider_changed_listener_(value);
}

@end