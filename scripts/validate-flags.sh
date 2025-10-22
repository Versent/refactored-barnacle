#!/bin/bash

# CTF Training - Flag Validation Script
# Tests if all flags are accessible

echo "========================================"
echo "CTF Training Flag Validator"
echo "========================================"
echo ""

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Expected flags by category
declare -A EXPECTED_FLAGS=(
    ["database"]=15
    ["api_keys"]=20
    ["aws_credentials"]=10
    ["ssh_keys"]=5
    ["kubernetes"]=12
    ["docker"]=8
    ["config_files"]=18
)

TOTAL_EXPECTED=88
TOTAL_FOUND=0
PASSED=0
FAILED=0

echo "Validating flag accessibility..."
echo ""

# Test 1: Database credentials
echo "[TEST 1] Database Credentials"
FLAGS=$(grep -r "FLAG{.*database\|FLAG{.*db_\|FLAG{.*postgres\|FLAG{.*mysql" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[database]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[database]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 2: API Keys
echo "[TEST 2] API Keys"
FLAGS=$(grep -r "FLAG{.*api_key\|FLAG{.*stripe\|FLAG{.*sendgrid\|FLAG{.*github.*token" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[api_keys]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[api_keys]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 3: AWS Credentials
echo "[TEST 3] AWS Credentials"
FLAGS=$(grep -r "FLAG{.*aws\|FLAG{.*AKIA" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[aws_credentials]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[aws_credentials]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 4: SSH Keys
echo "[TEST 4] SSH Keys"
FLAGS=$(grep -r "FLAG{.*ssh\|FLAG{.*private_key" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[ssh_keys]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[ssh_keys]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 5: Kubernetes
echo "[TEST 5] Kubernetes Secrets"
FLAGS=$(grep -r "FLAG{.*k8s\|FLAG{.*kubernetes\|FLAG{.*configmap" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[kubernetes]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[kubernetes]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 6: Docker
echo "[TEST 6] Docker/Container Secrets"
FLAGS=$(grep -r "FLAG{.*docker\|FLAG{.*compose\|FLAG{.*container" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[docker]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[docker]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Test 7: Config Files
echo "[TEST 7] Configuration File Secrets"
FLAGS=$(grep -r "FLAG{.*config\|FLAG{.*yml\|FLAG{.*json\|FLAG{.*properties" . 2>/dev/null | wc -l)
echo "  Expected: ${EXPECTED_FLAGS[config_files]}"
echo "  Found: $FLAGS"
if [ "$FLAGS" -ge "${EXPECTED_FLAGS[config_files]}" ]; then
    echo "  ✓ PASS"
    ((PASSED++))
else
    echo "  ✗ FAIL"
    ((FAILED++))
fi
TOTAL_FOUND=$((TOTAL_FOUND + FLAGS))
echo ""

# Connection string validation
echo "[TEST 8] Database Connection Strings"
CONN_STRINGS=$(grep -r "postgresql://\|mysql://\|mongodb://" --include="*.yml" --include="*.txt" --include="*.env" . 2>/dev/null | grep -v ".git" | wc -l)
echo "  Found: $CONN_STRINGS connection strings"
if [ "$CONN_STRINGS" -ge 10 ]; then
    echo "  ✓ PASS - Sufficient connection strings found"
    ((PASSED++))
else
    echo "  ✗ FAIL - Not enough connection strings"
    ((FAILED++))
fi
echo ""

# Credential validation
echo "[TEST 9] Cleartext Credentials"
PASSWORDS=$(grep -r "password.*:" --include="*.yml" --include="*.yaml" --include="*.txt" . 2>/dev/null | grep -v ".git" | wc -l)
echo "  Found: $PASSWORDS cleartext passwords"
if [ "$PASSWORDS" -ge 15 ]; then
    echo "  ✓ PASS - Sufficient cleartext passwords"
    ((PASSED++))
else
    echo "  ✗ FAIL - Not enough cleartext passwords"
    ((FAILED++))
fi
echo ""

# Summary
echo "========================================"
echo "Validation Summary"
echo "========================================"
echo "Total Flags Expected: $TOTAL_EXPECTED"
echo "Total Flags Found: $TOTAL_FOUND"
echo ""
echo "Tests Passed: $PASSED"
echo "Tests Failed: $FAILED"
echo ""

if [ "$TOTAL_FOUND" -ge "$TOTAL_EXPECTED" ] && [ "$FAILED" -eq 0 ]; then
    echo "✓ ALL TESTS PASSED"
    echo "CTF training environment is properly configured!"
    exit 0
else
    echo "✗ SOME TESTS FAILED"
    echo "Please review the configuration"
    exit 1
fi