# Отчет по лабораторной работе 
## по курсу "Искусственный интеллект"

## Нейросети для распознавания изображений


### Студенты: 

| ФИО       | Роль в проекте                     | Оценка       |
|-----------|------------------------------------|--------------|
| Девяткина Дария | Обработала датасет, обучала модели, писала отчет |    5      |
| Мамчур Александра | Подготовила датасет, обучила полносвязную модель |     5  |


## Результат проверки
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |     10.06.19         |       5        |

> Код может быть сильно сокращен и упрощен за счет выделения функций (особенно это касается функции разрезания символов). Я бы на вашем месте попробовал запустить этот код на Google Colab - это не является проблемой, и будет полезным упражнением на лето.

## Тема работы

Опишите тему работы, включая предназначенный для распознавания набор символов.

>Варианты рукописных символов (номер определяется следущим образом: ASCII-коды первых символов фамилий всех участников команды складываются и берётся остаток от деления на 5 + 1)

Девяткина -> D -> 68
Мамчур -> М -> 77

( 68 + 77 ) % 5 + 1 =  0 + 1 = 1 
Следовательно, вариант 1:
*Символы принадлежности множеству, пересечения, объединения множеств и пустого множества.*

Символ принадлежности множеству: ∈

Пересечение: ⋂

Объединение: ⋃

Пустое: ø

## Распределение работы в команде

Девяткина Дария - вырезала изображения, обучала модели, находила ответы на стакоферфлоу

Мамчур Александра - подготовила датасеты, обучала полносвязные модели

## Подготовка данных

>Приведите фотографии исходных листков с рукописными символами:
#### [1.jpg](https://i.postimg.cc/zB3sCCYp/1.jpg)
![1](https://i.postimg.cc/zB3sCCYp/1.jpg)
#### [2.jpg](https://i.postimg.cc/cCnPjdHn/2.jpg)
![2](https://i.postimg.cc/cCnPjdHn/2.jpg)
#### [3.jpg](https://i.postimg.cc/X79TkNtM/3.jpg)

![3](https://i.postimg.cc/X79TkNtM/3.jpg)
#### [4.jpg](https://i.postimg.cc/ryBB4RnC/4.jpg)
![4](https://i.postimg.cc/ryBB4RnC/4.jpg)

>Как осуществлялась подготовка датасета?

На тетрадном листе бумаги в клетках 1х1 см были выписаны 800 символов, по 200 на каждый. Они были сфотографированы и обработаны приложением AdobeScan для более удобной работы. Также сканы были обрезаны максимально близко к клеткам для того, чтобы было удобнее в последствии вырезать.

С помощью библиотеки OpenCV было выполнено сжатие изображения. Затем изображение было преобразовано в черно-белое. 
```python
im = cv2.imread('souce/2.jpg')
final_wide = 32*13
#коэф уменьшения сторон
r = float(final_wide) / im.shape[1]
dim = (final_wide, int(im.shape[0] * r))

resized = cv2.resize(im, dim, interpolation = cv2.INTER_AREA)
im = resized
wb = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
```
Затем при прохождении каждой фотографии, по строкам и по столбцам, вырезались квадраты со стороной 32. В зависимости от номера, новые отрезанные файлы сохранялись в отдельные папки:
```python
while row < (wb.shape[0] // size):
    column = 0
    x0 = 0
    x1 = x0 + size
    while column < (wb.shape[1] // size):
        if name <= 300:
            file = ofile+'{}.jpg'.format(name)
        elif name > 300 and name:
            file = nfile+'{}.jpg'.format(name)
        chop = wb[y0:y1, x0:x1]
        cv2.imwrite(file, chop)
        # и т.д.
```

[Ссылка](https://drive.google.com/drive/folders/1LOwn3ACU-CBdYzKVSMHnxRSMwq7SYUn2?usp=sharing) на папку в GoogleDrive со всеми исходниками, получившимися изображениями и ноутбуками.

## Загрузка данных

Прочитываем из каждой папки изображения в черно-белом виде, составляем матрицу изображений и вектор классов. Также переконвертируем данные в массивы numpy.
```python
for symbol in symbols:
    for image in os.listdir(symbol):
        array = cv2.imread(symbol + '/' + image, cv2.IMREAD_GRAYSCALE)
        data.append(array)
        if symbol == 'e':
            classes.append(0)
        elif symbol == 'n':
            classes.append(1)
        elif symbol == 'u':
            classes.append(2)
        else:
            classes.append(3)
```
Подготовка данных происходит таким образом: изображения представляются в виде одномерных массивов (каждый пиксель - один входной признак). Нормализация значения интенсивности пикселя, чтобы каждое значение принадлежало интервалу [0, 1]. Также мы преобразуем обучающие выходные данные в прямое кодирование (one-hot encoding) с помощью встроенной функции. 

```python
#приводим данные к 1Д 
x_train = x_train.reshape(num_train, height * width)
x_test = x_test.reshape(num_test, height * width)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
#нормализация данных до значений [0,1]
x_train /= 255
x_test /= 255

#one-hot encoding
y_train = np_utils.to_categorical(y_train, num_classes)
y_test = np_utils.to_categorical(y_test, num_classes)
```

## Обучение нейросети


### Полносвязная однослойная сеть
**Архитектура**

Нам нужно просто задать входные и выходные данные, как это сделано ниже.
```python
inp = Input(shape = (height * width,)) #входной вектор
out = Dense(num_classes, activation='softmax')(inp) #выходной слой

model = Model(inputs=inp, outputs=out)
```
Компилируем модель, используя adam как оптимизационный алгоритм и категориальную кросс-энтропию в качестве функции потерь.
```python
model.compile(loss='categorical_crossentropy',#функция кросс-энтропии
             optimizer='adam', #оптимайзер Адама
             metrics=['accuracy']) 
```
Количество эпох - 15, батчей - 16, валидационная выборка - 10%, отель - триваго

**Результаты**
```
Train on 576 samples, validate on 64 samples
Epoch 1/15
576/576 [==============================] - 15s 26ms/step - loss: 1.5442 - acc: 0.2587 - val_loss: 1.3553 - val_acc: 0.2188
Epoch 2/15
576/576 [==============================] - 16s 27ms/step - loss: 1.3690 - acc: 0.3212 - val_loss: 1.2334 - val_acc: 0.4375
Epoch 3/15
576/576 [==============================] - 16s 27ms/step - loss: 1.2946 - acc: 0.4010 - val_loss: 1.3161 - val_acc: 0.3281
Epoch 4/15
576/576 [==============================] - 15s 27ms/step - loss: 1.1822 - acc: 0.5260 - val_loss: 1.3309 - val_acc: 0.4844
Epoch 5/15
576/576 [==============================] - 14s 25ms/step - loss: 1.1332 - acc: 0.5347 - val_loss: 1.0726 - val_acc: 0.8125
Epoch 6/15
576/576 [==============================] - 15s 26ms/step - loss: 1.0625 - acc: 0.6267 - val_loss: 1.0529 - val_acc: 0.6875
Epoch 7/15
576/576 [==============================] - 15s 26ms/step - loss: 1.0767 - acc: 0.5312 - val_loss: 1.2197 - val_acc: 0.5312
Epoch 8/15
576/576 [==============================] - 15s 26ms/step - loss: 0.9430 - acc: 0.7274 - val_loss: 1.1488 - val_acc: 0.5312
Epoch 9/15
576/576 [==============================] - 15s 25ms/step - loss: 0.9104 - acc: 0.7344 - val_loss: 1.0334 - val_acc: 0.6406
Epoch 10/15
576/576 [==============================] - 15s 26ms/step - loss: 0.9428 - acc: 0.6493 - val_loss: 1.0050 - val_acc: 0.5938
Epoch 11/15
576/576 [==============================] - 16s 28ms/step - loss: 0.8212 - acc: 0.7760 - val_loss: 0.9921 - val_acc: 0.5000
Epoch 12/15
576/576 [==============================] - 16s 28ms/step - loss: 0.8028 - acc: 0.7639 - val_loss: 0.7897 - val_acc: 0.7812
Epoch 13/15
576/576 [==============================] - 16s 28ms/step - loss: 0.7626 - acc: 0.7830 - val_loss: 0.8368 - val_acc: 0.7812
Epoch 14/15
576/576 [==============================] - 15s 26ms/step - loss: 0.7224 - acc: 0.8090 - val_loss: 0.8164 - val_acc: 0.7812
Epoch 15/15
576/576 [==============================] - 20s 34ms/step - loss: 0.7136 - acc: 0.8333 - val_loss: 0.7537 - val_acc: 0.8594
160/160 [==============================] - 0s 488us/step
Loss = 0.7404324054718018, Final accuracy = 0.8
```
### Полносвязная многослойная сеть
**Архитектура** 

Одно из свойств Keras — это автоматический расчет размеров слоев; нам достаточно только указать размерность входного слоя, а Keras автоматически проинициализирует все остальные слои. Когда все слои определены, нам нужно просто задать входные и выходные данные, как это сделано ниже.
```python
inp = Input(shape = (height * width,)) #входной вектор
hidden_1 = Dense(hidden_size, activation='relu')(inp) #первый слой с акт.ф-ей relu
hidden_2 = Dense(hidden_size, activation='relu')(hidden_1) #второй слой
out = Dense(num_classes, activation='softmax')(hidden_2) #выходной слой

model = Model(inputs=inp, outputs=out)
```
На всех слоях, кроме выходного полносвязного слоя, используется функция активации ReLU, последний же слой использует softmax. Функция relu является хорошим аппроксиматором, так как любая функция может быть аппроксимирована комбинацией ReLu. Softmax специально предназначен для мультиклассовой классификации и обеспечивает, чтобы сумма выходных значений всех нейронов слоя равна единице. 


**Результаты**
```
Train on 576 samples, validate on 64 samples
Epoch 1/15
576/576 [==============================] - 384s 667ms/step - loss: 1.5050 - acc: 0.2309 - val_loss: 1.4505 - val_acc: 0.1875
Epoch 2/15
576/576 [==============================] - 375s 652ms/step - loss: 1.3209 - acc: 0.3576 - val_loss: 1.2865 - val_acc: 0.3906
Epoch 3/15
576/576 [==============================] - 377s 655ms/step - loss: 1.3035 - acc: 0.3941 - val_loss: 1.2733 - val_acc: 0.7188
Epoch 4/15
576/576 [==============================] - 386s 670ms/step - loss: 1.1821 - acc: 0.4618 - val_loss: 1.3588 - val_acc: 0.3594
Epoch 5/15
576/576 [==============================] - 447s 776ms/step - loss: 1.0858 - acc: 0.5503 - val_loss: 1.5359 - val_acc: 0.3438
Epoch 6/15
576/576 [==============================] - 418s 725ms/step - loss: 1.0003 - acc: 0.6024 - val_loss: 1.6510 - val_acc: 0.1875
Epoch 7/15
576/576 [==============================] - 482s 837ms/step - loss: 0.9770 - acc: 0.5764 - val_loss: 0.9124 - val_acc: 0.6094
Epoch 8/15
576/576 [==============================] - 549s 954ms/step - loss: 0.7364 - acc: 0.7917 - val_loss: 0.8096 - val_acc: 0.6719
Epoch 9/15
576/576 [==============================] - 462s 801ms/step - loss: 0.6642 - acc: 0.7674 - val_loss: 0.7575 - val_acc: 0.7188
Epoch 10/15
576/576 [==============================] - 473s 821ms/step - loss: 0.5773 - acc: 0.8177 - val_loss: 0.7345 - val_acc: 0.7031
Epoch 11/15
576/576 [==============================] - 545s 946ms/step - loss: 0.5619 - acc: 0.8003 - val_loss: 0.6638 - val_acc: 0.7031
Epoch 12/15
576/576 [==============================] - 551s 957ms/step - loss: 0.5694 - acc: 0.7865 - val_loss: 0.5882 - val_acc: 0.8750
Epoch 13/15
576/576 [==============================] - 584s 1s/step - loss: 0.4040 - acc: 0.8819 - val_loss: 0.4955 - val_acc: 0.8281
Epoch 14/15
576/576 [==============================] - 596s 1s/step - loss: 0.4760 - acc: 0.8507 - val_loss: 0.6985 - val_acc: 0.7344
Epoch 15/15
576/576 [==============================] - 408s 708ms/step - loss: 0.3373 - acc: 0.9132 - val_loss: 0.3976 - val_acc: 0.9062
160/160 [==============================] - 1s 5ms/step
Loss = 0.3583622992038727, Final accuracy = 0.90625
```

### Свёрточная сеть
**Архитектура** 

Используем модель последовательного типа:
1. Используются только свёрточные фильтры 3х3. 
2. 32 и 64 – это количество узлов в первом и втором слое. Это количество можно увеличить или уменьшить в зависимости от размера базы данных. В нашем случае отлично подходят 64 и 32, поэтому эти параметры оставляем.
3. Функция активации - ReLu.
4. Между слоем MaxPooling2D и  Dense находится слой выравнивания (Flatten). Он служит соединительным узлом между слоями.
6. Softmax функция активации на последнем слое. Она сводит получившуюся сумму к 1, чтобы результат мог интерпретироваться как ряд возможных исходов. Тогда модель будет делать прогноз на основании того, какой вариант наиболее вероятен.

```python
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),
                 activation='relu',
                 input_shape=input_shape))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(100, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))
```
## Предыстория
История этого задания очень грустная, потому как Тензорфлоу не устанавливался, мы решили сменить бэк на Теано. И вроде все было более-менее нормально с полносвязной нейросетью (долго, да, но терпимо). Когда Сверточная сказала, что ну где-то 2 часа одна эпоха считаться будет, мы подняли тревогу. Хочется принять во внимание, что 3 эпохи в таком темпе мы все таки посчитали (ждали 5.5 часов). Точность была 0.23.

Никакие танцы с бубном, pip и Теано не помогали нам избавиться от предупреждений и сократить время работы. Через неделю неудачных запусков, оказалось *(было прочитано на стаковерфлоу)*, что Теано не очень дружит с виндовс в принципе. Так как мы студенты 8 факультета, у нас у всех конечно же стоит *nix система, так что спасибо Xubuntu, за то, что сделала сдачу этой лабораторной возможной, хоть и на неделю позже. 

Список ошибок и время работы можно посмотреть в ноутбуке second_part в репозитории. 

**Результаты**

Результаты работы ниже приведены для Dense(4) и Dense(100).
```
danya@Lenovo-Z50-70:~/python$ KERAS_BACKEND=theano python3 sp.py
Using Theano backend.
WARNING (theano.tensor.blas): Using NumPy C-API based implementation for BLAS functions.
x_train shape: (640, 32, 32, 1)
640 train samples
160 test samples
Train on 640 samples, validate on 160 samples
Epoch 1/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3977 - acc: 0.2344 - val_loss: 1.3862 - val_acc: 0.2687
Epoch 2/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3865 - acc: 0.2406 - val_loss: 1.3863 - val_acc: 0.2187
Epoch 3/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3863 - acc: 0.2516 - val_loss: 1.3864 - val_acc: 0.2187
Epoch 4/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3863 - acc: 0.2469 - val_loss: 1.3865 - val_acc: 0.2187
Epoch 5/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3863 - acc: 0.2578 - val_loss: 1.3865 - val_acc: 0.2187
Epoch 6/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3863 - acc: 0.2578 - val_loss: 1.3867 - val_acc: 0.2187
Epoch 7/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2578 - val_loss: 1.3868 - val_acc: 0.2187
Epoch 8/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2578 - val_loss: 1.3869 - val_acc: 0.2187
Epoch 9/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2422 - val_loss: 1.3870 - val_acc: 0.2187
Epoch 10/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2516 - val_loss: 1.3870 - val_acc: 0.2187
Epoch 11/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2578 - val_loss: 1.3871 - val_acc: 0.2187
Epoch 12/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2578 - val_loss: 1.3873 - val_acc: 0.2187
Epoch 13/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3861 - acc: 0.2578 - val_loss: 1.3874 - val_acc: 0.2250
Epoch 14/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3862 - acc: 0.2484 - val_loss: 1.3874 - val_acc: 0.2250
Epoch 15/15
640/640 [==============================] - 6s 9ms/step - loss: 1.3861 - acc: 0.2469 - val_loss: 1.3875 - val_acc: 0.2250
Test loss: 1.3875492095947266
Test accuracy: 0.225

danya@Lenovo-Z50-70:~/python$ KERAS_BACKEND=theano python3 sp.py
Using Theano backend.
WARNING (theano.tensor.blas): Using NumPy C-API based implementation for BLAS functions.
x_train shape: (640, 32, 32, 1)
640 train samples
160 test samples
Train on 640 samples, validate on 160 samples
Epoch 1/15
640/640 [==============================] - 5s 8ms/step - loss: 1.4598 - acc: 0.2484 - val_loss: 1.3569 - val_acc: 0.5000
Epoch 2/15
640/640 [==============================] - 5s 8ms/step - loss: 1.3304 - acc: 0.4062 - val_loss: 1.2920 - val_acc: 0.2375
Epoch 3/15
640/640 [==============================] - 5s 8ms/step - loss: 1.2273 - acc: 0.4688 - val_loss: 1.1282 - val_acc: 0.6313
Epoch 4/15
640/640 [==============================] - 5s 8ms/step - loss: 1.0515 - acc: 0.6187 - val_loss: 0.7765 - val_acc: 0.8375
Epoch 5/15
640/640 [==============================] - 5s 8ms/step - loss: 0.9632 - acc: 0.6406 - val_loss: 0.8284 - val_acc: 0.8438
Epoch 6/15
640/640 [==============================] - 5s 8ms/step - loss: 0.7523 - acc: 0.7422 - val_loss: 0.4392 - val_acc: 0.8812
Epoch 7/15
640/640 [==============================] - 5s 8ms/step - loss: 0.4192 - acc: 0.8703 - val_loss: 0.2638 - val_acc: 0.9187
Epoch 8/15
640/640 [==============================] - 5s 8ms/step - loss: 0.3048 - acc: 0.9016 - val_loss: 0.1947 - val_acc: 0.9125
Epoch 9/15
640/640 [==============================] - 5s 8ms/step - loss: 0.3731 - acc: 0.8812 - val_loss: 0.1516 - val_acc: 0.9687
Epoch 10/15
640/640 [==============================] - 5s 8ms/step - loss: 0.1524 - acc: 0.9578 - val_loss: 0.0925 - val_acc: 0.9750
Epoch 11/15
640/640 [==============================] - 5s 8ms/step - loss: 0.2159 - acc: 0.9422 - val_loss: 0.1781 - val_acc: 0.9500
Epoch 12/15
640/640 [==============================] - 5s 8ms/step - loss: 0.1322 - acc: 0.9563 - val_loss: 0.0822 - val_acc: 0.9813
Epoch 13/15
640/640 [==============================] - 5s 9ms/step - loss: 0.0771 - acc: 0.9813 - val_loss: 0.1169 - val_acc: 0.9625
Epoch 14/15
640/640 [==============================] - 5s 8ms/step - loss: 0.2295 - acc: 0.9328 - val_loss: 0.0609 - val_acc: 0.9750
Epoch 15/15
640/640 [==============================] - 5s 8ms/step - loss: 0.0665 - acc: 0.9859 - val_loss: 0.0444 - val_acc: 0.9875
Test loss: 0.04444949552416801
Test accuracy: 0.9875
```

## Выводы

>Сформулируйте *содержательные* выводы по лабораторной работе. Чему он вас научила? 

Данная лабораторная работа была довольно увлекательным занятием, так как нам нужно было не только писать код, но немного поработать руками, что иногда полезно. Также, мы почувствовали как происходит обучение нейронных сетей на самом деле, построили несколько самостоятельно и теперь не стыдно сказать об этом на следующем собеседовании.  

Мы выяснили, что для классификации изображений полносвязные нейронные сети подходят в меньшей степени, чем свёрточные, предназначенные для работы с интенсивностями пикселей и изучения различающих фильтров, что позволяет классифицировать изображения с высокой точностью. 

Основные трудности вызывало время ожидания обучения модели, а мы оказались не самыми терпеливыми людьми. Очень неприятным было узнать, как много времени бы мы сократили, работая не в виндовс. Работа с вырезкой изображений так, чтобы было ровно, тоже оказалось немного неприятным действием. Наша команда, по традиции, использовала Telegram (запрещенный на территории РФ) и технологию Agile.

Нейронные сети оказались не самой простой работой, однако нам очень понравилось подбирать количество нейронов, слоев и батчей. Если бы компьютер был квантовым (или хотя бы удалось запустить ноутбук через Google Colab на их серверах), то возможно время ожидания в ОС Виндовс нас бы так не расстроило. Теперь мы будем запускать Keras на бэке Theano только в linux.  


