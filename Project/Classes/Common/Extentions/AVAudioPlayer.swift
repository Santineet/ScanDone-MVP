//
//  AVAudioPlayer.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 12/28/16.
//  Copyright © 2016 BEST. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox


extension AVAudioPlayer {
    static func playInSilentMode() {
        do {
            //if active some other Category - sound will not be played in SilentMode
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } else {
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
//    static func enableRecordingMode() {
//        do {
//            try AVAudioSession.sharedInstance().setActive(true)
//            if #available(iOS 10.0, *) {
//                try AVAudioSession.sharedInstance().setCategory(.play, mode: .moviePlayback)
//            } else {
//                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
//            }
//            //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
//            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }

    func fadeOut(toVolume: Float, duration: Double) {
        weak var weakSelf = self
        if volume > toVolume {
            let delayV = duration/100
            delay(delayV) {
                weakSelf?.volume -= 0.01
                weakSelf?.fadeOut(toVolume: toVolume, duration: duration)
                }
        } else {
            volume = toVolume
        }
    }
    
    func fadeIn(toVolume: Float, duration: Double) {
        weak var weakSelf = self
        if volume < toVolume {
            let delayV = duration/100
            delay(delayV) {
                weakSelf?.volume += 0.01
                weakSelf?.fadeIn(toVolume: toVolume, duration: duration)
                //print(weakSelf?.volume)
                }
        } else {
            volume = toVolume
        }
    }
    
    
    @nonobjc static var sharedPlayer: AVAudioPlayer?

    static func playSound(_ url: URL?) {
        playSound(url, volume: 1)
    }
    
    static func playSound(_ url: URL?, volume: Float) {
        sharedPlayer?.stop()
        //        sharedPlayer = nil
        
        if let url = url {
            do {
                sharedPlayer = try AVAudioPlayer(contentsOf: url)
                sharedPlayer?.volume = volume
                sharedPlayer?.numberOfLoops = 0
                sharedPlayer?.prepareToPlay()
                sharedPlayer?.play()
            } catch {
                print("error play audio")
            }
        }
    }

    static func playSoundSimultaneously(_ url: URL?, volume: Float, numberOfLoops: Int = 0) -> AVAudioPlayer? {
        if let url = url {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = volume
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                return player
            } catch {
                print("error play audio")
                return nil
            }
        }
        return nil
    }
    
}

 
