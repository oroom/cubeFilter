//
//  Sidebar.swift
//  ImageFilters
//
//  Created by oroom on 2023-03-31.
//

import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var store: Store
    
    @SceneStorage("expansionState") var expensionState = ExpansionState()
    
    @Binding var selectedFilter: Filter.ID?
    
    var body: some View {
        List(selection: $selectedFilter) {
            DisclosureGroup(isExpanded: $expensionState["filters"]) {
                ForEach(store.filters) { filter in
                    Label(filter.name, systemImage: "cube")
                }
            } label: {
                Label("Filters", systemImage: "camera.filters")
            }
        }
        .frame(minWidth: 200)
        .toolbar() {
            Button(action: addFilter) {
                Label("Add filter", systemImage: "plus")
            }
        }
    }
}

extension Sidebar {

    func addFilter() {
        if let filterUrl = showOpenPanel() {
            store[filterUrl.lastPathComponent] = .init(url: filterUrl)
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar(selectedFilter: .constant("filters"))
            .environmentObject(Store())
    }
}
