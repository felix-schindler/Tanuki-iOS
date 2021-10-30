//
//  IssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct IssueView: View {
    @State var issue: Issue
    
    var body: some View {
        Text(issue.title)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: Issue(id: 0, iid: 0, title: "No issue given"))
    }
}
