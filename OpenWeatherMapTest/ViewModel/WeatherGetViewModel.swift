//
//  WeatherViewModel.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import Foundation
import RxSwift
import RxRelay

protocol WeatherGetViewModelType {
    /// request
    var request: PublishRelay<(Int?)> { get }
    /// response
    var response: PublishRelay<OpenWeatherResponse?> { get }
    /// error
    var error: PublishRelay<(Int, String)> { get }
    
    var failure: PublishRelay<(Int, String)> { get }
}


class WeatherGetViewModel: WeatherGetViewModelType {
    var request: PublishRelay<(Int?)> = PublishRelay()
    var response: PublishRelay<OpenWeatherResponse?> = PublishRelay()
    var error: PublishRelay<(Int, String)> = PublishRelay()
    var failure: PublishRelay<(Int, String)> = PublishRelay()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(){
        setRxBinding()
    }
}

extension WeatherGetViewModel {
    private func setRxBinding(){
        request.flatMapLatest({(id) -> Observable<Result<OpenWeatherResponse,Error>> in
            
            let params : [String : String] = [ "id" : String(id ?? 0),
                                               "units" : ServerConfig.WEATHER_UNITS,
                                               "appid" : ServerConfig.WEATHER_API_KEY
            ]
            
            return APIService.fetch(params)
        })
        .subscribe(onNext: { [weak self] (result: Result<OpenWeatherResponse, Error>) in
            switch result {
            case .success(let value) :
                guard let this = self else { return }
                this.response.accept(value)
                break
            case .failure(let error) :
                self?.error.accept((0,error.localizedDescription))
                break
            }
        }, onError: {[weak self] error in
            self?.error.accept((0,error.localizedDescription))
        })
        .disposed(by: disposeBag)

    
    }
}



