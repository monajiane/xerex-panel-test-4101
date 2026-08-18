# PowerShell Script for Installing Laravel CMS for Shargh Tool Company

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Laravel CMS Installation for Shargh Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if PHP is installed
if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "Error: PHP is not installed. Please install PHP 8.2 or higher." -ForegroundColor Red
    exit 1
}

# Check PHP version
$phpVersion = php -v | Select-String -Pattern "PHP\s+(\d+\.\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
if ([float]$phpVersion -lt 8.2) {
    Write-Host "Error: PHP version 8.2 or higher is required. Current version: $phpVersion" -ForegroundColor Red
    exit 1
}

Write-Host "PHP version: $phpVersion" -ForegroundColor Green

# Check if Composer is installed
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "Composer is not installed. Installing Composer..." -ForegroundColor Yellow
    
    # Download and install Composer
    $composerInstaller = "composer-setup.php"
    Invoke-WebRequest -Uri "https://getcomposer.org/installer" -OutFile $composerInstaller
    
    & php $composerInstaller --install-dir="C:\ProgramData\ComposerSetup\bin" --filename=composer.exe
    
    Remove-Item $composerInstaller
    
    # Add Composer to PATH for current session
    $env:Path += ";C:\ProgramData\ComposerSetup\bin"
}

Write-Host "Composer is installed." -ForegroundColor Green

# Create Laravel project
$projectName = "shargh-tool-cms"
Write-Host "Creating Laravel project: $projectName" -ForegroundColor Yellow

composer create-project laravel/laravel $projectName --prefer-dist

# Navigate to project directory
Set-Location $projectName

# Install required packages
Write-Host "Installing required packages..." -ForegroundColor Yellow
composer require laravel/ui
composer require spatie/laravel-permission

# Setup authentication
php artisan ui blade --auth

# Create necessary directories
New-Item -ItemType Directory -Force -Path "app/Models" | Out-Null
New-Item -ItemType Directory -Force -Path "database/migrations" | Out-Null
New-Item -ItemType Directory -Force -Path "resources/views/admin" | Out-Null
New-Item -ItemType Directory -Force -Path "resources/views/products" | Out-Null
New-Item -ItemType Directory -Force -Path "resources/views/showroom" | Out-Null
New-Item -ItemType Directory -Force -Path "public/uploads/products" | Out-Null
New-Item -ItemType Directory -Force -Path "public/uploads/showroom" | Out-Null

# Create .env file if not exists
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
}

# Generate application key
php artisan key:generate

# Configure database for SQLite
$dbPath = Join-Path (Get-Location) "database/database.sqlite"
if (-not (Test-Path $dbPath)) {
    New-Item -ItemType File -Path $dbPath | Out-Null
}

# Update .env file for SQLite
$content = Get-Content ".env" -Raw
$content = $content -replace 'DB_CONNECTION=mysql', 'DB_CONNECTION=sqlite'
$content = $content -replace 'DB_DATABASE=laravel', "# DB_DATABASE=laravel"
$content = $content -replace '# DB_CONNECTION=sqlite', 'DB_CONNECTION=sqlite'
Set-Content ".env" $content

Write-Host "Database configured for SQLite." -ForegroundColor Green

# Run migrations
Write-Host "Running migrations..." -ForegroundColor Yellow
php artisan migrate

# Create admin user
Write-Host "Creating admin user..." -ForegroundColor Yellow
php artisan tinker --execute="App\Models\User::create(['name' => 'Admin', 'email' => 'admin@shargh-tool.com', 'password' => bcrypt('password')]);"

# Create sample data
Write-Host "Creating sample data..." -ForegroundColor Yellow

# Create categories
php artisan tinker --execute="
use App\Models\Category;
Category::create(['name' => 'ابزارهای برقی', 'slug' => 'power-tools', 'description' => 'انواع ابزارهای برقی صنعتی']);
Category::create(['name' => 'ابزارهای دستی', 'slug' => 'hand-tools', 'description' => 'انواع ابزارهای دستی حرفه‌ای']);
Category::create(['name' => 'تجهیزات ایمنی', 'slug' => 'safety-equipment', 'description' => 'تجهیزات حفاظت فردی']);
"

# Create products
php artisan tinker --execute="
use App\Models\Product;
use App\Models\Category;

\$category1 = Category::where('slug', 'power-tools')->first();
\$category2 = Category::where('slug', 'hand-tools')->first();

Product::create([
    'name' => 'دریل چکشی حرفه‌ای',
    'slug' => 'hammer-drill-pro',
    'description' => 'دریل چکشی با قدرت بالا برای مصارف صنعتی',
    'price' => 2500000,
    'category_id' => \$category1->id,
    'stock' => 15,
    'is_featured' => true
]);

Product::create([
    'name' => 'آچار فرانسه صنعتی',
    'slug' => 'adjustable-wrench',
    'description' => 'آچار فرانسه با کیفیت عالی و دوام بالا',
    'price' => 350000,
    'category_id' => \$category2->id,
    'stock' => 50,
    'is_featured' => false
]);
"

# Create showroom items
php artisan tinker --execute="
use App\Models\Showroom;

Showroom::create([
    'title' => 'نمایشگاه ابزارهای صنعتی',
    'slug' => 'industrial-tools-showroom',
    'description' => 'نمایش جدیدترین ابزارهای صنعتی شرکت ابزارسازی شرق',
    'location' => 'مشهد، شهرک صنعتی',
    'start_date' => now(),
    'end_date' => now()->addMonths(2),
    'is_active' => true
]);
"

# Optimize application
Write-Host "Optimizing application..." -ForegroundColor Yellow
php artisan config:cache
php artisan route:cache
php artisan view:cache

Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "" 
Write-Host "To start the development server, run:" -ForegroundColor Cyan
Write-Host "cd $projectName" -ForegroundColor White
Write-Host "php artisan serve" -ForegroundColor White
Write-Host "" 
Write-Host "Then visit:" -ForegroundColor Cyan
Write-Host "- Homepage: http://localhost:8000" -ForegroundColor White
Write-Host "- Admin Panel: http://localhost:8000/admin" -ForegroundColor White
Write-Host "" 
Write-Host "Admin credentials:" -ForegroundColor Yellow
Write-Host "- Email: admin@shargh-tool.com" -ForegroundColor White
Write-Host "- Password: password" -ForegroundColor White
Write-Host "" 
Write-Host "========================================" -ForegroundColor Green
