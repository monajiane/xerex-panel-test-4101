# Shargh Tool CMS

A modern content management system built with Laravel.

## Quick Start

### Windows (with Herd)

1. **Clone or download the project** to your sites directory (e.g., `C:\Users\YourName\Code`)

2. **Run the installer**:
   - Double-click `install.bat` in the project root
   - The script will automatically:
     - Install Composer dependencies
     - Create `.env` file from `.env.example`
     - Generate application key
     - Create SQLite database
     - Run database migrations
     - Clear all caches

3. **Open Herd** and refresh the site list

4. **Visit your site** in browser (e.g., `http://shargh-tool-cms.test`)

### Manual Installation

If you prefer manual installation or the batch file doesn't work:

```bash
# 1. Install dependencies
composer install

# 2. Create .env file
copy .env.example .env

# 3. Generate application key
php artisan key:generate

# 4. Create SQLite database
type nul > database\database.sqlite

# 5. Run migrations
php artisan migrate

# 6. Clear caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

## Requirements

- PHP 8.2+
- Composer
- SQLite (or MySQL/PostgreSQL if you change database settings)
- [Herd](https://herd.laravel.com/) (recommended for Windows) or any local server

## Configuration

Edit `.env` file to configure:
- Database connection (default is SQLite)
- Mail settings
- Application URL

## Admin Panel

Access the admin panel at: `/admin`

## Troubleshooting

### Common Issues

1. **"vendor/autoload.php not found"**
   - Run `composer install`

2. **".env file not found"**
   - Copy `.env.example` to `.env` and run `php artisan key:generate`

3. **"Database file does not exist"**
   - Create empty `database/database.sqlite` file

4. **"Call to undefined method index()"**
   - Check that all controller methods referenced in routes exist

5. **"Table 'sessions' doesn't exist"**
   - Run `php artisan migrate` again

### Support

For issues and questions, please check the documentation or contact support.

## License

MIT License
