# RARE□TV Mobile - Solana Native Streaming Platform

![App Preview](app.jpeg)

**A native mobile companion to RARE□TV, the decentralized live streaming platform built for Solana Colosseum Hackathon**

[Website](https://rarecube.tv) • [GitHub](https://github.com/rarecubetv/cube_colosseum) • [Twitter](https://x.com/rarecubetv)

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)](https://flutter.dev)
[![Solana](https://img.shields.io/badge/Solana-Devnet-9945FF?logo=solana)](https://solana.com)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

---

## Overview

RARE□TV Mobile brings the decentralized streaming experience to native iOS and Android devices with Solana Mobile Wallet Adapter integration. This Flutter application extends the RARE□TV web platform (built with Astro, React, and Convex) to mobile-first audiences, particularly targeting Solana Seeker and mobile Web3 users.

### Platform Context

RARE□TV is a multi-chain streaming platform featuring:
- Real-time live streaming
- Multi-chain wallet authentication (Solana, Ethereum, Base, Polygon)
- X/Twitter OAuth integration for social verification
- Live chat and viewer tracking via Convex real-time database
- Progressive Web App capabilities

This mobile application focuses exclusively on Solana integration, providing a streamlined native experience optimized for mobile hardware and the Solana ecosystem. The desktop application is cross-chain Solana + EVM.

---

## Key Features

### Solana Mobile Wallet Adapter Integration

**Production-Ready Wallet Connectivity**
- One-tap wallet connection using Solana's official Mobile Wallet Adapter specification
- Support for Phantom, Solflare, Backpack, and other mobile Solana wallets
- Transaction signing and message authentication
- Persistent wallet state management with Riverpod
- Devnet and mainnet configuration support

**Implementation Architecture**
```dart
// Core wallet service with complete lifecycle management
SolanaWalletService
  - authorize()           // Connect to mobile wallet
  - deauthorize()         // Disconnect and cleanup
  - signTransaction()     // Single transaction signing
  - signTransactions()    // Batch transaction support
  - signMessage()         // Message signing for authentication
```

### Native Mobile Experience

**Optimized UI Components**
- 3D animated cube avatars rendered at 60 FPS using Flutter's rendering engine
- Multiple avatar size variants (80x80, 48x48, 32x32) for different contexts
- Dark theme with WCAG-compliant contrast ratios optimized for OLED displays
- Responsive grid layouts adapting from 2-4 columns based on screen size
- Bottom navigation with badge support and smooth transitions

**Platform Support**
- iOS (iPhone, iPad) with native wallet deep linking
- Android with Material Design compliance
- Web deployment via Flutter Web
- Desktop support (macOS, Windows, Linux) for development

---

## Technical Architecture

### Frontend Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Framework | Flutter 3.8.1 | Cross-platform native UI |
| State Management | Riverpod 3.0.2 | Reactive state and dependency injection |
| Navigation | go_router 16.2.4 | Type-safe routing with deep links |
| Blockchain | solana_wallet_adapter 0.1.5 | Solana Mobile Wallet Adapter |
| HTTP Client | Dio 5.9.0 | API communication |
| Image Loading | cached_network_image 3.4.1 | Optimized image caching |

### Backend Integration

**Convex Real-Time Database**
- Primary backend: `https://preset-fox-185.convex.cloud`
- API proxy via Next.js routes at `rarecube.tv`
- Real-time subscriptions for live data (HTTP polling, WebSocket-ready)
- File storage for user avatars and media content

**Data Models**
- User profiles with Twitter verification and wallet linking
- Stream cards with media attachments and token metadata
- Social links and engagement tracking (followers, subscriptions)
- Comments with nested replies and voting system

### Solana Integration Details

**Service Layer**
```dart
// lib/core/solana/solana_wallet_service.dart
class SolanaWalletService {
  final SolanaWalletAdapter _adapter;
  Account? _currentAccount;
  bool _isAuthorized = false;

  String? get publicKey => _currentAccount?.address;
  bool get isAuthorized => _isAuthorized;
}
```

**State Management**
```dart
// lib/presentation/providers/solana_provider.dart
final solanaWalletServiceProvider;  // Singleton wallet service
final solanaAuthStateProvider;      // Connection state boolean
final solanaPublicKeyProvider;      // Current wallet address string
```

**UI Components**
- `SolanaWalletButton`: Reusable connect/disconnect button with address display
- Auto-formatting of wallet addresses (displays first 4 and last 4 characters)
- Connection status feedback with loading states

---

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── env_config.dart              # Environment variables
│   ├── theme/
│   │   ├── app_colors.dart              # Color system (#22C55E primary)
│   │   └── app_theme.dart               # Dark theme definition
│   ├── solana/
│   │   └── solana_wallet_service.dart   # Wallet lifecycle management
│   └── utils/
│       └── contrast_calculator.dart     # WCAG accessibility utilities
│
├── data/
│   ├── models/
│   │   ├── user.dart                    # User entity with Convex schema
│   │   └── stream_card.dart             # Stream content model
│   ├── datasources/
│   │   └── convex_client.dart           # HTTP client for Convex API
│   └── repositories/
│       └── user_repository.dart         # User CRUD operations
│
├── presentation/
│   ├── providers/
│   │   ├── convex_provider.dart         # Global Convex client
│   │   ├── user_provider.dart           # User data providers
│   │   └── solana_provider.dart         # Wallet state providers
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart        # Login + wallet connect
│   │   ├── home/
│   │   │   └── home_screen.dart         # User discovery grid
│   │   ├── stream/
│   │   │   ├── stream_feed_screen.dart  # Dual-tab feed (Streams/Wall)
│   │   │   ├── stream_create_screen.dart
│   │   │   └── stream_detail_screen.dart
│   │   └── profile/
│   │       └── user_profile_screen.dart
│   └── widgets/
│       ├── solana/
│       │   └── solana_wallet_button.dart # Wallet UI component
│       ├── cube/
│       │   └── cube_avatar.dart         # 3D rotating avatars
│       ├── media/                       # Video/image players
│       └── common/
│           └── bottom_nav.dart          # Tab navigation
│
└── routes/
    └── app_router.dart                  # Navigation configuration
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Xcode 14+ (for iOS development)
- Android Studio with NDK (for Android development)
- Solana wallet app (Phantom, Solflare) for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rarecubetv/cube_colosseum.git
   cd cube_colosseum
   git checkout flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment** (optional)

   Edit `lib/core/config/env_config.dart`:
   ```dart
   static const String convexUrl = 'https://preset-fox-185.convex.cloud';
   static const String backendUrl = 'https://join.rarecube.tv';
   ```

4. **Run on device**
   ```bash
   # List available devices
   flutter devices

   # iOS Simulator
   flutter run -d iphone

   # Android Emulator
   flutter run -d emulator-5554

   # Physical device (ensure USB debugging enabled)
   flutter run
   ```

### Testing Solana Integration

1. Install Phantom or Solflare wallet on your test device
2. Switch wallet network to Devnet in settings
3. Launch RARE□TV mobile app
4. Tap "Connect Wallet" button on login screen
5. Approve connection request in wallet app
6. Wallet address displays in app (format: `Abc1...xyz9`)

---

## Development Workflow

### Hot Reload

Flutter's hot reload enables instant feedback during development:
- Save any Dart file to trigger automatic reload
- Press `r` in terminal for manual reload
- Press `R` for full app restart (resets state)

### Code Quality

```bash
# Static analysis
flutter analyze

# Run tests
flutter test

# Format code
flutter format .
```

### Building for Production

**iOS**
```bash
flutter build ios --release
open ios/Runner.xcworkspace
# Use Xcode to archive and submit to App Store
```

**Android**
```bash
# APK for direct distribution
flutter build apk --release

# App Bundle for Google Play
flutter build appbundle --release
```

**Web**
```bash
flutter build web --release
# Deploy build/web directory to hosting provider
```

---

## Implementation Status

### Completed Features

**Core Infrastructure**
- Multi-platform Flutter setup (iOS, Android, Web, macOS, Windows, Linux)
- Dark theme with accessibility compliance
- Riverpod dependency injection and state management
- go_router navigation with deep linking support

**Solana Integration**
- SolanaWalletService with full wallet lifecycle
- Connect/disconnect functionality
- Transaction and message signing capabilities
- Riverpod providers for reactive state
- SolanaWalletButton reusable UI component

**User Interface**
- 3D CubeAvatar component (3 size variants)
- LoginScreen with Twitter OAuth and Solana wallet buttons
- HomeScreen with responsive user grid (2-4 columns)
- StreamFeedScreen with dual tabs (Streams/Wall)
- ProfileScreen with follow system
- BottomNav with 5-tab navigation and badge support

**Data Layer**
- User and StreamCard models aligned with Convex schema
- UserRepository for CRUD operations
- ConvexClient for API communication
- Support for token attachments and social links

### Roadmap

**Phase 2 - Post-Hackathon**
- NFT minting for creator cards
- Token-gated content access
- SPL token integration for tips and payments
- On-chain social graph with Solana accounts

**Phase 3 - Future Vision**
- Live streaming with Solana micropayments
- Creator DAOs for governance
- Cross-chain bridges (Solana ↔ EVM)
- AR features for Solana Saga device

---

## Design Philosophy

### Mobile-First Principles

**Performance**
- 60 FPS animations with Flutter's Skia rendering
- Lazy loading and pagination for large lists
- Image caching with automatic memory management
- Minimal bundle size through tree shaking

**User Experience**
- Dark theme optimized for OLED power savings
- Smooth transitions and micro-interactions
- Offline capability with cached data
- Progressive disclosure of complex features

**Accessibility**
- WCAG AA contrast ratios (4.5:1 minimum)
- Semantic screen reader labels
- Large tap targets (minimum 44x44 dp)
- Keyboard navigation support

### Brand Identity

**Color System**
- Primary: `#22C55E` (vibrant green representing growth)
- Background: `#000000` (pure black for OLED)
- Surface: `#0A0A0A` (subtle depth layers)
- Text Primary: `#FFFFFF`
- Text Secondary: `#FFFFFF` at 70% opacity

**Typography**
- Headings: Poppins (Bold, Semibold)
- Body: SF Pro (Regular, Medium)
- Labels: SF Pro (Medium, Semibold)

---

## Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards

- Follow Flutter style guide and lint rules
- Write unit tests for business logic
- Document public APIs with DartDoc comments
- Keep functions focused and under 50 lines
- Use meaningful variable names (no abbreviations)

---

## Team & Contact

**RARE□TV Project**
- Website: [rarecube.tv](https://rarecube.tv)
- GitHub: [rarecubetv/cube_colosseum](https://github.com/rarecubetv/cube_colosseum)
- Twitter: [@rarecube](https://twitter.com/rarecube)

**Built For**
- Solana Colosseum Hackathon - Mobile Track
- Solana Seeker device optimization
- Mobile Web3 ecosystem advancement

---

## License

Copyright (c) 2025 RareCube

Licensed under the Apache License, Version 2.0 - see [LICENSE](LICENSE) file for details.

**Key terms**: Free to use, modify, and distribute with attribution. Patent rights granted. Commercial use allowed.

---

## Acknowledgments

- **Solana Foundation** for Mobile Wallet Adapter SDK and developer resources
- **Flutter Team** for the cross-platform framework and comprehensive documentation
- **Convex** for real-time backend infrastructure with zero-config deployment
- **RARE□TV Community** for testing feedback and feature requests

---

## Project Statistics

- **Lines of Code**: 5,000+ Dart
- **Files**: 25+ source files
- **Platforms Supported**: 6 (iOS, Android, Web, macOS, Windows, Linux)
- **Dependencies**: 20+ carefully selected packages
- **Development Time**: Hackathon sprint (14 days)
- **Flutter Version**: 3.8.1
- **Solana Wallet Adapter**: 0.1.5

---

<div align="center">

**Built for Solana Colosseum Hackathon**

[Report Bug](https://github.com/rarecubetv/cube_colosseum/issues) • [Request Feature](https://github.com/rarecubetv/cube_colosseum/issues)

Last Updated: 2025-10-30
Version: 1.0.0 (Hackathon Submission)

</div>
