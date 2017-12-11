//
//  RootPageViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 7/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList:[UIViewController] = {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        
        let ImagesVC = SB.instantiateViewController(withIdentifier: "ImagesVC")
        let VideosVC = SB.instantiateViewController(withIdentifier: "VideosVC")
        let NotesVC = SB.instantiateViewController(withIdentifier: "NotesVC")
        let ComentsVC = SB.instantiateViewController(withIdentifier: "ComentsVC")
        
        return [ImagesVC,VideosVC,NotesVC,ComentsVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.dataSource = self
        
        if let FirstVC = viewControllerList.first {
            self.setViewControllers([FirstVC], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let VCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = VCIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let VCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let NextIndex = VCIndex + 1
        
        guard viewControllerList.count != NextIndex else {return nil}
        
        guard viewControllerList.count > NextIndex else {return nil}
        
        return viewControllerList[NextIndex]
    }

}
