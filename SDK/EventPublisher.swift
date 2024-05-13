//
//  EventPublisher.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

@objc(EventPublisherProtocol)
protocol EventPublisherProtocol {
    func subscribe(handler: @escaping @Sendable (NSDate) -> Void)
}

class EventPublisher: NSObject, EventPublisherProtocol, @unchecked Sendable {
    private let handlerLock: NSLock
    private var handler: ((NSDate) -> Void)?
    private var publishingTimer: Timer!

    override init() {
        handlerLock = NSLock()
        super.init()
        print("++", "init")
        publishingTimer = Timer(timeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.handlerLock.lock()
            defer { self?.handlerLock.unlock() }
            let date = NSDate()
            print("++", "event", date, String(describing: self?.handler))
            self?.handler?(date)
        })
        RunLoop.main.add(publishingTimer, forMode: .default)
    }

    deinit {
        publishingTimer.invalidate()
    }

    func subscribe(handler: @escaping @Sendable (NSDate) -> Void) {
        handlerLock.lock()
        defer { handlerLock.unlock() }
        self.handler = handler
    }
}
