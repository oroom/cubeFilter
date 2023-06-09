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
            Button(action: toggleVideo) {
                Label("Camera", systemImage: "camera.aperture")
            }
            Button(action: openImage) {
                Label("Open image", systemImage: "plus")
            }
            Button(action: saveImage) {
                Label("Save image", systemImage: "square.and.arrow.down.fill")
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
    
    func saveImage() {
        if let imageUrl = showSavePanel() {
            store.saveImage(url: imageUrl)
        }
    }
    
    func toggleVideo() {
        store.toggleVideo()
    }
}

struct ImageDetail_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetail()
            .environmentObject(Store())
    }
}
