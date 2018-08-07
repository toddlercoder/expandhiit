//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import os.log

class DemoTableViewController: ExpandingTableViewController {
    
    let workoutCell = "workoutTableViewCell"
    let challengeCell = "challengeCell"
    let restCell = "restCell"
    
    typealias workoutInfo = (exercise: String, sec: Int)
    //fileprivate let items: [workoutInfo] = [("Jump Rope Freestyle", 30), ("Squats", 30), ("Jump Rope Cross", 30), ("Push ups", 30)]
    var round : Round!
    var numRounds : Int!
    var workout: Workout!
    
    
    var items = [Exercise]()
   // var worouts = [Workout]()
    
    fileprivate var scrollOffsetY: CGFloat = 0
    
    
    var lastRow : Int?      // for workout card table
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        let image1 = Asset.backgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)
        //print(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        //tableView.allowsSelection = false
        
        round = workout.rounds
        items = round.exercises
        lastRow = items.count * 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // x2 for "rest time"
        // Last cell is for segueing to Timer
        return (items.count * 2) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == lastRow {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: challengeCell, for: indexPath) as? ChallengeCell
                else {
                    //print(cell)
                    fatalError("cell is weird")
            }
            cell.backgroundColor  = .clear
            cell.layer.cornerRadius = 5
            
            //let exercise = items[indexPath.row/2]
            // TO DO: clean up the code
            cell.setRepeat(num: workout.numRounds)
            return cell
        } else {
            // even numbers of indexPath are workout
            // odds are for rests
            if indexPath.row % 2 == 0 {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: workoutCell, for: indexPath) as? WorkoutTableViewCell
                    else {
                        //print(cell)
                        fatalError("cell is weird")
                }
                // CONFIGURE EACH CARD
                let exercise = items[indexPath.row/2]
                cell.exerciseNumLabel.text = String(indexPath.row+1)
                cell.exerciseNameLabel.text = exercise.name.uppercased()
                cell.setSecLabel(num: round.setSec)
                //cell.layer.cornerRadius = 5
                return cell
            } else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: restCell, for: indexPath) as? RestCell
                    else {
                        //print(cell)
                        fatalError("cell is weird")
                }
                cell.setSecLabel(num: round.restSec)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 100
        } else if indexPath.row == lastRow {
            return 100
        } else {
            return 30
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // only acts for workout cells
        if indexPath.row % 2 == 0 {
            let exercise = items[indexPath.row/2]
            // TO DO: Slice the URL for faster launch
            var url = URL(string: "youtube://\(exercise.video)")!
            if !(UIApplication.shared.canOpenURL(url)) {
                url = URL(string: exercise.video)!
            }
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
            case "startWorkout":
                //print("start a new workout!")
                guard let Timer = segue.destination as? TimerViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                //Timer.workout = "working out"
                // Deliver ROUND info
                Timer.round = round
                Timer.numRounds = workout.numRounds
                Timer.workout = workout
            case "showInformation":
                break
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
}

// MARK: Helpers

extension DemoTableViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}

// MARK: Actions

extension DemoTableViewController {
    
    @IBAction func backButtonHandler(_: AnyObject) {
        // buttonAnimation
        let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate

extension DemoTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
            // buttonAnimation
            for case let viewController as DemoViewController in navigationController.viewControllers {
                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
                    rightButton.animationSelected(false)
                }
            }
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}
