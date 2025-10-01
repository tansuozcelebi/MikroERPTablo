# Türkçe karakter düzeltme scripti
$files = Get-ChildItem -Path "." -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
    
    # Ortak değişimler
    $content = $content -replace 'Tablo Ad�', 'Tablo Adı'
    $content = $content -replace 'Tablo A��klamas�', 'Tablo Açıklaması'
    $content = $content -replace 'Ba�l�k', 'Başlık'
    $content = $content -replace 'K�sm�', 'Kısmı'
    $content = $content -replace '��in', 'İçin'
    $content = $content -replace 'T�klay�n', 'Tıklayın'
    $content = $content -replace 'Yap�s�', 'Yapısı'
    $content = $content -replace 'Database Yap�s�', 'Database Yapısı'
    $content = $content -replace 'Tablolar�m�zdaki', 'Tablolarımızdaki'
    $content = $content -replace 'alanlar�', 'alanları'
    $content = $content -replace 'belirtilmedi�i', 'belirtilmediği'
    $content = $content -replace 's�rece', 'sürece'
    $content = $content -replace 'i�ermemelidir', 'içermemelidir'
    
    $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
}

Write-Host "Tamamlandi!"