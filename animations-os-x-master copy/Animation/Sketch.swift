//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import IOKit
import IOKit.serial
import Foundation

class Sketch {

    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    let speed = 5;
    var x = [Int](count: 3, repeatedValue: 0)
    var y = [Int](count: 3, repeatedValue: 0)
    var sx = [Int](count: 3, repeatedValue: 1)
    var sy = [Int](count: 3, repeatedValue: 1)
    var portIterator: io_iterator_t = 0
    let kernResult = findSerialDevices(kIOSerialBSDAllTypes, serialPortIterator: &portIterator)
    if kernResult == KERN_SUCCESS {
    printSerialPaths(portIterator)
    }
    

    
    
    // This runs once, equivalent to setup() in Processing
    init() {
        
        
        // Create canvas object – specify size
        canvas = Canvas(width: 1200, height: 700)
        
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60
        
        
        let querkx = UInt32(canvas.width)
        let querky = UInt32(canvas.height)
        
        for (i,value) in x.enumerate() {
            
            x[i] = Int(arc4random_uniform(querkx))
            y[i] = Int(arc4random_uniform(querky))
        }
        
        //Draw a black background
        canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 199)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
    }
    
    // Runs repeatedly, equivalent to draw() in Processing
    func draw() {
        
        for (i,value) in x.enumerate() {
            
        // Horizontal position of circle
            x[i] = x[i] + (sx[i] * speed)
        
        // Bounce when hitting wall
            if (x[i] > canvas.width || x[i] < 0) {
                sx[i] *= -1
            }
            
            y[i] = y[i] + (sy[i] * speed)
            
            if (y[i] > canvas.height || y[i] < 0) {
                sy[i] *= -1
            }
        }
        
        // Clear the background
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 2)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
        // Draw a circle that moves across the screen
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
        for (i,value) in x.enumerate() {
            canvas.drawEllipse(centreX: x[i], centreY: y[i], width: 5, height: 5)
        }

    }

    
}