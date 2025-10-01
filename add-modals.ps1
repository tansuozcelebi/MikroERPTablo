# Modal ekleme scripti
$modalContent = Get-Content -Path "modal-template.html" -Encoding UTF8 -Raw

$files = Get-ChildItem -Path "." -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
    
    # Eğer mye-header-bar varsa ve modal yoksa modal ekle
    if ($content -match "mye-header-bar" -and $content -notmatch "aboutModal") {
        # </body> den önce modal ekle
        if ($content -match "</body>") {
            $content = $content -replace "</body>", "$modalContent`n</body>"
            $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "Modal eklendi: $($file.Name)"
        }
    }
}

Write-Host "Modal ekleme tamamlandi!"