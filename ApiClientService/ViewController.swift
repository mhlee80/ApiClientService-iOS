//
//  ViewController.swift
//  ApiClientService
//
//  Created by mhlee on 2020/03/20.
//  Copyright © 2020 mhlee. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ObjectMapper

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  private lazy var titleLabel: UILabel = {
    let v = UILabel()
    v.backgroundColor = .white
    v.textColor = .black
    v.font = .systemFont(ofSize: 48)
    v.text = "ApiClientService"
    return v
  }()
  
  private lazy var helloWorldButton: UIButton = {
    let v = UIButton()
    v.backgroundColor = .white
    v.layer.borderWidth = 1
    v.layer.cornerRadius = 24
    v.layer.borderColor = UIColor.black.cgColor
    v.setTitleColor(.black, for: .normal)
    v.titleLabel?.font = .systemFont(ofSize: 20)
    v.setTitle("Hello World", for: .normal)
    return v
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.backgroundColor = .white
    
    view.addSubview(titleLabel)
    view.addSubview(helloWorldButton)
    
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(100)
    }
    
    helloWorldButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.size.equalTo(CGSize(width: 260, height: 48))
    }
    
    helloWorldButton.rx.tap.flatMap {
      ApiClientService.RxRequest<HelloWorld>.create("https://helloworld-api-v1.dev.playground.wiwa.io/hello")
    }.subscribe(onNext: { helloWorld in
      log.info("\(helloWorld.message)")
    }, onError: { error in
      
    }).disposed(by: disposeBag)
  }
}

class HelloWorld: Mappable {
  var message: String = ""
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    message         <- map["message"]
  }
}
