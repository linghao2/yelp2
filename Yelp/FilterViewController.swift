//
//  FiltersViewController.swift
//  Yelp
//
//  Created by LING HAO on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum RadioType: Int {
    case RadioCollapsed=0, RadioSelected, RadioUnselected
}

@objc protocol FilterViewControllerDelegate: class {
    @objc optional func filterViewController(filterViewController: FilterViewController, filter: [String : AnyObject])
}
class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet var tableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate?
    
    // offer
    var offer: Bool = false
    
    // distance 
    let distanceOptions = ["Auto", "0.3 mile", "1 mile", "5 miles", "10 miles"]
    var distanceSelection = 0
    var distanceStyle = true
    
    // sort by
    let sortByOptions = ["Best Match", "Distance", "Highest Rated"]
    var sortBySelection = 0
    var sortByStyle = true
    
    // category
    let categoryOptions: [Dictionary<String, String>] = [
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "Chinese", "code": "chinese"],
        ["name" : "French", "code": "french"],
        ["name" : "Korean", "code": "korean"],
        ["name" : "Vegetarian", "code": "vegetarian"]]
    var categorySelection: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if distanceStyle {
                return 1
            } else {
                return distanceOptions.count
            }
        case 2:
            if sortByStyle {
                return 1
            } else {
                return sortByOptions.count
            }
        case 3:
            return categoryOptions.count
       default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            cell.label = "Offering a Deal"
            cell.onSwitch = offer
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as! RadioCell
            cell.selectionStyle = .none
            if distanceStyle {
                cell.label = distanceOptions[distanceSelection]
                cell.type = .RadioCollapsed
            } else {
                cell.label = distanceOptions[indexPath.row]
                cell.type = indexPath.row == distanceSelection ? .RadioSelected : .RadioUnselected
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as! RadioCell
            cell.selectionStyle = .none
            if sortByStyle {
                cell.label = sortByOptions[sortBySelection]
                cell.type = .RadioCollapsed
            } else {
                cell.label = sortByOptions[indexPath.row]
                if indexPath.row == sortBySelection {
                    cell.type = .RadioSelected
                } else {
                    cell.type = .RadioUnselected
                }
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            let category = categoryOptions[indexPath.row]
            cell.label = category["name"]!
            cell.onSwitch = categorySelection.contains(indexPath.row)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Category"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if !distanceStyle {
                distanceSelection = indexPath.row
            }
            distanceStyle = !distanceStyle
            let indexSet: IndexSet = [indexPath.section]
            tableView.reloadSections(indexSet, with: .none)
        case 2:
            if !sortByStyle {
                sortBySelection = indexPath.row
            }
            sortByStyle = !sortByStyle
            let indexSet: IndexSet = [indexPath.section]
            tableView.reloadSections(indexSet, with: .none)
        default:
            break
        }
    }
    
    // MARK: - SwitchCell
    func switchCell(switchCell: SwitchCell, didClickSwitch switchOn: Bool) {
        if let indexPath = tableView.indexPath(for: switchCell) {
            switch indexPath.section {
            case 0:
                offer = switchOn
                print("offer is \(offer)")
            case 3:
                if switchOn {
                    categorySelection.append(indexPath.row)
                } else {
                    if let index = categorySelection.index(of: indexPath.row) {
                        categorySelection.remove(at: index)
                    }
                }
            default:
                break
            }
        }
    }

    
    // MARK: - Actions

    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    func convertSortBy(_ selection: Int) -> YelpSortMode? {
        switch selection {
        case 0:
            return YelpSortMode.bestMatched
        case 1:
            return YelpSortMode.distance
        default:
            return YelpSortMode.highestRated
        }
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        var filter: [String : AnyObject] = [String : AnyObject]()
        filter["offer"] = offer as AnyObject?
        filter["sortBy"] = convertSortBy(sortBySelection) as AnyObject?
        var categories = [String]()
        for index in categorySelection {
            categories.append(categoryOptions[index]["code"]!)
        }
        filter["category"] = categories as AnyObject?
        delegate?.filterViewController?(filterViewController: self, filter: filter)
        
        self.dismiss(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
