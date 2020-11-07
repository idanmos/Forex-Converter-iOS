//
//  FeedTableViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 04/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import SafariServices
import GoogleMobileAds

class FeedTableViewController: ForexConverterTableViewController {
        
    private lazy var feedViewModel: FeedViewModel = {
        let viewModel = FeedViewModel()
        return viewModel
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "משוך לרענון")
        control.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        return control
    }()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "חדשות כלכלה"
        
        self.tableView.register(UINib(nibName: FeedTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        self.refreshControl = self.refresh
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.fetchData()
        
        let bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        bannerView.adUnitID = Constants.GoogleAdMob_AdUnitId_Banner
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        self.tableView.tableHeaderView = bannerView
        
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.fetchData), userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - General methods
    
    @objc private func fetchData() {
        debugPrint(#file, #function)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.feedViewModel.fetchRSS {  [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedViewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        let item: RSSItem = self.feedViewModel.items[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item: RSSItem = self.feedViewModel.items[indexPath.row]

        let url = URL(string: item.link)!
        let safariViewController = SFSafariViewController(url:url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
