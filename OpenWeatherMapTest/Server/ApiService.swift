//
//  ApiService.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import Foundation
import RxSwift
import Alamofire

enum Result<T, Failure: Error> {
    case success(T)
    case failure(Failure)
}

class APIService {
    static func fetch<T:Decodable>(_ param:Dictionary<String, Any>) -> Observable<Result<T,Error>> {
            
        return Observable.create { emitter in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 100
            manager.session.configuration.timeoutIntervalForResource = 100
                      
            let request = manager
                .request(ServerConfig.WEATHER_API_BASE_URL, method: .get, parameters: param)
                .responseData { (response) in
                    switch response.result {
                    case .success(let data) :
                        do{
                            let model : T = try JSONDecoder().decode(T.self, from: data)
                            emitter.onNext(Result.success(model))
                        }catch{
                            print("error")
                            emitter.onNext(Result.failure(error))
                        }
                        break
                        
                    case .failure(let error) :
                        emitter.onNext(Result.failure(error))
                        break
                    }
                }
            return Disposables.create()
        }
    }
}
