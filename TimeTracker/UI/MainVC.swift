//
//  MainVC.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit
import SnapKit

final class MainVC: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else {
                return
            }
            var config = button.configuration
            config?.title = self.isStarted ? "Stop" : "Start"
            config?.baseBackgroundColor = self.isStarted ? .red : .systemBlue

            button.configuration = config
        }
        button.addAction(
            UIAction { _ in
                self.isStarted.toggle()
                self.button.setNeedsUpdateConfiguration()
            },
            for: .touchUpInside
        )
        return button
    }()

    private var isStarted = false {
        didSet {
            if oldValue {
                self.stopwatch.stop()
            } else {
                self.stopwatch.start()
            }
        }
    }
    private lazy var stopwatch = Stopwatch { [weak label] (minutes, seconds) in
        label?.text = "\(minutes):\(String(format: "%02d", seconds))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.spacing = 16.0

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
