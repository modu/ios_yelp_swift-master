//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

//UISearchResultsUpdating
class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UISearchResultsUpdating {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData: [String]!

    var searchController: UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        //searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        // By default the navigation bar hides when presenting the
        // search interface.  Obviously we don't want this to happen if
        // our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
        // Hide HUD once network request comes back (must be done on main UI thread)
        MBProgressHUD.hideHUDForView(self.view, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
                return businesses!.count
        }
        else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row] /*Crash here array index out of range*/
        return cell
    }
 
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        if let searchText = searchController.searchBar.text {
//            Business.searchWithTerm(searchText, sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//                self.businesses = businesses
//                NSLog("Hi in search ")
//            }
            Business.searchWithTerm(searchText, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                
                self.tableView.reloadData()
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            })
//            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
//                return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//            })
            // Hide HUD once network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
