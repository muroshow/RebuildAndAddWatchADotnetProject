#!/bin/zsh

# --- AYARLAR & HAFIZA ---
CONFIG_FILE="$HOME/.dotnet_watcher_config"
GITHUB_ROOT="$HOME/Documents/GitHub"

# --- RENKLER VE STİLLER ---
BG_CYAN='\033[46;30m'
BG_GREEN='\033[42;30m'
BG_MAGENTA='\033[45;37m'
BG_RED='\033[41;37m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RED='\033[1;31m'
BOLD='\033[1m'
NC='\033[0m'

# --- YARDIMCI FONKSİYONLAR ---
draw_header() {
    clear
    echo -e "${CYAN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    echo -e "${CYAN}┃${NC}  ${BOLD}${WHITE}🧙‍♂️ .NET PROJECT WIZARD v2.6${NC}                 ${CYAN}┃${NC}"
    echo -e "${CYAN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
    [[ -n "$1" ]] && echo -e "  ${GRAY}📂 Konum: ${NC}${MAGENTA}$1${NC}\n"
}

print_status() {
    echo -e "\n${BG_CYAN} INFO ${NC} $1"
}

# --- DİL AYARLARI ---
if [[ "$LANG" == tr* ]]; then
    L_LAST_PATH="Hafızadaki yolu kullanmak ister misiniz?"
    L_SELECT_PROJ="Ana projenizi seçin"
    L_SELECT_SUB="Çalıştırılacak alt klasörü seçin"
    L_RUN_HERE="👉 [Bu klasörü seç ve başlat]"
    L_CHOICE="Seçiminiz"
    L_CLEANING="Projenin portları kontrol ediliyor ve temizleniyor..."
    L_PREPARING="Proje derleniyor (Bağımlılıklar yükleniyor)..."
    L_READY="Proje hazır! İzleme (Watch) moduna geçiliyor..."
    L_URLS="🚀 Proje şu adreslerde ayağa kalkacak:"
    L_BUILD_ERR="Derleme Hatası! Proje ayağa kalkamadı."
    L_ERROR="HATA: Klasör bulunamadı!"
    L_EXIT="Çıkmak için Enter'a basın..."
else
    L_LAST_PATH="Would you like to use the cached path?"
    L_SELECT_PROJ="Select your main project"
    L_SELECT_SUB="Select sub-folder to run"
    L_RUN_HERE="👉 [Select this folder and start]"
    L_CHOICE="Choice"
    L_CLEANING="Checking and cleaning project ports..."
    L_PREPARING="Building project (Restoring dependencies)..."
    L_READY="Project is ready! Starting watch mode..."
    L_URLS="🚀 Project will be available at:"
    L_BUILD_ERR="Build failed! Process stopped."
    L_ERROR="ERROR: Directory not found!"
    L_EXIT="Press Enter to exit..."
fi

# --- ANA AKIŞ ---
draw_header "GitHub"

# --- HAFIZA KONTROLÜ ---
PROJECT_PATH=""
if [ -f "$CONFIG_FILE" ]; then
    LAST_PATH=$(cat "$CONFIG_FILE")
    echo -e "  ${YELLOW}📍 $L_LAST_PATH${NC}"
    echo -e "      ${GRAY}$LAST_PATH${NC}"
    echo -n -e "\n  ${BOLD}(y/n):${NC} "
    read USE_LAST
    case "$USE_LAST" in
        [yYeE]*) PROJECT_PATH="$LAST_PATH" ;;
    esac
fi

# --- PROJE SEÇİMİ ---
if [ -z "$PROJECT_PATH" ]; then
    if [ ! -d "$GITHUB_ROOT" ]; then
        print_status "⚠️  $GITHUB_ROOT bulunamadı."
        echo -n -e "  ${WHITE}Lütfen yolu buraya sürükleyin:${NC} "
        read PROJECT_PATH
    else
        draw_header "GitHub"
        echo -e "  ${BOLD}${CYAN}▼ $L_SELECT_PROJ${NC}"
        cd "$GITHUB_ROOT"
        projects=(*(N/))
        
        for i in {1..$#projects}; do
            printf "  ${YELLOW}%2d)${NC} %-30s\n" $i "${projects[$i]}"
        done
        
        echo -n -e "\n  ${BOLD}$L_CHOICE (1-$#projects):${NC} "
        read P_IDX
        SELECTED_PROJ="${projects[$P_IDX]}"
        
        draw_header "GitHub > $SELECTED_PROJ"
        echo -e "  ${BOLD}${CYAN}▼ $L_SELECT_SUB${NC}"
        cd "$GITHUB_ROOT/$SELECTED_PROJ"
        subdirs=("." *(N/))
        
        for i in {1..$#subdirs}; do
            display_name="${subdirs[$i]}"
            [[ "$display_name" == "." ]] && display_name="$L_RUN_HERE"
            printf "  ${YELLOW}%2d)${NC} %-30s\n" $i "$display_name"
        done
        
        echo -n -e "\n  ${BOLD}$L_CHOICE (1-$#subdirs):${NC} "
        read S_IDX
        FINAL_SUB="${subdirs[$S_IDX]}"
        PROJECT_PATH="$GITHUB_ROOT/$SELECTED_PROJ/$FINAL_SUB"
    fi
fi

# --- ÇALIŞTIRMA ---
PROJECT_PATH=$(echo "$PROJECT_PATH" | sed "s/['\"]//g" | sed 's/\\//g' | xargs)

if [ -d "$PROJECT_PATH" ]; then
    echo "$PROJECT_PATH" > "$CONFIG_FILE"
    draw_header "$PROJECT_PATH"
    
    cd "$PROJECT_PATH"
    
    # ---------------------------------------------------------
    # ADIM 1: GELİŞMİŞ PORT TEMİZLİĞİ
    # ---------------------------------------------------------
    echo -e "${BG_CYAN} ADIM 1 ${NC} ${CYAN}$L_CLEANING${NC}"
    echo -e "${GRAY}--------------------------------------------------------${NC}"
    
    LAUNCH_SETTINGS="Properties/launchSettings.json"
    if [ -f "$LAUNCH_SETTINGS" ]; then
        PORTS=$(grep -oE '(localhost|127\.0\.0\.1):[0-9]+' "$LAUNCH_SETTINGS" 2>/dev/null | cut -d':' -f2 | sort -u)
        
        if [ -n "$PORTS" ]; then
            for PORT in $(echo $PORTS); do
                # Tüm PID'leri dizi olarak al
                PIDS=($(lsof -ti:$PORT 2>/dev/null))
                
                if [ ${#PIDS[@]} -gt 0 ]; then
                    echo -e "  ${YELLOW}⚠️ Port $PORT kullanımda (${#PIDS[@]} process). Temizleniyor...${NC}"
                    for pid in "${PIDS[@]}"; do
                        kill -9 $pid 2>/dev/null
                    done
                    # OS'in portu tamamen serbest bırakması için kısa bir es
                    sleep 1 
                    echo -e "  ${GREEN}✓ Port $PORT başarıyla temizlendi.${NC}"
                else
                    echo -e "  ${GRAY}✓ Port $PORT zaten boş.${NC}"
                fi
            done
        fi
    fi
    echo ""

    # ADIM 2: DERLEME
    echo -e "${BG_CYAN} ADIM 2 ${NC} ${CYAN}$L_PREPARING${NC}"
    echo -e "${GRAY}--------------------------------------------------------${NC}"
    
    BUILD_LOG=$(dotnet build 2>&1)
    BUILD_STATUS=$?
    
    if [ $BUILD_STATUS -eq 0 ]; then
        echo -e "  ${GREEN}✓ Derleme başarılı.${NC}"
        
        # ADIM 3: İZLEME (WATCH)
        echo -e "\n${BG_GREEN} ADIM 3 ${NC} ${GREEN}$L_READY${NC}"
        echo -e "${GRAY}--------------------------------------------------------${NC}"

        if [ -f "$LAUNCH_SETTINGS" ]; then
            APP_URLS=$(grep "applicationUrl" "$LAUNCH_SETTINGS" | sed -E 's/.*"applicationUrl": "(.*)".*/\1/' | tr ';' '\n' | sort -u)
            if [ -n "$APP_URLS" ]; then
                echo -e "  ${BOLD}${MAGENTA}$L_URLS${NC}"
                while read -r url; do
                    echo -e "  ${CYAN}➜ ${NC}${WHITE}${BOLD}$url${NC}"
                done <<< "$APP_URLS"
                echo -e "${GRAY}--------------------------------------------------------${NC}\n"
            fi
        fi

        dotnet watch run
        
    else
        # Hata Yönetimi
        echo -e "\n${BG_RED} $L_BUILD_ERR ${NC}"
        echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo "$BUILD_LOG" | awk '
        tolower($0) ~ /error|hata|başarısız|failed/ { print "\033[1;31m" $0 "\033[0m"; next }
        tolower($0) ~ /warning|uyarı/ { next }
        { print "\033[0;90m" $0 "\033[0m" }
        '
        echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi

else
    echo -e "\n${RED}❌ $L_ERROR${NC}"
    echo -e "${GRAY}Path: $PROJECT_PATH${NC}"
fi

echo -e "\n${GRAY}$L_EXIT${NC}"
read