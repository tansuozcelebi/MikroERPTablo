# Mikro ERP Dokümantasyon Build Script
# PowerShell için build automation

param(
    [string]$Command = "help",
    [switch]$Verbose = $false,
    [switch]$Clean = $false
)

# Renkli output için
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$White = "White"

function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = $White
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColoredOutput "🚀 Mikro ERP Dokümantasyon Build Sistemi" $Green
    Write-ColoredOutput "==========================================" $Green
    Write-Host ""
    Write-ColoredOutput "Kullanım: .\build.ps1 [KOMUT] [PARAMETRELER]" $Yellow
    Write-Host ""
    Write-ColoredOutput "Komutlar:" $Yellow
    Write-Host "  help      📋 Bu yardım mesajını göster"
    Write-Host "  install   📦 NPM bağımlılıklarını yükle"
    Write-Host "  build     🏗️ Projeyi build et"
    Write-Host "  dev       🔧 Geliştirme sunucusu başlat"
    Write-Host "  serve     🌐 Local HTTP server başlat"
    Write-Host "  test      🧪 Testleri çalıştır"
    Write-Host "  clean     🧹 Build dosyalarını temizle"
    Write-Host "  deploy    🚀 GitHub Pages'e deploy et"
    Write-Host "  status    📊 Proje durumunu göster"
    Write-Host "  quick     ⚡ Hızlı build ve test"
    Write-Host "  full      🎯 Tam build döngüsü"
    Write-Host ""
    Write-ColoredOutput "Parametreler:" $Yellow
    Write-Host "  -Verbose  Detaylı çıktı göster"
    Write-Host "  -Clean    İşlemden önce temizlik yap"
    Write-Host ""
    Write-ColoredOutput "Örnekler:" $Green
    Write-Host "  .\build.ps1 build"
    Write-Host "  .\build.ps1 build -Clean"
    Write-Host "  .\build.ps1 test -Verbose"
}

function Test-NodeJs {
    try {
        $nodeVersion = node --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredOutput "✅ Node.js bulundu: $nodeVersion" $Green
            return $true
        }
    }
    catch {
        Write-ColoredOutput "❌ Node.js bulunamadı!" $Red
        Write-ColoredOutput "Lütfen Node.js'i yükleyin: https://nodejs.org/" $Yellow
        return $false
    }
    return $false
}

function Test-Npm {
    try {
        $npmVersion = npm --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredOutput "✅ NPM bulundu: $npmVersion" $Green
            return $true
        }
    }
    catch {
        Write-ColoredOutput "❌ NPM bulunamadı!" $Red
        return $false
    }
    return $false
}

function Install-Dependencies {
    Write-ColoredOutput "📦 NPM bağımlılıkları yükleniyor..." $Green
    
    if (!(Test-Path "package.json")) {
        Write-ColoredOutput "❌ package.json bulunamadı!" $Red
        return $false
    }
    
    try {
        npm install
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredOutput "✅ Bağımlılıklar başarıyla yüklendi!" $Green
            return $true
        } else {
            Write-ColoredOutput "❌ Bağımlılık yükleme başarısız!" $Red
            return $false
        }
    }
    catch {
        Write-ColoredOutput "❌ NPM install hatası: $($_.Exception.Message)" $Red
        return $false
    }
}

function Start-Build {
    Write-ColoredOutput "🏗️ Build işlemi başlatılıyor..." $Green
    
    if (!(Test-Path "build.js")) {
        Write-ColoredOutput "❌ build.js bulunamadı!" $Red
        return $false
    }
    
    try {
        $env:NODE_ENV = "production"
        $env:BUILD_NUMBER = Get-Date -Format "yyyyMMddHHmmss"
        
        node build.js
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredOutput "✅ Build tamamlandı!" $Green
            return $true
        } else {
            Write-ColoredOutput "❌ Build başarısız!" $Red
            return $false
        }
    }
    catch {
        Write-ColoredOutput "❌ Build hatası: $($_.Exception.Message)" $Red
        return $false
    }
}

function Start-DevServer {
    Write-ColoredOutput "🔧 Geliştirme sunucusu başlatılıyor..." $Green
    Write-ColoredOutput "🌐 http://localhost:8080" $Yellow
    Write-ColoredOutput "Durdurmak için Ctrl+C tuşuna basın" $Yellow
    
    try {
        if (Test-Path "node_modules") {
            npm run dev
        } else {
            Write-ColoredOutput "⚠️ node_modules bulunamadı, önce 'install' komutunu çalıştırın" $Yellow
        }
    }
    catch {
        Write-ColoredOutput "❌ Dev server hatası: $($_.Exception.Message)" $Red
    }
}

function Start-Server {
    Write-ColoredOutput "🌐 HTTP sunucusu başlatılıyor..." $Green
    Write-ColoredOutput "🔗 http://localhost:8080" $Yellow
    Write-ColoredOutput "Durdurmak için Ctrl+C tuşuna basın" $Yellow
    
    try {
        if (Test-Path "node_modules") {
            npm run serve
        } else {
            # Basit Python server alternatifi
            Write-ColoredOutput "Python server alternatifi başlatılıyor..." $Yellow
            python -m http.server 8080 2>$null
            if ($LASTEXITCODE -ne 0) {
                python3 -m http.server 8080
            }
        }
    }
    catch {
        Write-ColoredOutput "❌ Server hatası: $($_.Exception.Message)" $Red
    }
}

function Start-Test {
    Write-ColoredOutput "🧪 Testler çalıştırılıyor..." $Green
    
    try {
        if (Test-Path "node_modules") {
            npm run test
            if ($LASTEXITCODE -eq 0) {
                Write-ColoredOutput "✅ Tüm testler başarılı!" $Green
            } else {
                Write-ColoredOutput "❌ Bazı testler başarısız!" $Red
            }
        } else {
            Write-ColoredOutput "⚠️ node_modules bulunamadı, önce 'install' komutunu çalıştırın" $Yellow
        }
    }
    catch {
        Write-ColoredOutput "❌ Test hatası: $($_.Exception.Message)" $Red
    }
}

function Clear-Build {
    Write-ColoredOutput "🧹 Build dosyaları temizleniyor..." $Green
    
    try {
        if (Test-Path "dist") {
            Remove-Item -Recurse -Force "dist"
            Write-ColoredOutput "✅ dist klasörü temizlendi" $Green
        }
        
        if (Test-Path "node_modules" -and $Clean) {
            Write-ColoredOutput "🗑️ node_modules temizleniyor..." $Yellow
            Remove-Item -Recurse -Force "node_modules"
            Write-ColoredOutput "✅ node_modules temizlendi" $Green
        }
        
        Write-ColoredOutput "✅ Temizlik tamamlandı!" $Green
    }
    catch {
        Write-ColoredOutput "❌ Temizlik hatası: $($_.Exception.Message)" $Red
    }
}

function Show-Status {
    Write-ColoredOutput "📊 Proje Durumu" $Green
    Write-ColoredOutput "===============" $Green
    Write-Host ""
    
    # Dosya sayıları
    Write-ColoredOutput "📁 Dosya Sayıları:" $Yellow
    $htmlCount = (Get-ChildItem -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch "(node_modules|dist)" }).Count
    $cssCount = (Get-ChildItem -Recurse -Filter "*.css" | Where-Object { $_.FullName -notmatch "(node_modules|dist)" }).Count
    $jsCount = (Get-ChildItem -Recurse -Filter "*.js" | Where-Object { $_.FullName -notmatch "(node_modules|dist)" }).Count
    
    Write-Host "  HTML dosyaları: $htmlCount"
    Write-Host "  CSS dosyaları: $cssCount"  
    Write-Host "  JS dosyaları: $jsCount"
    Write-Host ""
    
    # Git durumu
    Write-ColoredOutput "🔗 Git Durumu:" $Yellow
    try {
        $gitStatus = git status --porcelain 2>$null
        $changedFiles = ($gitStatus | Measure-Object).Count
        Write-Host "  Değiştirilmiş dosya: $changedFiles"
        
        $lastCommit = git rev-parse --short HEAD 2>$null
        Write-Host "  Son commit: $lastCommit"
    }
    catch {
        Write-Host "  Git repository bulunamadı"
    }
    Write-Host ""
    
    # Build durumu
    Write-ColoredOutput "🏗️ Build Durumu:" $Yellow
    if (Test-Path "dist") {
        Write-Host "  ✅ dist klasörü mevcut"
        $distFiles = (Get-ChildItem -Recurse "dist").Count
        Write-Host "  📦 dist içinde $distFiles dosya"
    } else {
        Write-Host "  ❌ dist klasörü yok"
    }
}

function Start-QuickBuild {
    Write-ColoredOutput "⚡ Hızlı build ve test başlatılıyor..." $Green
    Clear-Build
    if (Start-Build) {
        Start-Test
    }
    Write-ColoredOutput "🎉 Hızlı işlem tamamlandı!" $Green
}

function Start-FullBuild {
    Write-ColoredOutput "🎯 Tam build döngüsü başlatılıyor..." $Green
    
    Clear-Build
    if (Install-Dependencies) {
        if (Start-Build) {
            Start-Test
        }
    }
    
    Write-ColoredOutput "🎉 Tam build döngüsü tamamlandı!" $Green
}

# Ana işlem
Write-ColoredOutput "🚀 Mikro ERP Build Script" $Green
Write-Host ""

# Ön kontroller
if (!(Test-NodeJs) -or !(Test-Npm)) {
    exit 1
}

if ($Clean -and $Command -ne "clean") {
    Clear-Build
}

# Komut çalıştır
switch ($Command.ToLower()) {
    "help" { Show-Help }
    "install" { Install-Dependencies }
    "build" { Start-Build }
    "dev" { Start-DevServer }
    "serve" { Start-Server }
    "test" { Start-Test }
    "clean" { Clear-Build }
    "status" { Show-Status }
    "quick" { Start-QuickBuild }
    "full" { Start-FullBuild }
    default {
        Write-ColoredOutput "❌ Bilinmeyen komut: $Command" $Red
        Write-Host ""
        Show-Help
        exit 1
    }
}