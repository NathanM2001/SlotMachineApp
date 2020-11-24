//
//  Helicopter.swift
//  SlotMachineApp
//
//  Created by Nathan Mckenzie on 11/24/20.
//

import SwiftUI

struct Helicopter: View {
    
    let rows = 5
    let columns = 5
    let size: CGFloat = 10
    let heliBlocks: [[Color]] = [[.gray,.gray,.gray,.gray,.gray],
                                 [.clear,.clear,.green,.clear,.clear],
                                 [.green,.green,.green,.green,.gray],
                                 [.clear,.clear,.green,.green,.green],
                                 [.clear,.clear,.gray,.clear,.gray]]
    
    
    var body: some View {
        
        VStack (spacing: 0) {
            ForEach((0...self.rows - 1), id: \.self) { row in
                HStack (spacing: 0) {
                    ForEach((0...self.columns - 1), id: \.self) { col in
                        VStack (spacing: 0) {
                            Pixel(size: self.size, color: self.heliBlocks[row][col])
                        }
                    }
                }
            }
        }
    }
}
