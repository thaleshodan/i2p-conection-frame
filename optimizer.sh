#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

### === Global Starts=== ###
readonly I2P_DIR="${HOME}/.i2p"
readonly KEY_DIR="${I2P_DIR}/keys"
readonly LOG_FILE="/var/log/i2p-setup.log"
readonly INSTALLER_URL="https://geti2p.net/_static/i2pinstall_1.9.0.jar"
VERBOSE=false
KEY_TYPE="rsa" # ou ed25519

### === LOG === ###
log() {
    local level="$1"; shift
    [[ "$VERBOSE" = true ]] && echo "[$level] $*"
    echo "[$level] $*" >> "$LOG_FILE"
}
info()    { log "INFO" "$@"; }
warn()    { log "WARN" "$@"; }
error()   { log "ERROR" "$@"; }
success() { log "SUCCESS" "$@"; }

### === UTILS === ###
die() {
    error "$*"
    exit 1
}

run_or_die() {
    "$@" || die "Erro ao executar: $*"
}

check_dependency() {
    command -v "$1" &>/dev/null || die "Dependência faltando: $1"
}

check_all_dependencies() {
    for dep in curl gpg java openssl; do
        check_dependency "$dep"
    done
    info "Dependências OK."
}

detect_os() {
    case "$(uname -s)" in
        Linux*)   echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)        die "Sistema não suportado: $(uname -s)" ;;
    esac
}

### === INSTALATION ON I2P === ###
install_i2p() {
    mkdir -p "$I2P_DIR"
    cd "$I2P_DIR"
    info "Baixando I2P..."
    run_or_die curl -LO "$INSTALLER_URL"
    info "Instalando I2P..."
    run_or_die java -jar "$(basename "$INSTALLER_URL")" -console
    success "I2P instalado com sucesso em $I2P_DIR"
}

### === GENERATION OF PGP KEYS === ###
generate_rsa_keys() {
    mkdir -p "$KEY_DIR"
    openssl genpkey -algorithm RSA -out "$KEY_DIR/private.pem" -pkeyopt rsa_keygen_bits:4096
    openssl rsa -pubout -in "$KEY_DIR/private.pem" -out "$KEY_DIR/public.pem"
    chmod 600 "$KEY_DIR/private.pem"
    success "Chaves RSA geradas em $KEY_DIR"
}

generate_ed25519_keys() {
    mkdir -p "$KEY_DIR"
    ssh-keygen -t ed25519 -f "$KEY_DIR/ed25519" -N "" <<<y >/dev/null
    success "Chaves Ed25519 geradas em $KEY_DIR"
}

generate_keys() {
    case "$KEY_TYPE" in
        rsa) generate_rsa_keys ;;
        ed25519) generate_ed25519_keys ;;
        *) die "Tipo de chave inválido: $KEY_TYPE" ;;
    esac
}

### === CONFIGURATION === ###
apply_config() {
    info "Aplicando configurações básicas no I2P..."
    cat <<EOF >> "$I2P_DIR/i2prouter.config"
router.consolePassword=changeme
router.enableUDP=true
router.enableIPv6=false
EOF
    success "Configuração aplicada."
}

### === SYSTEMD SERVICE === ###
setup_service() {
    if [[ "$(detect_os)" != "linux" ]]; then
        warn "Serviço systemd só disponível em Linux."
        return
    fi

    sudo tee /etc/systemd/system/i2p.service >/dev/null <<EOF
[Unit]
Description=I2P Router
After=network.target

[Service]
User=$USER
ExecStart=$I2P_DIR/i2prouter start
ExecStop=$I2P_DIR/i2prouter stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reexec
    sudo systemctl enable --now i2p.service
    success "Serviço systemd criado e iniciado."
}

### === PARSE DE ARGUMENTOS === ###
usage() {
    cat <<EOF
Uso: $0 [opções]

Opções:
  --install           Instala o I2P
  --generate-keys     Gera par de chaves (use --key-type)
  --key-type <tipo>   Tipo de chave: rsa (padrão) ou ed25519
  --setup-service     Cria serviço systemd
  --configure         Aplica configuração padrão
  --verbose           Exibe mais detalhes
  --help              Mostra esta ajuda

Exemplo:
  $0 --install --generate-keys --key-type ed25519 --setup-service --configure --verbose
EOF
    exit 1
}

main() {
    local do_install=false
    local do_keys=false
    local do_service=false
    local do_config=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install) do_install=true ;;
            --generate-keys) do_keys=true ;;
            --key-type) shift; KEY_TYPE="$1" ;;
            --setup-service) do_service=true ;;
            --configure) do_config=true ;;
            --verbose) VERBOSE=true ;;
            --help) usage ;;
            *) die "Argumento inválido: $1" ;;
        esac
        shift
    done

    check_all_dependencies

    [[ "$do_install" == true ]]  && install_i2p
    [[ "$do_keys" == true ]]     && generate_keys
    [[ "$do_config" == true ]]   && apply_config
    [[ "$do_service" == true ]]  && setup_service
}

main "$@"
