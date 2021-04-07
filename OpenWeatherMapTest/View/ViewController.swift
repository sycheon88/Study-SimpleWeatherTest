//
//  ViewController.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.placeholder = "Search for a city"
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    fileprivate var shownCities: [CityInfo]?
    fileprivate var dataSource: [CityInfo]? {
        didSet{
            shownCities = dataSource
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            if let data = try JsonFileReader().loadJsonFile() {
                dataSource = data
            }
            
        }
        catch{
            
        }
        
        setRxBinding()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }

}

extension ViewController {
    
    func setRxBinding(){
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: {[weak self] text in
                self?.shownCities = self?.dataSource?.filter({$0.name.localizedCaseInsensitiveContains(text) || $0.country.localizedCaseInsensitiveContains(text)})
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(shownCities?[indexPath.row].name ?? ""), \(shownCities?[indexPath.row].country ?? "")"
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let data = shownCities?[indexPath.row] else { return }
        
        if let controller = WeatherDetailViewController.create(cityInfo: data) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    
}
