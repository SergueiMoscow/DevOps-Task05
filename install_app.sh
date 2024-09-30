#!/bin/bash

# Переменные
REPO_URL="https://github.com/SergueiMoscow/netology-devops-example-python.git"
CLONE_DIR="/opt/netology-devops-example-python"

# Проверка, запущен ли скрипт с привилегиями root
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен с правами root" 
   exit 1
fi

# Установка Docker и Docker Compose, если они еще не установлены (для Ubuntu)
if ! command -v docker &> /dev/null; then
    echo "Docker не установлен. Установка Docker..."
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Запустить и включить Docker демон
echo "Запуск и включение Docker демона..."
systemctl start docker
systemctl enable docker

# Убедиться, что Docker демон запущен
if ! systemctl is-active --quiet docker; then
    echo "Docker демон не удалось запустить. Проверьте установку Docker."
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "Docker Compose Plugin не установлен. Установка Docker Compose Plugin..."
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.0.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
fi

# Скачивание репозитория в /opt
if [[ -d $CLONE_DIR ]]; then
    echo "Каталог $CLONE_DIR уже существует. Обновление репозитория..."
    cd $CLONE_DIR
    git pull
else
    echo "Клонирование репозитория в $CLONE_DIR..."
    git clone $REPO_URL $CLONE_DIR
fi

# Переход в каталог с репозиторием
cd $CLONE_DIR

# Запуск проекта с помощью Docker Stack
echo "Запуск проекта с помощью Docker Stack..."
docker stack deploy -c compose-swarm.yaml python_app
