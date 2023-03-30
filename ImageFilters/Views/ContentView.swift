import SwiftUI

struct ContentView: View {
    
    @SceneStorage("selectedFilter") var selectedFilter: Filter.ID?
    
    var body: some View {
        NavigationView {
            Sidebar(selectedFilter: $selectedFilter)
            ImageDetail(selectedFilter: $selectedFilter)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}

struct Sidebar: View {
    @EnvironmentObject var store: Store
    
    @SceneStorage("expansionState") var expensionState = ExpansionState()
    
    @Binding var selectedFilter: Filter.ID?
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $expensionState["filters"]) {
                ForEach(store.filters) { filter in
                    Label(filter.name, systemImage: "cube")
                }
            } label: {
                Label("Filters", systemImage: "camera.filters")
            }
        }
        .frame(minWidth: 200)
    }
}
