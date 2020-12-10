//
//  SchedulingViewController.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

protocol SurgeryInfoUpdater{
    func updateSurgeryInfo(newInfo: LocalSurgeryInfo, nextIndex: Int)
    func getCurrentInfo() -> LocalSurgeryInfo
}

class SchedulingPageController: UIPageViewController, SurgeryInfoUpdater{

    var surgeryInfo:LocalSurgeryInfo

    var surgeryListUpdater:SurgeryListLocalUpdater?
    
    required init?(coder: NSCoder) {
        surgeryInfo = LocalSurgeryInfo()
        
        super.init(coder: coder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
    
    func updateSurgeryInfo(newInfo: LocalSurgeryInfo, nextIndex:Int) {
        print("newInfo =")
        print(newInfo)
        surgeryInfo = newInfo
        
        setViewControllers([orderedViewControllers[nextIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    func getCurrentInfo() -> LocalSurgeryInfo{
        return surgeryInfo
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewController("Hospital", nextIndex: 1),
            self.newViewController("PatientID", nextIndex: 2),
            self.newViewController("Procedure", nextIndex: 3),
            self.newViewController("SurgeryDate", nextIndex: 4),
//            self.newViewController("Implants"),
//            self.newViewController("Requests"),
//            self.newViewController("Notes"),
//            self.newViewController("Photo"),
            self.newViewController("Confirmation", nextIndex: -1)]
    }()

    private func newViewController(_ id: String, nextIndex: Int) -> UIViewController {
        if id == "SurgeryDate"{
            guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
                .instantiateViewController(withIdentifier: "\(id)VC") as? SurgeryDatePickerVC else{
                fatalError("could not set delegate of \(id)VC")
            }
            vc.surgeryInfoUpdater = self
            vc.surgeryListUpdater = surgeryListUpdater
            vc.id = id
            vc.nextIndex = nextIndex
            return vc
        }
        guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "\(id)VC") as? SchedulingItemVC else{
            fatalError("could not set delegate of \(id)VC")
        }
        vc.surgeryInfoUpdater = self
        vc.surgeryListUpdater = surgeryListUpdater
        vc.id = id
        vc.nextIndex = nextIndex
        return vc
    }

}

extension SchedulingPageController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        

        guard let vcIndex = orderedViewControllers.firstIndex(of: previousViewControllers[0]) else {
            print("could not find vc")
            return
        }
        guard let vc = orderedViewControllers[vcIndex] as? SchedulingItemVC else {
            print("could not convert to SchedulingItemVC")
            return
        }
    }
}

extension SchedulingPageController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
            
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
           return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
   
}
