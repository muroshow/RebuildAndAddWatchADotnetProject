# 🚀 .NET Project Rebuild & Watch Wizard v2.2 🧙‍♂️

## 🇹🇷 Türkçe Versiyon

.NET projelerini geliştirirken terminalde vakit kaybetmek bazen tam bir kabusa dönüşebilir. Bu gelişmiş ve akıllı sihirbaz, projelerinizi otomatik olarak bulur, listeler ve tek bir dokunuşla `rebuild` ederek izleme moduna (`watch`) alır.

### ✨ Özellikler

* **🔥 Akıllı Port Temizliği (Zombie Process Killer):** Projenize ait meşgul portları (`launchSettings.json` üzerinden) tespit eder ve "Port already in use" hatasını önlemek için sadece ilgili işlemleri güvenle temizler.
* **🛡️ Güvenli Başlatma (Safe Boot):** İzleme moduna (`watch`) geçmeden önce projeyi derler (`build`). Kodda hata varsa işlemi durdurarak sonsuz hata döngüsünü engeller.
* **🌍 Otomatik Dil Desteği:** Sistem dilinizi algılar. Türkçe sistemlerde Türkçe, diğer tüm dillerde otomatik olarak İngilizce çalışır.
* **🧙‍♂️ Sihirbaz Arayüzü:** İşlemleri adım adım gösteren, modern ve temiz "Boxed" (kutulu) bir terminal arayüzü sunar.
* **📂 Akıllı Proje Listeleme:** `Documents/GitHub` altındaki projelerinizi otomatik olarak tarar ve numaralandırılmış bir liste sunar.
* **🗺️ İnteraktif Gezinme:** Ana projenizi seçtikten sonra alt klasörlerini (UI, API vb.) listeler; tam olarak doğru dizinde çalışmanızı sağlar.
* **🧠 Akıllı Hafıza (Persistence):** En son çalıştığınız proje yolunu hatırlar ve bir sonraki açılışta hızlı erişim için size sorar.
* **⚡️ Temiz Başlangıç:** Sürükle-bırak yoluyla gelen hatalı karakterleri temizler ve projeyi her zaman en güncel haliyle derler.
* **🍎 macOS Native:** `.command` yapısı sayesinde terminalle uğraşmadan tek tıkla çalıştırılabilir.

### 🚀 Nasıl Kullanılır? (Tek Tıkla Kurulum)

**🍎 macOS:**

```bash
curl -L -o ~/Desktop/"macOs Rebuild And Add Watch A Dotnet Project.command" "https://raw.githubusercontent.com/muroshow/RebuildAndAddWatchADotnetProject/main/macOs%20Rebuild%20And%20Add%20Watch%20A%20Dotnet%20Project.command?v=1" && chmod +x ~/Desktop/"macOs Rebuild And Add Watch A Dotnet Project.command"

```

---

## 🇺🇸 English Version

Wasting time in the terminal while developing .NET projects can sometimes turn into a complete nightmare. This advanced and smart wizard automatically locates and lists your projects, and with a single touch, (`rebuilds`) them and switches to watch mode (`watch`).

### ✨ Features

* 🔥 Smart Port Cleaning (Zombie Process Killer): Reads your project's launchSettings.json, detects occupied ports specific to your project, and safely kills hanging processes to prevent "Port already in use" errors.
* 🛡️ Safe Boot (Pre-Watch Build Check): Compiles the project using dotnet build before entering watch mode. If the code has syntax errors or missing packages, it gracefully stops the process to prevent infinite error loops.
* 🌍 Automatic Language Support: Detects your system language. Runs in Turkish for Turkish systems and defaults to English for all other languages.
* 🧙‍♂️ Wizard Interface: Provides a modern and clean "Boxed" terminal UI that shows the process step-by-step (Clean > Build > Run).
* 📂 Smart Project Listing: Automatically scans Documents/GitHub and provides a numbered list of your projects.
* 🗺️ Interactive Navigation: After selecting a main project, it lists its sub-folders (UI, API, etc.), ensuring you run in the exact directory.
* 🧠 Smart Memory (Persistence): Remembers your last project path and asks if you'd like to resume on the next start.
* ⚡️ Clean Execution: Sanitizes drag-and-drop paths and ensures your project is always freshly built.
* 🍎 macOS Native: Run with a single click via the .command extension without manual terminal input.
* 🎨 User-Friendly: Provides real-time and aesthetic feedback with its colorful logging structure and status badges.

### 🚀 How to Use (One-Click Install)

**🍎 macOS:**

```bash
curl -L -o ~/Desktop/"macOs Rebuild And Add Watch A Dotnet Project.command" "https://raw.githubusercontent.com/muroshow/RebuildAndAddWatchADotnetProject/main/macOs%20Rebuild%20And%20Add%20Watch%20A%20Dotnet%20Project.command?v=1" && chmod +x ~/Desktop/"macOs Rebuild And Add Watch A Dotnet Project.command"

```

---

## 🛠️ Developer & Contact

**Muharrem AKTAS** 🔗 **Github:** [muroshow](https://github.com/muroshow/) 

🔗 **LinkedIn:** [muharremaktas](https://www.linkedin.com/in/muharremaktas/) 

## 📜 License

This project is protected under the **MIT License**.
