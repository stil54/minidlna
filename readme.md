docker build -t minidlna .

docker run -d --name minidlna \
    --net=host \
    -p 8200:8200 \
    -p 1900:1900/udp \
    -v /mnt/minidlna/music:/var/lib/minidlna/music \
    -v /mnt/minidlna/videos:/var/lib/minidlna/videos \
    -v /home/user/minidlna/minidlna.conf:/etc/minidlna.conf:ro \
    minidlna


# Порт сервера
port=8200

# Сетевой интерфейс
# Можно задать несколько интерфейсов
# в формате network_interface=eth0,eth1
#network_interface=eth0

# Имя пользователя или UID, под которым будет работать служба
# Добавлен в версии 1.1.0
# В Debian задается в параметрах init-скрипта
#user=jmaggard

# Путь к папке с медиа-файлами
# Для сканирования нескольких папок, укажите несколько параметров media_dir
# Чтобы сканировать файлы определенного типа, укажите соответствующий префикс:
#   A - аудио: media_dir=A,/home/jmaggard/Music
#   V - видео: media_dir=V,/home/jmaggard/Videos
#   P - изображения: media_dir=P,/home/jmaggard/Pictures
# Начиная с версии 1.1.0, можно задать несколько типов:
#   PV - изображения и видео: media_dir=AV,/var/lib/minidlna/digital_camera
#
# При изменении параметра, потребуется повторное сканирование файлов.
# Необходимо выполнить команду "service minidlna force-reload" от имени root [подробнее].
# Начиная с версии 1.1.0, при изменении параметра, сканирование выполняется автоматически.
media_dir=/var/lib/minidlna

# Объединять корневые папки
# Параметр добавлен в версии 1.1.3
# Включаем, чтобы избавиться от лишнего уровня вложенности
# Расположение видео файлов при значении "no": Video/Folders/Video, при значении "yes": Video/Folders
# При изменении параметра, потребуется повторное сканирование файлов.
merge_media_dirs=yes

# Имя DLNA-сервера, отображаемое клиентом
# По умолчанию: "$HOSTNAME:$USER"
#friendly_name=

# Путь к папке для хранения базы данных и кэша обложек альбомов
db_dir=/var/lib/minidlna

# Путь к папке с лог-файлами
log_dir=/var/log

# Уровень детальности лога
# В формате log_level=источник1,источник2=значение1,источник3,источник4=значение2 ...
# Доступные источники: "general", "artwork", "database", "inotify", "scanner", "metadata", "http", "ssdp", "tivo"
# Возможные значения: "off", "fatal", "error", "warn", "info" or "debug"
#log_level=general,artwork,database,inotify,scanner,metadata,info,ssdp,tivo=warn

# Перечень имен файлов-обложек альбомов, разделитель: "/"
album_art_names=Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg

# Автообнаружение новых файлов
# Включено по умолчанию
#inotify=yes

# Поддержка устройств TiVo
#enable_tivo=no

# Строго следовать DLNA-стандарту
# Использовать серверное масштабирование для очень больших JPEG-изображений
# Что может снизить скорость их обработки.
#strict_dlna=no

# Адрес веб-страницы устройства
# По умолчанию IP-адрес и заданный порт сервера
#presentation_url=http://www.mylan/index.php

# Интервал отправки SSDP-уведомлений, в секундах
#notify_interval=895

# Серийный номер и номер модели DLNA-сервера, сообщаемый клиенту
serial=12345678
model_number=1

 Путь к сокету MiniSSDPd, если установлен
 Требуется для обеспечения работы нескольких DLNA/UPnP служб на одном сервере
#minissdpdsocket=/run/minissdpd.sock

# Контейнер, используемый в качестве корневой папки для клиентов
   * "." - стандартный контейнер
   * "B" - "Обзор папки"
   * "M" - "Музыка"
   * "V" - "Видео"
   * "P" - "Изображения"
 Если задано "B" и клиент представится как аудиоплеер, в качестве корня будет использована папка "Music/Folders"
#root_container=.

# Всегда использовать заданный критерий сортировки, вместо значения, запрошенного клиентом
#force_sort_criteria=+upnp:class,+upnp:originalTrackNumber,+dc:title

# Максимальное число одновременных подключений
# Учтите: многие клиенты открывают несколько подключений одновременно
#max_connections=50

Проверяем параметры init-скрипта /etc/default/minidlna:

sudo vim /etc/default/minidlna
Обычно корректировка не требуется. Если файл отсутствует, при первичной установке из исходников, копируем листинг:

# Запускать демон, если задано "yes"
START_DAEMON="yes"

# Путь к файлу конфигурации
#CONFIGFILE="/etc/minidlna.conf"

# Путь к лог-файлу
#LOGFILE="/var/log/minidlna.log"

# Запуск от имени заданного пользователя и группы
# По умолчанию: minidlna
#USER="minidlna"
#GROUP="minidlna"

# Дополнительные ключи запуска
DAEMON_OPTS=""

Поскольку служба работает под пользователем с ограниченными правами, публикуемые папки и файлы должны быть доступны на чтение для всех пользователей, следовательно, иметь разрешения 644: "rw- r-- r--", для файлов и 755: "rwx r-x r-x", для папок.
Проверяем доступность для каждой папки, заданной в minidlna.conf, командой:

sudo -u minidlna ls -l папка
Если папка недоступна, задаем права доступа: 

sudo chmod -R 755 папка
Вышестоящие папки также должны быть доступны на чтение всем пользователям. Проверяем доступность на чтение каждой папки, указанной в пути. Для вышестоящих папок используем chmod без ключа -R, если не требуется сброс разрешений для всех дочерних файлов и папок. 

В качестве альтернативы смене разрешений, можно запустить MiniDLNA от имени пользователя или группы-владельца файлов. Для этого необходимо задать параметры USER и GROUP в /etc/default/minidlna, и сменить владельца папки /var/lib/minidlna командой:

sudo chown -R пользователь:группа /var/lib/minidlna

cat /var/log/minidlna.log

Сканирование медиа-библиотеки MiniDLNA
При появлении ошибок в каталоге, необходимо выполнить повторное сканирование файлов.

Для этого удалим базу Minidlna и перезапустим службу:

#sudo rm /var/lib/minidlna/files.db
sudo rm /var/cache/minidlna/files.db
sudo systemctl restart minidlna

# ----------------------------------

echo 65538 > /proc/sys/fs/inotify/max_user_watches
sysctl fs.inotify.max_user_watches=66538
fs.inotify.max_user_watches = 66538