//
//  ThreadCardView.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-04-30.
//

import UIKit

class ThreadCardView: AppUIView {
    @IBOutlet private weak var labelCapacity: UILabel!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet weak var hStackView: UIStackView!
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    func setupProgressStack(index: Int){
        
        for view in hStackView.arrangedSubviews {
            hStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        hStackView.spacing = 4
        
        for _ in 0..<max(0, index) {
            
            let ui = UIView()
            ui.backgroundColor = .red
            ui.clipsToBounds = true
            ui.layer.cornerRadius = 4
            ui.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                ui.widthAnchor.constraint(equalToConstant: 12),
                ui.heightAnchor.constraint(equalToConstant: 24)
            ])

            hStackView.addArrangedSubview(ui)
        }

        hStackView.addArrangedSubview(UIView())
    }
    
    func setup(model: String){
       
    }
   

}
