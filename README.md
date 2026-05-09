# 🌌 LumanovOS Desktop Environment

LumanovOS, Alpine Linux tabanlı, **PlayStation 5** ve **macOS** estetiğini birleştiren, ultra hafif ve modern bir masaüstü ortamıdır (DE). Oyun konsolu akıcılığı ile profesyonel bir işletim sistemi deneyimini bir araya getirir.

![LumanovOS Banner](https://via.placeholder.com/1200x400/0f1218/00aaff?text=LumanovOS+Desktop+Environment)

## ✨ Özellikler

- **🎮 PS5 Style Dashboard:** Uygulamalar arasında yatay ve akıcı geçişler.
- **🍎 macOS Aesthetic:** Dinamik blur (cam efekti) desteği ve minimalist dock tasarımı.
- **🎨 Canlı Tema Motoru:** Ayarlar üzerinden anında tema değiştirme (Koyu Mod, Apple Glass vb.).
- **⚡ Ultra Hafif:** Alpine Linux üzerinde en düşük kaynak tüketimi için optimize edildi.
- **🔔 Bildirim Sistemi:** Temaya duyarlı, modern bildirim kutucukları.
- **🛠️ Gelişmiş Uygulama Yönetimi:** Sistemdeki uygulamaları otomatik tanıma ve başlatma.

## 🚀 Hızlı Kurulum

LumanovOS'u sisteminize tek tıkla kurmak için şu komutu çalıştırın:

```bash
git clone https://github.com/rglomen/LumanovOS-DE.git
cd LumanovOS-DE
sh install.sh
```

Kurulum bittikten sonra başlatmak için:
```bash
sh start-lumanov.sh
```

## 🛠️ Mimari

- **Dil:** Python 3 (Backend Logic)
- **Arayüz:** Qt6 / QML (GPU Hızlandırmalı Render)
- **Pencere Yönetimi:** Openbox (Arka Plan)
- **Sistem:** Alpine Linux

## 📂 Dizin Yapısı

- `core/`: Bildirim ve Tema yönetimi gibi ana servisler.
- `ui/`: QML tasarım dosyaları.
- `themes/`: JSON formatındaki tema paketleri.
- `assets/`: Duvar kağıtları ve görsel materyaller.

## 🤝 Katkıda Bulunma

1. Bu depoyu çatallayın (Fork).
2. Özellik dalınızı oluşturun (`git checkout -b feature/yeniozellik`).
3. Değişikliklerinizi kaydedin (`git commit -am 'Yeni özellik eklendi'`).
4. Dalınıza gönderin (`git push origin feature/yeniozellik`).
5. Bir Çekme İsteği (Pull Request) açın.

---
Developed with ❤️ by **Lumanov Team**
