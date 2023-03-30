import Foundation
import AppKit

func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.allowedContentTypes = [.jpeg, .png]
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}
