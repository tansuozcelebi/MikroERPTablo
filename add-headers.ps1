# Header Entegrasyon Script'i
Write-Host "🎯 Tüm HTML dosyalarına header entegre ediliyor..." -ForegroundColor Yellow

$headerHtml = @"
    <!-- MYE Modern Header Bar -->
    <div class="mye-header-bar">
        <div class="mye-header-content">
            <a href="../../../index.html" class="mye-header-brand">
                <div class="logo">M</div>
                <span>Mikro Terminal</span>
            </a>
            <nav class="mye-header-nav">
                <a href="../../../index.html" class="mye-header-btn">
                    <span>🏠</span> Başa Dön
                </a>
                <button onclick="openAboutModal()" class="mye-header-btn primary">
                    <span>ℹ️</span> Hakkında
                </button>
            </nav>
        </div>
    </div>
"@

$modalHtml = @"

<!-- About Modal -->
<div id="aboutModal" class="mye-modal">
    <div class="mye-modal-content">
        <div class="mye-modal-header">
            <h2 class="mye-modal-title">Fabus Firması Hakkında</h2>
            <button class="mye-modal-close" onclick="closeAboutModal()">&times;</button>
        </div>
        <div class="mye-modal-body">
            <h3>🏢 Fabus Yazılım ve Danışmanlık</h3>
            <p>
                <strong>Fabus</strong>, 1995 yılından beri Türkiye'nin önde gelen yazılım şirketlerinden biri olarak 
                işletmelere yenilikçi teknoloji çözümleri sunmaktadır.
            </p>
            
            <h3>🎯 Misyonumuz</h3>
            <p>
                İşletmelerin dijital dönüşüm süreçlerinde güvenilir partner olmak, kullanıcı dostu 
                yazılımlar geliştirerek müşterilerimizin iş süreçlerini optimize etmek.
            </p>
            
            <h3>💼 Hizmetlerimiz</h3>
            <p>
                • <strong>Mikro Terminal:</strong> Comprehensive database management solutions<br>
                • <strong>ERP Sistemleri:</strong> Kurumsal kaynak planlaması<br>
                • <strong>Muhasebe Yazılımları:</strong> Mali işlem yönetimi<br>
                • <strong>Stok ve Satış Takibi:</strong> Envanter yönetimi<br>
                • <strong>İK Sistemleri:</strong> İnsan kaynakları yönetimi
            </p>
            
            <h3>🌟 Değerlerimiz</h3>
            <p>
                <strong>Güvenilirlik</strong> - <strong>Yenilikçilik</strong> - <strong>Müşteri Odaklılık</strong> - <strong>Sürekli Gelişim</strong>
            </p>
            
            <h3>📞 İletişim</h3>
            <p>
                <strong>Telefon:</strong> +90 (212) 555-0123<br>
                <strong>E-posta:</strong> info@fabus.com.tr<br>
                <strong>Web:</strong> <a href="https://www.fabus.com.tr" target="_blank" rel="noopener">www.fabus.com.tr</a><br>
                <strong>Adres:</strong> İstanbul, Türkiye
            </p>
        </div>
        <div class="mye-modal-footer">
            <button onclick="closeAboutModal()" class="mye-modal-btn">Kapat</button>
        </div>
    </div>
</div>

<script>
    function openAboutModal() {
        document.getElementById('aboutModal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }
    
    function closeAboutModal() {
        document.getElementById('aboutModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    // Click outside modal to close
    window.onclick = function(event) {
        const modal = document.getElementById('aboutModal');
        if (event.target === modal) {
            closeAboutModal();
        }
    }
    
    // ESC key to close modal
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeAboutModal();
        }
    });
</script>
"@

$processedCount = 0
$totalCount = 0

# v16 ve v17 alt dizinlerindeki tüm HTML dosyalarını bul
$htmlFiles = Get-ChildItem -Path "v16\v16\", "v17\v17\" -Filter "*.html" -Recurse -ErrorAction SilentlyContinue

$totalCount = $htmlFiles.Count
Write-Host "📊 Toplam $totalCount HTML dosyası bulundu" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    Write-Host "📄 İşleniyor: $($file.Name)" -ForegroundColor Gray
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # Zaten header varsa atla
        if ($content -match "mye-header-bar") {
            Write-Host "⚠️  Zaten header var: $($file.Name)" -ForegroundColor Yellow
            continue
        }
        
        # CSS linkini head'e ekle
        if ($content -match '<head[^>]*>' -and $content -notmatch 'mye-header\.css') {
            $content = $content -replace '(<head[^>]*>)', "`$1`n    <link rel=""stylesheet"" href=""../../../mye-header.css"">"
        }
        
        # Body padding ekle
        if ($content -match '<body[^>]*>') {
            $content = $content -replace '(<body[^>]*>)', "`$1`n<style>body { padding-top: 70px !important; }</style>"
        }
        
        # Header'ı body'nin hemen sonrasına ekle
        if ($content -match '<body[^>]*>') {
            $content = $content -replace '(<body[^>]*>)', "`$1`n$headerHtml"
        }
        
        # Modal ve script'i </body>'den önce ekle
        if ($content -match '</body>') {
            $content = $content -replace '</body>', "$modalHtml`n</body>"
        }
        
        # Dosyayı UTF-8 encoding ile kaydet
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        
        $processedCount++
        Write-Host "✅ Tamamlandı: $($file.Name)" -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Hata: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Header entegrasyonu tamamlandı!" -ForegroundColor Green
Write-Host "📊 İşlenen dosya: $processedCount / $totalCount" -ForegroundColor Cyan