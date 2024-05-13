//
//  EventPublisher.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

extension Date: Event {}

class EventPublisher: @unchecked Sendable {
    private let handlerLock: NSLock
    private var handler: ((Event) -> Void)?
    private var publishingTimer: Timer!

    init() {
        handlerLock = NSLock()
        publishingTimer = Timer(timeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.handlerLock.lock()
            defer { self?.handlerLock.unlock() }
            self?.handler?(Date())
        })
        RunLoop.main.add(publishingTimer, forMode: .default)
    }

    deinit {
        publishingTimer.invalidate()
    }

    func subscribe(handler: @escaping @Sendable (Event) -> Void) {
        handlerLock.lock()
        defer { handlerLock.unlock() }
        self.handler = handler
    }
}
