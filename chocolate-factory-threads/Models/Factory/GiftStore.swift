//
//  GiftStore.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-11.
//

import Foundation


class GiftStore : Store {
    private var unitQueue: DispatchQueue
    private var syncQueue: DispatchQueue
    private var maxCapacity: Int = 30
    private var units:[Gift]  = []
    private var isActive: Bool = false
    private var milkUnits: [Milk] = []
    private var chocoUnits:[Choco] = []
    private var status: Status {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChangeStatus?(newValue)
            }
        }
    }
    
    private var didChangeStatus: ((Status) -> Void)?
    
    
    init() {
        status = .stopped
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.gift.unit",
            attributes: .concurrent
        )
        self.syncQueue = DispatchQueue.init(label: "com.dinod.gift.sync")
      
    }
    
    func setAction(didChangeStatus: @escaping (Status) -> Void){
        self.didChangeStatus = didChangeStatus
    }
    
    func produce(chocoStore:ChocoStore, milkStore: MilkStore){
        syncQueue.async {
            self.isActive = true
            self.unitQueue.async {[weak self] in
                guard let `self` = self else { return }
                
                let isActive = syncQueue.sync{ self.isActive }
                while isActive {
                    if(self.maxCapacity > self.units.count){
                       
                        
                        if(milkUnits.count == 0){
//                            milkStore
//                                .consume(count: 2, callback: milkConsume)
                        }
                        
                        
                        chocoStore
                            .consume(count: 1, callback: chocoConsume)
                        
                       
                        let milk =  self.syncQueue.sync{ self.milkUnits }
                        let choco = self.syncQueue.sync{ self.chocoUnits }
                        

                        guard  milk.count == 2, choco.count == 1 else {
                           
                            self.syncQueue.sync {
                                self.status = .waiting
                            }
//                            print("gift continued ",milk.count," ",choco.count)
                            continue
                        }
                        self.syncQueue.sync {
                            self.status = .producing
                        }
                        Thread.sleep(forTimeInterval: 2)
                        self.units.insert(Gift(), at: 0)
                        syncQueue.async {
                            self.milkUnits = []
                            self.chocoUnits = []

                        }
                                               
//                        print("Gift Produced" ,units.count)
                        
                    } else {
                        let st = self.syncQueue.sync {
                            self.status
                        }
                        if st != .resourceFull {
                            self.syncQueue.sync {
                                self.status = .resourceFull
                            }
                        }
                    }
                }
            }
        }
    }
    

    
    func milkConsume(milk:[Milk]?){
       
        
        self.syncQueue.async{
            guard self.milkUnits.count == 0 else {
                return
            }
            self.milkUnits = milk ?? []
        }
    }
    
    
    func chocoConsume(choco:[Choco]?){
      
        
        self.syncQueue.async{
            guard self.chocoUnits.count == 0 else {
                return
            }
            self.chocoUnits = choco ?? []
        }
    }
    
}
