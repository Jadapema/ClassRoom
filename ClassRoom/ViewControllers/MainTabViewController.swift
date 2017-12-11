//
//  MainTabViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 10/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("tabbar")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UserDefaults.standard.removeObject(forKey: "Topics")
        UserDefaults.standard.removeObject(forKey: "Members")
        UserDefaults.standard.removeObject(forKey: "SubjectName")
        UserDefaults.standard.removeObject(forKey: "SelectedUniversityPosition")
        UserDefaults.standard.removeObject(forKey: "SelectedYearPosition")
        UserDefaults.standard.removeObject(forKey: "SubjectDescription")
        UserDefaults.standard.removeObject(forKey: "GroupName")
        UserDefaults.standard.removeObject(forKey: "TeacherName")
        UserDefaults.standard.synchronize()
    }

}
