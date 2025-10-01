# Mikro Terminal -> Mikro Fly degisimi
$files = Get-ChildItem -Path "." -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
    
    if ($content -match "Mikro Terminal") {
        $content = $content -replace "Mikro Terminal", "Mikro Fly"
        $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Guncellendi: $($file.Name)"
    }
}

Write-Host "Tamamlandi!"