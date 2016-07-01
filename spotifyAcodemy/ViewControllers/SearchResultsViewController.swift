//
//  SearchResultsViewController.swift
//
//
//  Created by Piotr Dudek on 28/06/16.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

protocol SearchResultsViewControllerDelegate: class {
    func didSelectResult(viewController: SearchResultsViewController, result: String)
}

class SearchResultsViewController: UIViewController {
    
    // MARK: Properties
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var tableView = UITableView()
    private var searchHistory = [String]()
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 45);
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        tableView.separatorStyle = .None
        
        let footerview = UIView()
        tableView.tableFooterView = footerview
        tableView.setTableViewBackgroundGradient(UIColor.darklyDark(), UIColor.blackColor())
        tableView.addNib(CustomCell.LastSearchTableViewCell)
    }
}

// MARK: UITableViewDataSource

extension SearchResultsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.LastSearchTableViewCell.rawValue, forIndexPath: indexPath) as! LastSearchTableViewCell
        cell.searchLabel.text = searchHistory[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
}

// MARK: UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectResult(self, result: searchHistory[indexPath.row])
        view.hidden = true
    }
}

// MARK: UISearchResultsUpdating

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        view.hidden = false
        
        let latestSearchHistory = LastQueries.getLastQueries()
        guard searchHistory != latestSearchHistory else { return }
        searchHistory = latestSearchHistory
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        view.hidden = true
        guard let text = searchBar.text else { return }
        delegate?.didSelectResult(self, result: text)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
