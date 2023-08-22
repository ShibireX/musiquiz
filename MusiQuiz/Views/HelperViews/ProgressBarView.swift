//
//  ProgressBarView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-22.
//

import SwiftUI

struct ProgressBarView: View {
    var barWidth: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: barWidth, height: 20)
                //.padding(.bottom, -65)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(barWidth: 400)
    }
}
