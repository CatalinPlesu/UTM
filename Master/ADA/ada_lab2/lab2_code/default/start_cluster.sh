#!/bin/bash
# sudo rm -R rabbitmq
# Rebuild container will trigger error for rabbitmq container because rabbbitmq-data cannot be removed
# docker compose up -d --remove-orphans #--build  
docker compose up -d --remove-orphans
# docker-compose exec lab2_producer /bin/bash
# docker-compose exec lab2_consumer /bin/bash