//
//  StopwatchTimer.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit

protocol StopwatchTimer {
    var currentTime: CFTimeInterval { get }

    func start()
    func register(stopwatch: StopwatchProtocol)
    func remove(stopwatch: StopwatchProtocol)
}

final class StopwatchDisplayLinkTimer: StopwatchTimer {

    private var stopwatches: [StopwatchProtocol] = []
    private var displayLink: CADisplayLink?

    var currentTime: CFTimeInterval {
        CACurrentMediaTime()
    }

    func start() {
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 20, maximum: 20)
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func register(stopwatch: StopwatchProtocol) {
        stopwatches.append(stopwatch)
    }

    func remove(stopwatch: StopwatchProtocol) {
        stopwatches = stopwatches.filter { $0 !== stopwatch }
    }

    @objc private func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard !stopwatches.isEmpty else {
            return
        }

        for stopwatch in stopwatches where stopwatch.state.isStarted {
            stopwatch.handleTimerEvent()
        }
    }
}
