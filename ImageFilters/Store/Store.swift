import Foundation

class Store: ObservableObject {
    @Published var image: FilteredImage?
    @Published var filters: [Filter] = []
    @Published var selectedFilter: Filter.ID?
    @Published var mode: ImageDetail.ViewMode = .input
    lazy var videoService = VideoService { videoFrame in
        self.image = videoFrame
    }
    private var loadedFilter: ImageFilter = NoOp() {
        didSet {
            videoService.filters = [loadedFilter]
            updateImage()
        }
    }

    init() {
        filters = []
    }

    subscript(filterID: Filter.ID?) -> Filter? {
        get {
            if let id = filterID {
                return filters.first(where: { $0.id == id }) ?? nil
            }
            return nil
        }

        set(newValue) {
            if let id = filterID, let newValue {
                if let index = filters.firstIndex(where: { $0.id == id }) {
                    filters[index] = newValue
                }
                else {
                    filters.append(newValue)
                }
            }
        }
    }
    
    func filterSelected(_ id: Filter.ID?) {
        if let filter = self[id], let lutFilter = LUTFilter(from: filter) {
            loadedFilter = lutFilter
        }
    }

    func append(_ filter: Filter) {
        filters.append(filter)
    }
    
    func processImage(url: URL) {
        videoService.stop()
        image = FilteredImage(url: url)
        updateImage()
    }
    
    func saveImage(url: URL) {
        _ = image?.output?.write(to: url)
    }
    
    func toggleVideo() {
        videoService.toggleVideo()
    }
    
    private func updateImage() {
        image?.applyFilters([loadedFilter])
    }
}
