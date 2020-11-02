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
    
    private let items: [CityModel] = ModelExtractor.shared.model
    
    var filteredCityItems = PublishSubject<[CityModel]>()
    var searchValue = PublishSubject<String>()
    
    init() {
        configureRx()
    }
    
    private func configureRx() {
        searchValue
            .asObserver()
            .subscribe(onNext: { (value) in
                var filteredItems: [CityModel] = self.items
                if !value.isEmpty {
                    filteredItems = self.items.filter {
                        return $0.name.lowercased().contains(value.lowercased())
                    }
                }
                self.filteredCityItems.onNext(filteredItems)
            }, onError: { (error) in
                print(error)
            })
        .disposed(by: disposeBag)
    }
    
    
    func refreshDataToDefault() {
        filteredCityItems.onNext(items)
    }
}
