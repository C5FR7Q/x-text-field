//
//  ViewController.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(XViewController(), animated: true)
    }

}

