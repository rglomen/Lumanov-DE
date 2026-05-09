#!/bin/sh

# LumanovOS DE - Tek Tık Kurulum Scripti
# Hedef: Alpine Linux

echo "🚀 LumanovOS DE Kurulumu Başlıyor..."

# 1. Paket Kaynaklarını Kontrol Et (Community deposu gerekli)
if ! grep -q "community" /etc/apk/repositories; then
    echo "📦 Community deposu ekleniyor..."
    echo "http://dl-cdn.alpinelinux.org/alpine/v$(cut -d. -f1,2 /etc/alpine-release)/community" >> /etc/apk/repositories
fi

# 2. Sistem Güncelleme ve Bağımlılıklar
echo "📥 Bağımlılıklar kuruluyor..."
apk update
apk add python3 py3-pyside6 py3-pip openbox dbus-python font-dejavu mesa-dri-gallium

# 3. Klasör Yapısını Oluştur
echo "📁 Klasörler hazırlanıyor..."
mkdir -p core ui assets themes scripts

# 4. Çalıştırma Yetkileri
chmod +x lumanov-shell.py

# 5. Masaüstü Kısayolu Oluştur (İsteğe bağlı)
echo "🔗 Başlatıcı hazırlanıyor..."
cat <<EOF > start-lumanov.sh
#!/bin/sh
openbox --replace &
python3 lumanov-shell.py
EOF
chmod +x start-lumanov.sh

echo "------------------------------------------------"
echo "✅ Kurulum Tamamlandı!"
echo "Şimdi LumanovOS'u başlatmak için şu komutu kullanın:"
echo "sh start-lumanov.sh"
echo "------------------------------------------------"
