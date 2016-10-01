//
//  Slider.h
//  CIV3_Menu
//
//  Created by callum taylor on 11/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef __CIV3_Menu__Slider__
#define __CIV3_Menu__Slider__


#include "Element.h"
#include "Delegate.h"

#import <UIKit/UIKit.h>


class Slider;

@interface SliderWrapper : NSObject
@property Slider *sliderClass;

+ (id)initWithSliderClass:(Slider *)sliderClass;
- (void)sliderValueChangedEvent:(UISlider *)sender;
@end

class Slider : public Element {
public:
    Slider();
    void Setup();
    void AddEventHandler(std::function<void(float)> handler);
    
    Delegate<float> slider_changed_listener_;
    SliderWrapper *slider_wrapper_;
};

#endif