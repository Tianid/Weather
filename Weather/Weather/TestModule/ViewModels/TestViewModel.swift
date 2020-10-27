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
    
    var testText = PublishSubject<String?>()
}
