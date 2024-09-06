//
//  RunStats.swift
//  Numo test1
//
//  Created by Тасік on 26.06.2024.
//

import SwiftUI

struct RunStats: View {
    @Binding var duration : Double
    @Binding var distance : Double
    @Binding var pace : Double
    
    
    
    var body: some View {
        Text("Duration : \(duration)")
        Text("Distance : \(distance)")
        Text("Pace : \(pace)")
    }
}
