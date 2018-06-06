//
//  MyUtils.swift
//  Zombie
//
//  Created by Roman Slezenko on 14.02.18.
//  Copyright © 2018 Roman Slezenko. All rights reserved.
//

import Foundation
import CoreGraphics

func - (left: CGPoint, right: CGPoint) ->CGPoint{
    return CGPoint(x: left.x - right.x,y: left.y - right.y)
    
}
func + (left: CGPoint, right: CGPoint) ->CGPoint{
    return CGPoint(x: left.x + right.x,y: left.y + right.y)
    
}

func / (point: CGPoint,sc: CGFloat) ->CGPoint{
    return CGPoint(x: point.x/sc,y: point.y/sc)
    
}
func * (point: CGPoint,sc: CGFloat) ->CGPoint{
    return CGPoint(x: point.x*sc,y: point.y*sc)
    
}

func += (left: inout CGPoint ,right: CGPoint){
    left = left + right
}

extension CGPoint{
    func length() -> CGFloat{
        return sqrt(x*x + y*y)
    }
    var angle: CGFloat{
        return atan2(y, x)
    }
    func normalized()->CGPoint{
        return self / length()
    }
}

extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(Float(arc4random())/Float(UInt32.max))
    }

    static func random(min: CGFloat,max: CGFloat) -> CGFloat{
        assert(min<max)
        return CGFloat.random() * (max - min) + min
    }
    
    func sign() ->CGFloat{
        return self>=0.0 ? 1.0 : -1.0
    }
}

func shortestAngleBetween(angle1: CGFloat,angle2:CGFloat)->CGFloat{
    let twopi = CGFloat.pi * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twopi)
    
    if angle >= CGFloat.pi {
        angle = angle - twopi
    }
    if angle <= -CGFloat.pi {
        angle = angle + twopi
    }
    return angle
}


import AVFoundation

var backgroundMusic: AVAudioPlayer!

func playbackgroundmusic(filename: String){
    let resoursleUrl = Bundle.main.url(forResource: filename, withExtension: nil)
    guard let url = resoursleUrl else {
        print("Eroor with \(filename)")
        return
    }
    
    do{
        try backgroundMusic = AVAudioPlayer(contentsOf: url)
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.prepareToPlay()
        backgroundMusic.play()
        
        
    }catch{
        print("Error player")
    }
    
}
