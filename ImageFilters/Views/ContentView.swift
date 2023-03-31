import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @SceneStorage("selectedFilter") var selectedFilterID: Filter.ID?
    
    var body: some View {
        NavigationView {
            Sidebar(selectedFilter: selection)
            ImageDetail()
        }
    }
    
    private var selection: Binding<Filter.ID?> {
        Binding(get: {
            selectedFilterID
        }, set: {
            selectedFilterID = $0
            store.filterSelected($0)
        })
    }
    
    private var selectedFilter: Binding<Filter?> {
        $store[selection.wrappedValue]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}
