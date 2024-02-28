Машук Григорий Владимирович :sunglasses:
<br /> Когорта: 10   
<br /> Группа: 3
<br /> Эпик: Профиль
<br /> Верстка: кодом
<br /> Архитектура: MVVM
<br /> [Ссылка на доску] (https://github.com/users/chrnivan/projects/1)

# Profile Flow Decomposition   

##** Module 1:

#### Верстка экрана профиля 
- Add icons in asset(est: 10 min; fact: 10 min)
- Image Edit(est: 30 min; fact: 40 min).
- Image User(est: 30 min; fact:45 min).
- Label FullName(est: 20 min; fact: 30 min).
- Description(est: 30 min; fact: 70 min).   
- Label Link(est: 20 min; fact: 40 min).
- Table (est: 40 min; fact: 60 min).
- Cells (est: 40 min; fact: 45 min).

#### Верстка модального окна редактирования профиля
- Image Exit(est: 20 min; fact: 20 min).
- Image User(est: 30 min; fact: 45 min).
- Label Name(est: 20 min; fact: 45 min).
- TextField FullName(est: 30 min; fact: 50 min).  
- Label Description(est: 20 min; fact: 60 min).
- TextView Description(est: 30 min; fact: 70 min).
- Label Site(est: 20 min; fact: 45 min).
- TextField Site(est: 30 min; fact: 45 min).

#### Запросы + логика
- Запросы на сервер для экрана профиля (est: 4h; fact: 4h).
- Запросы на сервер для модального окна EditProfile (est: 4 h; fact: 5h).
- Разработка ProfileViewModel + спомогательные классы (est: 14 h; fact: 12h).

`Total:` est: 24 h; fact: 33 h.

##** Module 2:

#### Верстка экран "Мои NFT"

- NavBar (est: 30 min; fact: 50 min).
- Table (est: 30 min; fact: 60 min).  
- Ячейка (est: 1 h; fact: 3 h).
- Label StubView (est: 30 min; fact: 20 min).
- Alert (est: 40 min; fact: 60 min).

#### Логика
- Сортировка по цене (est: 2 h; fact: 2 h).
- Сортировка по рейтнгу (est: 2 h; fact: 30 min).
- Сортировка по названию (est: 2 h; fact: 30 min).

#### Составление запросов
- Запрос на получение NFT (est: 3 h; fact: 6 h).
- Запрос на добавление лайков (est: 3 h; fact: 5 h).

`Total:` est: 12 h; fact: 20 h .

##** Module 3:

#### Экран "Избранные NFT"

- CollectionView (est: 2 h; fact:  2h).
- CollectionCell (est: 2 h; fact: 3h).
- Label Stub (est: 30 min; fact: 30min).                
                                                   
#### Составление запросов
- Запрос на получение избранных NFT (est: 4 h; fact: 40m) написан в предыдущем эпике.
- Запрос на лайки NFT (est: 4 h; fact: 40 min) написан в предыдущем эпике.

#### Верстка WebView
- Верстка (est: 60 min; fact: 60 min).

`Total:` est: 9h 30 min; fact: 7h 50 min.

