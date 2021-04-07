//
//  WeatherDetailViewController.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class WeatherDetailViewController: UIViewController {
    
    fileprivate var cityInfo : CityInfo?
    fileprivate var weatherGetViewModel = WeatherGetViewModel()
    fileprivate var weatherViewModel = WeatherViewModel()
    fileprivate var weatherMainViewModel = WeatherMainViewModel()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var vwMain : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 233, g: 234, b: 234,alpha: 0.8)
        view.layer.cornerRadius = 10
        return view
    }()
    
    var vwDescription : UIView = {
        let view = UIView()
        return view
    }()
    
    var imgIconView : UIImageView!
    var lblDescription : UILabel! {
        didSet{
            lblDescription.font = UIFont.systemFont(ofSize: 15)
        }
    }
    var lblWeatherMain : UILabel! {
        didSet{
            lblWeatherMain.font = UIFont.systemFont(ofSize: 15)
            lblWeatherMain.textAlignment = .center
        }
    }
    var lblTemp : UILabel!{
        didSet{
            lblTemp.font = UIFont.systemFont(ofSize: 45)
            lblTemp.textAlignment = .center
        }
    }
    var lblFeelLike : UILabel! {
        didSet{
            lblFeelLike.font = UIFont.systemFont(ofSize: 15)
            lblFeelLike.textAlignment = .center
        }
    }
    
    var tableView : UITableView = {
        var view = UITableView()
        view.register(WeatherDetailTableViewCell.self, forCellReuseIdentifier: "WeatherDetailTableViewCell")
        view.separatorStyle = .none
        view.tableFooterView = UIView(frame: .zero)
        view.tableFooterView?.isHidden = true
        return view
    }()
    
    fileprivate var dataSource : [WeatherDetailInfo]? {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = cityInfo?.name
        weatherGetViewModel.request.accept((cityInfo?.id))

        tableView.delegate = self
        tableView.dataSource = self
        
        self.setupContainerView()
        self.setRxBinding()
        self.setRxBindingMainView()
        
        // Do any additional setup after loading the view.
    }
    
    func showAlert() {
        
        let alertVc = UIAlertController(title: "", message: "Please try again in a few minutes", preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction =  UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (_) in
            self.navigationController?.popViewController(animated: true)
            
        }
        
        alertVc.addAction(defaultAction)
 
        self.present(alertVc, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UI
extension WeatherDetailViewController {
    private func setupContainerView(){
        view.addSubview(vwMain)
        vwMain.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(30)
            make.top.equalTo(vwMain.snp.bottom).offset(30)
        }
        
        vwMain.addSubview(vwDescription)
        vwDescription.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        imgIconView = UIImageView()
        vwDescription.addSubview(imgIconView)
        imgIconView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        lblDescription = UILabel()
        vwDescription.addSubview(lblDescription)
        lblDescription.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(imgIconView.snp.right).offset(10)
            make.centerY.equalTo(imgIconView.snp.centerY)
            make.height.equalToSuperview()
        }
        
        lblWeatherMain = UILabel()
        vwMain.addSubview(lblWeatherMain)
        lblWeatherMain.snp.makeConstraints { (make) in
            make.top.equalTo(vwDescription.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        lblTemp = UILabel()
        vwMain.addSubview(lblTemp)
        lblTemp.snp.makeConstraints { (make) in
            make.top.equalTo(lblWeatherMain.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        lblFeelLike = UILabel()
        vwMain.addSubview(lblFeelLike)
        lblFeelLike.snp.makeConstraints { (make) in
            make.top.equalTo(lblTemp.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension WeatherDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as! WeatherDetailTableViewCell

        cell.lblTitle.text = dataSource?[indexPath.row].title
        cell.lblData.text = dataSource?[indexPath.row].value
        cell.lblUnit.text = dataSource?[indexPath.row].unit
    
        return cell

    }
}

//MARK: - RxBinding
extension WeatherDetailViewController {
    private func setRxBinding() {
        weatherGetViewModel.response
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (data) in

                self?.weatherMainViewModel.request.accept(data)
                self?.weatherViewModel.request.accept(data)
            })
            .disposed(by: disposeBag)
        
        weatherGetViewModel.error.asDriver(onErrorJustReturn: (0, ""))
            .drive(onNext: {[weak self] (code, message) in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
        
        weatherViewModel.machingInfo.asDriver(onErrorJustReturn: nil)
            .drive(onNext: {self.dataSource = $0 ?? []})
            .disposed(by: disposeBag)
    }
    
    private func setRxBindingMainView(){
        weatherMainViewModel.descriptionText.bind(to: lblDescription.rx.text)
            .disposed(by: disposeBag)
        weatherMainViewModel.weatherMainText.bind(to: lblWeatherMain.rx.text)
            .disposed(by: disposeBag)
        weatherMainViewModel.tempText.bind(to: lblTemp.rx.text)
            .disposed(by: disposeBag)
        weatherMainViewModel.feelLikeText.bind(to: lblFeelLike.rx.text)
            .disposed(by: disposeBag)
        weatherMainViewModel.iconImage.bind(to: imgIconView.rx.image)
            .disposed(by: disposeBag)
    }
}

// MARK: - create viewcontroller
extension WeatherDetailViewController {
    static func create(cityInfo : CityInfo) -> UIViewController? {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard  let vc = sb.instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController else {
            return nil
        }
        
        vc.cityInfo = cityInfo
        
        return vc
    }
}
