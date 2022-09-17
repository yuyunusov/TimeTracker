//
//  StopwatchTests.swift
//  TimeTrackerTests
//
//  Created by Yunus Yunusov on 17.09.2022.
//

import XCTest
@testable import TimeTracker

class StopwatchTimerMock: StopwatchTimer {
    var currentTime = CFTimeInterval()
    var stopwatches: [StopwatchProtocol] = []

    func start() {}

    func register(stopwatch: StopwatchProtocol) {
        stopwatches.append(stopwatch)
    }

    func remove(stopwatch: StopwatchProtocol) {
        stopwatches = stopwatches.filter { $0 !== stopwatch }
    }
    
}

class StopwatchMockDelegate: StopwatchDelegate {
    var minutes: Int?, seconds: Int?, milliseconds: Int?

    func stopwatchTimeDidChange(minutes: Int, seconds: Int, milliseconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    }

    func stopwatchStateDidChange(stopwatch: TimeTracker.Stopwatch) {}
}

final class StopwatchTests: XCTestCase {

    let stopwatchTimerMock = StopwatchTimerMock()
    var stopwatchMockDelegate = StopwatchMockDelegate()
    var stopwatch: Stopwatch!

    override func setUpWithError() throws {
        stopwatch = Stopwatch(stopwatchTimer: stopwatchTimerMock)
        stopwatch.delegate = stopwatchMockDelegate
    }

    override func tearDownWithError() throws {
        stopwatch = nil
    }

    func testRegister() {
        XCTAssertEqual(stopwatchTimerMock.stopwatches.count, 1)
    }

    func testState() {
        stopwatch.start()
        XCTAssertEqual(stopwatch.state, .started(0.0))
        stopwatch.pause()
        XCTAssertEqual(stopwatch.state, .paused(0.0, 0.0))
        stopwatch.reset()
        XCTAssertEqual(stopwatch.state, .empty)
    }

    func testStart() {
        stopwatchTimerMock.currentTime = 0.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 61.05
        stopwatch.handleTimerEvent()
        XCTAssertNotNil(stopwatchMockDelegate.minutes)
        XCTAssertNotNil(stopwatchMockDelegate.seconds)
        XCTAssertNotNil(stopwatchMockDelegate.milliseconds)
        XCTAssertEqual(stopwatchMockDelegate.minutes, 1)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 1)
        XCTAssertEqual(stopwatchMockDelegate.milliseconds, 5)
    }

    func testPause() {
        stopwatchTimerMock.currentTime = 0.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 1.0
        stopwatch.pause() // elapsed 1.0 seconds
        stopwatchTimerMock.currentTime = 5.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 10.0
        stopwatch.pause() // elapsed 1.0 + 5.0 seconds
        stopwatchTimerMock.currentTime = 15.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 16.0
        stopwatch.handleTimerEvent() // elapsed 1.0 + 5.0 + 1.0 seconds
        XCTAssertNotNil(stopwatchMockDelegate.minutes)
        XCTAssertNotNil(stopwatchMockDelegate.seconds)
        XCTAssertNotNil(stopwatchMockDelegate.milliseconds)
        XCTAssertEqual(stopwatchMockDelegate.minutes, 0)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 7)
        XCTAssertEqual(stopwatchMockDelegate.milliseconds, 0)
    }

    func testReset() {
        stopwatchTimerMock.currentTime = 0.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 1.0
        stopwatch.handleTimerEvent()
        stopwatch.reset()
        XCTAssertNotNil(stopwatchMockDelegate.minutes)
        XCTAssertNotNil(stopwatchMockDelegate.seconds)
        XCTAssertNotNil(stopwatchMockDelegate.milliseconds)
        XCTAssertEqual(stopwatchMockDelegate.minutes, 0)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 0)
        XCTAssertEqual(stopwatchMockDelegate.milliseconds, 0)
    }
}
