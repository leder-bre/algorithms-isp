//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Foundation

// NOTE: The Sketch class will define the methods required by the ORSSerialPortDelegate protocol
//
// “A protocol defines a blueprint of methods, properties, and other requirements that suit a 
// particular task or piece of functionality.”
//
// Excerpt From: Apple Inc. “The Swift Programming Language (Swift 2).” iBooks. https://itun.es/ca/jEUH0.l
//
// In this case, the Sketch class implements methods that allow us to read and use the serial port, via
// the ORSSerialPort library.
class Sketch : NSObject, ORSSerialPortDelegate {

    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    var serialPort : ORSSerialPort?       // Object required to read serial port
    var serialBuffer : String = ""
    var p1 = 100
    var p2 = 100
    let pWidth = 50
    let pHeight = 100
    var pColor = arc4random_uniform(360)
    var bX = Float(0)
    var bY = Float(0)
    var bYSpeed = Float(2)
    var bXSpeed = Float(4)
    let bWidth = 10
    let bHeight = 10
    // This runs once, equivalent to setup() in Processing
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 500, height: 300)
        bX = Float(canvas.width/2)
        bY = Float(canvas.height/2)
        if (arc4random_uniform(100)%2==0) {
            bXSpeed *= -1
        }
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60

        // Call superclass initializer
        super.init()
        
        // Find and list available ports
        var availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
        if availablePorts.count == 0 {
            
            // Show error message if no ports found
            print("No connected serial ports found. Please connect your USB to serial adapter(s) and run the program again.\n")
            exit(EXIT_SUCCESS)
            
        } else {
            
            // List available ports in debug window (view this and adjust
            print("Available ports are...")
            for (i, port) in availablePorts.enumerate() {
                print("\(i). \(port.name)")
            }
            
            // Open the desired port
            serialPort = availablePorts[0]  // selecting first item in list of available ports
            serialPort!.baudRate = 9600
            serialPort!.delegate = self
            serialPort!.open()
            
        }
        
    }
    
    // Runs repeatedly, equivalent to draw() in Processing
    func draw() {
        
        p1 = (100*Int(bY)/(canvas.height))
        p2 = (100*Int(bY)/(canvas.height))
        
        //Calculate Movement
        if(Int(bY)<bHeight+pHeight/2) {
            bYSpeed *= -1
            bY = Float(bHeight+pHeight/2)
            print("TEENY")
        }
        if(Int(bY)>canvas.height-bHeight-pHeight/2) {
            bYSpeed *= -1
            bY = Float(canvas.height-bHeight-pHeight/2)
            print("HULK")
        }
        
        
        if(Int(bX)<pWidth && Int(bX)>0) {
            if(Int(bY)>(p1*(canvas.height-pHeight)/100)){
                bXSpeed *= -1
            }
        }
        if(Int(bX)<canvas.width && Int(bX)>canvas.width-pHeight) {
            if(Int(bY)>(p2*(canvas.height-pHeight)/100)){
                bXSpeed *= -1
            }
        }
        
        //Move Ball
        bX += bXSpeed
        bY += bYSpeed
        
        //Draw Shapes
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 100)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
        canvas.fillColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
        canvas.drawEllipse(centreX: Int(bX), centreY: Int(bY)+pHeight/2, width: bWidth, height: bHeight)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: (p1*(canvas.height-pHeight)/100), width: pWidth, height: pHeight)
        canvas.drawRectangle(bottomRightX: canvas.width-pWidth, bottomRightY: (p2*(canvas.height-pHeight)/100), width: pWidth, height: pHeight)
        
      /*
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 10)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
        // Draw a circle that moves across the screen
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
        canvas.drawEllipse(centreX: x, centreY: y, width: 25, height: 25)
        */
                
    }
    
    // ORSSerialPortDelegate
    // These four methods are required to conform to the ORSSerialPort protocol
    // (Basically, the methods will be invoked when serial port events happen)
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        // Print whatever we receive off the serial port to the console
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {

            // Iterate over all the characters received from the serial port this time
            for chr in string.characters {
                
                // Check for delimiter
                if chr == "|" {
                    
                    // Entire value sent from Arduino board received, assign to
                    // variable that controls the vertical position of the circle on screen
                    p1 = Int(serialBuffer)!
                    p2 = p1
                    while(p1>99) {
                        p1 -= 100
                    }
                    p2 = p2 - (p2%100)
                    // Reset the string that is the buffer for data received from serial port
                    serialBuffer = ""
                    
                } else {
                    
                    // Have not received all the data yet, append what was received to buffer
                    serialBuffer += String(chr)
                }
                
            }

            // DEBUG: Print what's coming over the serial port
            print("\(string)", terminator: "")
            
        }
        
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
}