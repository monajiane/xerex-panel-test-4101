# اسکریپت نصب لاراول بدون نیاز به دسترسی ادمین
# این اسکریپت آخرین نسخه را از گیت‌هاب دانلود و نصب می‌کند

param(
    [string]$GitHubUser = "YOUR_GITHUB_USERNAME",
    [string]$RepoName = "YOUR_REPO_NAME",
    [string]$Branch = "main"
)

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   نصب کننده هوشمند لاراول (نسخه بدون ادمین)" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

# بررسی وجود PHP
Write-Host "`n[1/5] بررسی نصب بودن PHP..." -ForegroundColor Yellow
if (!(Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "خطا: PHP نصب نیست یا در PATH قرار ندارد." -ForegroundColor Red
    Write-Host "لطفاً ابتدا PHP را نصب کنید و سپس مجدد تلاش کنید." -ForegroundColor Yellow
    Write-Host "دانلود از: https://windows.php.net/download/" -ForegroundColor Gray
    Read-Host "برای خروج Enter بزنید"
    exit
} else {
    $phpVersion = php -v | Select-Object -First 1
    Write-Host "پیدا شد: $phpVersion" -ForegroundColor Green
}

# بررسی وجود Composer
Write-Host "`n[2/5] بررسی نصب بودن Composer..." -ForegroundColor Yellow
if (!(Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "خطا: Composer نصب نیست." -ForegroundColor Red
    Write-Host "لطفاً Composer را نصب کنید: https://getcomposer.org/download/" -ForegroundColor Yellow
    Read-Host "برای خروج Enter بزنید"
    exit
} else {
    $composerVersion = composer --version
    Write-Host "پیدا شد: $composerVersion" -ForegroundColor Green
}

# دریافت نام مخزن اگر کاربر وارد نکرده باشد
if ($GitHubUser -eq "YOUR_GITHUB_USERNAME" -or $RepoName -eq "YOUR_REPO_NAME") {
    Write-Host "`nلطفاً مشخصات مخزن گیت‌هاب خود را وارد کنید:" -ForegroundColor Cyan
    $GitHubUser = Read-Host "نام کاربری گیت‌هاب (GitHub Username)"
    $RepoName = Read-Host "نام مخزن (Repository Name)"
}

$DownloadUrl = "https://github.com/$GitHubUser/$RepoName/archive/refs/heads/$Branch.zip"
$ZipFile = "source-code.zip"
$ExtractFolder = "$RepoName-$Branch"

# دانلود فایل از گیت‌هاب
Write-Host "`n[3/5] در حال دانلود از گیت‌هاب ($GitHubUser/$RepoName)..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipFile -UseBasicParsing
    Write-Host "دانلود با موفقیت انجام شد." -ForegroundColor Green
} catch {
    Write-Host "خطا در دانلود: $_" -ForegroundColor Red
    Write-Host "بررسی کنید که نام کاربری و نام مخزن درست باشد و مخزن Public باشد." -ForegroundColor Yellow
    Read-Host "برای خروج Enter بزنید"
    exit
}

# استخراج فایل‌ها
Write-Host "`n[4/5] در حال استخراج فایل‌ها..." -ForegroundColor Yellow
if (Test-Path $ExtractFolder) {
    Remove-Item -Recurse -Force $ExtractFolder
}
Expand-Archive -Path $ZipFile -DestinationPath . -Force
Remove-Item $ZipFile

# پیدا کردن پوشه اصلی پروژه (چون گیت‌هاب یک پوشه مادر می‌سازد)
$ProjectRoot = Get-ChildItem -Directory | Where-Object { $_.Name -like "$RepoName-*" } | Select-Object -First 1
if ($ProjectRoot) {
    $TargetPath = $ProjectRoot.FullName
    Write-Host "پوشه پروژه: $TargetPath" -ForegroundColor Gray
    
    # انتقال فایل‌ها به پوشه جاری برای راحتی (اختیاری) یا کار در همان پوشه
    # ما در اینجا مستقیماً داخل پوشه دانلود شده عملیات را انجام می‌دهیم
    
    Write-Host "`n[5/5] در حال نصب وابستگی‌ها (Composer Install)..." -ForegroundColor Yellow
    Push-Location $TargetPath
    
    try {
        # کپی کردن فایل env اگر وجود نداشته باشد
        if (!(Test-Path ".env")) {
            Copy-Item ".env.example" ".env"
        }

        # نصب کامپوزر
        composer install --no-interaction --prefer-dist
        
        # تولید کلید اپلیکیشن
        Write-Host "`nدر حال تولید کلید اپلیکیشن..." -ForegroundColor Yellow
        php artisan key:generate
        
        # ساخت دیتابیس SQLite (اگر در تنظیمات پیش‌فرض باشد)
        if (!(Test-Path "database\database.sqlite")) {
            Write-Host "در حال ساخت دیتابیس SQLite..." -ForegroundColor Yellow
            New-Item -Path "database\database.sqlite" -ItemType File
        }

        # اجرای مایگریشن‌ها
        Write-Host "در حال اجرای مایگریشن‌ها..." -ForegroundColor Yellow
        php artisan migrate --force

        Pop-Location
        Write-Host "`n==================================================" -ForegroundColor Green
        Write-Host "   نصب با موفقیت تمام شد!" -ForegroundColor Green
        Write-Host "==================================================" -ForegroundColor Green
        Write-Host "مسیر پروژه: $TargetPath" -ForegroundColor Cyan
        
        $RunCommand = "cd $TargetPath; php artisan serve"
        Write-Host "`nبرای اجرای سرور دستور زیر را در ترمینال وارد کنید:" -ForegroundColor Yellow
        Write-Host "$RunCommand" -ForegroundColor White
        
        $OpenBrowser = Read-Host "`nآیا می‌خواهید سرور را همین الان اجرا کنم؟ (y/n)"
        if ($OpenBrowser -eq 'y' -or $OpenBrowser -eq 'Y') {
            cd $TargetPath
            php artisan serve
        }

    } catch {
        Pop-Location
        Write-Host "خطا در حین نصب: $_" -ForegroundColor Red
    }
} else {
    Write-Host "پوشه پروژه پس از استخراج یافت نشد." -ForegroundColor Red
}

Read-Host "`nپایان. برای خروج Enter بزنید..."
