//
//  MyProfilesPageViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfilesPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }

    
}
