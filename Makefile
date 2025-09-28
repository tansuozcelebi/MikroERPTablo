# Mikro ERP Dokümantasyon Makefile
# Make komutları için yardım dosyası

.PHONY: help install build dev serve test clean deploy status

# Varsayılan hedef
.DEFAULT_GOAL := help

# Renkler
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## 📋 Bu yardım mesajını göster
	@echo "$(GREEN)Mikro ERP Dokümantasyon Build Sistemi$(NC)"
	@echo "======================================"
	@echo ""
	@echo "Kullanılabilir komutlar:"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(GREEN)Örnek kullanım:$(NC)"
	@echo "  make install    # Bağımlılıkları yükle"
	@echo "  make build      # Projeyi build et"
	@echo "  make serve      # Local server başlat"
	@echo ""

install: ## 📦 NPM bağımlılıklarını yükle
	@echo "$(GREEN)📦 Bağımlılıklar yükleniyor...$(NC)"
	npm install
	@echo "$(GREEN)✅ Bağımlılıklar başarıyla yüklendi!$(NC)"

build: ## 🏗️ Projeyi build et
	@echo "$(GREEN)🏗️ Build işlemi başlatılıyor...$(NC)"
	node build.js
	@echo "$(GREEN)✅ Build tamamlandı!$(NC)"

dev: ## 🔧 Geliştirme modunda çalıştır
	@echo "$(GREEN)🔧 Geliştirme sunucusu başlatılıyor...$(NC)"
	npm run dev

serve: ## 🌐 Local HTTP server başlat
	@echo "$(GREEN)🌐 HTTP sunucusu başlatılıyor...$(NC)"
	@echo "$(YELLOW)http://localhost:8080$(NC)"
	npm run serve

test: ## 🧪 Testleri çalıştır ve validasyon yap
	@echo "$(GREEN)🧪 Testler çalıştırılıyor...$(NC)"
	npm run test
	@echo "$(GREEN)✅ Tüm testler başarılı!$(NC)"

lint: ## 🔍 HTML dosyalarını lint et
	@echo "$(GREEN)🔍 HTML dosyaları kontrol ediliyor...$(NC)"
	npm run lint

validate: ## ✅ HTML dosyalarını validate et
	@echo "$(GREEN)✅ HTML dosyaları doğrulanıyor...$(NC)"
	npm run validate

clean: ## 🧹 Build dosyalarını temizle
	@echo "$(GREEN)🧹 Build dosyaları temizleniyor...$(NC)"
	npm run clean
	@echo "$(GREEN)✅ Temizlik tamamlandı!$(NC)"

deploy: ## 🚀 GitHub Pages'e deploy et
	@echo "$(GREEN)🚀 GitHub Pages'e deploy ediliyor...$(NC)"
	npm run deploy
	@echo "$(GREEN)✅ Deploy tamamlandı!$(NC)"

status: ## 📊 Proje durumunu göster
	@echo "$(GREEN)📊 Proje Durumu$(NC)"
	@echo "==============="
	@echo ""
	@echo "$(YELLOW)📁 Dosya sayıları:$(NC)"
	@find . -name "*.html" -not -path "./node_modules/*" -not -path "./dist/*" | wc -l | xargs echo "  HTML dosyaları:"
	@find . -name "*.css" -not -path "./node_modules/*" -not -path "./dist/*" | wc -l | xargs echo "  CSS dosyaları:"
	@find . -name "*.js" -not -path "./node_modules/*" -not -path "./dist/*" | wc -l | xargs echo "  JS dosyaları:"
	@echo ""
	@echo "$(YELLOW)📦 Boyut bilgisi:$(NC)"
	@du -sh . 2>/dev/null | head -1 || echo "  Boyut hesaplanamadı"
	@echo ""
	@echo "$(YELLOW)🔗 Git durumu:$(NC)"
	@git status --porcelain | wc -l | xargs echo "  Değiştirilmiş dosya:"
	@git rev-parse --short HEAD 2>/dev/null | xargs echo "  Son commit:" || echo "  Git repository bulunamadı"
	@echo ""

quick: ## ⚡ Hızlı build ve test
	@echo "$(GREEN)⚡ Hızlı build ve test başlatılıyor...$(NC)"
	make clean
	make build
	make test
	@echo "$(GREEN)🎉 Hızlı işlem tamamlandı!$(NC)"

full: ## 🎯 Tam build döngüsü (clean + install + build + test)
	@echo "$(GREEN)🎯 Tam build döngüsü başlatılıyor...$(NC)"
	make clean
	make install
	make build
	make test
	@echo "$(GREEN)🎉 Tam build döngüsü tamamlandı!$(NC)"

watch: ## 👁️ Dosya değişikliklerini izle ve otomatik build et
	@echo "$(GREEN)👁️ Dosya değişiklikleri izleniyor...$(NC)"
	@echo "$(YELLOW)Ctrl+C ile durdurun$(NC)"
	@while true; do \
		inotifywait -r -e modify,create,delete --exclude='(dist/|node_modules/|\.git/)' . 2>/dev/null && \
		echo "$(YELLOW)📝 Değişiklik algılandı, yeniden build ediliyor...$(NC)" && \
		make build; \
	done

info: ## ℹ️ Sistem bilgilerini göster
	@echo "$(GREEN)ℹ️ Sistem Bilgileri$(NC)"
	@echo "=================="
	@echo ""
	@echo "$(YELLOW)🖥️ Sistem:$(NC)"
	@uname -a 2>/dev/null || echo "  Sistem bilgisi alınamadı"
	@echo ""
	@echo "$(YELLOW)🟢 Node.js:$(NC)"
	@node --version 2>/dev/null || echo "  Node.js bulunamadı"
	@echo ""
	@echo "$(YELLOW)📦 NPM:$(NC)"
	@npm --version 2>/dev/null || echo "  NPM bulunamadı"
	@echo ""
	@echo "$(YELLOW)🔗 Git:$(NC)"
	@git --version 2>/dev/null || echo "  Git bulunamadı"
	@echo ""