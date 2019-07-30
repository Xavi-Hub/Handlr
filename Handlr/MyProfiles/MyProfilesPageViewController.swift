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
    var addButton: UIBarButtonItem! = nil
    var saveButton = UIBarButtonItem()
    var cancelButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEditing))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
        
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        
        dataSource = self
        delegate = self
        
        setupViews()
        
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addProfile))
        
        navigationItem.rightBarButtonItems = [editButtonItem]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
        if profilesData.isEmpty {
            setViewControllers([NoProfilesViewController()], direction: .forward, animated: false, completion: nil)
        } else {
            setViewControllers([MyProfileViewController(profileData: profilesData[startIndex])], direction: .forward, animated: false, completion: nil)
        }
        
        
        pageControl.numberOfPages = profilesData.count
        pageControl.currentPage = startIndex

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = viewControllers {
            if viewControllers.count > 0 {
                if let profileVC = viewControllers[0] as? MyProfileViewController {
                    startIndex = profilesData.firstIndex(of: profileVC.profileData) ?? 0
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
        
        if editing {
            navigationItem.rightBarButtonItems = [saveButton, addButton]
            navigationItem.leftBarButtonItem = cancelButton
        } else {
            fetchData()
            pageControl.numberOfPages = profilesData.count
            if currentIndex ?? 0 > profilesData.count - 1 {
                currentIndex = (profilesData.count - 1) < 0 ? 0 : profilesData.count - 1
            }
            pageControl.currentPage = currentIndex ?? 0
            if profilesData.count > 0 {
                setViewControllers([MyProfileViewController(profileData: profilesData[currentIndex ?? 0])], direction: .reverse, animated: false, completion: nil)
            } else {
                setViewControllers([NoProfilesViewController()], direction: .reverse, animated: false, completion: nil)
            }
            navigationItem.rightBarButtonItems = [editButtonItem]
            navigationItem.leftBarButtonItem = nil
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        
        if let profileVC = viewControllers![0] as? MyProfileViewController {
            profileVC.setEditing(editing, animated: animated)
        }

    }
    
    @objc func cancelEditing() {
        AppDelegate.viewContext.rollback()
        setEditing(false, animated: true)
    }
    
    @objc func saveEditing() {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error)
        }
        setEditing(false, animated: true)
    }
    
    @objc func addProfile() {
        let profileData = NSEntityDescription.insertNewObject(forEntityName: "ProfileData", into: AppDelegate.viewContext) as! ProfileData
        profileData.isMine = true
        profileData.order = Int16(profilesData.count)
        profileData.creationDate = Date()
        profilesData.append(profileData)
        pageControl.numberOfPages += 1
        let newVC = MyProfileViewController(profileData: profileData)
        newVC.setEditing(isEditing, animated: false)
        setViewControllers([newVC], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = pageControl.numberOfPages - 1
        currentIndex = pageControl.numberOfPages - 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MyProfileViewController else { return nil }
        guard let viewControllerIndex = profilesData.firstIndex(of: viewController.profileData) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard profilesData.count > previousIndex else {
            return nil
        }
        
        let newVC = MyProfileViewController(profileData: profilesData[previousIndex])
        newVC.setEditing(isEditing, animated: true)
        return newVC

    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MyProfileViewController else { return nil }
        guard let viewControllerIndex = profilesData.firstIndex(of: viewController.profileData) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let profilesCount = profilesData.count
        
        guard profilesCount != nextIndex else {
            return nil
        }
        
        guard profilesCount > nextIndex else {
            return nil
        }
        let newVC = MyProfileViewController(profileData: profilesData[nextIndex])
        newVC.setEditing(isEditing, animated: true)
        return newVC

    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = profilesData.firstIndex(of: (pendingViewControllers.first! as! MyProfileViewController).profileData)
        if let pendingVC = pendingViewControllers.first as? MyProfileViewController {
            if pendingVC.isEditing != isEditing {
                pendingVC.setEditing(isEditing, animated: true)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            pageControl.currentPage = currentIndex!
        }
    }

    
}
