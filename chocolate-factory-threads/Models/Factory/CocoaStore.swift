//
//  ChocoaStore.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-08.
//

import Foundation


class CocoaStore : Store{
    private var unitQueue: DispatchQueue
    
    private var syncQueue: DispatchQueue
    
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
        self.syncQueue = DispatchQueue.init(label: "com.dinod.cooca.sync")
    }
    
    func setAction(didChangeStatus: @escaping (Status) -> Void){
        self.didChangeStatus = didChangeStatus
    }
    
    
    func start(){
        syncQueue.async {
            self.isActive = true
            self.unitQueue.async{ [weak self] in
                
                guard let `self` = self else {
                    return
                }
                
                var isActive = self.syncQueue.sync{ self.isActive }
                
                while isActive {
                    if(self.maxCapacity >= self.units.count) {
                      
                        syncQueue.sync { self.status = .producing }
                        units.insert(Cocoa(), at: 0)
                        print("Cocoa Produced ",units.count)
                        Thread.sleep(forTimeInterval:0.2)
                    } else {
                        let st = syncQueue.sync{ self.status }
                        
                        if(st != .resourceFull){
                            syncQueue.sync { self.status = .resourceFull }
                        }
                    }
                    
                    isActive = syncQueue.sync{ self.isActive }
                }
                
            }
        }
    
    }
    
    func pause(){
        syncQueue.async {
            print("Stopped!")
            self.isActive = false
        }
        
    }
    
    func reset(){
        syncQueue.async {
            self.isActive = false
            self.unitQueue.async {
                print("Reset")
                self.units = []
            }
        }
        
    }
    
    func consume(count: Int, callback: @escaping ([Cocoa]?) -> Void){
        // check stock availability
        guard count <=  units.count else {
            callback(nil)
            return
        }
        var output: [Cocoa] = []
    
        unitQueue.async { [weak self] in
           
            guard let `self` = self else {
                callback(nil)
                return
            }
            
            for _ in (0..<count).reversed() {
                guard let last = units.popLast() else {
                    callback(output)
                    break
                }
                output.append(last)
            }
           
            
            callback(output)
        }
    }
    
}

