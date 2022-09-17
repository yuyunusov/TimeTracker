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
        label.text = "0:00:00"
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else {
                return
            }
            var config = button.configuration
            switch self.stopwatch.state {
            case .empty, .paused:
                config?.title = "Start"
                config?.baseBackgroundColor = .systemBlue
            case .started:
                config?.title = "Pause"
                config?.baseBackgroundColor = .systemRed
            }

            button.configuration = config
        }
        button.addAction(
            UIAction { _ in
                switch self.stopwatch.state {
                case .started:
                    self.stopwatch.pause()
                case .paused, .empty:
                    self.stopwatch.start()
                }
            },
            for: .touchUpInside
        )
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else {
                return
            }
            var config = button.configuration
            config?.title = "Reset"
            switch self.stopwatch.state {
            case .started, .paused:
                config?.baseBackgroundColor = .systemBlue
            case .empty:
                config?.baseBackgroundColor = .systemGray
            }

            button.configuration = config
        }
        button.addAction(
            UIAction { _ in
                self.stopwatch.reset()
            },
            for: .touchUpInside
        )
        return button
    }()

    private let stopwatch: StopwatchProtocol

    init(stopwatch: StopwatchProtocol) {
        self.stopwatch = stopwatch

        super.init(nibName: nil, bundle: nil)

        self.stopwatch.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupLayout()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [label, startButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 16.0

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension MainVC: StopwatchDelegate {
    func stopwatchTimeDidChange(hours: Int, minutes: Int, seconds: Int, milliseconds: Int) {
        label.text = "\(minutes):\(String(format: "%02d", seconds)):\(String(format: "%02d", milliseconds))"
    }

    func stopwatchStateDidChange(stopwatch: Stopwatch) {
        self.startButton.setNeedsUpdateConfiguration()
        self.resetButton.setNeedsUpdateConfiguration()
    }
}
