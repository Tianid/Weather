//
//  TestViewModel.swift
//  Weather
//
//  Created by Tianid on 27.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class TestViewModel {
    private let disposeBag = DisposeBag()
    private var model: [WeatherBundle]?
    private var isNeedExtraNumber = false
    
    var filteredModels = PublishSubject<[WeatherBundle]>()
    var dateLabelData: BehaviorSubject<String>
    var daysofWeekData = PublishSubject<[String]>()
    var segments = PublishSubject<[String]>()
    var isPullRefreshing = PublishSubject<Bool>()
    
    init() {
        dateLabelData = BehaviorSubject<String>(value: "")
    }
    
    func loadDataFromNetwork() {
        NetworkManager.makeRequest(cityName: "Moscow", method: .get, successor: {
            guard !$0.list.isEmpty else { return }
            self.model = $0.list
            self.parceModelByDays(numberOfDays: 0)
            self.parceDaysOfWeek()
            self.isPullRefreshing.onNext(false)
        }, failire: {
            self.isPullRefreshing.onNext(false)
        })
    }
    
    func parceModelByDays(numberOfDays: Int) {
        guard let model = model else { return }
        var extraNumber = isNeedExtraNumber ? 1 : 0
        var filtered = filterModel(model: model, numberOfDays: numberOfDays + extraNumber)
        if filtered.isEmpty {
            isNeedExtraNumber = true
            extraNumber = 1
            filtered = filterModel(model: model, numberOfDays: numberOfDays + extraNumber)
        }
        
        filteredModels.onNext(filtered)
        guard let element = filtered.first else { return }
        let date = Date(timeIntervalSince1970: element.dt.timeIntervalSinceReferenceDate)
        let value = CustomDateFormatter.makeFormattedDateString(date: date, type: .MonthDayYear)
        dateLabelData.onNext(value)
    }
    
    func parceDaysOfWeek() {
        var daysOfWeekArray:[String] = []
        model?.forEach({ element in
            let date = Date(timeIntervalSince1970: element.dt.timeIntervalSinceReferenceDate)
            let value = CustomDateFormatter.makeFormattedDateString(date: date, type: .DayOfWeekShort)
            
            if !daysOfWeekArray.contains(value) {
                daysOfWeekArray.append(value)
            }
        })
        
        daysofWeekData.onNext(daysOfWeekArray)
        segments.onNext(daysOfWeekArray)
    }
    
    func filterModel(model: [WeatherBundle], numberOfDays: Int) -> [WeatherBundle] {
        let filtered = model.filter({ element in
            let dateAfter = Date.dateAfter(numberOfDays: numberOfDays)
            let elementDate = Date(timeIntervalSince1970: element.dt.timeIntervalSinceReferenceDate)
            
            return elementDate >= dateAfter.start && elementDate <= dateAfter.end
        })
        
        return filtered
    }
}
