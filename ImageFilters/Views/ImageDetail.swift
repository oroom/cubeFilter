import SwiftUI

struct ImageDetail: View {
    
    enum ViewMode: String, CaseIterable, Identifiable {
        var id: Self { self }
        case input
        case output
        case pair
    }
    
    @EnvironmentObject var store: Store
    @Binding var selectedFilter: Filter.ID?
    @SceneStorage("viewMode") private var mode: ViewMode = .input
    
    var body: some View {
        Group {
            if let url = store.image {
                Image(nsImage: NSImage(byReferencing: url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Add input source")
            }
        }
        .toolbar {
            DisplayModePicker(mode: $mode)
            Button(action: openImage) {
                Label("Open image", systemImage: "plus")
            }
        }
        .frame(width: 500, height: 500)
        .navigationTitle("Image url")
    }
}

extension ImageDetail {

    func openImage() {
        if let imageUrl = showOpenPanel() {
            store.image = imageUrl
        }
    }
}

struct ImageDetail_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetail(selectedFilter: .constant(nil))
            .environmentObject(Store())
    }
}
