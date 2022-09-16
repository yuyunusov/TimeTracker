//
//  Stopwatch.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit

final class Stopwatch {

    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    private var timeChangeHandler: ((Int, Int) -> Void)?

    init(timeChangeHandler: @escaping (Int, Int) -> Void) {
        self.timeChangeHandler = timeChangeHandler
    }

    func start() {
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func stop() {
        startTime = nil
        displayLink?.invalidate()
    }

    @objc private func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard
            let startTime = startTime,
            let timeChangeHandler = timeChangeHandler
        else {
            return
        }

        let allSeconds = Int(CACurrentMediaTime() - startTime)
        let minutes = allSeconds / 60
        let seconds = allSeconds % 60
        timeChangeHandler(minutes, seconds)
    }
}
