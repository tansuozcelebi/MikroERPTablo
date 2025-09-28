# HTML dosyalarına header ekleme script'i
Write-Host "HTML dosyalarına header ekleniyor..." -ForegroundColor Green

# Header CSS ve HTML içeriklerini oku
$headerCSS = Get-Content "c:\mikro\mye-header.css" -Raw -Encoding UTF8
$headerHTML = Get-Content "c:\mikro\mye-header.html" -Raw -Encoding UTF8

# v16 ve v17 mye klasörlerindeki tüm HTML dosyalarını bul
$htmlFiles = @()
$htmlFiles += Get-ChildItem -Path "c:\mikro\v16\v16\mye" -Filter "*.html" -Recurse
$htmlFiles += Get-ChildItem -Path "c:\mikro\v17\v17\mye" -Filter "*.html" -Recurse

$processedCount = 0
$totalCount = $htmlFiles.Count

Write-Host "Toplam $totalCount HTML dosyası bulundu." -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Host "[$processedCount/$totalCount] İşleniyor: $($file.Name)" -ForegroundColor Yellow
    
    try {
        # Dosya içeriğini oku
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # Eğer header zaten eklenmişse geç
        if ($content -match "mye-header-bar") {
            Write-Host "  - Header zaten var, geçiliyor..." -ForegroundColor Gray
            continue
        }
        
        # Dosya yoluna göre ana sayfa linkini ayarla
        $relativePath = $file.FullName
        if ($relativePath.Contains("v16")) {
            $homeLink = "../../../index.html"
        } else {
            $homeLink = "../../../index.html"
        }
        
        # Header HTML'ini dosya yoluna göre ayarla
        $adjustedHeaderHTML = $headerHTML -replace 'href="../../../index.html"', "href=`"$homeLink`""
        
        # HTML içine CSS ve header ekle
        if ($content -match '(<head[^>]*>)') {
            # <head> taginden sonra CSS ekle
            $newContent = $content -replace '(<head[^>]*>)', "`$1`n<style>`n$headerCSS`n</style>"
            
            # <body> taginden sonra header HTML ekle
            if ($newContent -match '(<body[^>]*>)') {
                $newContent = $newContent -replace '(<body[^>]*>)', "`$1`n$adjustedHeaderHTML"
            }
            
            # UTF-8 encoding ile dosyayı kaydet
            $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $newContent, $utf8NoBOM)
            
            Write-Host "  ✓ Header eklendi!" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ <head> tag bulunamadı, geçiliyor..." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "  ⚠ Hata: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nToplam $processedCount dosya işlendi!" -ForegroundColor Green