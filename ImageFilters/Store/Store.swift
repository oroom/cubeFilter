import Foundation

class Store: ObservableObject {
    @Published var image: URL?
    @Published var filters: [Filter] = []
    @Published var selectedFilter: Filter.ID?
    @Published var mode: ImageDetail.ViewMode = .input

    init() {
        filters = [.init(id: "test", name: "test")]
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
                filters[filters.firstIndex(where: { $0.id == id })!] = newValue
            }
        }
    }

    func append(_ filter: Filter) {
        filters.append(filter)
    }
}
