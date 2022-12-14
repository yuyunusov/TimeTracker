//
//  StopwatchListVC.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit
import SnapKit

final class StopwatchListVC: UIViewController {

    // MARK: - UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.defaultMargin

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StopwatchCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Dependency
    private let stopwatchTimer: StopwatchTimer

    // MARK: - Properties
    private var stopwatches: [StopwatchProtocol] = []

    init(stopwatchTimer: StopwatchTimer) {
        self.stopwatchTimer = stopwatchTimer

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.backgroundColor
        title = "Time tracker"

        setupLayout()
        setupNavigationBar()
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStopwatch))
        navigationItem.rightBarButtonItem = addBarItem
    }

    @objc private func addStopwatch() {
        let stopwatch = Stopwatch(stopwatchTimer: stopwatchTimer)
        stopwatches.insert(stopwatch, at: 0)

        collectionView.insertOnTop()
    }
}

extension StopwatchListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stopwatches.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StopwatchCell

        let stopwatch = stopwatches[indexPath.item]
        cell.configure(with: stopwatch)
        
        return cell
    }
}

extension StopwatchListVC: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: collectionView.bounds.width - Constants.defaultMargin*2, height: 72.0)
    }
}

private enum Constants {
    static let defaultMargin = 16.0
}
