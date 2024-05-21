//
//  ViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 08.05.2022.
//

import UIKit

class ViewController: UIViewController {


    private let buttonSingel: UIButton = {
        let control = UIButton()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.setTitle("Играть", for: .normal)
        control.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        return control
    }()

//    private let buttonMulty: UIButton = {
//        let control = UIButton()
//        control.translatesAutoresizingMaskIntoConstraints = false
//        control.setTitle("Мультиплеер", for: .normal)
//        control.addTarget(self, action: #selector(touchButtonMulty), for: .touchUpInside)
//        return control
//    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }

    private let label: UILabel = {
        let control = UILabel()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.text = "TETRIS AR"
        control.font = UIFont(name: "HelveticaNeue-Bold", size: 60)
        control.textAlignment = .center
        control.textColor = .systemBlue
        return control
    }()

    private func configUI(){
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(buttonSingel)
        buttonSingel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonSingel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

//        view.addSubview(buttonMulty)
//        buttonMulty.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        buttonMulty.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true

    }

    @objc func touchButton() {
         self.navigationController?.pushViewController(ARViewController(), animated: true)
     }
    
    
    

//    @objc func touchButtonMulty() {
//         let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
////        let vc = MyltyPlayerViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//     }



}

