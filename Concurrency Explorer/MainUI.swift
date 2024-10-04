import SwiftUI

struct MainUI: View {
    @StateObject private var viewModel = StreamReaderViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    let openURL = showOpenPanel()
                    guard let url = openURL else { return }
                    
                    viewModel.startReading(url: url)
                    
                }, label: {
                    Text("Open file")
                })
                
                List(viewModel.lines.indices, id: \.self) { index in
                    highlightSearchTerm(in: viewModel.lines[index], searchTerm: searchText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear {
                            if index == viewModel.lines.count - 1 {
                                viewModel.loadMore()
                            }
                        }
                }
                .border(Color.gray, width: 1)
                .padding()
                .searchable(text: $searchText)
            }
            .padding()
        }
    }
    
    private func showOpenPanel() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.text]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    private func highlightSearchTerm(in text: String, searchTerm: String) -> Text {
        guard !searchTerm.isEmpty else {
            return Text(text)
        }
        
        let parts = text.components(separatedBy: searchTerm)
        var result = Text("")
        
        for (index, part) in parts.enumerated() {
            if index > 0 {
                result = result + Text(searchTerm).foregroundColor(.yellow)
            }
            result = result + Text(part)
        }
        
        return result
    }
}
