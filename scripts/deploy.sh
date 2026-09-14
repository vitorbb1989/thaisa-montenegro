#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" != "main" ]; then
  echo "FALHA: deploy só é permitido a partir da branch main (atual: $branch)" >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "FALHA: árvore de trabalho suja — commit ou descarte as alterações antes do deploy" >&2
  exit 1
fi

bash scripts/validate.sh

GIT_SHA="$(git rev-parse --short HEAD)"
IMAGE="thaisamontenegro-site:${GIT_SHA}"

echo "Build da imagem ${IMAGE}..."
docker build -t "${IMAGE}" .

echo "Deploy da stack thaisamontenegro com IMAGE_TAG=${GIT_SHA}..."
IMAGE_TAG="${GIT_SHA}" docker stack deploy \
  --resolve-image never \
  -c docker-stack.yml \
  thaisamontenegro

echo "Aguardando convergência do serviço..."
for i in $(seq 1 30); do
  running="$(docker service ls --filter name=thaisamontenegro_web --format '{{.Replicas}}')"
  echo "  thaisamontenegro_web: ${running}"
  if [ "$running" = "1/1" ]; then
    echo "Serviço convergiu (${running})."
    exit 0
  fi
  sleep 2
done

echo "AVISO: o serviço não confirmou 1/1 dentro do tempo esperado — verifique manualmente:" >&2
echo "  docker stack ps thaisamontenegro --no-trunc" >&2
exit 1
