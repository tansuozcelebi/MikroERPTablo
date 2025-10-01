# Türkçe karakter düzeltme PowerShell scripti
param([string]$rootPath = ".")

Write-Host "Türkçe karakter düzeltmeleri başlıyor..." -ForegroundColor Green

# Türkçe karakter haritalama
$charMap = @{
    # Ana karakterler
    'Ad�' = 'Adı'
    'A��klamas�' = 'Açıklaması'
    'Ba�l�k' = 'Başlık'
    'K�sm�' = 'Kısmı'
    '��in' = 'İçin'
    'T�klay�n' = 'Tıklayın'
    'Yap�s�' = 'Yapısı'
    'Database Yap�s�' = 'Database Yapısı'
    'Tablolar�' = 'Tabloları'
    'm�zdaki' = 'mızdaki'
    'alanlar�' = 'alanları'
    'belirtilmedi�i' = 'belirtilmediği'
    's�rece' = 'sürece'
    'i�ermemelidir' = 'içermemelidir'
    'Tablolar�m�zdaki' = 'Tablolarımızdaki'
    
    # Genel karakter değişimleri
    '�' = 'ı'
    '�' = 'ş'
    '�' = 'ğ'
    '�' = 'ü'
    '�' = 'ö'
    '�' = 'ç'
    '�' = 'İ'
    '�' = 'Ş'
    '�' = 'Ğ'
    '�' = 'Ü'
    '�' = 'Ö'
    '�' = 'Ç'
}

$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse

foreach ($file in $files) {
    Write-Host "İşleniyor: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        $modified = $false
        
        foreach ($pair in $charMap.GetEnumerator()) {
            if ($content.Contains($pair.Key)) {
                $content = $content.Replace($pair.Key, $pair.Value)
                $modified = $true
            }
        }
        
        if ($modified) {
            $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "✓ Düzeltildi: $($file.Name)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Hata: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Türkçe karakter düzeltmeleri tamamlandı!" -ForegroundColor Cyan