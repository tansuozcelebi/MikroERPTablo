# Basit karakter düzeltme scripti
param([string]$rootPath = ".")

$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse

foreach ($file in $files) {
    Write-Host "Düzeltiliyor: $($file.Name)"
    
    $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
    
    # Türkçe karakter düzeltmeleri
    $content = $content -replace 'Ä±', 'ı'
    $content = $content -replace 'Å£', 'ş'
    $content = $content -replace 'Ä', 'ğ'
    $content = $content -replace 'Ã¼', 'ü'
    $content = $content -replace 'Ã¶', 'ö'
    $content = $content -replace 'Ã§', 'ç'
    $content = $content -replace 'Ä°', 'İ'
    $content = $content -replace 'Åž', 'Ş'
    $content = $content -replace 'Ä', 'Ğ'
    $content = $content -replace 'Ãœ', 'Ü'
    $content = $content -replace 'Ã–', 'Ö'
    $content = $content -replace 'Ã‡', 'Ç'
    
    # Header CSS yolu düzeltme
    $relativePath = $file.FullName.Replace($PWD.Path, "").Replace("\", "/")
    $depth = ($relativePath.Split("/").Length - 2)
    $cssPath = "../" * $depth + "mye-header.css"
    
    # CSS link düzeltme
    $content = $content -replace 'href="[^"]*mye-header\.css"', "href=`"$cssPath`""
    
    # Dosyayı kaydet
    $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
}

Write-Host "Tamamlandı!"