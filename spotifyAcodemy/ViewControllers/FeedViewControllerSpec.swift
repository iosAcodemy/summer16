//
//  FeedViewControllerSpec.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 23.06.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit

@testable
import spotifyAcodemy

class FeedViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: FeedViewController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Feed", bundle: nil)
            sut = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        }

        describe("navigation title") {
            it("should be set") {
                expect(sut.navigationItem.title).toNot(beNil())
            }
            it("should be 'Feed'") {
                expect(sut.navigationItem.title).to(equal("Feed"))
            }
        }
        
        describe("searchController") {
            var searchController: UISearchController!
            
            beforeEach {
                let _ = sut.view
                searchController = sut.searchController
            }
            it("should be set") {
                expect(searchController).toNot(beNil())
            }
            
            describe("search field") {
                context("when search button tapped") {
                    var searchBar: UISearchBar!
                    var searchResultVC: SearchResultsViewController!
                    
                    beforeEach {
                        searchBar = searchController.searchBar
                        searchResultVC = sut.searchResultsViewController
                        searchBar.text = "adele"
                    }
                    
                    it("should add query to the list") {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.removeObjectForKey("QueryArray")
                        let lastQueries = defaults.objectForKey("QueryArray") as? [String] ?? [String]()
                        
                         LastQueries.addQuery("adele")
                        let newQueries = defaults.objectForKey("QueryArray") as? [String] ?? [String]()
                         expect(newQueries.count) > lastQueries.count
                    }
                    
                    it("should reload table") {
                        let tableViewFake = UITableViewFake()
                        sut.tableView = tableViewFake
                        searchResultVC.searchBarSearchButtonClicked(searchBar)
                        expect(tableViewFake.reloadDataCalled).toEventually(equal(true))
                    }
                    
                    it("should populate table") {
                        searchResultVC.searchBarSearchButtonClicked(searchBar)
                        expect(sut.tableView.numberOfRowsInSection(0)).toEventually(beGreaterThan(0))
                        expect(sut.tableView.numberOfRowsInSection(1)).toEventually(beGreaterThan(0))
                        expect(sut.tableView.numberOfRowsInSection(2)).toEventually(beGreaterThan(0))
                    }
                    afterEach {
                        searchBar = nil
                        searchResultVC = nil
                    }
                }
            }
            afterEach {
                searchController = nil
            }
        }

        afterEach {
            sut = nil
        }
    }
}
