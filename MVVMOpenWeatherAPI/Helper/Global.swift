//
//  Global.swift
//  MVVMOpenWeatherAPI
//
//  Created by Tai Chin Huang on 2022/6/1.
//

import Foundation
import MBProgressHUD

typealias Handler = (() -> ())?
//API_KEY = "0238269da9e36c5574830edd6b343ab8"
class Global {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "0238269da9e36c5574830edd6b343ab8"
}

class HUD {
    static let shared = HUD()
    func showLoadingHUD(addTo view: UIView, with text: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        hud.mode = .indeterminate
    }
    
    func hideLoadingHUD(removeFrom view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

class Alert {
    static let standard = Alert()
    func showMessage(title: String, msg: String, vc: UIViewController, handler: Handler) {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "確定", style: .default) { _ in
            if handler != nil {
                handler?()
            }
        }
        ac.addAction(doneAction)
        vc.present(ac, animated: true, completion: nil)
    }
}
