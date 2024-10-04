import SwiftUI
import Combine

class StreamReaderViewModel: ObservableObject {
    private var fileReader: FileReader?
    private let streamReaderDispatch = DispatchQueue(label: "concurrencyExplorer", qos: .userInitiated)
    private let lock = NSLock()
    @Published var lines: [String] = []
    
    func startReading(url: URL) {
        lock.lock()
        self.fileReader = FileReader(url: url)
        self.lines = []
        lock.unlock()
        self.loadMore()
    }
    
    func loadMore() {
        streamReaderDispatch.async {
            self.lock.lock()
            guard let fileReader = self.fileReader else {
                self.lock.unlock()
                return
            }
            let newLines = fileReader.readChunk().split(separator: "\n").map(String.init)
            self.lock.unlock()
            DispatchQueue.main.async {
                self.lock.lock()
                self.lines.append(contentsOf: newLines)
                self.lock.unlock()
            }
        }
    }
}
