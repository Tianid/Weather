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
    
    @IBOutlet weak var label: UILabel!
    @IBAction func buttonAction(_ sender: UIButton) {
        viewModel.testText.onNext("\(Int.random(in: 0...100))")
    }
    
    
    
    var viewModel: TestViewModel = TestViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.loadDataFromNetwork()
        // Do any additional setup after loading the view.
    }
    
    private func setupBindings() {
        viewModel
            .testText
            .observe(on: MainScheduler.instance)
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }


}

