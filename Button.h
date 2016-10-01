//
//  Button.h
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef __CIV3_Menu__Button__
#define __CIV3_Menu__Button__

#include <string>
#include "Element.h"
#include "Delegate.h"

#import <UIKit/UIKit.h>

class Button;
enum class ButtonEvent {
    ButtonEventPush
};

@interface ButtonWrapper : NSObject
@property Button *buttonClass;

+ (id)initWithButtonClass:(Button *)buttonClass;
- (void)buttonClickEvent;
@end

class Button : public Element {
public:
    Button(std::string title);
    void Setup();
    void AddEventHandler(std::function<void(ButtonEvent)> handler);
    std::string title_;
    Delegate<ButtonEvent> button_event_listener_;
    ButtonWrapper *button_wrapper_;
};

#endif /* defined(__CIV3_Menu__Button__) */
