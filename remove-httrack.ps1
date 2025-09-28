# HTTrack ibarelerini kaldıran script
param(
    [string]$RootPath = "C:\mikro"
)

Write-Host "HTTrack ibarelerini kaldırılıyor..." -ForegroundColor Green

# Tüm HTML dosyalarını bul
$htmlFiles = Get-ChildItem -Path $RootPath -Recurse -Filter "*.html" | Where-Object { $_.Name -ne "remove-httrack.ps1" }

$processedFiles = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedFiles++
    Write-Progress -Activity "HTTrack ibareleri kaldırılıyor" -Status "İşlenen: $($file.Name)" -PercentComplete (($processedFiles / $totalFiles) * 100)
    
    try {
        # Dosya içeriğini oku
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        if ($content) {
            $originalContent = $content
            
            # HTTrack comment satırlarını kaldır
            $content = $content -replace '<!-- Mirrored from .* by HTTrack Website Copier.*? -->', ''
            $content = $content -replace '<!-- Mirror and index made by HTTrack Website Copier.*? -->', ''
            $content = $content -replace '<!-- Thanks for using HTTrack Website Copier! -->', ''
            
            # HTML içindeki HTTrack meta tag'lerini kaldır
            $content = $content -replace '<meta name="generator" content="HTTrack Website Copier.*?"[^>]*>', ''
            
            # Title'da HTTrack referanslarını temizle
            $content = $content -replace '<title>([^<]*) - HTTrack Website Copier</title>', '<title>$1</title>'
            $content = $content -replace '<title>([^<]*) - HTTrack</title>', '<title>$1</title>'
            $content = $content -replace '<TITLE>([^<]*) - HTTrack</TITLE>', '<TITLE>$1</TITLE>'
            
            # HTTrack meta description'ı kaldır
            $content = $content -replace '<meta name="description" content="HTTrack is an easy-to-use website mirror utility.*?"[^>]*>', ''
            
            # HTTrack keywords'leri temizle
            $content = $content -replace '<meta name="keywords" content="[^"]*HTTrack[^"]*"[^>]*>', ''
            
            # HTTrack subtitle'ları kaldır
            $content = $content -replace '<td id="subTitle">HTTrack Website Copier - Open Source offline browser</td>', '<td id="subTitle"></td>'
            
            # HTTrack footer text'lerini kaldır
            $content = $content -replace '<I>Mirror and index made by HTTrack Website Copier.*?</I>', ''
            
            # Boş satırları temizle
            $content = $content -replace "`n`s*`n", "`n"
            $content = $content -replace "`r`n`s*`r`n", "`r`n"
            
            # İçerik değiştiyse kaydet
            if ($content -ne $originalContent) {
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
                Write-Host "Temizlendi: $($file.FullName)" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Warning "Hata: $($file.FullName) - $($_.Exception.Message)"
    }
}

Write-Host "HTTrack temizleme tamamlandı!" -ForegroundColor Green
Write-Host "Toplam işlenen dosya: $totalFiles" -ForegroundColor Cyan