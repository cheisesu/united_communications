//
//  SDKAPI.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

public class SDKAPI: @unchecked Sendable {
    public enum APIError: Error {
        case xpc
    }

#if os(macOS)
    let publisherConnection: NSXPCConnection
#endif
    private let eventPublisher: EventPublisherProtocol

    public init() throws {
#if os(macOS)
        publisherConnection = NSXPCConnection(serviceName: "dmitrii.shelonin.SDKPublisher")
        publisherConnection.remoteObjectInterface = NSXPCInterface(with: EventPublisherProtocol.self)
        publisherConnection.resume()
        let publisher = publisherConnection.remoteObjectProxyWithErrorHandler { error in
            print("==>>", error)
        }
        guard let publisher = publisher as? EventPublisherProtocol else { throw APIError.xpc }
        eventPublisher = publisher
#else
        eventPublisher = EventPublisher()
#endif
    }

    deinit {
#if os(macOS)
        publisherConnection.invalidate()
#endif
    }

    public func subscribe(handler: @escaping @Sendable (NSDate) -> Void) {
        eventPublisher.subscribe(handler: handler)
    }
}
