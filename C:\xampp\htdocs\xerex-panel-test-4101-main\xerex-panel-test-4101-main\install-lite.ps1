# اسکریپت نصب بدون نیاز به ادمین (Lite Version)
# این فایل را در پوشه خالی مورد نظر قرار دهید و اجرا کنید

param(
    [string]$RepoOwner = "YOUR_GITHUB_USERNAME", # نام کاربری گیت‌هاب خود را اینجا وارد کنید
    [string]$RepoName = "YOUR_REPO_NAME"        # نام مخزن گیت‌هاب را اینجا وارد کنید
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   نصب کننده خودکار لاراول (نسخه Lite)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# بررسی وجود Git
try {
    $gitVersion = git --version
    Write-Host "[OK] گیت نصب است: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] گیت نصب نیست. لطفاً گیت را از https://git-scm.com/download/win نصب کنید." -ForegroundColor Red
    exit
}

# بررسی وجود PHP
try {
    $phpVersion = php -v | Select-Object -First 1
    Write-Host "[OK] پی‌اچ‌پی نصب است: $phpVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] پی‌اچ‌پی نصب نیست یا در PATH تعریف نشده است." -ForegroundColor Red
    exit
}

# بررسی وجود Composer
try {
    $composerVersion = composer --version
    Write-Host "[OK] کامپوزر نصب است: $composerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] کامپوزر نصب نیست. لطفاً از https://getcomposer.org/download نصب کنید." -ForegroundColor Red
    exit
}

$installPath = Join-Path $PWD "shargh-tool-cms"

if (Test-Path $installPath) {
    Write-Host "[INFO] پوشه نصب قبلاً وجود دارد. در حال حذف برای نصب تمیز..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $installPath
}

Write-Host "[STEP 1] در حال دانلود پروژه از گیت‌هاب..." -ForegroundColor Cyan

# اگر نام مخزن توسط کاربر وارد نشده باشد، از یک مخزن نمونه استفاده می‌کند (یا خطا می‌دهد)
if ($RepoOwner -eq "YOUR_GITHUB_USERNAME" -or $RepoName -eq "YOUR_REPO_NAME") {
    Write-Host "[WARNING] نام کاربری یا نام مخزن تنظیم نشده است. در حال استفاده از دستور clone عمومی..." -ForegroundColor Yellow
    Write-Host "لطفاً آدرس ریپازیتوری خود را دستی وارد کنید یا اسکریپت را ویرایش کنید."
    # در حالت واقعی باید آدرس را بگیرید، اینجا برای تست فرض می‌کنیم کاربر می‌داند چه می‌کند
    # یا می‌توانیم از کاربر بخواهیم آدرس را وارد کند:
    $repoUrl = Read-Host "آدرس کامل ریپازیتوری (مثلا https://github.com/user/repo.git) را وارد کنید"
    if ([string]::IsNullOrWhiteSpace($repoUrl)) {
        Write-Host "[ERROR] آدرس ریپازیتوری وارد نشد." -ForegroundColor Red
        exit
    }
    git clone $repoUrl $installPath
} else {
    $repoUrl = "https://github.com/$RepoOwner/$RepoName.git"
    git clone $repoUrl $installPath
}

if (-not (Test-Path "$installPath\composer.json")) {
    Write-Host "[ERROR] فایل composer.json یافت نشود. ممکن است آدرس ریپازیتوری اشتباه باشد." -ForegroundColor Red
    exit
}

Set-Location $installPath

Write-Host "[STEP 2] در حال نصب وابستگی‌های PHP (Composer Install)..." -ForegroundColor Cyan
composer install --no-interaction --prefer-dist

Write-Host "[STEP 3] کپی کردن فایل محیطی (.env)..." -ForegroundColor Cyan
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
} else {
    Write-Host "[INFO] فایل .env از قبل موجود است."
}

Write-Host "[STEP 4] تولید کلید اپلیکیشن..." -ForegroundColor Cyan
php artisan key:generate

Write-Host "[STEP 5] تنظیم دیتابیس SQLite (بدون نیاز به نصب سرور جداگانه)..." -ForegroundColor Cyan
$dbPath = "database\database.sqlite"
if (-not (Test-Path $dbPath)) {
    New-Item -ItemType File -Path $dbPath | Out-Null
    Write-Host "[OK] فایل دیتابیس SQLite ساخته شد."
}

# آپدیت فایل .env برای استفاده از SQLite
(Get-Content .env) -replace "DB_CONNECTION=mysql", "DB_CONNECTION=sqlite" | Set-Content .env
(Get-Content .env) -replace "DB_DATABASE=.*", "# DB_DATABASE=database\database.sqlite" | Set-Content .env

Write-Host "[STEP 6] در حال اجرای مایگریشن‌ها..." -ForegroundColor Cyan
php artisan migrate:fresh --seed --force

Write-Host "[STEP 7] لینک دادن استوریج..." -ForegroundColor Cyan
php artisan storage:link

Write-Host "========================================" -ForegroundColor Green
Write-Host "   نصب با موفقیت انجام شد!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "برای اجرای سرور دستور زیر را در این پوشه وارد کنید:" -ForegroundColor Yellow
Write-Host "  cd $installPath" -ForegroundColor White
Write-Host "  php artisan serve" -ForegroundColor White
Write-Host ""
Write-Host "سپس به آدرس http://localhost:8000 بروید." -ForegroundColor Cyan
