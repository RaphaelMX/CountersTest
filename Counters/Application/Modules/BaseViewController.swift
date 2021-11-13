//
//  BaseViewController.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
    }
}

// MARK: - Public functions

extension BaseViewController {
    func setupLargeTitle(with text: String, searchUpdater: UISearchBarDelegate? = nil) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = text
        
        if let delegate = searchUpdater {
            let search = UISearchController()
            search.searchBar.delegate = delegate
            search.searchBar.returnKeyType = .done
            search.searchBar.isTranslucent = false
            navigationItem.searchController = search
        }
    }
    
    func showAlert(message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: "Counters", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
