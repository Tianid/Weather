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
    private var filteredItems = [CityModel]()
    
    var filteredCityItems = PublishSubject<[CityModel]>()
    var searchValue = PublishSubject<String>()
    
    init() {
        configureRx()
    }
    
    private func configureRx() {
        searchValue
            .asObserver()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .observe(on: SerialDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { (value) in
                if !value.isEmpty {
                    
                    if self.filteredItems.isEmpty {
                        self.filteredItems = self.items.filter {
                            return $0.name.lowercased().contains(value.lowercased())
                        }
                    } else {
                        self.filteredItems = self.filteredItems.filter {
                            return $0.name.lowercased().contains(value.lowercased())
                        }
                    }
                    
                    self.filteredCityItems.onNext(self.filteredItems)
                } else {
                    self.filteredCityItems.onNext(self.items)
                    self.filteredItems = []
                }
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })

        .disposed(by: disposeBag)
    }
    
    func refreshDataToDefault() {
        filteredCityItems.onNext(items)
    }
}
