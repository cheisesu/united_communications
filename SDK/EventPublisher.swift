//
//  EventPublisher.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

@objc(EventPublisherProtocol)
protocol EventPublisherProtocol: Sendable {
    func subscribe(handler: @escaping @Sendable () -> Void)
}

@objc(EventSubscriber)
protocol EventSubscriber: Sendable {
    func handle(new date: NSDate)
}

class EventPublisher: NSObject, EventPublisherProtocol, @unchecked Sendable {
    private let handlerLock: NSLock
    private let subscriber: EventSubscriber
    private var publishingTimer: Timer?

    init(_ subscriber: EventSubscriber) {
        handlerLock = NSLock()
        self.subscriber = subscriber
        super.init()
        print("++", "init")
    }

    deinit {
        publishingTimer?.invalidate()
    }

    func subscribe(handler: @escaping @Sendable () -> Void) {
        handlerLock.lock()
        defer { handlerLock.unlock() }
        publishingTimer?.invalidate()
        let timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.handlerLock.lock()
            defer { self?.handlerLock.unlock() }
            let date = NSDate()
            print("++", "event", date)
            self?.subscriber.handle(new: date)
        })
        publishingTimer = timer
        RunLoop.main.add(timer, forMode: .default)
        handler()
    }
}
