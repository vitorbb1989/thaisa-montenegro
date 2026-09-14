#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

TAG="${1:-}"
if [ -z "$TAG" ]; then
  echo "Uso: bash scripts/rollback.sh <TAG_ANTERIOR>" >&2
  echo "A tag deve ser o short SHA de um commit cuja imagem já foi buildada e testada." >&2
  exit 1
fi

IMAGE="thaisamontenegro-site:${TAG}"

if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
  echo "FALHA: imagem ${IMAGE} não encontrada localmente. Buildar novamente a partir do commit ${TAG} antes de tentar o rollback." >&2
  exit 1
fi

echo "Revertendo thaisamontenegro_web para ${IMAGE}..."
IMAGE_TAG="${TAG}" docker stack deploy \
  --resolve-image never \
  -c docker-stack.yml \
  thaisamontenegro

echo "Rollback solicitado. Acompanhe com:"
echo "  docker stack ps thaisamontenegro --no-trunc"
