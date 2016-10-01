//
//  Color.h
//  CIV3_Menu
//
//  Created by callum taylor on 06/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef CIV3_Menu_Color_h
#define CIV3_Menu_Color_h

#include <string>
#import <UIKit/UIKit.h>

#define RedColor [UIColor redColor]

namespace Color {
    UIColor *ColorForHex(std::string hex) {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:hex.c_str()]];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
}

#endif
