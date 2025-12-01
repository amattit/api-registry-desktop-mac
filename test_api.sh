#!/bin/bash

# Скрипт для тестирования API Registry сервера

API_BASE_URL="http://localhost:8080"

echo "🧪 Тестирование API Registry сервера..."
echo "📍 URL: $API_BASE_URL"
echo ""

# Проверка доступности сервера
echo "1. Проверка доступности сервера..."
if curl -s --connect-timeout 5 "$API_BASE_URL/services" > /dev/null; then
    echo "✅ Сервер доступен"
else
    echo "❌ Сервер недоступен. Убедитесь, что сервер запущен на $API_BASE_URL"
    exit 1
fi

# Получение списка сервисов
echo ""
echo "2. Получение списка сервисов..."
SERVICES_RESPONSE=$(curl -s "$API_BASE_URL/services")
SERVICES_COUNT=$(echo "$SERVICES_RESPONSE" | jq '. | length' 2>/dev/null || echo "0")
echo "📊 Найдено сервисов: $SERVICES_COUNT"

if [ "$SERVICES_COUNT" -gt 0 ]; then
    echo "📋 Первые 3 сервиса:"
    echo "$SERVICES_RESPONSE" | jq '.[0:3] | .[] | {name: .name, owner: .owner, serviceType: .serviceType}' 2>/dev/null || echo "Не удалось распарсить JSON"
fi

# Тестирование создания сервиса
echo ""
echo "3. Тестирование создания сервиса..."
TEST_SERVICE_NAME="test-service-$(date +%s)"
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE_URL/services" \
    -H "Content-Type: application/json" \
    -d "{
        \"name\": \"$TEST_SERVICE_NAME\",
        \"description\": \"Тестовый сервис для проверки API\",
        \"owner\": \"test-team\",
        \"tags\": [\"test\", \"api\"],
        \"serviceType\": \"APPLICATION\",
        \"supportsDatabase\": false,
        \"proxy\": false
    }")

if echo "$CREATE_RESPONSE" | jq -e '.serviceId' > /dev/null 2>&1; then
    echo "✅ Сервис успешно создан"
    SERVICE_ID=$(echo "$CREATE_RESPONSE" | jq -r '.serviceId')
    echo "🆔 ID сервиса: $SERVICE_ID"
    
    # Тестирование обновления сервиса
    echo ""
    echo "4. Тестирование обновления сервиса..."
    UPDATE_RESPONSE=$(curl -s -X PATCH "$API_BASE_URL/services/$SERVICE_ID" \
        -H "Content-Type: application/json" \
        -d "{
            \"description\": \"Обновленное описание тестового сервиса\"
        }")
    
    if echo "$UPDATE_RESPONSE" | jq -e '.serviceId' > /dev/null 2>&1; then
        echo "✅ Сервис успешно обновлен"
    else
        echo "❌ Ошибка обновления сервиса"
    fi
    
    # Тестирование удаления сервиса
    echo ""
    echo "5. Тестирование удаления сервиса..."
    DELETE_RESPONSE=$(curl -s -w "%{http_code}" -X DELETE "$API_BASE_URL/services/$SERVICE_ID")
    
    if [ "$DELETE_RESPONSE" = "204" ]; then
        echo "✅ Сервис успешно удален"
    else
        echo "❌ Ошибка удаления сервиса (код: $DELETE_RESPONSE)"
    fi
else
    echo "❌ Ошибка создания сервиса"
    echo "📄 Ответ сервера: $CREATE_RESPONSE"
fi

echo ""
echo "🎉 Тестирование завершено!"
echo ""
echo "💡 Если все тесты прошли успешно, вы можете запускать macOS приложение."
echo "💡 Если есть ошибки, проверьте настройки сервера API Registry."