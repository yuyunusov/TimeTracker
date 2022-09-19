//
//  StopwatchCell.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit

final class StopwatchCell: UICollectionViewCell {

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00:00"
        label.font = .systemFont(ofSize: 32.0)
        return label
    }()

    private lazy var stateButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.gray()
        button.configurationUpdateHandler = { [weak self] button in
            guard let stopwatch = self?.stopwatch else {
                return
            }
            var config = button.configuration
            switch stopwatch.state {
            case .started:
                config?.image = UIImage(systemName: "pause.fill")
            case .paused, .empty:
                config?.image = UIImage(systemName: "play.fill")
            }

            config?.baseBackgroundColor = .systemGray
            config?.cornerStyle = .capsule
            config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14.0)

            button.configuration = config
        }
        button.addAction(
            UIAction { _ in
                switch self.stopwatch?.state {
                case .started:
                    self.stopwatch?.pause()
                case .paused, .empty:
                    self.stopwatch?.start()
                case .none:
                    break
                }
            },
            for: .touchUpInside
        )
        button.tintColor = .white
        button.contentMode = .center
        return button
    }()

    private var stopwatch: StopwatchProtocol? {
        didSet {
            timerLabel.text = "0:00:00"
            stateButton.setNeedsUpdateConfiguration()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        setupUI()
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
        contentView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(24.0)
        }

        contentView.addSubview(stateButton)
        stateButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(16.0)
            make.size.equalTo(CGSize(width: 40.0, height: 40.0))
        }
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
    }

    func configure(with stopwatch: StopwatchProtocol) {
        self.stopwatch = stopwatch
        self.stopwatch?.delegate = self
    }
}

extension StopwatchCell: StopwatchDelegate {
    func stopwatchTimeDidChange(hours: Int, minutes: Int, seconds: Int) {
        let text = "\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        guard timerLabel.text != text else {
            return
        }
        timerLabel.text = text
    }

    func stopwatchStateDidChange(stopwatch: Stopwatch) {
        stateButton.setNeedsUpdateConfiguration()
    }
}
