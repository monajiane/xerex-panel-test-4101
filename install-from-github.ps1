param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUser,
    
    [Parameter(Mandatory=$true)]
    [string]$RepoName
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   نصب کننده خودکار از گیت‌هاب (Laravel)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1. دریافت آخرین نسخه از گیت‌هاب
Write-Host "[1/7] در حال دریافت اطلاعات آخرین نسخه از گیت‌هاب..." -ForegroundColor Yellow
$apiUrl = "https://api.github.com/repos/$GitHubUser/$RepoName/releases/latest"

try {
    $release = Invoke-RestMethod -Uri $apiUrl -Method Get
    $version = $release.tag_name
    Write-Host "آخرین نسخه یافت شد: $version" -ForegroundColor Green
    
    # پیدا کردن فایل zipball یا tarball (معمولا source code)
    # گیت‌هاب لینک مستقیم به zip را در zipball_url میدهد
    $downloadUrl = $release.zipball_url
    
} catch {
    Write-Host "خطا در دریافت اطلاعات از گیت‌هاب. مطمئن شوید نام کاربری و مخزن صحیح است." -ForegroundColor Red
    Write-Host "جزئیات خطا: $_" -ForegroundColor Red
    exit 1
}

# 2. دانلود فایل
$zipFileName = "$RepoName-$version.zip"
Write-Host "[2/7] در حال دانلود نسخه $version..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFileName -UseBasicParsing
    Write-Host "دانلود با موفقیت انجام شد." -ForegroundColor Green
} catch {
    Write-Host "خطا در دانلود فایل." -ForegroundColor Red
    exit 1
}

# 3. استخراج فایل‌ها
Write-Host "[3/7] در حال استخراج فایل‌ها..." -ForegroundColor Yellow
$extractPath = Join-Path $PWD.Path "temp_extract"
if (Test-Path $extractPath) { Remove-Item -Recurse -Force $extractPath }
New-Item -ItemType Directory -Path $extractPath | Out-Null

try {
    Expand-Archive -Path $zipFileName -DestinationPath $extractPath -Force
    # معمولا گیت‌هاب یک پوشه با نام user-repo-hash میسازد، محتویات آن را به ریشه می‌آوریم
    $innerFolder = Get-ChildItem -Path $extractPath | Select-Object -First 1
    Move-Item -Path "$($innerFolder.FullName)\*" -Destination $PWD.Path -Force
    Remove-Item -Recurse -Force $extractPath
    Remove-Item $zipFileName
    Write-Host "فایل‌ها با موفقیت استخراج شدند." -ForegroundColor Green
} catch {
    Write-Host "خطا در استخراج فایل‌ها." -ForegroundColor Red
    exit 1
}

# 4. بررسی و نصب Composer
Write-Host "[4/7] بررسی پیش‌نیازها (Composer & PHP)..." -ForegroundColor Yellow
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "Composer یافت نشد. در حال نصب خودکار..." -ForegroundColor Yellow
    try {
        $installerUrl = "https://getcomposer.org/installer"
        Invoke-WebRequest -Uri $installerUrl -OutFile "composer-setup.php" -UseBasicParsing
        php composer-setup.php --quiet
        Remove-Item "composer-setup.php"
        # اضافه کردن composer به مسیر جاری برای این جلسه اگر نیاز بود، اما معمولا نصب سراسری انجام میشود
        $env:Path += ";$PWD.Path" 
        Write-Host "Composer نصب شد." -ForegroundColor Green
    } catch {
        Write-Host "خطا در نصب Composer. لطفاً PHP و Composer را دستی نصب کنید." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Composer یافت شد." -ForegroundColor Green
}

# 5. نصب وابستگی‌های لاراول
Write-Host "[5/7] در حال نصب وابستگی‌های لاراول (composer install)..." -ForegroundColor Yellow
try {
    composer install --no-interaction --prefer-dist
    Write-Host "وابستگی‌ها نصب شدند." -ForegroundColor Green
} catch {
    Write-Host "خطا در اجرای composer install." -ForegroundColor Red
    exit 1
}

# 6. تنظیمات محیطی و دیتابیس
Write-Host "[6/7] پیکربندی محیط و پایگاه داده..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
}

# تولید کلید اپلیکیشن
php artisan key:generate

# تنظیم دیتابیس به SQLite (برای سادگی نصب لوکال)
$dbPath = Join-Path $PWD.Path "database\database.sqlite"
if (-not (Test-Path $dbPath)) {
    New-Item -Path $dbPath -ItemType File | Out-Null
    Write-Host "فایل دیتابیس SQLite ایجاد شد." -ForegroundColor Green
}

# بروزرسانی فایل .env برای استفاده از SQLite
$content = Get-Content ".env" -Raw
$content = $content -replace 'DB_CONNECTION=mysql', 'DB_CONNECTION=sqlite'
$content = $content -replace 'DB_DATABASE=.*', '# DB_DATABASE=database\database.sqlite'
Set-Content ".env" $content

Write-Host "در حال اجرای مهاجرت‌ها (Migrations)..." -ForegroundColor Yellow
try {
    php artisan migrate --force
    Write-Host "پایگاه داده آماده شد." -ForegroundColor Green
} catch {
    Write-Host "هشدار: مشکلی در مایگریشن پیش آمد، اما ادامه می‌دهیم." -ForegroundColor Yellow
}

# 7. اجرای سرور
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "   نصب با موفقیت به پایان رسید!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "در حال راه‌اندازی سرور توسعه..." -ForegroundColor Cyan
Write-Host "وب‌سایت شما در آدرس زیر قابل مشاهده است:" -ForegroundColor White
Write-Host ">>> http://localhost:8000 <<<" -ForegroundColor Cyan
Write-Host ""
Write-Host "برای توقف سرور، کلیدهای Ctrl+C را فشار دهید." -ForegroundColor Gray
Write-Host ""

# اجرای سرور
php artisan serve
