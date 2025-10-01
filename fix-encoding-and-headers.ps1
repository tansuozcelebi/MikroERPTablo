# Türkçe karakter sorunlarını ve header yollarını düzelten PowerShell scripti

# Türkçe karakter haritası
$turkishMap = @{
    'Ä±' = 'ı'
    'Å£' = 'ş'
    'ÄŸ' = 'ğ'
    'Ã¼' = 'ü'
    'Ã¶' = 'ö'
    'Ã§' = 'ç'
    'Ä°' = 'İ'
    'Åž' = 'Ş'
    'ÄŸ' = 'Ğ'
    'Ãœ' = 'Ü'
    'Ã–' = 'Ö'
    'Ã‡' = 'Ç'
}

# HTML dosyalarını bul
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" -Recurse

Write-Host "HTML dosyaları düzeltiliyor..." -ForegroundColor Green

foreach ($file in $htmlFiles) {
    Write-Host "Düzeltiliyor: $($file.FullName)" -ForegroundColor Yellow
    
    try {
        # Dosyayı UTF-8 olarak oku
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        
        # Türkçe karakterleri düzelt
        foreach ($pair in $turkishMap.GetEnumerator()) {
            $content = $content -replace [regex]::Escape($pair.Key), $pair.Value
        }
        
        # Header CSS yolunu düzelt
        $depth = ($file.FullName -replace [regex]::Escape($PWD.Path), "").Split('\').Length - 2
        $headerPath = "../" * $depth + "mye-header.css"
        
        # Mevcut header CSS linklerini düzelt
        $content = $content -replace 'href="[^"]*mye-header\.css"', "href=`"$headerPath`""
        $content = $content -replace "<link rel=`"stylesheet`" href=`"[^`"]*mye-header\.css`">", "<link rel=`"stylesheet`" href=`"$headerPath`">"
        
        # Eğer header CSS linki yoksa ekle
        if ($content -notmatch "mye-header\.css" -and $content -match "<head>") {
            $headerLink = "`n    <link rel=`"stylesheet`" href=`"$headerPath`">"
            $content = $content -replace "(<head[^>]*>)", "`$1$headerLink"
        }
        
        # Header HTML'i ekle (eğer yoksa)
        if ($content -notmatch "mye-header-bar" -and $content -match "<body[^>]*>") {
            $indexPath = "../" * $depth + "index.html"
            $headerHTML = @"
    <!-- MYE Modern Header Bar -->
    <div class="mye-header-bar">
        <div class="mye-header-content">
            <a href="$indexPath" class="mye-header-brand">
                <div class="logo">M</div>
                <span>Mikro Terminal</span>
            </a>
            <nav class="mye-header-nav">
                <a href="$indexPath" class="mye-header-btn">
                    <span>🏠</span> Başa Dön
                </a>
                <button onclick="openAboutModal()" class="mye-header-btn primary">
                    <span>ℹ️</span> Hakkında
                </button>
            </nav>
        </div>
    </div>

"@
            $content = $content -replace "(<body[^>]*>)", "`$1`n$headerHTML"
        }
        
        # Body padding'i ekle (eğer yoksa)
        if ($content -notmatch "padding-top.*70px" -and $content -match "mye-header-bar") {
            $bodyStyle = "<style>body { padding-top: 70px !important; }</style>"
            if ($content -match "</head>") {
                $content = $content -replace "</head>", "$bodyStyle`n</head>"
            }
        }
        
        # About modal scripti ekle (eğer yoksa)
        if ($content -notmatch "openAboutModal" -and $content -match "mye-header-bar") {
            $modalScript = @"

<!-- About Modal -->
<div id="aboutModal" class="mye-modal">
    <div class="mye-modal-content">
        <div class="mye-modal-header">
            <h2 class="mye-modal-title">Hakkında</h2>
            <button class="mye-modal-close" onclick="closeAboutModal()">&times;</button>
        </div>
        <div class="mye-modal-body">
            <h3>🚀 Mikro Fly ERP Veritabanı Yapısı</h3>
            <p><strong>Geliştirici:</strong> Tansu Özçelebi</p>
            <p><strong>Web Sitesi:</strong> <a href="https://mikro.fabus.app" target="_blank">mikro.fabus.app</a></p>
            <p><strong>Versiyon:</strong> 2024</p>
            <p>Bu dokümantasyon, Mikro Fly ERP sisteminin veritabanı yapısını detaylarıyla açıklamaktadır.</p>
        </div>
    </div>
</div>

<script>
function openAboutModal() {
    document.getElementById('aboutModal').classList.add('active');
}

function closeAboutModal() {
    document.getElementById('aboutModal').classList.remove('active');
}

// Modal dışına tıklayınca kapat
document.getElementById('aboutModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeAboutModal();
    }
});
</script>
"@
            if ($content -match "</body>") {
                $content = $content -replace "</body>", "$modalScript`n</body>"
            }
        }
        
        # Dosyayı UTF-8 olarak kaydet
        $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
        
        Write-Host "✓ Tamamlandı: $($file.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Hata: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nTüm HTML dosyaları düzeltildi!" -ForegroundColor Cyan