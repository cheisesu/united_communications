//
//  SDKAPI.swift
//  SDK
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

public class SDKAPI: @unchecked Sendable {
    private let eventPublisher: EventPublisher

    public init() {
        eventPublisher = EventPublisher()
    }

    public func subscribe(handler: @escaping @Sendable (Event) -> Void) {
        eventPublisher.subscribe(handler: handler)
    }
}
