//
//  Pixel.swift
//  SlotMachineApp
//
//  Created by Nathan Mckenzie on 11/24/20.
//

import SwiftUI

struct Pixel: View {
    let size: CGFloat
    let color: Color
    
    
    var body: some View {
        Rectangle()
            .frame(width: size, height: size)
            .foregroundColor(color)
    }
    
    
}
