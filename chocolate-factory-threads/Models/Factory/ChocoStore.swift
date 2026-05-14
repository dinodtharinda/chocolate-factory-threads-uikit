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
    private let requiredSugar:Int = 80
    private let requiredMilk:Int = 5
    private let requiredCocoa:Int = 30

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
    private var callBackConsumeSugar: (() -> Sugar?)?
    private var callBackConsumeCocoa: (() -> Cocoa?)?
    
    
    init() {
        self.status = .stopped
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.unit.choco"
        )
        //self.syncQueue = DispatchQueue.init(label: "com.dinod.unit.sync")
    }
    func setAction(didChangeStatus: @escaping (Status) -> Void) {
        self.didChangeStatus = didChangeStatus
    }

    func setCallbacks(
        callbackConsumeMilk: @escaping () -> Milk?,
        callbackConsumeSugar: @escaping () -> Sugar?,
        callbackConsumeCocoa: @escaping () -> Cocoa?
    ) {
        self.callbackConsumeMilk = callbackConsumeMilk
        self.callBackConsumeSugar = callbackConsumeSugar
        self.callBackConsumeCocoa = callbackConsumeCocoa
    }

    func startProduction() {
        self.isActive = true
        print("Choco Store started")
        while self.isActive {
        
        unitQueue.async { [weak self] in
            guard let `self` = self else { return }
            
       
                if self.maxCapacity > self.units.count {
                    print("True Capacity Condition")
                    
//                    consume milk
                    if(requiredMilk > milkUnits.count){
                        let milk:Milk? = callbackConsumeMilk?()
                        if(milk != nil){
                            milkUnits.append(milk!)
                            print("milk added to the chocostore")
                        }
                    }
                   
                    //consume sugar
                    if(requiredSugar > sugarUnits.count){
                        let sugar:Sugar? = callBackConsumeSugar?()
                        if(sugar != nil){
                            sugarUnits.append(sugar!)
                            print("sugar added to the chocostore")
                        }
                    }
                    
                    //consume cocoa
                    if(requiredCocoa > cocoaUnits.count){
                        let cocoa:Cocoa? = callBackConsumeCocoa?()
                        if(cocoa != nil){
                            cocoaUnits.append(cocoa!)
                            print("cocoa added to the chocostore")
                        }
                    }
                    
                    
                   
                    
                    guard milkUnits.count >= 5,sugarUnits.count >= 80, cocoaUnits.count >= 30 else {
                        print(
                            "not enough Milk(\(milkUnits.count)) or Sugar(\(sugarUnits.count)) or Cocoa(\(cocoaUnits.count)) units"
                        )
                        toggleStatus(status: .waiting)
                        return
                    }
                   
                    toggleStatus(status: .producing)
                    
                    
                    self.units.insert(Choco(), at: 0)
                    self.milkUnits = []
                    self.sugarUnits = []
                    self.cocoaUnits = []
                                                        
                    print("chocobar Produced", units.count)
                    
                } else {
                   
                    toggleStatus(status: .resourceFull)
                }
            }
            
            Thread.sleep(forTimeInterval: 0.3)
        }

    }
    
    func toggleStatus(status: Status){
        if self.status != status {
            self.status = status
        }
    }
    
    func pause(){
        unitQueue.sync {
            self.isActive = false
        }
    }
    
    func reset(){
        unitQueue.sync {
            self.isActive = false
            milkUnits = []
            sugarUnits = []
            cocoaUnits = []
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
