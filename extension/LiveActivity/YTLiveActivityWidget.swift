import ActivityKit
import SwiftUI
import WidgetKit

@main
struct YTLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        YTLiveActivityWidget()
    }
}

struct YTLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: YTLiveActivityAttributes.self) { context in
            // Lock Screen presentation
            HStack(spacing: 14) {
                if let data = context.state.artworkData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Image(systemName: "music.note")
                                .foregroundColor(.white.opacity(0.8))
                        )
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(context.state.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(context.state.artist)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding(16)
            .background(Color.black.opacity(0.85))
            .activityBackgroundTint(Color.black.opacity(0.75))
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded Dynamic Island
                DynamicIslandExpandedRegion(.leading) {
                    if let data = context.state.artworkData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    } else {
                        Image(systemName: "music.note")
                            .frame(width: 44, height: 44)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(context.state.artist)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: context.state.progress, total: max(context.state.duration, 1.0))
                        .tint(.white)
                        .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: "music.note")
                    .foregroundColor(.white)
            } compactTrailing: {
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: "music.note")
                    .foregroundColor(.white)
            }
        }
    }
}
