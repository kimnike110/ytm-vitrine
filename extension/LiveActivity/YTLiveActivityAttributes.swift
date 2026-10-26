import ActivityKit
import Foundation

public struct YTLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var title: String
        public var artist: String
        public var isPlaying: Bool
        public var progress: Double
        public var duration: Double
        public var artworkData: Data?

        public init(title: String, artist: String, isPlaying: Bool, progress: Double, duration: Double, artworkData: Data? = nil) {
            self.title = title
            self.artist = artist
            self.isPlaying = isPlaying
            self.progress = progress
            self.duration = duration
            self.artworkData = artworkData
        }
    }

    public var sessionID: String

    public init(sessionID: String) {
        self.sessionID = sessionID
    }
}
