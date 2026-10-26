# YTMVitrine (Liquid Glass UI for YouTube Music iOS)

[![Build IPA](https://github.com/your-username/ytm-vitrine/actions/workflows/build-ipa.yml/badge.svg)](https://github.com/your-username/ytm-vitrine/actions/workflows/build-ipa.yml)

A complete **Liquid Glass (UIGlassEffect / iOS 26+)** UI overhaul for the official decrypted YouTube Music iOS app, faithfully recreating the design language and experience of **[chroma.pw](https://github.com/Clone5030/vitrine)** (Vitrine).

---

## ✨ Features (1:1 Chroma.pw Design Match)

* **💎 Native Liquid Glass Design Language**:
  * Utilizes native `UIGlassEffect` on iOS 26+ with high-fidelity `UIBlurEffectStyleSystemChromeMaterialDark` fallback on earlier versions.
  * Continuous corner radii (`kCACornerCurveContinuous` / `UICornerConfiguration`) across cards, sheets, buttons, and popups.
  * True Black AMOLED base theme (`#000000`).

* **📱 Apple Music-Style Floating Tab Bar**:
  * Floating glass-morphic bottom bar floating 16pt above screen edges.
  * Integrated **Mini Player** directly inside the tab bar displaying live artwork thumbnail, bold title, secondary artist, and play/pause button.
  * Custom SF Symbols iconography (outline when inactive, filled when active).

* **🎵 Full Player Redesign**:
  * Full-screen dynamically animated blurred artwork backdrop with 60% opacity dark overlay.
  * Centered 280pt+ album artwork card with 24pt continuous corner radii and glass specular highlight reflection.
  * Thin glass-morphic scrubber slider with glowing thumb and elapsed/remaining timestamps.
  * Glass playback controls: 64pt prominent play/pause, 48pt previous/next, shuffle, repeat, and lyrics.
  * Interactive pull-down gesture to collapse seamlessly back to mini player.

* **🎤 Word-by-Word Synchronized Lyrics**:
  * Real-time synchronized lyrics screen with full glass overlay and bold centered typography (26pt).
  * Word-level highlighting / sweep animation as words are sung.
  * Active line glow with surrounding lines dimmed and blurred.
  * Immersive landscape mode hiding extraneous controls.

* **🔍 Redesigned Browse, Search & Library**:
  * Collapsing large title header ("Listen Now") with glass profile avatar button.
  * Glass-morphic search bar with 20pt radius and live suggestions.
  * Library view with list/grid toggle and glass filter pills (Playlists, Songs, Albums, Artists, Downloads).
  * Detail header for albums, playlists, and artists with pill-shaped glass Play and Shuffle buttons.

* **⚙️ Dedicated In-App Mod Settings**:
  * Injected directly into YouTube Music's settings.
  * Toggles for Liquid Glass Redesign, True Black AMOLED, Mini Player in Tab Bar, Animated Artwork, Word-by-Word Lyrics, and Haptic Feedback.

* **📲 WidgetKit Live Activity Extension**:
  * Native iOS 17+ Live Activity and Dynamic Island widget support for Now Playing state.

---

## 🚀 Building the IPA

### Path 1: GitHub Actions (Recommended — No Mac Required)

1. **Fork or push this repository** to your GitHub account:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for YTMVitrine"
   git branch -M main
   git remote add origin https://github.com/<your-username>/ytm-vitrine.git
   git push -u origin main
   ```
2. In your GitHub repository, navigate to the **Actions** tab.
3. Select **"Build IPA from your own YouTube Music IPA"** on the left menu.
4. Click **Run workflow**:
   * Enter a direct download URL to your decrypted YouTube Music `.ipa` (e.g. from Google Drive direct link, filebin, Discord CDN, etc.).
   * Choose the upload target (`artifacts`, `filebin`, or `both`).
5. Once the build finishes (approx. 3–5 minutes), download the ready-to-sign `ytm-vitrine.ipa` from the **Artifacts** section!

---

### Path 2: Building Locally with Theos (macOS / Linux)

#### Requirements
* macOS with Xcode or Linux with iOS toolchain
* Theos installed (`~/theos`)
* `cyan` (pyzule-rw):
  ```bash
  uv tool install "cyan @ git+https://github.com/asdfzxcvbn/pyzule-rw.git"
  ```
* Homebrew packages:
  ```bash
  brew install make dpkg ldid
  ```

#### Build & Inject
Place your decrypted YouTube Music IPA in the `ipa/` folder (or specify path):
```bash
# Compile tweak and inject into IPA
make release IPA=path/to/YouTubeMusic.ipa

# The resulting patched IPA will be created in out/ytm-vitrine-1.0.0.ipa
```

---

## ✍️ Signing & Sideloading

Install the resulting IPA on your iOS device using your preferred signing tool:

1. **SideStore / AltStore**:
   * Add the IPA file to SideStore / AltStore and sign with your Apple ID.
2. **Feather / Scarlet / TrollStore**:
   * Direct import and install.
3. **Sideloadly**:
   * Drag and drop `ytm-vitrine-1.0.0.ipa`, enter your Apple ID, and start.

> **Note on Lock Screen Controls**:
> When signing with a personal developer certificate, ensure the App ID matches your signing profile so that tapping Now Playing controls on the lock screen seamlessly opens the app.

---

## 📜 Legal & Credits

* Inspired by **chroma.pw** / **[Vitrine](https://github.com/Clone5030/vitrine)** by Clone5030 & spoti.pw.
* All UI components are original implementations written in Objective-C, Logos, and Swift.
* This project does not contain copyrighted YouTube Music binaries or proprietary Google code. Decrypted IPAs must be provided by the user.
