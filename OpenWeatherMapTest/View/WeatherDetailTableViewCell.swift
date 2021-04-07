//
//  WeatherDetailTableViewCell.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/27.
//

import UIKit
import SnapKit
import RxSwift

class WeatherDetailTableViewCell: UITableViewCell {
    
    var lblTitle = UILabel()
    var lblData = UILabel()
    var lblUnit = UILabel()

    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(10)
        }
        
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 2
        addSubview(stackView)

        stackView.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(lblTitle.snp.right).inset(10).priority(750)
            make.right.top.bottom.equalToSuperview().inset(10)
            make.width.lessThanOrEqualTo(100).priority(250)
        }
        
        stackView.addArrangedSubview(lblData)
        stackView.addArrangedSubview(lblUnit)
    }
    
    

}
