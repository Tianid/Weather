//
//  CitySelectionViewModel.swift
//  Weather
//
//  Created by Tianid on 30.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation
import RxSwift

class CitySelectionViewModel {
    private let disposeBag = DisposeBag()
    private let cityItems = [CityModel]()
    
    private let items: [CityModel] = [CityModel(id: 0, name: "1"),
                                      CityModel(id: 1, name: "2"),
                                      CityModel(id: 3, name: "3"),
                                      CityModel(id: 4, name: "4"),
                                      CityModel(id: 5, name: "5"),
    ]
    
    var filteredCityItems = PublishSubject<[CityModel]>()
    var searchValue = PublishSubject<String>()
    
    init() {
        configureRx()
    }
    
    private func configureRx() {
         searchValue
             .asObserver()
             .subscribe { (value) in
                 var filteredItems: [CityModel] = self.items
                 if !value.element!.isEmpty {
                     filteredItems = self.items.filter {
                         $0.name.lowercased() == value.element?.lowercased()
                     }
                 }
                 self.filteredCityItems.onNext(filteredItems)

         }
         .disposed(by: disposeBag)
    }
    
    
    func refreshDataToDefault() {
        filteredCityItems.onNext(items)
    }
}
