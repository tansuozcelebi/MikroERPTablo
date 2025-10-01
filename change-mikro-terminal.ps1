# Mikro Terminal -> Mikro Fly değişimi
$files = Get-ChildItem -Path "." -Filter "*.html" -Recurse

Write-Host "Mikro Terminal -> Mikro Fly değişimi başlıyor..." -ForegroundColor Green

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        
        if ($content -match "Mikro Terminal") {
            $content = $content -replace "Mikro Terminal", "Mikro Fly"
            $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "✓ Güncellendi: $($file.Name)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Hata: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Mikro Terminal -> Mikro Fly değişimi tamamlandı!" -ForegroundColor Cyan