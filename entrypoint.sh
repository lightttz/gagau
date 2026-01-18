#!/bin/bash

# 1. Iniciar o AppHub em background
if [ -f "./gaga_files/apphub" ]; then
    chmod +x ./gaga_files/apphub
    ./gaga_files/apphub &
    APPHUB_PID=$!
    echo "--- AppHub iniciado. Monitorando download do binário... ---"
else
    echo "ERRO: AppHub não encontrado!"
    exit 1
fi

# 2. Aguarda o binário 'gaganode' aparecer (ele é baixado pelo AppHub)
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    GAGA_PATH=$(find . -type f -name gaganode | head -n 1)
    if [ -n "$GAGA_PATH" ]; then
        echo "✅ Binário gaganode detectado!"
        break
    fi
    echo "⏳ Aguardando binário ($((COUNT * 5))s)..."
    sleep 5
    COUNT=$((COUNT + 1))
done

# 3. Configura o Token e Reinicia
if [ -n "$GAGA_PATH" ]; then
    chmod +x "$GAGA_PATH"
    "$GAGA_PATH" config set --token=$GAGA_TOKEN
    echo "Token injetado. Reiniciando para validar..."
    kill $APPHUB_PID
    sleep 3
    ./gaga_files/apphub
else
    echo "❌ Erro: O binário não apareceu a tempo."
    exit 1
fi
