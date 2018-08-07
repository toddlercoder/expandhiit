//
//  SoundService.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/10/18.
//  Copyright © 2018 Melody Song. All rights reserved.
//

import UIKit
import AVFoundation



class SoundService {
    
    var player = AVAudioPlayer()
    
    func initializeAudio(name: SoundFile, ofType: String) {
        
        if let path = Bundle.main.path(forResource: name.rawValue, ofType: ofType) {
            let url = URL(fileURLWithPath: path)
            //print(name)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            } catch {
                // couldn't upload file
                print("Error: couldn't upload a file to AVAudioPlayer")
            }
        } else {
            print("Error: No path bundle for AVAudioPlayer")
        }
    }
    
}
