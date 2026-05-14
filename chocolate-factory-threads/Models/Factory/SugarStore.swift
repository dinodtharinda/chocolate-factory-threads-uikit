//
//  SugarFactory.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-07.
//

import Foundation

class SugarStore: Store {

    private var unitQueue: DispatchQueue

    private var units: [Sugar] = []

    private var maxCapacity: Int = 480

    private var status: Status {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChangeStatus?(newValue)
            }
        }
    }

    private var isActive: Bool = false

    private var didChangeStatus: ((Status) -> Void)?

    init() {
        status = .waiting
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.sugar-unit",
        )
    }

    func setAction(didChangeStatus: @escaping (Status) -> Void) {
        self.didChangeStatus = didChangeStatus
    }

    func start() {

        // enable isActive
        self.isActive = true
        while self.isActive {
            self.unitQueue.async { [weak self] in
                guard let `self` = self else { return }

                // loop produce

                if self.maxCapacity >= self.units.count {
                    self.status = .producing
                    
                    units.insert(Sugar(), at: 0)
                    print("Sugar Produced")

                } else {
                    if self.status != .resourceFull {
                        self.status = .resourceFull
                    }
                }

            }
            Thread.sleep(forTimeInterval: 0.1)
            
        }

    }

    func pause() {
        self.isActive = false
    }

    func reset() {
        self.isActive = false
        self.status = .stopped
        self.units = []
    }

    func consume( callback: @escaping (Sugar?) -> Void) {
       
        unitQueue.sync { [weak self] in
            guard let `self` = self else {
                callback(nil)
                return
            }
           
            // 1. Check Count
            guard 0 != self.units.count else {
                callback(nil)
                return
            }
            // 2. Prepare Return Values
            var output: Sugar?
            
             output = units.popLast()
            print("Suger Consume")
            callback(output)
        }
    }

}
