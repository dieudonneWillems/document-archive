//
//  NSColor+LightAndDark.swift
//  Document Archive
//
//  Created by Don Willems on 28/06/15.
//  Copyright (c) 2015 lapsedpacifist. All rights reserved.
//

import Cocoa

extension NSColor {
    
    func lighterColor() -> NSColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = min(brightness*1.3, 1.0)
        return NSColor(deviceHue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func darkerColor() -> NSColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness/1.3
        return NSColor(deviceHue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}