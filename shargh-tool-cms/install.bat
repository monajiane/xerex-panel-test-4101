@echo off
echo ========================================
echo Shargh Tool CMS - Auto Installer
echo ========================================
echo.

REM Check if composer.json exists
if not exist "composer.json" (
    echo ERROR: composer.json not found. Please run this script from the project root directory.
    pause
    exit /b 1
)

REM Step 1: Install Composer dependencies
echo [1/6] Installing Composer dependencies...
call composer install --no-interaction --optimize-autoloader
if %errorlevel% neq 0 (
    echo ERROR: Composer install failed.
    pause
    exit /b 1
)
echo.

REM Step 2: Create .env file if it doesn't exist
if not exist ".env" (
    echo [2/6] Creating .env file from .env.example...
    copy .env.example .env > nul
    if not exist ".env" (
        echo ERROR: .env.example not found. Cannot create .env file.
        pause
        exit /b 1
    )
) else (
    echo [2/6] .env file already exists, skipping...
)
echo.

REM Step 3: Generate application key
echo [3/6] Generating application key...
call php artisan key:generate
if %errorlevel% neq 0 (
    echo ERROR: Failed to generate application key.
    pause
    exit /b 1
)
echo.

REM Step 4: Create SQLite database file
echo [4/6] Setting up SQLite database...
if not exist "database\database.sqlite" (
    type nul > "database\database.sqlite"
    echo SQLite database file created.
) else (
    echo SQLite database file already exists, skipping...
)
echo.

REM Step 5: Run database migrations
echo [5/6] Running database migrations...
call php artisan migrate --force
if %errorlevel% neq 0 (
    echo WARNING: Migration failed. You may need to check your database configuration.
    echo Continuing with installation...
)
echo.

REM Step 6: Clear all caches
echo [6/6] Clearing application caches...
call php artisan config:clear
call php artisan cache:clear
call php artisan route:clear
call php artisan view:clear
echo.

echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Configure your database settings in .env file if needed
echo 2. Start your local server (Herd, Valet, or php artisan serve)
echo 3. Visit your site in browser
echo.
pause
