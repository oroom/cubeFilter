import Foundation
import AppKit
import UniformTypeIdentifiers

enum ContentTypes {
    static let allowed: [UTType] = [.jpeg, .png]
}

func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.allowedContentTypes = ContentTypes.allowed
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}

func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = ContentTypes.allowed
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.allowsOtherFileTypes = false
    savePanel.title = "Save processed image"
    savePanel.message = "Choose a folder and a name to store processed image."
    savePanel.nameFieldLabel = "File name:"
    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
}
