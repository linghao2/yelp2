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
        
        // Yelp search
        searchBusiness("Thai")
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        let filterVC = vc.topViewController as! FilterViewController
        filterVC.delegate = self
    }
    
    // MARK: FilterViewController
    func filterViewController(filterViewController: FilterViewController, filter: [String : AnyObject]) {
        print(filter)
        let offer = filter["offer"] as? Bool
        let categories = filter["category"] as? [String]
        let sortBy = filter["sortBy"] as? YelpSortMode
        Business.searchWithTerm(term: "Restaurant", sort: sortBy, categories: categories, deals: offer) { (businesses: [Business]?, error:Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
