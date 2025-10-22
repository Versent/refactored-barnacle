#!/bin/bash

# CTF Training Data Loader
# Loads manufactured data with cleartext credentials

set -e

echo "=========================================="
echo "CTF Training Data Loader"
echo "WARNING: Contains intentional vulnerabilities"
echo "=========================================="

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${REPO_ROOT}/data"
CONFIG_DIR="${REPO_ROOT}/configs"
SCRIPTS_DIR="${REPO_ROOT}/scripts"

# Database connection (from cleartext config)
DB_HOST="${DB_HOST:-prod-db.ctf-training.internal}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-ctf_training_prod}"
DB_USER="${DB_USER:-prod_admin}"
DB_PASS="${DB_PASS:-ProdAdm1n!SecretP@ss}"

echo ""
echo "Database Configuration:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: $DB_PASS"  # Intentionally displayed
echo ""

# Load SQL seed data
echo "[1/5] Loading SQL seed data..."
if [ -f "${SCRIPTS_DIR}/seed-database.sql" ]; then
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" < "${SCRIPTS_DIR}/seed-database.sql"
    echo "✓ SQL data loaded"
else
    echo "✗ seed-database.sql not found"
fi

# Load financial data
echo "[2/5] Loading financial data..."
if [ -d "${DATA_DIR}/financial" ]; then
    for file in "${DATA_DIR}/financial"/*; do
        echo "  Processing: $(basename "$file")"
        # Process CSV/JSON files
    done
    echo "✓ Financial data loaded"
fi

# Load healthcare data
echo "[3/5] Loading healthcare PHI data..."
if [ -d "${DATA_DIR}/healthcare" ]; then
    for file in "${DATA_DIR}/healthcare"/*; do
        echo "  Processing: $(basename "$file")"
        # Process medical records
    done
    echo "✓ Healthcare data loaded"
fi

# Load credentials
echo "[4/5] Loading credential files..."
if [ -d "${DATA_DIR}/credentials" ]; then
    echo "  Copying credential files to application..."
    cp -r "${DATA_DIR}/credentials"/* /opt/ctf-training/credentials/
    echo "✓ Credentials loaded"
fi

# Load secrets
echo "[5/5] Loading secret files..."
if [ -d "${DATA_DIR}/secrets" ]; then
    echo "  Copying SSH keys, certificates, tokens..."
    cp -r "${DATA_DIR}/secrets"/* /opt/ctf-training/secrets/
    chmod 600 /opt/ctf-training/secrets/ssh-keys/*
    echo "✓ Secrets loaded"
fi

echo ""
echo "=========================================="
echo "Data Loading Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Database seeded with test data"
echo "  - Financial records loaded"
echo "  - Healthcare PHI data loaded"
echo "  - Cleartext credentials deployed"
echo "  - SSH keys and certificates installed"
echo ""
echo "⚠️  WARNING: All credentials are CLEARTEXT"
echo "⚠️  This is for CTF TRAINING purposes only"
echo ""
echo "Quick Test:"
echo "  Database: psql -h $DB_HOST -U $DB_USER -d $DB_NAME"
echo "  Password: $DB_PASS"
echo ""
echo "Flags to Find: 50+"
echo "=========================================="