//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var searchBar = UISearchBar()
    
    var businesses: [Business]!
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var savedFilter: [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // automatically resize rows - make sure there is a bottom pin
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // searchBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        
        // infinite scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Yelp search
        searchBusiness("Thai")
    }
    
    func searchBusiness(_ term: String) {
        Business.searchWithTerm(term: term) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
        
    // MARK: - UITableView
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    // MARK: - UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBusiness(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: UISrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollContentHeight - tableView.bounds.height
            if tableView.contentOffset.y > scrollOffsetThreshold {
                if tableView.isDragging {
                    isMoreDataLoading = true
                    
                    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                    loadingMoreView!.frame = frame
                    loadingMoreView!.startAnimating()
                    
                    loadMoreData()
                    print("loadMoreData")
                } else {
                    print("here!!!")
                }
            }
        }
    }
    
    func loadMoreData() {
        if let filter = savedFilter {
            let offer = filter["offer"] as? Bool
            let categories = filter["category"] as? [String]
            let sortBy = filter["sortBy"] as? YelpSortMode
            savedFilter = filter
            Business.searchWithTerm(term: "Restaurant", sort: sortBy, categories: categories, deals: offer, offset: businesses.count) { (businesses: [Business]?, error:Error?) in
                self.isMoreDataLoading = false
                
                self.loadingMoreView!.stopAnimating()
                
                self.businesses! += businesses!
                self.tableView.reloadData()
            }
        } else {
            Business.searchWithTerm(term: "Thai", offset: businesses.count) { (businesses: [Business]?, error: Error?) in
                self.isMoreDataLoading = false
                
                self.loadingMoreView!.stopAnimating()
                
                self.businesses! += businesses!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        let filterVC = vc.topViewController as! FilterViewController
        filterVC.delegate = self
    }
    
    // MARK: FilterViewController
    
    func filterViewController(filterViewController: FilterViewController, filter: [String : AnyObject]) {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        
        let offer = filter["offer"] as? Bool
        let categories = filter["category"] as? [String]
        let sortBy = filter["sortBy"] as? YelpSortMode
        savedFilter = filter
        Business.searchWithTerm(term: "Restaurant", sort: sortBy, categories: categories, deals: offer) { (businesses: [Business]?, error:Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
