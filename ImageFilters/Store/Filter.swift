import Foundation

struct Filter: Identifiable, Codable {
    let url: URL
    var id: String {
        url.lastPathComponent
    }
    var name: String {
        url.deletingPathExtension().lastPathComponent
    }
}
