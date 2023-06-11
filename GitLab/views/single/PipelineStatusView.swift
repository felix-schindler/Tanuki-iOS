//
//  PipelineStatusView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct PipelineStatusView: View {
	@State var status: String
	
	var body: some View {
		if (status == "success") {
			Image(systemName: "checkmark.circle")
				.foregroundStyle(.green)
		} else if (status == "failed") {
			Image(systemName: "minus.circle")
				.foregroundStyle(.red)
		} else if (status == "canceled") {
			Image(systemName: "slash.circle")
				.foregroundStyle(.gray)
		} else if (status == "skipped") {
            Image(systemName: "chevron.right.circle")
                .foregroundStyle(.gray)
        } else {
			Image(systemName: "arrow.2.circlepath.circle")
				.foregroundStyle(.orange)
		}
	}
}

struct PipelineStatusView_Previews: PreviewProvider {
	static var previews: some View {
        PipelineStatusView(status: "skipped")
	}
}
