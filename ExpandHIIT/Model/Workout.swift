//
//  Workout.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Melody Song. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase.FIRDataSnapshot

/*
 Workout has specified number of rounds.
 One round is composed of exercise sets.
 An exercise is done during the specified amount of seconds followed by rest seconds.
 */

let dummyImageURL = "https://firebasestorage.googleapis.com/v0/b/hiit-79b64.appspot.com/o/street-workout-2628893_1920.jpg?alt=media&token=50e6ef79-6eb3-4e39-8386-21a9e12b6d73"

class Exercise : NSObject {
    var key: String?
    var name: String
    var descript: String
    var video: String
    var hasVideo = false
    var hasAlt = false
    //var alternative: Exercise()?
    
    init(name: String, descript: String, url: String) {
        self.name = name
        self.descript = descript
        self.video = url   // should check if the link is valid or not
        //self.hasAlt = hasAlt
    }
    
    init(json: [String : Any]) {
            self.name = json["name"] as! String
        // update after user management is added
            self.descript = json["descript"] as! String     // FOR NOW: round repeats
            self.video = json["video"] as! String
    }
    
    func printExercise() {
        print("\(self.name) - \(self.descript)")
        print("\(self.video)")
    }
}

class Round : NSObject {
    var key: String?
    var numSets: Int
    var setSec: Int
    var restSec: Int
    var exercises : [Exercise]
    
    init(numSets: Int, setSec: Int, restSec: Int, exercises: [Exercise]) {
        self.numSets = numSets
        self.setSec = setSec
        self.restSec = restSec
        self.exercises = exercises
    }
    
    init(json: [String : Any]) {
        //print("Initializing ROUND object")
        self.numSets = json["num_sets"] as! Int
            // update after user management is added
        self.setSec = json["set_sec"] as! Int // FOR NOW: round repeats
        self.restSec = json["rest_sec"] as! Int
        //let sets = json["exercises"].arrayObject
        
        var exercises = [Exercise]()
        let sets = json["exercises"] as! NSArray
        for set in sets {
            exercises.append(Exercise(json: set as! [String : Any]))
        }
            //self.thumbnail_images.append(ThumbImages(dict: postImage))
        
        /*for set in sets as? [String: Any] {
            exercises.append(Exercise(json: set as! JSON))
        }*/
        self.exercises = exercises
    }
    
    func printRound() {
        print("With \(self.setSec):\(self.restSec):")
        for index in 1...numSets {
            self.exercises[index-1].printExercise()
        }
    }
}

class Workout : NSObject {
    var title: String
    var key: String?
    var numRounds: Int
    var repeats = true
    var uid = "melody"      // update after user management is added
    var rounds : Round!     // FOR NOW: round repeats
    var restSec : Int
    var numAttempts : Int
    var numCompletion : Int
    var instructor : String
    var img : String
    var creationDate: Date
    
    init(title: String, numRounds: Int, round: Round) {
        self.title = title
        self.numRounds = numRounds
        self.rounds = round
        self.restSec = 60
        self.numAttempts = 0
        self.numCompletion = 0
        self.instructor = "Expand HIIT"
        self.img = dummyImageURL
        self.creationDate = Date()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict["title"] as? String,
            let numRounds = dict["num"] as? Int,
        let roundSet = dict["rounds"] as? [String : Any], // FOR NOW: round repeats
            let restSec = dict["rest_sec"] as? Int,
            let numAttempts = dict["numAttempts"] as? Int,
            let numCompletion = dict["numCompletion"] as? Int,
            let instructor = dict["instructor"] as? String,
            let img = dict["img"] as? String,
            let creationDate = dict["creationDate"] as? TimeInterval
            else {
                print("something isn't right")
                return nil
                
        }
        self.key = snapshot.key
        self.title = title
        self.numRounds = numRounds
        // ONLY ONE round FOR NOW
        self.rounds = Round(json: roundSet)
        self.restSec = restSec
        self.numAttempts = numAttempts
        self.numCompletion = numCompletion
        self.img = img
        self.instructor = instructor
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        
    }
    
    var dictValue: [String: Any] {
        var exerciseDict = [[String: Any]]()
        for exercise in (rounds?.exercises)! {
            exerciseDict.append(["name" : exercise.name,
                                 "descript" : exercise.descript,
                                 "video" : exercise.video])
        }
        print(exerciseDict)
        
        let roundDict = ["num_sets" : rounds.numSets,
                         "set_sec" : rounds.setSec,
                         "rest_sec" : rounds.restSec,
                         "exercises" : exerciseDict] as [String : Any]
        print(roundDict)
        return ["num": numRounds,
                "repeats": repeats,
                "rounds": roundDict,
                "numAttempts": numAttempts,
                "numCompletion" : numCompletion,
                "instructor" : instructor,
                "rest_sec": restSec,
                "img": img,
                "title": title,
                "creationDate": creationDate.timeIntervalSince1970]
    }
    
    
    // TO DO : PRINT function for EASIER reading
    func printWorkout() {
        print("[\(self.title)]")
        print("\(self.numRounds) rounds of the following sets :")
        self.rounds?.printRound()
    }
}




