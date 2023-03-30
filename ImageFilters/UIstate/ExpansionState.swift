import Foundation

struct ExpansionState: RawRepresentable {

    var ids: Set<String>
    
    let current = "filters"

    init?(rawValue: String) {
        ids = Set(rawValue.components(separatedBy: ","))
    }

    init() {
        ids = []
    }

    var rawValue: String {
        ids.joined(separator: ",")
    }

    var isEmpty: Bool {
        ids.isEmpty
    }

    func contains(_ id: String) -> Bool {
        ids.contains(id)
    }

    mutating func insert(_ id: String) {
        ids.insert(id)
    }

    mutating func remove(_ id: String) {
        ids.remove(id)
    }

    subscript(section: String) -> Bool {
        get {
            // Expand the filters by default
            ids.contains(section) ? true : section == current
        }
        set {
            if newValue {
                ids.insert(section)
            } else {
                ids.remove(section)
            }
        }
    }
}
