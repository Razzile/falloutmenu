//
//  Element.cpp
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#include "Element.h"

static int objCount = 0;
Element::Element(id obj, float height) : obj_(obj), height(height)
{
    objCount++;
    hash_ = (objCount << 2 ^ 4);
}