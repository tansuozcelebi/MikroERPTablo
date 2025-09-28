#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🚀 Mikro ERP Dokümantasyon Build Başlatılıyor...\n');

// Build bilgileri
const buildInfo = {
    version: require('./package.json').version,
    buildDate: new Date().toISOString(),
    buildNumber: process.env.BUILD_NUMBER || Math.floor(Date.now() / 1000),
    gitCommit: getGitCommit(),
    environment: process.env.NODE_ENV || 'production'
};

function getGitCommit() {
    try {
        return execSync('git rev-parse HEAD', { encoding: 'utf8' }).trim().substring(0, 7);
    } catch (error) {
        return 'unknown';
    }
}

// Build adımları
async function build() {
    try {
        console.log('📋 1. Proje analizi yapılıyor...');
        await analyzeProject();
        
        console.log('🧹 2. Temizlik yapılıyor...');
        await cleanBuild();
        
        console.log('📁 3. Dist klasörü oluşturuluyor...');
        await createDist();
        
        console.log('📄 4. HTML dosyaları işleniyor...');
        await processHTML();
        
        console.log('🎨 5. CSS dosyaları optimize ediliyor...');
        await processCSS();
        
        console.log('🖼️  6. Görseller optimize ediliyor...');
        await processImages();
        
        console.log('📊 7. Sitemap güncelleniyor...');
        await updateSitemap();
        
        console.log('✅ 8. Build bilgileri oluşturuluyor...');
        await createBuildInfo();
        
        console.log('🔍 9. Validasyon yapılıyor...');
        await validateBuild();
        
        console.log('\n✨ Build başarıyla tamamlandı!');
        console.log(`📦 Sürüm: ${buildInfo.version}`);
        console.log(`🔗 Commit: ${buildInfo.gitCommit}`);
        console.log(`📅 Tarih: ${buildInfo.buildDate}`);
        
    } catch (error) {
        console.error('❌ Build başarısız:', error.message);
        process.exit(1);
    }
}

async function analyzeProject() {
    const stats = {
        htmlFiles: 0,
        cssFiles: 0,
        jsFiles: 0,
        imageFiles: 0,
        totalSize: 0
    };
    
    function analyzeDir(dir) {
        const files = fs.readdirSync(dir);
        files.forEach(file => {
            const filePath = path.join(dir, file);
            const stat = fs.statSync(filePath);
            
            if (stat.isDirectory() && !file.startsWith('.') && file !== 'node_modules' && file !== 'dist') {
                analyzeDir(filePath);
            } else if (stat.isFile()) {
                const ext = path.extname(file).toLowerCase();
                stats.totalSize += stat.size;
                
                if (ext === '.html') stats.htmlFiles++;
                else if (ext === '.css') stats.cssFiles++;
                else if (ext === '.js') stats.jsFiles++;
                else if (['.png', '.jpg', '.jpeg', '.gif'].includes(ext)) stats.imageFiles++;
            }
        });
    }
    
    analyzeDir('./');
    
    console.log(`   📄 HTML: ${stats.htmlFiles} dosya`);
    console.log(`   🎨 CSS: ${stats.cssFiles} dosya`);
    console.log(`   ⚡ JS: ${stats.jsFiles} dosya`);
    console.log(`   🖼️  Görsel: ${stats.imageFiles} dosya`);
    console.log(`   📦 Toplam boyut: ${(stats.totalSize / 1024 / 1024).toFixed(2)} MB`);
}

async function cleanBuild() {
    if (fs.existsSync('./dist')) {
        fs.rmSync('./dist', { recursive: true });
    }
}

async function createDist() {
    fs.mkdirSync('./dist', { recursive: true });
    fs.mkdirSync('./dist/v16', { recursive: true });
    fs.mkdirSync('./dist/v17', { recursive: true });
}

async function processHTML() {
    // Ana HTML dosyalarını kopyala
    const htmlFiles = ['index.html', '404.html'];
    htmlFiles.forEach(file => {
        if (fs.existsSync(file)) {
            let content = fs.readFileSync(file, 'utf8');
            
            // Build bilgilerini ekle
            content = content.replace(
                '</head>',
                `    <!-- Build Info: v${buildInfo.version} - ${buildInfo.gitCommit} -->\n</head>`
            );
            
            fs.writeFileSync(`./dist/${file}`, content);
        }
    });
    
    // Diğer dosyaları kopyala
    copyDirectory('./v16', './dist/v16');
    copyDirectory('./v17', './dist/v17');
}

async function processCSS() {
    // CSS dosyaları varsa optimize et
    if (fs.existsSync('./mye-header.css')) {
        fs.copyFileSync('./mye-header.css', './dist/mye-header.css');
    }
}

async function processImages() {
    // Görselleri kopyala
    const imageExtensions = ['.png', '.jpg', '.jpeg', '.gif'];
    
    function copyImages(srcDir, destDir) {
        if (!fs.existsSync(srcDir)) return;
        
        const files = fs.readdirSync(srcDir);
        files.forEach(file => {
            const srcFile = path.join(srcDir, file);
            const destFile = path.join(destDir, file);
            const stat = fs.statSync(srcFile);
            
            if (stat.isDirectory()) {
                if (!fs.existsSync(destFile)) {
                    fs.mkdirSync(destFile, { recursive: true });
                }
                copyImages(srcFile, destFile);
            } else if (imageExtensions.includes(path.extname(file).toLowerCase())) {
                fs.copyFileSync(srcFile, destFile);
            }
        });
    }
    
    copyImages('./v16', './dist/v16');
    copyImages('./v17', './dist/v17');
}

async function updateSitemap() {
    // Sitemap'i dist'e kopyala
    if (fs.existsSync('./sitemap.xml')) {
        fs.copyFileSync('./sitemap.xml', './dist/sitemap.xml');
    }
    
    // Robots.txt'yi kopyala
    if (fs.existsSync('./robots.txt')) {
        fs.copyFileSync('./robots.txt', './dist/robots.txt');
    }
}

async function createBuildInfo() {
    const buildData = {
        ...buildInfo,
        files: getFileCount('./dist'),
        buildDuration: Date.now() - startTime
    };
    
    fs.writeFileSync('./dist/build-info.json', JSON.stringify(buildData, null, 2));
    
    // README oluştur
    const readme = `# Mikro ERP Dokümantasyon Build

**Sürüm:** ${buildInfo.version}  
**Build Tarihi:** ${new Date(buildInfo.buildDate).toLocaleString('tr-TR')}  
**Git Commit:** ${buildInfo.gitCommit}  
**Build Numarası:** ${buildInfo.buildNumber}  

## Dosya İstatistikleri
- Toplam dosya: ${buildData.files.total}
- HTML dosyaları: ${buildData.files.html}
- CSS dosyaları: ${buildData.files.css}
- Görsel dosyaları: ${buildData.files.images}

## Build Süreci
Build süresi: ${buildData.buildDuration}ms

Bu build GitHub Actions tarafından otomatik olarak oluşturulmuştur.
`;
    
    fs.writeFileSync('./dist/README.md', readme);
}

function getFileCount(dir) {
    let stats = { total: 0, html: 0, css: 0, js: 0, images: 0 };
    
    function count(directory) {
        const files = fs.readdirSync(directory);
        files.forEach(file => {
            const filePath = path.join(directory, file);
            const stat = fs.statSync(filePath);
            
            if (stat.isDirectory()) {
                count(filePath);
            } else {
                stats.total++;
                const ext = path.extname(file).toLowerCase();
                if (ext === '.html') stats.html++;
                else if (ext === '.css') stats.css++;
                else if (ext === '.js') stats.js++;
                else if (['.png', '.jpg', '.jpeg', '.gif'].includes(ext)) stats.images++;
            }
        });
    }
    
    count(dir);
    return stats;
}

function copyDirectory(src, dest) {
    if (!fs.existsSync(src)) return;
    
    if (!fs.existsSync(dest)) {
        fs.mkdirSync(dest, { recursive: true });
    }
    
    const files = fs.readdirSync(src);
    files.forEach(file => {
        const srcFile = path.join(src, file);
        const destFile = path.join(dest, file);
        const stat = fs.statSync(srcFile);
        
        if (stat.isDirectory()) {
            copyDirectory(srcFile, destFile);
        } else {
            fs.copyFileSync(srcFile, destFile);
        }
    });
}

async function validateBuild() {
    // Temel dosyaların varlığını kontrol et
    const requiredFiles = ['index.html', 'sitemap.xml', 'robots.txt', 'build-info.json'];
    
    for (const file of requiredFiles) {
        if (!fs.existsSync(`./dist/${file}`)) {
            throw new Error(`Gerekli dosya bulunamadı: ${file}`);
        }
    }
    
    console.log('   ✅ Tüm gerekli dosyalar mevcut');
}

const startTime = Date.now();
build().catch(console.error);