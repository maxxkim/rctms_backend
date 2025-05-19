# RCTMS Backend (Realtime Collaborative Task Management System)

[![Elixir](https://img.shields.io/badge/Elixir-1.15%2B-6B39BD)](https://elixir-lang.org/)
[![Phoenix](https://img.shields.io/badge/Phoenix-1.7%2B-FD4F00)](https://www.phoenixframework.org/)
[![Absinthe](https://img.shields.io/badge/Absinthe-1.7-AB2B28)](https://absinthe-graphql.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Latest-336791)](https://www.postgresql.org/)

Бэкенд-сервер для системы управления задачами в реальном времени с коллаборативными функциями. Построен с использованием Elixir, Phoenix Framework и GraphQL.

## 🔗 Связанные проекты

- [RCTMS Mobile App]([https://github.com/your-username/rctms-mobile](https://github.com/maxxkim/rctms_app)) - Flutter мобильный клиент для данного бэкенда

## 📖 Обзор проекта

RCTMS — это современная система управления задачами и проектами, разработанная для демонстрации всех сильных сторон экосистемы Elixir/Phoenix: высокой конкурентности, устойчивости к сбоям, эффективной обработки в реальном времени и масштабируемой архитектуры.

Ключевые особенности архитектуры:
- **Context-driven дизайн** - четкое разделение бизнес-логики по доменам
- **Функциональный подход** - использование неизменяемых структур данных и предсказуемой функциональной логики
- **CQRS элементы** - разделение операций чтения и записи для оптимальной производительности
- **Эффективные WebSockets** - поддержка тысяч одновременных соединений благодаря легковесным процессам Erlang
- **Встроенная отказоустойчивость** - использование механизмов супервизии Erlang OTP для создания самовосстанавливающихся систем

## 🚀 Возможности

- **Полный GraphQL API** - Современный и гибкий доступ к данным с Absinthe
- **Реальное время с Phoenix Channels** - Мгновенные обновления с использованием WebSockets для совместной работы
- **Аутентификация с Guardian** - Безопасная JWT-аутентификация с гибкими политиками доступа
- **Комплексное управление проектами и задачами** - Создание, редактирование, назначение и отслеживание задач
- **Управление пользователями** - Регистрация, аутентификация и авторизация
- **Совместная работа** - Функции присутствия, комментирования и совместной работы в реальном времени
- **Отказоустойчивая архитектура** - Устойчивость к сбоям благодаря супервизорам Erlang OTP
- **Высокая производительность** - Оптимизировано для обработки высоких нагрузок благодаря BEAM VM

## 📋 Требования

- Elixir 1.15 или выше
- Erlang OTP 26 или выше
- Phoenix 1.7 или выше
- PostgreSQL 12 или выше
- NodeJS 18+ (для сборки активов Phoenix)

## 🛠️ Установка и настройка

### Начальная установка

1. **Клонируйте репозиторий:**
   ```bash
   git clone https://github.com/your-username/rctms-backend.git
   cd rctms-backend
   ```

2. **Установите зависимости Elixir:**
   ```bash
   mix deps.get
   ```

3. **Установите Node.js зависимости:**
   ```bash
   cd assets && npm install && cd ..
   ```

4. **Создайте файл конфигурации базы данных:**
   
   Скопируйте пример конфигурации и настройте его:
   ```bash
   cp config/dev.exs.example config/dev.exs
   cp config/test.exs.example config/test.exs
   ```
   
   Отредактируйте `config/dev.exs` и `config/test.exs` в соответствии с вашими настройками базы данных.

### Настройка базы данных

1. **Настройте доступ к базе данных** (в `config/dev.exs`):
   ```elixir
   config :rctms, RCTMS.Repo,
     username: "postgres",
     password: "postgres", 
     hostname: "localhost",
     database: "rctms_dev",
     show_sensitive_data_on_connection_error: true,
     pool_size: 10
   ```

2. **Создайте и настройте базу данных:**
   ```bash
   mix ecto.create
   mix ecto.migrate
   mix run priv/repo/seeds.exs
   ```

### Генерация секретного ключа для Guardian

1. **Сгенерируйте секретный ключ для JWT токенов:**
   ```bash
   mix guardian.gen.secret
   ```

2. **Добавьте сгенерированный ключ в `config/config.exs`:**
   ```elixir
   config :rctms, RCTMS.Accounts.Guardian,
     issuer: "rctms",
     secret_key: "СГЕНЕРИРОВАННЫЙ_СЕКРЕТНЫЙ_КЛЮЧ"
   ```

### Запуск сервера

1. **Запустите сервер Phoenix:**
   ```bash
   mix phx.server
   ```

2. **Или запустите сервер с интерактивной консолью Elixir:**
   ```bash
   iex -S mix phx.server
   ```

После запуска, сервер будет доступен по адресу [http://localhost:4000](http://localhost:4000). GraphiQL интерфейс для работы с GraphQL API доступен по адресу [http://localhost:4000/api/graphiql](http://localhost:4000/api/graphiql) (только в режиме разработки).

## 📂 Структура проекта

```
lib/
├── rctms/                       # Бизнес-логика, модели, контексты
│   ├── accounts/                # Пользователи, аутентификация
│   │   ├── user.ex              # Модель пользователя
│   │   ├── guardian.ex          # Конфигурация Guardian для JWT
│   │   ├── error_handler.ex     # Обработчик ошибок аутентификации
│   │   └── pipeline.ex          # Конвейер аутентификации
│   ├── projects/                # Управление проектами
│   │   └── project.ex           # Модель проекта
│   ├── tasks/                   # Управление задачами
│   │   └── task.ex              # Модель задачи
│   ├── collaboration/           # Комментарии, совместная работа
│   │   └── comment.ex           # Модель комментария
│   ├── application.ex           # Определение приложения OTP
│   └── repo.ex                  # Репозиторий Ecto
├── rctms_web/                   # Веб-слой (контроллеры, шаблоны)
│   ├── channels/                # Каналы Phoenix для WebSockets
│   │   ├── presence.ex          # Модуль присутствия
│   │   ├── project_channel.ex   # Канал для проектов
│   │   └── user_socket.ex       # Конфигурация сокета
│   ├── schema/                  # GraphQL схема (Absinthe)
│   │   ├── resolvers/           # GraphQL резолверы
│   │   ├── types/               # GraphQL типы
│   │   └── schema.ex            # Основная схема GraphQL
│   ├── endpoint.ex              # Конфигурация Phoenix endpoint
│   └── router.ex                # Маршрутизация
├── mix.exs                      # Конфигурация проекта
├── config/                      # Файлы конфигурации
├── priv/                        # Ресурсы проекта
│   ├── repo/                    # Миграции и сиды базы данных
│   │   ├── migrations/          # Миграции Ecto
│   │   └── seeds.exs            # Начальные данные
│   └── static/                  # Статические файлы
└── test/                        # Тесты
```

## 📡 GraphQL API

Эндпоинт GraphQL: `/api/graphql`

RCTMS предоставляет мощный GraphQL API для гибкого доступа к данным. Вот несколько примеров запросов:

### Аутентификация

```graphql
# Регистрация пользователя
mutation Register($input: UserRegistrationInput!) {
  register(input: $input) {
    token
    user {
      id
      email
      username
    }
  }
}

# Вход пользователя
mutation Login($input: UserLoginInput!) {
  login(input: $input) {
    token
    user {
      id
      email
      username
    }
  }
}
```

### Запросы данных

```graphql
# Получение текущего пользователя
query Me {
  me {
    id
    email
    username
  }
}

# Получение списка проектов
query Projects {
  projects {
    id
    name
    description
    owner {
      id
      username
    }
    tasks {
      id
      title
      status
    }
  }
}

# Получение задач с фильтрацией
query ProjectTasks($projectId: ID!) {
  projectTasks(projectId: $projectId) {
    id
    title
    description
    status
    priority
    dueDate
    assignee {
      id
      username
    }
  }
}

# Получение задачи с комментариями
query Task($id: ID!) {
  task(id: $id) {
    id
    title
    description
    status
    priority
    dueDate
    project {
      id
      name
    }
    assignee {
      id
      username
    }
    creator {
      id
      username
    }
    comments {
      id
      content
      user {
        id
        username
      }
      insertedAt
    }
  }
}
```

### Мутации

```graphql
# Создание проекта
mutation CreateProject($input: ProjectInput!) {
  createProject(input: $input) {
    id
    name
    description
  }
}

# Создание задачи
mutation CreateTask($input: TaskInput!) {
  createTask(input: $input) {
    id
    title
    status
    priority
    project {
      id
      name
    }
  }
}

# Добавление комментария
mutation CreateComment($input: CommentInput!) {
  createComment(input: $input) {
    id
    content
    user {
      id
      username
    }
    insertedAt
  }
}
```

### Подписки

```graphql
# Подписка на обновления задачи
subscription TaskUpdated($id: ID!) {
  taskUpdated(id: $id) {
    id
    title
    status
    priority
    updatedAt
  }
}

# Подписка на новые комментарии к задаче
subscription CommentAdded($taskId: ID!) {
  commentAdded(taskId: $taskId) {
    id
    content
    user {
      id
      username
    }
    insertedAt
  }
}
```

Полная документация по схеме GraphQL доступна через GraphiQL интерфейс: [http://localhost:4000/api/graphiql](http://localhost:4000/api/graphiql)

### WebSocket Каналы

RCTMS использует Phoenix Channels для обеспечения обновлений в реальном времени. Основные каналы:

- `project:{project_id}` - Обновления связанные с проектом
- `task:{task_id}` - Обновления связанные с задачей

#### События проектного канала

- `task_created` - Создана новая задача
- `task_updated` - Задача обновлена
- `project_updated` - Проект обновлен

#### События канала задачи

- `comment_added` - Добавлен новый комментарий
- `task_updated` - Задача обновлена
- `task_assigned` - Задача переназначена

#### Пример подключения к каналу (JavaScript)

```javascript
import {Socket} from "phoenix"

// Инициализация Socket с токеном
const socket = new Socket("/socket", {
  params: {token: "YOUR_JWT_TOKEN"}
})
socket.connect()

// Подключение к каналу проекта
const projectChannel = socket.channel(`project:${projectId}`, {})
projectChannel.join()
  .receive("ok", resp => console.log("Joined project channel!", resp))
  .receive("error", resp => console.log("Unable to join", resp))

// Прослушивание событий
projectChannel.on("task_created", task => {
  console.log("New task created:", task)
})

// Отправка событий
projectChannel.push("new_task", {
  title: "Новая задача",
  description: "Описание задачи",
  status: "pending",
  priority: "medium"
})
```

## 🔐 Безопасность и аутентификация

RCTMS использует JWT (JSON Web Tokens) для аутентификации, реализованной с помощью библиотеки Guardian. Токены должны быть включены в заголовок `Authorization` для GraphQL запросов:

```
Authorization: Bearer YOUR_JWT_TOKEN
```

### Авторизация в GraphQL

В GraphQL авторизация происходит на уровне резолверов:

```elixir
def get_project(%{id: id}, %{context: %{current_user: current_user}}) do
  project = Projects.get_project(id)

  cond do
    is_nil(project) ->
      {:error, "Project not found"}
    project.owner_id == current_user.id ->
      {:ok, project}
    true ->
      {:error, "Not authorized to access this project"}
  end
end
```

## 🧪 Тестирование

RCTMS включает в себя комплексный набор тестов для обеспечения надежности кода.

### Запуск тестов

```bash
# Запуск всех тестов
mix test

# Запуск тестов с отчётом о покрытии
mix test --cover

# Запуск только определенного теста
mix test test/rctms_web/schema/query_testy.exs

# Запуск только тестов с определенным тегом
mix test --only integration
```

### Структура тестов

```
test/
├── rctms/                   # Тесты бизнес-логики
│   ├── accounts_test.exs    # Тесты контекста accounts
│   ├── projects_test.exs    # Тесты контекста projects
│   └── tasks_test.exs       # Тесты контекста tasks
├── rctms_web/               # Тесты веб-слоя
│   ├── channels/            # Тесты каналов
│   └── schema/              # Тесты GraphQL API
├── support/                 # Вспомогательный код для тестов
│   ├── conn_case.ex         # Модуль для тестирования контроллеров
│   └── data_case.ex         # Модуль для тестирования контекстов и моделей
└── test_helper.exs          # Настройка тестового окружения
```

## 📊 Мониторинг и производительность

RCTMS включает встроенные инструменты мониторинга и оптимизации производительности.

### Phoenix LiveDashboard

В режиме разработки доступен LiveDashboard по адресу [http://localhost:4000/dashboard](http://localhost:4000/dashboard), предоставляющий:
- Мониторинг процессов
- Метрики производительности
- Статистику сокетов и каналов Phoenix
- Метрики базы данных

### Телеметрия

RCTMS настроен для сбора и экспорта телеметрии. Метрики можно найти в `lib/rctms_web/telemetry.ex`.

## 🚢 Развертывание

### Подготовка к продакшну

1. **Создайте секретный ключ для продакшна:**
   ```bash
   mix phx.gen.secret
   ```

2. **Настройте переменные окружения:**
   ```
   SECRET_KEY_BASE=your_generated_secret
   DATABASE_URL=postgres://username:password@hostname/database
   POOL_SIZE=10
   PHX_HOST=your-app-domain.com
   PORT=4000
   ```

### Создание релиза

1. **Создание релиза:**
   ```bash
   MIX_ENV=prod mix release
   ```

2. **Запуск миграций в продакшне:**
   ```bash
   _build/prod/rel/rctms/bin/rctms eval "RCTMS.Release.migrate"
   ```

3. **Запуск сервера:**
   ```bash
   _build/prod/rel/rctms/bin/server
   ```

### Docker

Проект включает Dockerfile для удобного развертывания:

```bash
# Создание Docker образа
docker build -t rctms-backend .

# Запуск контейнера
docker run -p 4000:4000 --env-file .env.prod rctms-backend
```

### Проверка работоспособности

После развертывания убедитесь, что GraphQL API доступен:

```bash
curl -X POST https://your-app-domain.com/api/graphql -H "Content-Type: application/json" -d '{"query": "{ __typename }"}'
```

## 🧩 Разработка и вклад в проект

### Руководство по стилю кода

RCTMS следует стандартным соглашениям по стилю кода Elixir:

- Используйте `mix format` перед каждым коммитом
- Используйте инструмент `credo` для анализа кода: `mix credo`
- Документируйте публичные функции с помощью `@doc` и `@spec`

### Рабочий процесс для внесения вклада

1. Форкните репозиторий на GitHub
2. Создайте ветку для вашей функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте изменения в свой форк (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

### Полезные команды для разработки

```bash
# Создание новой миграции
mix ecto.gen.migration add_some_field_to_some_table

# Сбросить базу данных (осторожно в продакшне!)
mix ecto.reset

# Создание нового контекста с генератором Phoenix
mix phx.gen.context Projects Project projects name:string description:text owner_id:references:users

# Форматирование кода
mix format

# Проверка кода инструментом credo
mix credo

# Создание документации
mix docs
```

## ❓ FAQ

### Как настроить CORS?
Настройте CORS в файле `lib/rctms_web/endpoint.ex`. По умолчанию CORS настроен для локальной разработки, но для продакшна вам нужно будет указать домены, с которых вы хотите разрешить запросы.

### Какую базу данных использовать?
По умолчанию RCTMS использует PostgreSQL, но вы можете использовать любую базу данных, поддерживаемую Ecto. Для смены базы данных необходимо изменить конфигурацию в `config/dev.exs` и `config/prod.exs`.

### Как настроить отправку email?
RCTMS включает интеграцию с Swoosh для отправки email. Настройки для различных адаптеров (SMTP, Mailgun, SendGrid и т.д.) можно найти в `config/config.exs` и `config/runtime.exs`.

### Как мне расширить схему GraphQL?
Добавляйте новые типы в директорию `lib/rctms_web/schema/types/` и обновляйте основную схему в `lib/rctms_web/schema/schema.ex`. Не забудьте создать резолверы в директории `lib/rctms_web/schema/resolvers/`.

### Как добавить новые миграции?
```bash
mix ecto.gen.migration название_миграции
```
Затем отредактируйте сгенерированный файл миграции в директории `priv/repo/migrations/`.

## 🛣️ Дорожная карта

- [x] Аутентификация и авторизация 
- [x] GraphQL API
- [x] Каналы реального времени
- [ ] Продвинутая система уведомлений
- [ ] Система тегов и меток для задач
- [ ] Полнотекстовый поиск
- [ ] Историю изменений задач
- [ ] Совместное редактирование задач
- [ ] Интеграции со сторонними сервисами
- [ ] Шаблоны задач
- [ ] Продвинутая статистика и отчёты
- [ ] Экспорт/импорт данных

## 📄 Лицензия

Этот проект лицензирован под [MIT License](LICENSE).

## 👥 Контакты и поддержка

- Создайте Issue в репозитории для сообщения о проблеме или запроса функций
- Присоединяйтесь к дискуссии в нашем канале Slack или Discord (TODO: добавить ссылки)
- Свяжитесь с командой разработчиков по email: [your-email@example.com](mailto:your-email@example.com)
