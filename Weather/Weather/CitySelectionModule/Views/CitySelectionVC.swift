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
    
    var backAction: ((CityModel) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var searchBarController: UISearchController!
    
    private let viewModel = CitySelectionViewModel()
    private let disposeBag = DisposeBag()
    
    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.definesPresentationContext = true
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
                
                cell.textLabel?.text = element.presentName
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CityModel.self).subscribe(onNext: {
            print($0.presentName)
            self.searchController.isActive = false
            self.saveToUD(model: $0)
            self.dismiss(animated: true)
            self.backAction!($0)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: {
            self.tableView.deselectRow(at: $0, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private func saveToUD(model: CityModel) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(model.name, forKey: "cityName")
        userDefaults.set(model.id, forKey: "cityKey")
    }
}
