//
//  ViewController.swift
//  Weather
//
//  Created by Tianid on 27.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listButton: UIButton!
    private var refreshControll = UIRefreshControl()
    
    var viewModel: WeatherMainViewModel = WeatherMainViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        let userDefaults = UserDefaults.standard
        
        if let value = userDefaults.string(forKey: "cityName") {
            viewModel.loadDataFromNetwork(cityName: value, numberOfDays: 0)
        }
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControll
        
        if #available(iOS 13, *) {
            
        } else {
            listButton.backgroundColor = .red
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func setupBindings() {
        tableView.register(UINib(nibName: "\(WeatherTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "Cell")
        
        viewModel
            .filteredModels
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: WeatherTableViewCell.self)) { row, element, cell in
                let date = Date(timeIntervalSince1970: element.dt.timeIntervalSinceReferenceDate)
                let value = CustomDateFormatter.makeFormattedDateString(date: date, type: .HoursMinutes)
                cell.dayOfWeekLabel.text =  value
                let count = element.weather.count - 1
                cell.weatherImageView.image = UIImage(named: element.weather[count].getImageName())
                cell.degreesLabel.text = "\(String(element.main.temp)) °C"
        }
        .disposed(by: disposeBag)
        
        segmentedControl.rx.value.asDriver().drive(onNext: { value in
            self.dateLabel.text = String(value)
            self.viewModel.parceModelByDays(numberOfDays: value)
        }).disposed(by: disposeBag)
        
        viewModel
            .dateLabelData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.dateLabel.isHidden = false
                self.dateLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel
            .cityLabelData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.cityNameLabel.isHidden = false
                self.cityNameLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel
            .segments
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                
                let numberOfPotentialSegments = $0.count
                let currentNumberOfSegments = self.segmentedControl.numberOfSegments
                
                if numberOfPotentialSegments > currentNumberOfSegments {
                    self.segmentedControl.insertSegment(withTitle: "", at: currentNumberOfSegments, animated: true)
                } else if numberOfPotentialSegments < currentNumberOfSegments {
                    self.segmentedControl.removeSegment(at: numberOfPotentialSegments, animated: true)
                }
                
                for (key, name) in $0.enumerated() {
                    self.segmentedControl.setTitle(name, forSegmentAt: key)
                }
                
                self.segmentedControl.isHidden = false
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.view.layoutIfNeeded()
//                })
            })
            .disposed(by: disposeBag)
        
        refreshControll.rx.controlEvent(.valueChanged).bind(onNext: {
            self.viewModel.loadDataFromNetwork(cityName: self.viewModel.curentCity?.name ?? "", numberOfDays: self.segmentedControl.selectedSegmentIndex)
        }).disposed(by: disposeBag)
        
        viewModel.isPullRefreshing.observe(on: MainScheduler.instance).bind(to: refreshControll.rx.isRefreshing).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citySelection" {
            guard let nav = segue.destination as? UINavigationController else { return }
            guard let citySelectionVC = nav.viewControllers.first as? CitySelectionVC else { return }
            citySelectionVC.backAction = {
                self.viewModel.curentCity = $0
                self.viewModel.cityLabelData.onNext($0.name)
                let index = self.segmentedControl.selectedSegmentIndex
                self.viewModel.loadDataFromNetwork(cityName: $0.name, numberOfDays: index)
            }
        }
    }
}

