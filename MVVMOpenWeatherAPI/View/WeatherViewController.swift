//
//  WeatherViewController.swift
//  MVVMOpenWeatherAPI
//
//  Created by Tai Chin Huang on 2022/6/1.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel(apiService: APIService())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initVM()
    }
    
    func initView() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    Alert.standard.showMessage(title: "", msg: message, vc: self!, handler: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    HUD.shared.showLoadingHUD(addTo: self!.view, with: "")
                    UIView.animate(withDuration: 0.25) {
                        self?.tableView.alpha = 0
                    }
                } else {
                    HUD.shared.hideLoadingHUD(removeFrom: self!.view)
                    UIView.animate(withDuration: 0.25) {
                        self?.tableView.alpha = 1
                    }
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellIdentifier(), for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.weatherCellViewModel = cellVM
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var weatherCellViewModel: WeatherCellViewModel? {
        didSet {
            cityNameLabel.text = weatherCellViewModel?.cityNameText
            tempLabel.text = weatherCellViewModel?.tempText
            descriptionLabel.text = weatherCellViewModel?.descriptionText
        }
    }
}
