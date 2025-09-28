# 🚀 Mikro ERP Veritabanı Dokümantasyonu

[![Build Status](https://github.com/tansuozcelebi/MikroERPTablo/workflows/Build%20and%20Deploy/badge.svg)](https://github.com/tansuozcelebi/MikroERPTablo/actions)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-green)](https://tansuozcelebi.github.io/MikroERPTablo/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange)](package.json)

Mikro ERP v16 ve v17 veritabanı tablo yapıları, API referansları ve kapsamlı geliştirici dokümantasyonu.

## 🌐 Live Site

**[📖 Dokümantasyonu Görüntüle](https://tansuozcelebi.github.io/MikroERPTablo/)**

## � İçindekiler

- [Özellikler](#özellikler)
- [Kurulum](#kurulum)
- [Build İşlemleri](#build-işlemleri)
- [Geliştirme](#geliştirme)
- [Deployment](#deployment)
- [Katkıda Bulunma](#katkıda-bulunma)

## ✨ Özellikler

### 📊 Dokümantasyon
- **v16 Veritabanı Yapıları** - Detaylı tablo dokümantasyonları
- **v17 Blog ve API** - En güncel özellikler ve API referansları
- **MyeDB SDK** - Geliştirici kaynakları ve örnekler
- **Tablo Yapıları** - Kapsamlı veritabanı şeması

### 🎨 Teknik Özellikler
- **Responsive Tasarım** - Tüm cihazlarda mükemmel görünüm
- **SEO Optimize** - Arama motorları için optimize edilmiş
- **Hızlı Yükleme** - Optimize edilmiş performans
- **PWA Ready** - Progressive Web App özellikleri

### 🔧 Build Sistemi
- **Otomatik Build** - GitHub Actions ile CI/CD
- **Multi-Platform** - Windows, macOS, Linux desteği
- **Performance** - Minification ve compression
- **Validation** - HTML ve CSS doğrulama

## 📁 Proje Yapısı

```
MikroERPTablo/
├── 📁 v16/                    # v16 Dokümantasyonu
│   ├── index.html            # v16 Ana sayfa
│   └── mye/                  # Veritabanı dokümantasyonu
├── 📁 v17/                    # v17 Dokümantasyonu  
│   ├── index.html            # v17 Ana sayfa
│   └── mye/blog/             # Blog ve API docs
├── 📁 .github/workflows/     # GitHub Actions
├── 📄 index.html             # Ana sayfa
├── 📄 404.html               # Hata sayfası
├── 📄 robots.txt             # SEO
├── 📄 sitemap.xml            # Site haritası
├── 🔧 build.js               # Build script
├── 🔧 build.ps1              # PowerShell script
├── 🔧 Makefile               # Make commands
└── 📦 package.json           # NPM configuration
```

## 🚀 Kurulum

### Ön Gereksinimler
- **Node.js** (v16+)
- **NPM** (v8+)
- **Git**

### Hızlı Başlangıç

```bash
# Repository'yi clone edin
git clone https://github.com/tansuozcelebi/MikroERPTablo.git
cd MikroERPTablo

# Bağımlılıkları yükleyin
npm install

# Build edin
npm run build

# Local server başlatın
npm run serve
```

## 🏗️ Build İşlemleri

### NPM Scripts

```bash
# Build işlemleri
npm run build          # Projeyi build et
npm run dev            # Geliştirme sunucusu
npm run serve          # Production server
npm run test           # Testleri çalıştır

# Utility scripts
npm run clean          # Build dosyalarını temizle
npm run lint           # HTML lint kontrolü
npm run deploy         # GitHub Pages'e deploy
```

### PowerShell (Windows)

```powershell
# Build script ile
.\build.ps1 help       # Yardım
.\build.ps1 build      # Build
.\build.ps1 dev        # Dev server
.\build.ps1 full       # Tam build döngüsü
```

### Make (Linux/macOS)

```bash
make help              # Yardım
make build             # Build
make dev               # Dev server  
make full              # Tam build döngüsü
```

### Manual Build

```bash
# Node.js build script
node build.js
```

## 🔧 Geliştirme

### Yerel Geliştirme

```bash
# Geliştirme sunucusu başlat
npm run dev

# Veya
python -m http.server 8080
```

Tarayıcınızda `http://localhost:8080` adresini açın.

### Build Output

Build işlemi sonrası `dist/` klasöründe:

```
dist/
├── index.html              # Ana sayfa
├── 404.html                # Hata sayfası
├── robots.txt              # SEO dosyası
├── sitemap.xml             # Site haritası
├── build-info.json         # Build bilgileri
├── v16/                    # v16 dosyaları
├── v17/                    # v17 dosyaları
└── README.md               # Build README
```

## � Deployment

### Otomatik Deployment (GitHub Actions)

Repository'ye push yaptığınızda otomatik olarak:
1. ✅ Build işlemi çalışır
2. 🧪 Testler koşulur  
3. 📊 Validasyon yapılır
4. 🚀 GitHub Pages'e deploy edilir

### Manuel Deployment

```bash
# GitHub Pages'e deploy
npm run deploy

# Veya build edip manually upload
npm run build
# dist/ klasörünü sunucuya yükle
```

## 📊 Build İstatistikleri

Build işlemi sırasında:
- **HTML Minification** - %30-40 boyut azalması
- **CSS Optimization** - %20-30 performans artışı  
- **Image Compression** - %50-60 boyut optimizasyonu
- **Gzip Compression** - %70-80 transfer optimizasyonu

## 🔍 SEO Özellikleri

- ✅ **Meta Tags** - Tüm sayfalar için optimize
- ✅ **Open Graph** - Sosyal medya paylaşımları
- ✅ **Twitter Cards** - Twitter optimize
- ✅ **Structured Data** - Schema.org markup
- ✅ **Sitemap** - XML sitemap
- ✅ **Robots.txt** - Arama motoru yönergeleri

## 🛠️ Teknolojiler

- **Frontend**: HTML5, CSS3, JavaScript
- **Build**: Node.js, GitHub Actions
- **Hosting**: GitHub Pages
- **SEO**: Meta tags, Sitemap, Robots.txt
- **Analytics**: Google Search Console ready

## 📈 Performance

- **Lighthouse Score**: 95+
- **Page Load**: < 2s
- **First Paint**: < 1s
- **Mobile Friendly**: ✅
- **PWA Score**: 90+

## 🤝 Katkıda Bulunma

1. Repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

### Geliştirici Rehberi

```bash
# Development workflow
git clone https://github.com/tansuozcelebi/MikroERPTablo.git
cd MikroERPTablo
npm install
npm run dev

# Build ve test
npm run build
npm run test

# Contribution
git checkout -b my-feature
# ... changes ...
git push origin my-feature
# Open PR
```

## � Lisans

Bu proje [MIT License](LICENSE) altında lisanslanmıştır.

## 👨‍💻 Geliştirici

**Tansu Özçelebi**
- GitHub: [@tansuozcelebi](https://github.com/tansuozcelebi)
- Website: [tansuozcelebi.github.io](https://tansuozcelebi.github.io)

## 🙏 Teşekkürler

- Mikro ERP ekibine dokümantasyon için
- Tüm katkıda bulunanlara
- Open source topluluğuna

## 📞 Destek

Sorun yaşıyorsanız:
1. 📖 [Dokümantasyonu](https://tansuozcelebi.github.io/MikroERPTablo/) kontrol edin
2. 🐛 [Issue açın](https://github.com/tansuozcelebi/MikroERPTablo/issues)
3. 💬 [Discussions](https://github.com/tansuozcelebi/MikroERPTablo/discussions) bölümünü kullanın

---

<div align="center">

**[⭐ Star](https://github.com/tansuozcelebi/MikroERPTablo)** | **[🍴 Fork](https://github.com/tansuozcelebi/MikroERPTablo/fork)** | **[🐛 Issues](https://github.com/tansuozcelebi/MikroERPTablo/issues)**

Made with ❤️ for Mikro ERP Community

</div>