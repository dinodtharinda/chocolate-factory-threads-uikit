//
//  ChocoaStore.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-08.
//

import Foundation


class CocoaStore : Store{
    private var unitQueue: DispatchQueue
    
    private var maxCapacity: Int = 180
    
    private var units: [Cocoa] = []
    
    private var status: Status {
        willSet {
            DispatchQueue.main.async {[weak self] in
                self?.didChangeStatus?(newValue)
            }
        }
    }
    
    private var isActive: Bool =  false
    
    private var didChangeStatus: ((Status)-> Void)?
    
    init() {
        self.status = .stopped
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.cocoa.unit",
            attributes: .concurrent
        )
    }
    
    func setAction(didChangeStatus: @escaping (Status) -> Void){
        self.didChangeStatus = didChangeStatus
    }
    
    
    func start(){
       
            self.isActive = true
            self.unitQueue.async{ [weak self] in
                
                guard let `self` = self else {
                    return
                }
                while self.isActive {
                    if(self.maxCapacity > self.units.count) {
                      
                        toggleStatus(status: .producing)
                        units.insert(Cocoa(), at: 0)
                        print("Cocoa Produced ",units.count)
                        Thread.sleep(forTimeInterval:0.2)
                    } else {
                    
                        toggleStatus(status: .resourceFull)
                    }
                    
                   
                }
                
            }
        
    }
    
    func toggleStatus(status: Status){
        if self.status != status {
            self.status = status
        }
    }
    
    func pause(){
        unitQueue.async {
            print("Stopped!")
            self.isActive = false
            self.toggleStatus(status: .stopped)
        }
        
    }
    
    func reset(){
        unitQueue.async {
            self.isActive = false
            print("Reset")
            self.units = []
            self.toggleStatus(status: .stopped)
        }
        
    }
    
    func consume(callback: @escaping (Cocoa?) -> Void){
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
            var output: Cocoa?
            
             output = units.popLast()
            print("Milk Consume")
            callback(output)
        }
    }
    
}

