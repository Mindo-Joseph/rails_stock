# Inventory Management System

A modern, real-time inventory management system built with Ruby on Rails and Hotwire. The system provides real-time stock tracking, low stock notifications, and export capabilities.

## Features

- **Product Management**
  - Create, view, update, and delete products
  - Real-time updates using Hotwire
  - Automatic stock level tracking

- **Stock Management**
  - Real-time stock level updates
  - Low stock threshold configuration
  - Visual indicators for stock status

- **Notifications**
  - Real-time low stock notifications
  - In-app notification system
  - Stock threshold customization

- **Search & Filter**
  - Search products by name or SKU
  - Filter by stock status
  - Real-time search results

- **Data Export**
  - Export to CSV
  - Export to Excel (XLSX)
  - Formatted data exports

## Prerequisites

- Ruby 3.2.2
- Rails 7.1.3
- PostgreSQL
- Node.js & Yarn

## Setup

1. Clone the repository:
```bash
git clone [repository-url]
cd rails_stock
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Database setup:
```bash
rails db:create
rails db:migrate
```

4. Start the servers:
```bash
./bin/dev    # For development with Tailwind CSS
```

## Configuration

- Configure low stock thresholds in product settings
- Notification settings can be adjusted per product
- Default currency is set to KES (Kenyan Shilling)

## Testing

The application includes a comprehensive test suite using RSpec:

```bash
bundle exec rspec                 # Run all tests
bundle exec rspec spec/models     # Run model tests only
bundle exec rspec spec/system     # Run system tests only
```

## Design Decisions

1. **Real-time Updates**
   - Used Hotwire (Turbo + Stimulus) for real-time functionality
   - Minimized full page refreshes
   - Enhanced user experience with immediate feedback

2. **Stock Management**
   - Implemented threshold-based notifications
   - Used status badges for quick visual reference
   - Real-time stock updates

3. **User Interface**
   - Clean, modern design with Tailwind CSS
   - Responsive layout
   - Intuitive navigation and actions

## Technical Stack

- **Backend**: Ruby on Rails 7.1.3
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Tailwind CSS
- **Database**: PostgreSQL
- **Testing**: RSpec, Capybara
- **Real-time**: Turbo Streams
- **Export**: CSV, XLSX (axlsx)

## Assumptions

- Single currency (KES) operation
- Web-based access only (no API endpoints)
- Single timezone operation
- No user roles/permissions (basic authentication only)
- No image upload functionality
- No barcode scanning capability

## Future Improvements

1. Add multi-currency support
2. Implement user roles and permissions
3. Add API endpoints for external integration
4. Add barcode scanning capability
5. Implement batch operations for products
6. Add image upload functionality for products

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details