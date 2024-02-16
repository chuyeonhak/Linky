//
//  MakerProfileView.swift
//  Features
//
//  Created by chuchu on 2/16/24.
//

import SwiftUI

struct MakerProfileView: View {
    var body: some View {
        VStack {
            FidgetTextView("Project Manager @mong._09", fontSize: 25)
                .frame(height: 25)
            Spacer()
            FidgetTextView("UI Designer @hi__luu", fontSize: 25)
                .frame(height: 25)
            Spacer()
            FidgetTextView("iOS developer @amola_chu", fontSize: 25)
                .frame(height: 25)
            Spacer()
            FidgetTextView("android developer @min._.dda", fontSize: 25)
                .frame(height: 25)
        }.frame(height: 160)
    }
}
