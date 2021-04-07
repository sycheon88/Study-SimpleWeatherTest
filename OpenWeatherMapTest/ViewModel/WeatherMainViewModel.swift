//
//  WeatherMainViewModel.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/28.
//

import Foundation
import RxSwift
import RxRelay

protocol WeatherMainViewModelType {
    /// 서버로 부터 응답받은  데이터
    var request: PublishRelay<OpenWeatherResponse?> { get }
    
    var descriptionText: BehaviorRelay<String> { get }
    var weatherMainText: BehaviorRelay<String> { get }
    var tempText: BehaviorRelay<String> { get }
    var feelLikeText: BehaviorRelay<String> { get }
    var iconImage: BehaviorRelay<UIImage?> { get }
    
}

class WeatherMainViewModel: WeatherMainViewModelType {
    var request: PublishRelay<OpenWeatherResponse?> = PublishRelay()
    var descriptionText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var weatherMainText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var tempText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var feelLikeText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var iconImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()
    

    init(){
        setRxBinding()
    }
}


extension WeatherMainViewModel {
    private func setRxBinding(){
        request.asObservable()
            .subscribe(onNext:{[weak self] (data: OpenWeatherResponse?) in
                guard let this = self else { return }
        
                this.descriptionText.accept(data?.weather?.first?.description ?? "")
                this.weatherMainText.accept(data?.weather?.first?.main ?? "")
                this.tempText.accept("\(data?.main?.temp ?? 0)°C")
                this.feelLikeText.accept("feels like: \(data?.main?.feels_like ?? 0)°C")
                this.iconImage.accept(this.loadImage(icon: data?.weather?.first?.icon ?? ""))


            })
            .disposed(by: disposeBag)
        
    }
    
    private func loadImage(icon:String) -> UIImage? {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon).png") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
            
        }catch{
            return nil
        }
    }
}
