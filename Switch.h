//
//  Switch.h
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef __CIV3_Menu__Switch__
#define __CIV3_Menu__Switch__

#include <string>
#include "Element.h"
#include "Delegate.h"

#import <UIKit/UIKit.h>

class Switch;

enum class SwitchEvent {
    SwitchEventToggleOn,
    SwitchEventToggleOff
};

@interface SwitchWrapper : NSObject
@property Switch *switchClass;

+ (id)initWithSwitchClass:(Switch *)switchClass;
- (void)switchToggleEvent:(UISwitch *)sender;
@end

class Switch : public Element {
public:
    Switch(std::string label);
    void Setup();
    void AddEventHandler(std::function<void(SwitchEvent)> handler);
    
    std::string label_;
    Delegate<SwitchEvent> switch_toggle_listener_;
    SwitchWrapper *switch_wrapper_;
};

#endif /* defined(__CIV3_Menu__Switch__) */
