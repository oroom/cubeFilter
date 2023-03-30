import SwiftUI

struct DisplayModePicker: View {
    @Binding var mode: ImageDetail.ViewMode

    var body: some View {
        Picker("Display Mode", selection: $mode) {
            ForEach(ImageDetail.ViewMode.allCases) { viewMode in
                viewMode.label
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

extension ImageDetail.ViewMode {

    var labelContent: (name: String, systemImage: String) {
        switch self {
        case .input:
            return ("Input", "arrowtriangle.left")
        case .output:
            return ("Input", "arrowtriangle.right")
        case .pair:
            return ("Compare", "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right")
        }
    }

    var label: some View {
        let content = labelContent
        return Label(content.name, systemImage: content.systemImage)
    }
}
