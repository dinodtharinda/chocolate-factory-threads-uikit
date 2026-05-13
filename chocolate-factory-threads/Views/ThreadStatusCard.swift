//
//  ThreadStatusCard.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-04-30.
//

import UIKit

class ThreadStatusCard: AppUIView {
    @IBOutlet private weak var labelThreadName: UILabel!
    @IBOutlet private weak var labelThreadStatus: UILabel!
    
    
    func setup(model:ThreadStatus){
        labelThreadName.text = model.threadName
        labelThreadStatus.text = model.threadStatus.rawValue
        model.store.setAction(didChangeStatus: reloadLabel)
    }
    
    func reloadLabel(status: Status){
        labelThreadStatus.text = status.rawValue.capitalized
    }
    
    
}
