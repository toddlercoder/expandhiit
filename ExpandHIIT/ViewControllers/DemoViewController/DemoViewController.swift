//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Kingfisher

class DemoViewController: ExpandingViewController {

    // MARK - Properties
    var imgs = ["item0", "item1", "item2", "item3"]  // DELETE
    
    fileprivate var cellsIsOpen = [Bool]()
    var items = [Workout]()
    @IBOutlet var pageLabel: UILabel!
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        
        registerCell()
        addGesture(to: collectionView!)
        configureNavBar()
        getWorkout()
        //WorkoutService.create()
    }
    
    @objc func getWorkout() {
        WorkoutService.get { (workouts: [Workout]) in
            self.items = workouts
            self.fillCellIsOpenArray()
            self.collectionView?.reloadData()
            self.pageLabel.text = "1/\(self.items.count)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getWorkout()        // figure out how to get just the numbers updated
    }
}

// MARK: - Lifecycle 🌎

extension DemoViewController {
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
    }
}

// MARK: Helpers

extension DemoViewController {

    fileprivate func registerCell() {

        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
    }

    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }

    fileprivate func getViewController(workout: Workout) -> ExpandingTableViewController {
    //fileprivate func getViewController() -> UICollectionViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: DemoTableViewController = storyboard.instantiateViewController()  //
        
        toViewController.workout = workout
        
        return toViewController
    }

    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}

/// MARK: Gesture
extension DemoViewController {

    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }

        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }

    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController(workout: cell.workout))

            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate

extension DemoViewController {

    func scrollViewDidScroll(_: UIScrollView) {
        pageLabel.text = "\(currentIndex + 1)/\(items.count)"
    }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }

        let index = indexPath.row % items.count
        let info = items[index]
        // ALL THE SAME IMAGES FOR NOW
        let imageURL = URL(string: info.img)
        cell.backgroundImageView?.kf.setImage(with: imageURL)
        cell.customTitle.text = info.title
        // ALL THE SAME INSTRUCTURE for now
        cell.instructor.text = "by \(info.instructor)"
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numAttempts = numberFormatter.string(from: NSNumber(value: info.numAttempts))!
        let numCompletion = numberFormatter.string(from: NSNumber(value: info.numCompletion))!
        cell.numChallengeLabel.text = String(describing: numAttempts)
        cell.numCompletedLabel.text = String(describing: numCompletion)
        
        cell.workout = info
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            //let vc = MelodyTableViewController()
            //pushToViewController(MelodyTableViewController())
            
            pushToViewController(getViewController(workout: cell.workout))

            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {

}
