//
//  WeatherViewModel.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/28.
//

import Foundation
import RxSwift
import RxRelay


protocol WeatherViewModelType {
    /// 서버로 부터 응답받은  데이터
    var request: PublishRelay<OpenWeatherResponse?> { get }
    
    var machingInfo: PublishRelay<[WeatherDetailInfo]?> { get }
}

class WeatherViewModel: WeatherViewModelType {
    var request: PublishRelay<OpenWeatherResponse?> = PublishRelay()
    var machingInfo: PublishRelay<[WeatherDetailInfo]?> = PublishRelay()
    private let disposeBag: DisposeBag = DisposeBag()
    

    init(){
        setRxBinding()
    }
}


extension WeatherViewModel {
    private func setRxBinding(){
        request.asObservable()
            .subscribe(onNext:{[weak self] (data: OpenWeatherResponse?) in
                guard let this = self else { return }
                var data = [WeatherDetailInfo(title: "wind", value: "\(data?.wind?.speed ?? 0)", unit: "m/s"),
                            WeatherDetailInfo(title: "pressure", value: "\(data?.main?.pressure ?? 0)", unit: "hPa"),
                            WeatherDetailInfo(title: "humidity", value: "\(data?.main?.humidity ?? 0)", unit: "%"),
                            WeatherDetailInfo(title: "sunrise", value: Date(timeIntervalSince1970: TimeInterval(data?.sys?.sunrise ?? 0)).string, unit: ""),
                            WeatherDetailInfo(title: "sunset", value: Date(timeIntervalSince1970: TimeInterval(data?.sys?.sunset ?? 0)).string, unit: "")]
                
                this.machingInfo.accept(data)
            })
            .disposed(by: disposeBag)
        
    }
}
