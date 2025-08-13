# Ongi SwiftUI

A SwiftUI application built with Tuist for project generation and management.

## Project Structure

This project uses [Tuist](https://tuist.io/) to generate and maintain the Xcode project structure.

## Requirements

- Xcode 16.4+
- iOS 18.0+
- Tuist

## Setup

1. Install Tuist if you haven't already:

   ```bash
   curl -Ls https://install.tuist.io | bash
   ```

2. Generate the Xcode project:

   ```bash
   tuist generate
   ```

3. Open the generated `.xcodeproj` or `.xcworkspace` file in Xcode.

## Development

- Use `tuist generate` to regenerate the project after making changes to project configuration files
- The main app source code is located in `ongi-swiftui/Sources/`
- Tests are located in `ongi-swiftui/Tests/`

## Building and Running

1. Generate the project: `tuist generate`
2. Open in Xcode and build/run as usual
3. Or use Tuist commands: `tuist build`, `tuist test`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request
