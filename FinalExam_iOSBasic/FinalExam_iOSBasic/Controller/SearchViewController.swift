//
//  SearchViewController.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 28/02/2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchBtn(_ sender: Any) {
        ViewController.cityCall = searchField.text
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
