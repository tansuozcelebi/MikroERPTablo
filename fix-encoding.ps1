# HTML dosyalarinda charset duzeltme script'i
Write-Host "HTML dosyalari duzeltiliyor..." -ForegroundColor Green

# Tum HTML dosyalarini bul
$htmlFiles = Get-ChildItem -Path "c:\mikro\v16", "c:\mikro\v17" -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    Write-Host "Isleniyor: $($file.Name)" -ForegroundColor Yellow
    
    try {
        # Dosya icerigini oku
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        if ($content -match "charset=windows-1254") {
            # charset'i utf-8'e degistir
            $content = $content -replace 'charset=windows-1254', 'charset=utf-8'
            
            # Dosyayi UTF-8 olarak kaydet
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllText($file.FullName, $content, $Utf8NoBomEncoding)
            
            Write-Host "  Duzeltildi!" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  Hata: $_" -ForegroundColor Red
    }
}

Write-Host "Islem tamamlandi!" -ForegroundColor Green