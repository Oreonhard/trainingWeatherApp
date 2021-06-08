//
//  SearchResultTableViewController.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/04/18.
//  Copyright © 2021 최준찬. All rights reserved.
//

import UIKit
import MapKit

class SearchResultTableViewController : UITableViewController {
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults  = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MKLocalSearch(request: .init(completion: searchResults[indexPath.row])).start(completionHandler: { (result, error)  in
            guard error == nil,let placeMark = result?.mapItems[0].placemark else {
                let alertController = UIAlertController(title: "trainingWeatherApp", message: "정보를 가져오는 중 오류가 발생했습니다.", preferredStyle: .alert)
                alertController.addAction(.init(title: "확인", style: .default, handler: nil))
                DispatchQueue.main.async(execute: {
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }
            NotificationCenter.default.post(name: .init("selectRegion"), object: placeMark)
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension SearchResultTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text , text != "" {
            searchCompleter.queryFragment = text
        } else {
            searchResults.removeAll()
            self.tableView.reloadData()
        }
    }
}

extension SearchResultTableViewController : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.tableView.reloadData()
    }
}
