//
//  ViewController.swift
//  AutoScrollCollectionView
//
//  Created by hikaruhara on 2021/05/15.
//

import UIKit

class HogeVieController: UIViewController {
    @IBAction func didTapButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController")
        self.present(vc, animated: true, completion: nil)
    }
}

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let randomInt = Int.random(in: 1..<5)
        var item: [Int] = []
        print(randomInt)
        for i in 1...randomInt {
            item.append(i)
        }
        setup(item: item)
    }
    
    private func setup(item: [Int]) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        let autoScrollCollectionView: AutoScrollCollectionView = .init()
        autoScrollCollectionView.items = item
        autoScrollCollectionView.backgroundColor = .yellow
        view.addSubview(autoScrollCollectionView)
        autoScrollCollectionView.frame.size = .init(width: view.bounds.width, height: 350)
        autoScrollCollectionView.center = view.center
        
        print(autoScrollCollectionView.frame.size)
        print(autoScrollCollectionView.center)

        let btn: UIButton = .init()
        btn.addTarget(self, action: #selector(hoge), for: .touchUpInside)
        view.addSubview(btn)
        btn.setTitle("button", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 95, height: 45)
        btn.backgroundColor = .blue
    }
    
    @objc private func hoge() {
//        autoScrollCollectionView.hoge()
    }
}
