#!/bin/bash
set -e

# SAS Token separado para que bash no lo rompa
SAS_TOKEN="se=2025-12-31&sp=racwdl&sv=2022-11-02&sr=c&sig=fwpM5rnfEpwm1/lwz0rtF26/4MNHydtQDG5R3lPuB/E%3D"
BASE_URL="https://sonarqubeprecredit.blob.core.windows.net/sonarqube?${SAS_TOKEN}"

echo "=== Descargando datos desde Azure Blob Storage ==="
azcopy sync "${BASE_URL}/data" /opt/sonarqube/data --recursive || echo "⚠️ No hay datos previos en Azure Blob"

chown -R sonarqube:sonarqube /opt/sonarqube/data /opt/sonarqube/extensions /opt/sonarqube/logs

function sync_to_azure {
  echo "🔄 Sincronizando datos de SonarQube a Azure Blob Storage..."
  azcopy sync /opt/sonarqube/data "${BASE_URL}/data" --recursive --delete-destination=true \
    || echo "⚠️ Error en sincronización"
}

trap sync_to_azure SIGTERM SIGINT

(
  while true; do
    sleep 300
    sync_to_azure
  done
) &

exec gosu sonarqube /opt/sonarqube/docker/entrypoint.sh
