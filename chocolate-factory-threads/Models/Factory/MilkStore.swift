//
//  MilkFactory.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-07.
//

import Foundation

class MilkStore: Store {
    
    private var unitQueue: DispatchQueue
    
    private let maxCapacity = 40
    
    private var units: [Milk] = []
    
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
        status = Status.stopped
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.milk-unit"
            
        )
       
    }
    
    func setAction(didChangeStatus: @escaping (Status) -> Void){
        self.didChangeStatus = didChangeStatus
    }
    func start(){
        self.isActive = true
        while self.isActive {
       
            self.unitQueue.async { [weak self] in
                guard let `self` = self else { return }
               
                
                    if(self.units.count < self.maxCapacity){
                        
                        toggleStatus(status: .producing)
                        
                        self.units.insert(Milk(), at: 0)
                        print("Milk Produced")
                        Thread.sleep(forTimeInterval: 0.3)
                    } else {
                        
                        toggleStatus(status: .resourceFull)
                    }
                    
                   
                }
            
            Thread.sleep(forTimeInterval: 1)
//            print("milk ",self.status.rawValue)
            
        }
        
        
    }
    
    func toggleStatus(status: Status){
        if self.status != status {
            self.status = status
        }
    }
    
    func pause(){
        unitQueue.async {
            self.isActive = false
            self.toggleStatus(status: .stopped)
        }
        
       
    }
    
    func reset(){
        unitQueue.sync{
            self.isActive = false
            self.units = []
            self.toggleStatus(status: .stopped)
        }
    
    }
    
    func consume( callback: @escaping (Milk?) -> Void){
     
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
            var output: Milk?
            
             output = units.popLast()
            print("Milk Consume")
            callback(output)
        }
    }
    
}
