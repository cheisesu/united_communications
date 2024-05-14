//
//  SDKAPI.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

class _EventSubscriber: NSObject, @unchecked Sendable, EventSubscriber {
    var handler: ((NSDate) -> Void)?
    func handle(new date: NSDate) {
        handler?(date)
    }
}

public class SDKAPI: @unchecked Sendable {
    public enum APIError: Error {
        case xpc
    }

#if os(macOS)
    private let publisherConnection: NSXPCConnection
#endif
    private let subscriber: _EventSubscriber
    private let eventPublisher: EventPublisherProtocol

    public init() throws {
        let subscriber = _EventSubscriber()
        self.subscriber = subscriber
#if os(macOS)
        publisherConnection = NSXPCConnection(serviceName: "dmitrii.shelonin.SDKPublisher")
        publisherConnection.exportedInterface = NSXPCInterface(with: EventSubscriber.self)
        publisherConnection.exportedObject = subscriber

        publisherConnection.remoteObjectInterface = NSXPCInterface(with: EventPublisherProtocol.self)
        publisherConnection.resume()
        let publisher = publisherConnection.remoteObjectProxyWithErrorHandler { error in
            print("==>>", error)
        }
        guard let publisher = publisher as? EventPublisherProtocol else { throw APIError.xpc }
        eventPublisher = publisher
#else
        eventPublisher = EventPublisher(subscriber)
#endif
    }

    deinit {
#if os(macOS)
        publisherConnection.invalidate()
#endif
    }

    public func subscribe(handler: @escaping @Sendable (NSDate) -> Void) {
        subscriber.handler = handler
        eventPublisher.subscribe(handler: {})
    }
}
