//
//  main.swift
//  SDKPublisher
//
//  Created by Dmitrii Shelonin on 13/5/24.
//

import Foundation

class XPCInterface: NSXPCInterface {
    init(with_ proto: Protocol) {
        super.init()
        self.protocol = proto
        print("++", "init", proto)
    }

    deinit {
        print("++", "deinit", self)
    }
}

class EventPublisherDelegate: NSObject, NSXPCListenerDelegate {

    /// This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        
        // Configure the connection.
        // First, set the interface that the exported object implements.
        newConnection.exportedInterface = XPCInterface(with_: EventPublisherProtocol.self)

        // Next, set the object that the connection exports. All messages sent on the connection to this service will be sent to the exported object to handle. The connection retains the exported object.
        let exportedObject = EventPublisher()
        newConnection.exportedObject = exportedObject
        newConnection.interruptionHandler = {
            print("--", "connection interrupted")
        }
        newConnection.invalidationHandler = {
            print("--", "connection invalidated")
        }

        // Resuming the connection allows the system to deliver more incoming messages.
        newConnection.resume()

        // Returning true from this method tells the system that you have accepted this connection. If you want to reject the connection for some reason, call invalidate() on the connection and return false.
        return true
    }
}

// Create the delegate for the service.
let delegate = EventPublisherDelegate()

// Set up the one NSXPCListener for this service. It will handle all incoming connections.
let listener = NSXPCListener(machServiceName: "dmitrii.shelonin.SDKPublisher")
listener.delegate = delegate

// Resuming the serviceListener starts this service. This method does not return.
listener.resume()
RunLoop.main.run()
