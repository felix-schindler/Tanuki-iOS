//
//  LabelListView.swift
//  GitLab
//
//  Created by Felix Schindler on 06.11.21.
//

import SwiftUI

struct LabelListView: View {
    @State var labels: [Label]
    
    var body: some View {
        VStack {
            Text("Labels")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(labels, id: \.id) { label in
                Text(label.name.emojized())
                    .padding(.horizontal, 5)
                    .background(Color.init(hex: label.color))
                    .cornerRadius(10)
                    .foregroundColor(Color.init(hex: label.textColor))
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LabelListView_Previews: PreviewProvider {
    static var previews: some View {
        LabelListView(labels: [Label]())
    }
}
