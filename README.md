# Project Structure & Architecture Guidelines

## Project Structure

```
lib/
├── src/
│   ├── core/
│   │   ├── api/           # API clients and services
│   │   ├── constants/     # App-wide constants
│   │   ├── exceptions/    # Custom exceptions
│   │   ├── extensions/    # Extension methods
│   │   ├── navigation/    # Router configuration
│   │   ├── storage/       # Local storage services
│   │   ├── theme/         # App theme definitions
│   │   └── core.dart      # Barrel file for core exports
│   │
│   ├── modules/           # Feature modules
│   │   ├── admin/
│   │   │   ├── data/      # Repository implementations, models, data sources
│   │   │   ├── domain/    # Business logic, entities, repository interfaces
│   │   │   └── presentation/
│   │   │       ├── notifiers/  # State management
│   │   │       ├── screens/    # UI screens
│   │   │       └── widgets/    # Reusable widgets
│   │   │
│   │   ├── auth/          # Authentication module
│   │   ├── audio/         # Audio module
│   │   ├── books/         # Books module
│   │   ├── dashboard/     # Dashboard module
│   │   ├── donation/      # Donation module
│   │   ├── profile/       # Profile module
│   │   └── videos/        # Videos module
│   │
│   └── tools/             # Utility functions and helpers
│       └── tools_barrel.dart  # Barrel file for tools
│
├── assets/
│   ├── images/            # Image assets
│   ├── vectors/           # SVG assets
│   └── env/               # Environment configuration files
│
└── main.dart              # Application entry point
```

## Architecture

This project follows a modular architecture with clear separation of concerns:

1. **Core Layer**: Contains app-wide utilities, constants, and services
2. **Modules**: Feature-based modules following a clean architecture pattern with:
    - **Data Layer**: API clients, repositories, models
    - **Domain Layer**: Business logic, entities
    - **Presentation Layer**: UI components, state management

## Coding Style Guidelines

### Naming Conventions

- **Classes**: Pascal case (e.g., `UploadVideoScreen`, `AppColors`)
- **Variables/Functions**: Camel case (e.g., `titleController`, `uploadVideo`)
- **Constants**: Camel case for constants (e.g., `blackVoid` in `AppColors`)
- **Files**: Snake case (e.g., `upload_video_screen.dart`)

### File Organization

1. **Import Order**:
    - Dart/Flutter SDK imports
    - External package imports
    - Project imports
    - Relative imports

2. **Class Structure**:
    - Properties
    - Constructor
    - Lifecycle methods (`dispose`, `initState`)
    - Public methods
    - Private methods
    - Build method (for widgets)

## State Management

The project uses the **Vanilla State** package for state management:

- State classes extend `VanillaState`
- Notifiers handle business logic and state changes
- `VanillaBuilder` rebuilds UI when state changes
- `VanillaListener` handles side effects

Example usage:

```dart
// State definition
class UploadVideoState extends VanillaState {
  final bool isOutLoading;
  final bool isSuccess;

  const UploadVideoState({
    this.isOutLoading = false,
    this.isSuccess = false,
  });
}

// Listening to state changes
VanillaListener<UploadVideoNotifier, UploadVideoState>
(
listener: (previous, current) {
// Handle state changes
},
child: VanillaBuilder<UploadVideoNotifier, UploadVideoState>(
builder: (context, state) {
// Build UI based on state
},
)
,
);
```

## Dependency Injection

The project uses **GetIt** for dependency injection:

- Services and repositories are registered with the container
- Components access dependencies through the container
- Example usage: `container()` to get an instance of a registered dependency

```dart
// Service registration
final GetIt container = GetIt.instance;

void setupDependencies() {
  container.registerLazySingleton<ApiClient>(() => ApiClientImpl());
  container.registerFactory<UploadVideoNotifier>(() => UploadVideoNotifier(container()));
}

// Service usage
final apiClient = container<ApiClient>();
```

## Navigation

The application uses **go_router** for navigation:

- Routes are defined in `lib/src/core/navigation/router.dart`
- Named routes with parameters
- Nested routes for feature modules
- Shell routes for persistent navigation elements

Example:

```dart
GoRoute
(
name: AppRoute.uploadVideo.name,
path: AppRoute.uploadVideo.path,
builder: (context, state
)
=>
const
UploadVideoScreen
(
)
,
)
```

## Native Plugin Configuration

For plugins requiring native configuration:

1. **Android**:
    - Update `android/app/build.gradle` for compiler options
    - Add necessary permissions in `AndroidManifest.xml`
    - Configure services for background processing

2. **iOS**:
    - Update `Info.plist` for permissions and capabilities
    - Configure `Podfile` for iOS-specific settings

## Linting

The project uses Flutter's linting rules with customizations:

- `flutter_lints` package for base rules
- Run linting: `flutter analyze`
- Auto-fix issues: `flutter fix --apply`

Recommended custom linting rules:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - prefer_const_constructors
    - prefer_const_declarations
    - sort_child_properties_last
    - use_key_in_widget_constructors
```

## Testing Guidelines

- Unit tests in `test/` directory matching the source structure
- Widget tests for UI components
- Integration tests for end-to-end flows
- Use mocks for dependencies
- Test coverage target: 80%+

This documentation provides a comprehensive guide to the project structure and coding practices
based on the code samples provided.