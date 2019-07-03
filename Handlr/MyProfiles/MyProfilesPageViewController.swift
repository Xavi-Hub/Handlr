//
//  MyProfilesPageViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit
import CoreData

class MyProfilesPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    var startIndex = 0
    var currentIndex: Int?
    var pendingIndex: Int?
    var profilesData: [ProfileData]!
    var profileViewControllers = [MyProfileViewController]()
    var addButton: UIBarButtonItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupViews()
        
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addProfile))
        
        navigationItem.rightBarButtonItems = [addButton,editButtonItem]
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
        if profileViewControllers.isEmpty {
            setViewControllers([NoProfilesViewController()], direction: .forward, animated: false, completion: nil)
        } else {
            setViewControllers([(profileViewControllers[startIndex])], direction: .forward, animated: false, completion: nil)
        }
        
        
        pageControl.numberOfPages = profileViewControllers.count
        pageControl.currentPage = startIndex

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = viewControllers {
            if viewControllers.count > 0 {
                if let profileVC = viewControllers[0] as? MyProfileViewController {
                    startIndex = profileViewControllers.firstIndex(of: profileVC) ?? 0
                    return
                }
            }
        }
        startIndex = 0
    }
    
    func fetchData() {
        let request: NSFetchRequest<ProfileData> = NSFetchRequest<ProfileData>(entityName: "ProfileData")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isMine = %d", true)
        request.predicate = predicate
        profilesData = try? AppDelegate.viewContext.fetch(request)
        print(profilesData.count)
        profileViewControllers = []
        for profile in profilesData ?? [ProfileData]() {
            let profileVC = MyProfileViewController(profileData: profile)
            profileViewControllers.append(profileVC)
        }
    }
    
    func setupViews() {
        
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        for vc in profileViewControllers {
            vc.setEditing(editing, animated: animated)
        }
    }
    
    @objc func addProfile() {
        let profileData = NSEntityDescription.insertNewObject(forEntityName: "ProfileData", into: AppDelegate.viewContext) as! ProfileData
        profileData.isMine = true
        profileData.order = Int16(profileViewControllers.count)
        profileData.profile = Profile(name: "Xavi Anderhub", ins: ["XaviHub"], sna: ["Xavi-Hub"], pho: ["214-926-7723"])
        try? AppDelegate.viewContext.save()
        profilesData.append(profileData)
        profileViewControllers.append(MyProfileViewController(profileData: profileData))
        pageControl.numberOfPages += 1
        setViewControllers([profileViewControllers.last!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let _ = viewController as? MyProfileViewController else { return nil }
        guard let viewControllerIndex = profileViewControllers.firstIndex(of: viewController as! MyProfileViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard profileViewControllers.count > previousIndex else {
            return nil
        }
        
        return profileViewControllers[previousIndex]

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let _ = viewController as? MyProfileViewController else { return nil }
        guard let viewControllerIndex = profileViewControllers.firstIndex(of: viewController as! MyProfileViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = profileViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return profileViewControllers[nextIndex]

    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = profileViewControllers.firstIndex(of: pendingViewControllers.first! as! MyProfileViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            pageControl.currentPage = currentIndex!
        }
    }

    
}
