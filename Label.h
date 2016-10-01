//
//  Label.h
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef __CIV3_Menu__Label__
#define __CIV3_Menu__Label__

#include <string>
#include "Element.h"
#include "Delegate.h"

#import <UIKit/UIKit.h>

class Label : public Element {
public:
    Label(std::string text);
    void Setup();
protected:
    std::string text_;
};

#endif /* defined(__CIV3_Menu__Label__) */
