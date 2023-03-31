import SwiftUI

struct ImageDetail: View {
    
    enum ViewMode: String, CaseIterable, Identifiable {
        var id: Self { self }
        case input
        case output
        case pair
    }
    
    @EnvironmentObject var store: Store
    @SceneStorage("viewMode") private var mode: ViewMode = .input
    
    var body: some View {
        Group {
            if let image = store.image, mode == .input {
                Image(nsImage: image.input)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let image = store.image, mode == .output {
                Image(nsImage: image.output)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let image = store.image, mode == .pair {
                HStack {
                    Image(nsImage: image.input)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image(nsImage: image.output)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
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
        .navigationTitle("Image url")
    }
}

extension ImageDetail {

    func openImage() {
        if let imageUrl = showOpenPanel() {
            store.processImage(url: imageUrl)
        }
    }
}

struct ImageDetail_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetail()
            .environmentObject(Store())
    }
}
