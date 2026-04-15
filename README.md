# Billify - Invoice Generator & Maker App

A production-ready **Invoice Generator & Maker App** built with Flutter, featuring clean architecture, GetX state management, Hive local storage, and PDF generation.

## Features

- **Client Management** — Full CRUD operations for managing clients
- **Invoice Creation** — Create invoices with itemized billing, quantity, price, and tax
- **GST Calculation** — Automatic tax calculation with configurable rates
- **PDF Generation** — Generate professional invoice PDFs with clean layout
- **Share & Download** — Share or download invoices as PDF
- **Local Storage** — All data persisted locally using Hive
- **Responsive UI** — Modern Material 3 design that adapts across screen sizes
- **Dashboard** — Business overview with revenue stats and quick actions

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform framework |
| GetX | State management, routing, DI |
| Hive | Local database |
| pdf + printing | PDF generation & sharing |
| intl | Date formatting |
| uuid | Unique ID generation |

## Architecture

Clean architecture with feature-based structure:

```
lib/
 ├── core/
 │    ├── utils/         # Validators, PDF generator
 │    ├── constants/     # App-wide constants
 │    └── themes/        # Material 3 theme
 ├── data/
 │    ├── models/        # Client, Invoice, InvoiceItem models
 │    ├── services/      # Client, Invoice, Settings services
 │    └── local_db/      # Hive initialization
 ├── modules/
 │    ├── splash/        # Splash screen
 │    ├── dashboard/     # Dashboard with stats
 │    ├── clients/       # Client list, add/edit
 │    ├── invoices/      # Invoice list
 │    ├── create_invoice/# Create invoice, add items
 │    ├── invoice_preview/# Invoice preview with PDF
 │    └── settings/      # Business settings
 ├── routes/             # GetX routing
 └── main.dart
```

## Screens

1. **Splash Screen** — Animated app intro
2. **Dashboard** — Business overview with revenue stats and quick actions
3. **Client List** — View all clients with search
4. **Add/Edit Client** — Client form with validation
5. **Invoice List** — View all invoices with status badges
6. **Create Invoice** — Select client, add items, set due date
7. **Add Items** — Item form with quantity, price, tax
8. **Invoice Preview** — Full invoice view with share/download
9. **Settings** — Business details and invoice defaults

## Getting Started

### Prerequisites

- Flutter SDK (3.x stable)
- Android Studio / VS Code
- Android emulator or device

### Setup

```bash
# Clone the repository
git clone https://github.com/IC-XOrbit-07/billify-invoice-app.git
cd billify-invoice-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## License

This project is open source and available under the MIT License.
