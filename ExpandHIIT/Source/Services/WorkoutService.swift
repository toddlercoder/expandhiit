//
//  WorkoutService.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Melody Song. All rights reserved.
//

import Foundation
import FirebaseDatabase

let rootRef = Database.database().reference()

enum DBName : String {
    case Attempts = "numAttempts"
    case Complete = "numCompletion"
}

struct WorkoutService {
    static func create() {
        // initial static setting
        let exercise1 = Exercise(name: "Jump Rope Freestyle", descript: "Whatever you feel like.", url: "https://www.youtube.com/watch?v=Une6mlfy5mA")
        let exercise2 = Exercise(name: "Jump Rope Mummy Kicks", descript: "Keep your core tight.", url: "https://youtu.be/kkrCpGx5Fdc?t=2m57s")
        let exercise3 = Exercise(name: "Jump Rope Butt Kick", descript: "Kick your own ass!", url: "https://youtu.be/AF4Zr_bbbWs?t=2m11s")
        let exercise4 = Exercise(name: "Jump Rope Half Twist", descript: "Twist your core!", url: "https://youtu.be/10cE0D2bYs4")
        let exercise5 = Exercise(name: "Jump Rope Front & Back", descript: "Bounce with us.", url: "https://youtu.be/10cE0D2bYs4")
        let exercise6 = Exercise(name: "Jump Rope Run In Place", descript: "Go go go.", url: "https://www.youtube.com/watch?v=7XndvyHv3w8")
        let exercise7 = Exercise(name: "Jump Rope Boxer Skip", descript: "With your rhythm", url: "https://youtu.be/e1rBY-pJXhM?t=2m51s")
        let exercise8 = Exercise(name: "Jump Rope High Knees", descript: "Try to keep your knees 90 degrees angle!", url: "https://youtu.be/MII0QvoM9M8?t=2m52s")
        let round = Round(numSets: 8, setSec: 30, restSec: 10, exercises: [exercise1, exercise2, exercise3, exercise4, exercise5, exercise6, exercise7, exercise8])
        
        let workout = Workout(title: "Jump Rope Cardio", numRounds: 4, round: round)
        
        // FIREBASE
        //let rootRef = Database.database().reference()
        let newWorkout = rootRef.child("workouts").childByAutoId()
        let newWorkoutKey = newWorkout.key
        
        let updateData : [String: Any] = ["workouts/\(newWorkoutKey)" : workout.dictValue]
        print(updateData)
        rootRef.updateChildValues(updateData)
        
    }
    
    static func get(completion: @escaping ([Workout]) -> Void) {
        let workoutRef = rootRef.child("workouts")
        print("Getting workouts")
        workoutRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("Are we in?")
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([])}
            print("So we are!")
            let dispatchGroup = DispatchGroup()
            
            var workouts = [Workout]()
           
            for workSnap in snapshots {
                print("What's happening?")
                dispatchGroup.enter()
                guard let workout = Workout(snapshot: workSnap) else {
                    return completion([])
                }
                print("appending workout")
                workouts.append(workout)
                workout.printWorkout()
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(workouts)
            })
        })
    }
    
    // isChallenge is TRUE if "attemps", else, "completed"
    static func increment(for wID: String, isChallenge: Bool) {
        let childName = isChallenge ? DBName.Attempts : DBName.Complete
        
        let countRef = rootRef.child("workouts").child(wID).child(childName.rawValue)
        //print(countRef)
        countRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            mutableData.value = currentCount + 1
            return TransactionResult.success(withValue: mutableData)
        }, andCompletionBlock: { (error, _, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                //completion(false)
            } //else {
                //completion(true)
            //}
        })
    }
}
