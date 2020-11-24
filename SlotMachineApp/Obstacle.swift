//
//  Obstacle.swift
//  SlotMachineApp
//
//  Created by Nathan Mckenzie on 11/24/20.
//

import SwiftUI

struct Obstacle: View {
    
    let width: CGFloat = 20
    let height: CGFloat = 200
    
    var body: some View {
        
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(Color.green)
        
    }
}
