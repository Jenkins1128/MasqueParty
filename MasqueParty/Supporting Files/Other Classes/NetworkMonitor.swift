//
//  NetworkMonitor.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/26/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import Network

class NetworkMonitor {
  static let shared = NetworkMonitor()
  var isReachable: Bool { status == .satisfied }

  private let monitor = NWPathMonitor()
  private var status = NWPath.Status.requiresConnection

  private init() {
    startMonitoring()
  }

  func startMonitoring() {
    let queue = DispatchQueue(label: "NetworkMonitor")
      
    monitor.pathUpdateHandler = { path in
        self.status = path.status
    }
    monitor.start(queue: queue)
  }

  func stopMonitoring() {
    monitor.cancel()
  }
}
