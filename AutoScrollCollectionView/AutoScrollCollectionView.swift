//
//  AutoScrollCollectionView.swift
//  AutoScrollCollectionView
//
//  Created by hikaruhara on 2021/05/15.
//

import UIKit

class AutoScrollCollectionView: UICollectionView {
    var items: [Int] = [] {
        didSet {
            reloadData()
            scrollToItem(at: .init(row: items.count, section: 0), at: .right, animated: false)
            timer = Timer(timeInterval: 3.5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
            if let timer = timer {
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    init() {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
    }
    
    func hoge() {
        let currentRow = Int(round(contentOffset.x / bounds.width))
        print("currentRow: \(currentRow)")
        scrollToItem(at: .init(row: currentRow + 1, section: 0), at: .right, animated: true)
    }
    
    @objc private func autoScroll() {
        let currentRow = Int(round(contentOffset.x / bounds.width))
        scrollToItem(at: .init(row: currentRow + 1, section: 0), at: .right, animated: true)
    }
}

//AutoScrollCollectionView = UICollectionViewのサブクラス
extension AutoScrollCollectionView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //スワイプ完了でコール
        if scrollView.contentOffset.x == scrollView.contentSize.width / 3 - scrollView.bounds.width {
            //2Aへのスクロール完了時
            self.contentOffset.x = (scrollView.contentSize.width / 3) * 2 - scrollView.bounds.width
        } else if scrollView.contentOffset.x == (scrollView.contentSize.width / 3) * 2 {
            //0Cへのスクロール完了時
            self.contentOffset.x = (scrollView.contentSize.width / 3)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //scrollToItemでコール
        if scrollView.contentOffset.x == scrollView.contentSize.width / 3 - scrollView.bounds.width {
            //2Aへのスクロール完了時
            self.contentOffset.x = (scrollView.contentSize.width / 3) * 2 - scrollView.bounds.width
        } else if scrollView.contentOffset.x == (scrollView.contentSize.width / 3) * 2 {
            //0Cへのスクロール完了時
            self.contentOffset.x = (scrollView.contentSize.width / 3)
        }
    }
}

extension AutoScrollCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //3倍にして返す
        print(items.count)
        return items.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("cellClass is not registered")
        }
        //配列の個数は3倍されているので元の配列で割った数で要素を指定する
        cell.render("\(items[indexPath.row % items.count])")
        return cell
    }
}

extension AutoScrollCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension AutoScrollCollectionView {
    class Cell: UICollectionViewCell {
        static let identifier = "cell"
        private let lbl: UILabel = .init()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        private func setup() {
            contentView.addSubview(lbl)
            lbl.center = contentView.center
            layer.borderWidth = 2
            layer.borderColor = UIColor.black.cgColor
        }
        
        func render(_ object: String) {
            lbl.text = object
            lbl.sizeToFit()
        }
    }
}
