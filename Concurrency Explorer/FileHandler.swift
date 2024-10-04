import Foundation

class FileReader {
    let chunkSize: Int
    let fileHandle: FileHandle
    var buffer: Data?
    var offset: UInt64
    
    init?(url: URL, chunkSize: Int = 4096, offset: UInt64 = 0)
    {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return nil }
        self.fileHandle = fileHandle
        self.chunkSize = chunkSize
        self.buffer = Data(capacity: chunkSize)
        self.offset = offset
    }
    
    deinit {
        fileHandle.closeFile()
    }
    
    func readChunk() -> String {
        do {
            if offset != 0 {
                try fileHandle.seek(toOffset: offset)
            }
            buffer = try fileHandle.read(upToCount: chunkSize)
            guard let buffer = buffer else {
                return ""
            }
            offset += UInt64(buffer.count)
            return String(decoding: buffer, as: UTF8.self)
        } catch {
            print("Error: \(error.localizedDescription)")
            return ""
        }
    }
}
