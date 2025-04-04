# EasyBuy

**EasyBuy** — это iOS-приложение, позволяющее пользователям искать товары, применять фильтры (по категории, ценовому диапазону и сортировке), просматривать детальную информацию о товарах и добавлять их в корзину с возможностью управления (изменение количества, удаление, очистка и т. д.). Данные о корзине и последних поисковых запросах сохраняются между сессиями (через `UserDefaults`).

https://github.com/user-attachments/assets/02979835-28b5-4831-b9ee-5fa24728ecb8


## Возможности

- **Поиск товаров**  
  - Экран поиска с фильтрами и сохранением последних 5 поисковых запросов.  
  - Постраничная выдача (пагинация) и поиск по названию товара.
  - Приложеник использует API [Fake API](https://fakeapi.platzi.com/).
  
  <img src="https://github.com/user-attachments/assets/816c17ad-3ba8-47e8-b667-a79787518ac1" alt="Simulator Screenshot" width="232">

- **Фильтрация**  
  - Фильтры по категории (`Clothes`, `Electronics`, `Furniture`, `Shoes`, `Miscellaneous`), ценовому диапазону (`From / To`) и сортировке (`Price: Low to High`, `Price: High to Low`).  
  - Открытие экрана фильтров в виде нижнего листа (Bottom Sheet).
  <img src="https://github.com/user-attachments/assets/971ad99f-1770-4d71-8002-822a14f47b21" alt="Simulator Screenshot" width="232">

- **Детальная карточка товара**  
  - Отображение изображения (с загрузкой через URL), заголовка, описания, цены и категории.  
  - Если загрузка изображения не удалась, показывается placeholder.  
  - Кнопка «Поделиться» (Share) для отправки текстовой информации о товаре.
  - Кнопка «Купить» (Buy), добавляющая товар в корзину (с выводом подтверждающего сообщения).

  <img src="https://github.com/user-attachments/assets/08c8c4b3-f8e9-4c85-ad50-e0efe2c67160" alt="Simulator Screenshot" width="232">

- **Корзина**  
  - Экран корзины, где пользователь может управлять списком добавленных товаров: изменять количество, удалять и очищать корзину.  
  - Состояние корзины сохраняется в `UserDefaults` и восстанавливается при повторном запуске приложения.  
  - Кнопка  «Поделиться» (Share) для отправки списка товаров из корзины.
    
   <img src="https://github.com/user-attachments/assets/b7fe2b96-17c2-4df7-b27f-fcf9be2aa5a3" alt="Simulator Screenshot" width="232">

  ## Проблемы, с которыми я столкнулась
  
  - **Некоторые изображения**  
  При загрузке товаров некоторые URL могут оказаться нерабочими или недоступными. В таких случаях отображается placeholder.

  - **Цена и фильтрация**  
  Используемый API может возвращать товары с ценами, выходящими за указанный диапазон, реализация на стороне сервера некорректна. Например, при запросе `GET https://api.escuelajs.co/api/v1/products/?price_min=0&price_max=100` могут возвращаться товары дороже 100. Протестировала с использованием Postman (см. ниже). 
  <img width="780" alt="Снимок экрана 2025-02-15 в 17 44 54" src="https://github.com/user-attachments/assets/27f1cc88-5bc7-4040-8281-cc76a3657666" />

  ## Структура проекта
  Проект имеет следующую структуру (папки и основные файлы):

  ```
  EasyBuy
  ├── EasyBuy                // Каталог с файлами проекта: LaunchScreen.storyboard, Info.plist
  ├── App                    // Основные файлы приложения (AppDelegate, SceneDelegate)
  ├── Model                  // Модели данных (Product, APIClient, CartManager)
  ├── View                   // Кастомные UI-компоненты (ProductCell, CartItemCell)
  ├── Controller             // Контроллеры (SearchVC, FiltersVC, ProductDetailVC, CartVC)
  └── Resources              // Ресурсы (Assets.xcassets)
  ```

  ## Установка и запуск
  
1. **Клонируйте репозиторий**:

   ```bash
   git clone https://github.com/mrussa/EasyBuy.git
   cd EasyBuy
     ```

2. **Откройте проект в Xcode**:

  - Откройте файл `EasyBuy.xcodeproj`.

3. **Установите зависимости**:

  - Приложение использует [SnapKit](https://github.com/SnapKit/SnapKit) для верстки через код.
  - Убедитесь, что SnapKit добавлен через Swift Package Manager, CocoaPods или Carthage.

4. **Соберите и запустите**::

  - Выберите целевое устройство или симулятор в Xcode.
  - Нажмите **Run** (⌘R).

