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
    func stopwatchTimeDidChange(minutes: Int, seconds: Int, milliseconds: Int)
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
        delegate?.stopwatchTimeDidChange(minutes: 0, seconds: 0, milliseconds: 0)
    }

    func handleTimerEvent() {
        guard
            case let .started(startedAt) = state,
            let delegate = delegate
        else {
            return
        }

        let allSeconds = Int((timer.currentTime - startedAt) * 100)
        let minutes = allSeconds / 6000
        let seconds = (allSeconds / 100) % 60
        let milliseconds = allSeconds - ((minutes * 60 + seconds) * 100)
        delegate.stopwatchTimeDidChange(minutes: minutes, seconds: seconds, milliseconds: milliseconds)
    }
}
