# Özgür Güler referanslarını temizleme scripti
Write-Host "🧹 Özgür Güler referansları temizleniyor..." -ForegroundColor Yellow

# Tüm HTML dosyalarında arama yap
$files = Get-ChildItem -Path "c:\mikro" -Filter "*.html" -Recurse

$totalFiles = 0
$cleanedFiles = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    if ($content -match "özgür güler|Özgür Güler|Özgür GÜLER") {
        Write-Host "📄 İşleniyor: $($file.Name)" -ForegroundColor Cyan
        
        # Title tag'leri değiştir
        $content = $content -replace "Sayfa bulunamadı \| Özgür Güler &#8211; BLOG", "Mikro ERP Tablo Dokümantasyonu"
        $content = $content -replace "Özgür Güler &#8211; BLOG", "Mikro ERP Dokümantasyon"
        
        # Meta property değiştir
        $content = $content -replace 'content="Sayfa bulunamadı \| Özgür Güler &#8211; BLOG"', 'content="Mikro ERP Tablo Dokümantasyonu"'
        
        # Footer copyright'ı değiştir
        $content = $content -replace "Copyright 2016\| Tüm Hakları Saklıdır \| Özgür GÜLER", "Copyright 2025 | Mikro ERP Dokümantasyonu | Tansu Özçelebi"
        
        # Link ve yorum referanslarını temizle
        $content = $content -replace 'href="https://www\.ozgurguler\.net"[^>]*>Özgür GÜLER</a>', '<span>Mikro ERP</span>'
        $content = $content -replace 'Özgür GÜLER', 'Mikro ERP'
        $content = $content -replace 'Özgür Güler', 'Mikro ERP'
        $content = $content -replace 'özgür güler', 'mikro erp'
        
        # Eğer değişiklik varsa dosyayı kaydet
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $cleanedFiles++
            Write-Host "✅ Temizlendi: $($file.Name)" -ForegroundColor Green
        }
        $totalFiles++
    }
}

Write-Host ""
Write-Host "🎉 Temizleme tamamlandı!" -ForegroundColor Green
Write-Host "📊 Toplam kontrol edilen dosya: $($files.Count)" -ForegroundColor White
Write-Host "📝 Özgür Güler referansı bulunan dosya: $totalFiles" -ForegroundColor Yellow  
Write-Host "🧽 Temizlenen dosya: $cleanedFiles" -ForegroundColor Green
Write-Host ""