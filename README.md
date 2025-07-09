# Rick and Morty Flutter App

A Flutter application that displays a list of Rick and Morty characters with infinite scroll, filtering, and detailed character pages. The app uses the [Rick and Morty API](https://rickandmortyapi.com/) to fetch character data.

## Features

- Infinite scroll for character list
- Filter characters by name and status
- Character detail page with image and information
- Modern UI with custom fonts and colors

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A device or emulator to run the app

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/rick-and-morty-flutter.git
   cd rick-and-morty-flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/main.dart` - App entry point and theme setup
- `lib/character_list_page.dart` - Character list with infinite scroll and filter
- `lib/character_detail_page.dart` - Character detail screen
- `lib/filter_page.dart` - Filter UI
- `lib/rick_and_morty_api.dart` - API integration
- `lib/character.dart` - Character model

## Customization

- The app uses a custom font (`get_schwifty`) for the title.
- Colors and card styles are defined in `main.dart` using `ThemeData`.

## API

This app uses the [Rick and Morty API](https://rickandmortyapi.com/) for all character data.

## License

This project is licensed under the MIT License.
