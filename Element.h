//
//  Element.h
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef __CIV3_Menu__Element__
#define __CIV3_Menu__Element__

#include <stdio.h>
#include <objc/runtime.h>
#include "ObjCMacros.h"

class Element {
    friend class Menu;
public:
    Element(id obj, float height = 40);
    virtual void Setup() { };
    id obj_;
    uint32_t hash_;
    float height;
};

#endif /* defined(__CIV3_Menu__Element__) */
