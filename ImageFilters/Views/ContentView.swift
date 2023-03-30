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
