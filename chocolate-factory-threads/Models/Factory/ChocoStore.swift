//
//  ChocoStore.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-10.
//

import Foundation

class ChocoStore: Store {

    private var unitQueue: DispatchQueue
    //    private var syncQueue : DispatchQueue
    private var maxCapacity: Int = 12
    private var units: [Choco] = []

    private var milkUnits: [Milk] = []
    private var cocoaUnits: [Cocoa] = []
    private var sugarUnits: [Sugar] = []
    private var isActive: Bool = false
    private var status: Status {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChangeStatus?(newValue)
            }
        }
    }
    var didChangeStatus: ((Status) -> Void)?

    private var callbackConsumeMilk: (() -> Milk?)?

    init() {
        self.status = .stopped
        self.unitQueue = DispatchQueue.init(label: "com.dinod.unit.choco")
        //self.syncQueue = DispatchQueue.init(label: "com.dinod.unit.sync")
    }
    func setAction(didChangeStatus: @escaping (Status) -> Void) {
        self.didChangeStatus = didChangeStatus
    }

    func setCallbacks(callbackConsumeMilk: @escaping () -> Milk?) {
        self.callbackConsumeMilk = callbackConsumeMilk
    }

    func startProduction() {

        while isActive {
            unitQueue.async { [weak self] in
                guard let `self` = self
                if self.maxCapacity > self.units.count {

                    //                    guard cocoa.count == 30, sugar.count == 80, milk!.count == 5 else {
                    //                        print(cocoa.count," ",sugar.count," ",milk!.count)
                    //                        self.status = .waiting
                    ////                            print("continued")
                    //                        continue
                    //                    }
                    
                    let milk:Milk? = callbackConsumeMilk?()
                    
                    guard let m = milk else {
                        return
                    }
                    
                    
                    self.status = .producing

                    Thread.sleep(forTimeInterval: 1)
                    self.units.insert(Choco(), at: 0)
                    self.cocoaUnits = []

                    self.sugarUnits = []

                    print("chocobar Produced", units.count)

                } else {

                    if self.status != .resourceFull {
                        self.status = .resourceFull
                    }
                }
            }
            

        }

    }

    func consume(count: Int, callback: @escaping ([Choco]?) -> Void) {

        // 1. Check Count
        guard count < units.count else {
            //            print("Test Consume Choco 2 ",units.count)
            callback(nil)
            return

        }

        // 2. Prepare Return Values
        var output: [Choco] = []
        unitQueue.sync { [weak self] in
            //            print("Test Consume Choco 4")
            guard let `self` = self else {
                callback(nil)
                return
            }

            // For Loop
            for _ in (0..<count).reversed() {

                // 3. Remove Resource Array
                guard let last = units.popLast() else {
                    break
                }

                output.append(last)
            }
            //            print("Consumed Choco")
            callback(output)
        }
    }

}
