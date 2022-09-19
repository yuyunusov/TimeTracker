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
    var hours: Int?, minutes: Int?, seconds: Int?

    func stopwatchTimeDidChange(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
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
        XCTAssertTrue(stopwatch.state.isStarted)
        stopwatch.pause()
        XCTAssertTrue(stopwatch.state.isPaused)
        stopwatch.reset()
        XCTAssertTrue(stopwatch.state.isEmpty)
    }

    func testStart() {
        stopwatchTimerMock.currentTime = 0.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 3661.0
        stopwatch.handleTimerEvent()
        XCTAssertNotNil(stopwatchMockDelegate.hours)
        XCTAssertNotNil(stopwatchMockDelegate.minutes)
        XCTAssertNotNil(stopwatchMockDelegate.seconds)
        XCTAssertEqual(stopwatchMockDelegate.hours, 1)
        XCTAssertEqual(stopwatchMockDelegate.minutes, 1)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 1)
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
        XCTAssertEqual(stopwatchMockDelegate.minutes, 0)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 7)
    }

    func testReset() {
        stopwatchTimerMock.currentTime = 0.0
        stopwatch.start()
        stopwatchTimerMock.currentTime = 1.0
        stopwatch.handleTimerEvent()
        stopwatch.reset()
        XCTAssertEqual(stopwatchMockDelegate.hours, 0)
        XCTAssertEqual(stopwatchMockDelegate.minutes, 0)
        XCTAssertEqual(stopwatchMockDelegate.seconds, 0)
    }
}
