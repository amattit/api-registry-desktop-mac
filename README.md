# API Registry Desktop для macOS

Настольное приложение для управления API Registry на macOS, созданное с использованием SwiftUI.

## Функциональность

### ✅ Реализованные функции

1. **Дашборд (главный экран)**
   - Статистика сервисов (всего, активных, эндпоинтов, устаревших)
   - Быстрые действия (создание сервиса, просмотр всех сервисов, зависимости, базы данных)
   - Список последних сервисов
   - Обновление данных по pull-to-refresh

2. **Создание сервиса**
   - Форма с валидацией полей
   - Поддержка всех типов сервисов (APPLICATION, LIBRARY, JOB, PROXY)
   - Добавление тегов
   - Настройка опций (поддержка БД, прокси)
   - Рекомендации по созданию сервиса

3. **Редактирование сервиса**
   - Редактирование всех полей сервиса
   - Отображение информации о сервисе (ID, дата создания)
   - Удаление сервиса с подтверждением
   - Валидация изменений

4. **Список сервисов**
   - Поиск по названию, владельцу и тегам
   - Отображение типа сервиса и статуса
   - Клик для редактирования

## Требования

- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+
- Сервер API Registry, запущенный на `localhost:8080`

## Установка и запуск

### 1. Настройка проекта

1. Откройте `api-registry-descktop.xcodeproj` в Xcode
2. Добавьте новые файлы в проект:
   - `Models/ServiceModels.swift`
   - `Services/APIService.swift`
   - `ViewModels/ServiceViewModel.swift`
   - `Views/CreateServiceView.swift`
   - `Views/EditServiceView.swift`
   - `Views/Components/DashboardComponents.swift`

### 2. Настройка зависимостей

Проект использует пакет `Networking` для работы с API. Убедитесь, что он добавлен в проект.

### 3. Запуск сервера

Убедитесь, что сервер API Registry запущен на `http://localhost:8080`.

### 4. Сборка и запуск

1. Выберите схему `api-registry-descktop`
2. Нажмите `Cmd+R` для запуска приложения

## Структура проекта

```
api-registry-descktop/
├── Models/
│   └── ServiceModels.swift          # Модели данных
├── Services/
│   └── APIService.swift             # API клиент
├── ViewModels/
│   └── ServiceViewModel.swift       # ViewModel для управления состоянием
├── Views/
│   ├── DashboardView.swift          # Главный экран
│   ├── CreateServiceView.swift      # Создание сервиса
│   ├── EditServiceView.swift        # Редактирование сервиса
│   └── Components/
│       └── DashboardComponents.swift # UI компоненты
├── ContentView.swift                # Главный контейнер с табами
└── api_registry_descktopApp.swift   # Точка входа приложения
```

## API Endpoints

Приложение использует следующие API endpoints:

- `GET /services` - получение списка сервисов
- `GET /services/{id}` - получение сервиса по ID
- `POST /services` - создание нового сервиса
- `PATCH /services/{id}` - обновление сервиса
- `DELETE /services/{id}` - удаление сервиса

## Модели данных

### ServiceResponse
```swift
struct ServiceResponse {
    let serviceId: UUID
    let name: String
    let description: String?
    let owner: String
    let tags: [String]
    let serviceType: ServiceType
    let supportsDatabase: Bool
    let proxy: Bool
    let createdAt: Date?
    let updatedAt: Date?
    let environments: [ServiceEnvironmentResponse]?
}
```

### ServiceType
```swift
enum ServiceType: String, CaseIterable {
    case APPLICATION = "APPLICATION"
    case LIBRARY = "LIBRARY"
    case JOB = "JOB"
    case PROXY = "PROXY"
}
```

## Особенности реализации

1. **Архитектура MVVM** - использование ObservableObject для управления состоянием
2. **Async/Await** - современный подход к асинхронному программированию
3. **SwiftUI** - декларативный UI фреймворк
4. **Валидация форм** - проверка данных на клиенте
5. **Обработка ошибок** - отображение ошибок пользователю
6. **Поиск и фильтрация** - поиск сервисов по различным критериям

## Возможные улучшения

1. Добавление управления окружениями сервисов
2. Просмотр и управление зависимостями
3. Управление базами данных
4. Генерация OpenAPI спецификаций
5. Экспорт данных
6. Настройки приложения
7. Темная тема
8. Локализация

## Troubleshooting

### Проблемы с подключением к серверу

1. Убедитесь, что сервер запущен на `localhost:8080`
2. Проверьте, что сервер отвечает на запросы: `curl http://localhost:8080/services`
3. Убедитесь, что нет блокировки файрвола

### Ошибки сборки

1. Убедитесь, что все новые файлы добавлены в проект Xcode
2. Проверьте, что пакет `Networking` корректно подключен
3. Очистите кэш сборки: `Product > Clean Build Folder`

## Лицензия

Этот проект создан для демонстрационных целей.