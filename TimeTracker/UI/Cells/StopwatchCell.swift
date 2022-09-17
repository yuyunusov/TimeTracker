//
//  StopwatchCell.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit

final class StopwatchCell: UICollectionViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "0:00:00"
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.configurationUpdateHandler = { [weak self] button in
            guard let stopwatch = self?.stopwatch else {
                return
            }
            var config = button.configuration
            switch stopwatch.state {
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
                guard let stopwatch = self.stopwatch else {
                    return
                }
                switch stopwatch.state {
                case .started:
                    stopwatch.pause()
                case .paused, .empty:
                    stopwatch.start()
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
            guard let stopwatch = self?.stopwatch else {
                return
            }
            var config = button.configuration
            config?.title = "Reset"
            switch stopwatch.state {
            case .started, .paused:
                config?.baseBackgroundColor = .systemBlue
            case .empty:
                config?.baseBackgroundColor = .systemGray
            }

            button.configuration = config
        }
        button.addAction(
            UIAction { _ in
                self.stopwatch?.reset()
            },
            for: .touchUpInside
        )
        return button
    }()

    private var stopwatch: StopwatchProtocol? {
        didSet {
            resetButton.setNeedsUpdateConfiguration()
            startButton.setNeedsUpdateConfiguration()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        stopwatch?.delegate = nil
        stopwatch = nil
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [label, startButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 16.0

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with stopwatch: StopwatchProtocol) {
        self.stopwatch = stopwatch
        self.stopwatch?.delegate = self
    }
}

extension StopwatchCell: StopwatchDelegate {
    func stopwatchTimeDidChange(minutes: Int, seconds: Int, milliseconds: Int) {
        label.text = "\(minutes):\(String(format: "%02d", seconds)):\(String(format: "%02d", milliseconds))"
    }

    func stopwatchStateDidChange(stopwatch: Stopwatch) {
        resetButton.setNeedsUpdateConfiguration()
        startButton.setNeedsUpdateConfiguration()
    }
}
