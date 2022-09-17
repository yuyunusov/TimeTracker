//
//  Stopwatch.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import UIKit

enum StopwatchState: Equatable {
    case started(_ at: CFTimeInterval)
    case paused(_ at: CFTimeInterval, _ startedAt: CFTimeInterval)
    case empty

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.started, .started), (.paused, .paused), (.empty, .empty):
            return true
        default:
            return false
        }
    }
}

protocol StopwatchProtocol: AnyObject {
    var state: StopwatchState { get }
    var delegate: StopwatchDelegate? { get set }

    init(stopwatchTimer: StopwatchTimer)

    func start()
    func pause()
    func reset()
    func handleTimerEvent()
}

protocol StopwatchDelegate: AnyObject {
    func stopwatchTimeDidChange(hours: Int, minutes: Int, seconds: Int)
    func stopwatchStateDidChange(stopwatch: Stopwatch)
}

final class Stopwatch: StopwatchProtocol {

    private var timer: StopwatchTimer

    var state: StopwatchState = .empty {
        didSet {
            delegate?.stopwatchStateDidChange(stopwatch: self)
        }
    }
    weak var delegate: StopwatchDelegate?

    init(stopwatchTimer: StopwatchTimer) {
        timer = stopwatchTimer
        timer.register(stopwatch: self)
    }

    func start() {
        switch state {
        case .empty:
            state = .started(timer.currentTime)
        case let .paused(pausedAt, startedAt):
            let pausedTime = timer.currentTime - pausedAt
            state = .started(startedAt + pausedTime)
            break
        case .started:
            break
        }
    }

    func pause() {
        switch state {
        case let .started(startedAt):
            state = .paused(timer.currentTime, startedAt)
        case .empty, .paused:
            break
        }
    }

    func reset() {
        state = .empty
        delegate?.stopwatchTimeDidChange(hours: 0, minutes: 0, seconds: 0)
    }

    func handleTimerEvent() {
        guard
            case let .started(startedAt) = state,
            let delegate = delegate
        else {
            return
        }

        let allSeconds = Int((timer.currentTime - startedAt))
        let hours = allSeconds / 3600
        let minutes = (allSeconds - hours * 3600) / 60
        let seconds = allSeconds % 60
        delegate.stopwatchTimeDidChange(hours: hours, minutes: minutes, seconds: seconds)
    }
}
