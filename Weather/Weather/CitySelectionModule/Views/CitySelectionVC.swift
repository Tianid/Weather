//
//  CitySelectionVC.swift
//  Weather
//
//  Created by Tianid on 30.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import UIKit
import RxSwift

class CitySelectionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBarController: UISearchController!
    
    private let viewModel = CitySelectionViewModel()
    private let disposeBag = DisposeBag()
    
    private var searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.placeholder = "Search city..."
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = UIView()

        configureBindings()
        viewModel.refreshDataToDefault()
    }
    
    private func configureBindings() {
        searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        
        viewModel
            .filteredCityItems
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                
                cell.textLabel?.text = element.name
        }
        .disposed(by: disposeBag)
    }
}
