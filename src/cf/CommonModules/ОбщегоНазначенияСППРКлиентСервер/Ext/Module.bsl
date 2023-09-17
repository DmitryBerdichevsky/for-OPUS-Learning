﻿#Область ПрограммныйИнтерфейс

// Устанавливает отображение элемента в переданной форме
// Параметры:
//  Форма - форма, в которой требуется установить отображение элемента
//
Процедура УстановитьОтображениеСостоянияКонтроля(Форма) Экспорт
	
	ГруппаКонтроль = Форма.Элементы.Найти("ФормаГруппаКонтроль");
	Если ТипЗнч(ГруппаКонтроль) = Тип("ГруппаФормы") Тогда
		ГруппаКонтроль.Заголовок = Форма.СтатусКонтроля;
		
		Если Форма.СтатусКонтроля = "Проверено" Тогда
			ГруппаКонтроль.Картинка = БиблиотекаКартинок.ЗеленаяГалка;
		ИначеЕсли Форма.СтатусКонтроля = "Не проверено" Тогда
			ГруппаКонтроль.Картинка = БиблиотекаКартинок.НеПроверено;
		ИначеЕсли Форма.СтатусКонтроля = "Изменено" Тогда
			ГруппаКонтроль.Картинка = БиблиотекаКартинок.Изменено;
		ИначеЕсли Форма.СтатусКонтроля = "Снято с контроля" Тогда
			ГруппаКонтроль.Картинка = БиблиотекаКартинок.СнятоСКонтроля;
		Иначе
			ГруппаКонтроль.Картинка = БиблиотекаКартинок.Добавлено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьТекстГиперссылкиДополнительныеРазделы(Элемент, КоличествоРазделов) Экспорт
	
	ТекстЗаголовка = НСтр("ru='Доп. разделы (%Количество%)'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Количество%", КоличествоРазделов);
	
	Элемент.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

// Проверяет возможность подключения к ИБ по указанному пути
//
// Параметры:
//  ПутьИБ  - Строка - Различные варианты строки подключения к ИБ
//
// Возвращаемое значение:
//   Булево   - Истина, если по этому пути можно подключиться, Ложь - если не возможно.
//
Функция ЭтоСтрокаСоединенияИнформационнойБазы(Знач ПутьИБ) Экспорт 
	
	ПутьИБ = ВРег(ПутьИБ);
	
	Если Найти(ПутьИБ, "FILE=") > 0
		ИЛИ Найти(ПутьИБ, "WS=") > 0
		ИЛИ Найти(ПутьИБ, "SRVR=") > 0
		И Найти(ПутьИБ, "REF=") > 0 Тогда
	
		Возврат Истина;
	
	КонецЕсли; 
	
	Возврат Ложь;
	
КонецФункции 

// Функция проверяет, является ли переданная строка адресом файловой системы
//
// Параметры:
//  Путь - Строка	 - Путь который необходимо проверить
//
// Возвращаемое значение:
//  Булево - Истина, если это путь и Ложь - если путь определить не удалось.
//
Функция ЭтоПутьФайловойСистемы(Знач Путь) Экспорт 
	
	Если ТипЗнч(Путь) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Путь = СокрЛП(Путь);
	
	Если Найти(Путь, "\\")>0
		ИЛИ Найти(Путь, ":\")>0
		ИЛИ (Найти(Путь, ":/")>0 И Найти(Путь, "://")= 0)
		ИЛИ Лев(Путь, 1) = ПолучитьРазделительПутиКлиента()
		ИЛИ Лев(Путь, 1) = ПолучитьРазделительПути() Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции 

// Функция проверяет, является ли переданная строка web-адресом
//
// Параметры:
//  Адрес - Строка	 - адрес который необходимо проверить
//
// Возвращаемое значение:
//  Булево - Истина, если это веб-адрес и Ложь - если адрес определить не удалось.
//
Функция ЭтоWebАдрес(Знач Адрес) Экспорт 
	
	Адрес = ВРег(Адрес);
	
	Если СтрНачинаетсяС(Адрес, "HTTP://")
		ИЛИ СтрНачинаетсяС(Адрес, "HTTPS://")
		ИЛИ СтрНачинаетсяС(Адрес, "FTP://") 
		ИЛИ СтрНачинаетсяС(Адрес, "FTPS://")  Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции 

// Преобразует дату в строку в определенном формате
//
// Параметры:
//  ДатаВремя	- Дата - дата
//
// Возвращаемое значение:
//   Строка   - дата в нужном формате
//
Функция ДатаСтрокой(ДатаВремя) Экспорт

	Если ТипЗнч(ДатаВремя) <> Тип("Дата") Тогда
		Возврат "";
	КонецЕсли;
	
	Если НачалоДня(ДатаВремя) = ДатаВремя Тогда
		Возврат Формат(ДатаВремя, "ДЛФ=D");
	Иначе
		Возврат Формат(ДатаВремя, "ДФ='dd.MM.yyyy ЧЧ:мм'");
	КонецЕсли; 

КонецФункции

// Процедура останавливает исполнение.
// В случае выполнения вне Windows-систем, будет вызвано исключение.
//
// Параметры:
//  КоличествоСекунд - Число	 - Количество целых секунд
//
Процедура Пауза(КоличествоСекунд) Экспорт
	
	Шел = Новый COMОбъект("WScript.Shell");
	Шел.run("timeout /t " + Формат(КоличествоСекунд, "ЧДЦ=; ЧГ=0") , 0, -1);
	
КонецПроцедуры

// Функция - Запустить приложение 1С
//
// Параметры:
//  Параметры		Структура - Дополнительные параметры для открытия 1С:Предприятия	 - 	 - 
//  ШаблонКоманды	 - Строка	 - Альтернативный шаблон команды
// 
// Возвращаемое значение:
//   - 
//
Функция ЗапуститьПриложение1С(Параметры, ШаблонКоманды = "", ДождатьсяЗавершения = Истина, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ШаблонКоманды) Тогда
	
		ШаблонКоманды = "%КаталогИсполняемогоФайла%1cv8s DESIGNER";
	
	КонецЕсли; 
	
	ПутьИБ = "";
	ВерсияПлатформы = "";
	КаталогИсполняемогоФайла = "";
	КаталогПрограммы = "";
	ДополнительныеПараметрыЗапуска = "";
	ИскатьВерсию = Истина;
	
	Параметры.Свойство("ПутьИБ", ПутьИБ);
	Параметры.Свойство("ВерсияПлатформы", ВерсияПлатформы);
	Параметры.Свойство("КаталогИсполняемогоФайла", КаталогИсполняемогоФайла);
	Параметры.Свойство("ДополнительныеПараметрыЗапуска", ДополнительныеПараметрыЗапуска);
	
	Если Параметры.Свойство("ИскатьВерсию") Тогда
		ИскатьВерсию = Параметры.ИскатьВерсию;
	КонецЕсли;
	
	СимволСлеша = ПолучитьРазделительПути();
	
	СтрокаПодключенияИБ = СтрокаСоединенияИБ(ПутьИБ);
	
	#Если Сервер ИЛИ ВнешнееСоединение Тогда
		
		КаталогИсполняемогоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогПрограммы());
		ПутьКВерсиямПлатформыНаСервере = Константы.ПутьКВерсиямПлатформыНаСервере.Получить();
		Если ЗначениеЗаполнено(ПутьКВерсиямПлатформыНаСервере) Тогда
			
			Если Не ЗначениеЗаполнено(ВерсияПлатформы) Тогда
				СисИнфо = Новый  СистемнаяИнформация;
				ВерсияПлатформы = СисИнфо.ВерсияПриложения;
			КонецЕсли; 
			ПутьКВерсиямПлатформыНаСервере = СтрЗаменить(ПутьКВерсиямПлатформыНаСервере, "%ВерсияПлатформы%", ВерсияПлатформы);
			Файл = Новый Файл(ПутьКВерсиямПлатформыНаСервере);
			Если Файл.Существует() Тогда
				КаталогИсполняемогоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКВерсиямПлатформыНаСервере);
			Иначе
				ТекстОшибки = НСтр("ru = 'Не найдена указанная версия платформы: %ВерсияПлатформы% на сервере: %ИмяСервера%.
				|Путь к 1С:Конфигуратору на сервере: %Путь%.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВерсияПлатформы%", ВерсияПлатформы);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИмяСервера%", ИмяКомпьютера());
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Путь%", ПутьКВерсиямПлатформыНаСервере);
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
		КонецЕсли; 
	
	#Иначе
	
		ВерсияУказана = ЗначениеЗаполнено(КаталогИсполняемогоФайла);
		
		#Если ВебКлиент Тогда
			Параметры.Свойство("КаталогПрограммы", КаталогПрограммы);
		#Иначе
			Параметры.Свойство("КаталогПрограммы", КаталогПрограммы);
			Если НЕ ЗначениеЗаполнено(КаталогПрограммы) Тогда
				КаталогПрограммы = СокрЛП(КаталогПрограммы());
			КонецЕсли; 
		#КонецЕсли
		
		КаталогПрограммы = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогПрограммы);
		
		Если ЗначениеЗаполнено(ВерсияПлатформы) 
			И НЕ ЗначениеЗаполнено(КаталогИсполняемогоФайла) Тогда
			
			КаталогИсполняемогоФайла = КаталогПрограммы;
			
			СистемнаяИнформация = Новый СистемнаяИнформация;
			
			ТекущаяВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
			Если Найти(КаталогПрограммы, ТекущаяВерсияПриложения) > 0 Тогда
				
				КаталогПроверки = СтрЗаменить(КаталогПрограммы, ТекущаяВерсияПриложения, ВерсияПлатформы);
				Файл = Новый Файл(КаталогПроверки);
				Если Файл.Существует() Тогда
					ВерсияУказана = Истина;
					КаталогИсполняемогоФайла = КаталогПроверки;
				КонецЕсли;
			КонецЕсли; 
		ИначеЕсли НЕ ЗначениеЗаполнено(КаталогИсполняемогоФайла) Тогда
			КаталогИсполняемогоФайла = КаталогПрограммы;
		КонецЕсли;
		
		Если Не ВерсияУказана И ИскатьВерсию Тогда
			ШаблонКоманды = ШаблонКоманды + " /AppAutoCheckVersion";
		КонецЕсли; 
	
	#КонецЕсли
	
	СтрокаКоманды = СтрЗаменить(ШаблонКоманды, "%КаталогИсполняемогоФайла%", КаталогИсполняемогоФайла);
	
	СтрокаКоманды = СтрокаКоманды + СтрокаПодключенияИБ;
	
	Если Параметры.Свойство("ИмяПользователя") Тогда
	
		СтрокаКоманды = СтрокаКоманды + " /N """+ СокрЛП(Параметры.ИмяПользователя) + """";
		Если Параметры.Свойство("ПарольПользователя") Тогда
			
			СтрокаКоманды = СтрокаКоманды + " /P """+ СокрЛП(Параметры.ПарольПользователя) + """";
			
			СтрокаКоманды = СтрокаКоманды + " /DisableStartupDialogs"
			
		КонецЕсли; 
	
	КонецЕсли; 
	Если Параметры.Свойство("Отладка") Тогда
	
		СтрокаКоманды = СтрокаКоманды + " /Debug"
	
	КонецЕсли; 
	Если ЗначениеЗаполнено(ДополнительныеПараметрыЗапуска) Тогда
	
		СтрокаКоманды = СтрокаКоманды + " " + ДополнительныеПараметрыЗапуска;
	
	КонецЕсли;
	
	Попытка
		
		#Если ВебКлиент Тогда
			НачатьЗапускПриложения(ОповещениеЗавершения, СтрокаКоманды, КаталогИсполняемогоФайла, ДождатьсяЗавершения);
		#Иначе
			КодВозврата = Неопределено;
			ЗапуститьПриложение(СтрокаКоманды, КаталогИсполняемогоФайла, ДождатьсяЗавершения, КодВозврата);
		#КонецЕсли
		
	Исключение
		
		КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
		ТекстСообщения = НСтр("ru = 'Не удалось выполнить запуск внешнего приложения'", КодОсновногоЯзыка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		#Если Сервер ИЛИ ВнешнееСоединение Тогда
			
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка, , ,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		#КонецЕсли
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	#Если ВебКлиент Тогда
		Возврат 0;
	#Иначе
		Возврат КодВозврата;
	#КонецЕсли
	
КонецФункции

Функция СтрокаСоединенияИБ(Знач ПутьИБ) Экспорт 
	
	СтрокаСоединения = "";
	
	Если ОбщегоНазначенияСППРКлиентСервер.ЭтоСтрокаСоединенияИнформационнойБазы(ПутьИБ) Тогда
		
		СтрокаСоединения = " /IBConnectionString ""%СтрокаСоединения%""";
		Если Найти(ПутьИБ, """""") = 0 Тогда
			ПутьИБ = СтрЗаменить(ПутьИБ, """", """""");
		КонецЕсли; 
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "%СтрокаСоединения%", ПутьИБ);
	ИначеЕсли ОбщегоНазначенияСППРКлиентСервер.ЭтоПутьФайловойСистемы(ПутьИБ) Тогда
		
		СтрокаСоединения = " /F ""%Путь%""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "%Путь%", ПутьИБ);
		
	ИначеЕсли Найти(ПутьИБ, "\") > 0 Тогда
		
		СтрокаСоединения = " /S ""%Путь%""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "%Путь%", ПутьИБ);
	
	КонецЕсли;
	
	Возврат СтрокаСоединения;
	
КонецФункции

Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

Функция ТипОбъектаВЕдинственномЧисле(ТипОбъектаВВомножественномЧисле) Экспорт
	
	Если ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ХранилищаНастроек") Тогда
		Возврат "ХранилищеНастроек";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ПланыОбмена") Тогда
		Возврат "ПланОбмена";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ПланыОбмена") Тогда
		Возврат "ПланОбмена";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("Константы") Тогда
		Возврат "Константа";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("Справочники") Тогда
		Возврат "Справочник";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("Документы") Тогда
		Возврат "Документ";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ПланыВидовХарактеристик") Тогда
		Возврат "ПланВидовХарактеристик";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ПланыСчетов") Тогда
		Возврат "ПланСчетов";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("ПланыВидовРасчета") Тогда
		Возврат "ПланВидовРасчета";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("Регистрысведений") Тогда
		Возврат "РегистрСведений";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("РегистрыНакопления") Тогда
		Возврат "РегистрНакопления";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("РегистрыБухгалтерии") Тогда
		Возврат "РегистрБухгалтерии";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("РегистрРасчета") Тогда
		Возврат "РегистрРасчета";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("БизнесПроцессы") Тогда
		Возврат "БизнесПроцесс";
	ИначеЕсли ВРег(ТипОбъектаВВомножественномЧисле) = ВРег("Задачи") Тогда
		Возврат "Задача";
	Иначе
		Возврат ""
	КонецЕсли;
	
КонецФункции

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора
//
// Параметры:
//  Список - динамический список, для которого требуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора, 
			Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбора.Свойство(ИмяКолонки, Значение) Тогда
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора и переданных настроек
//
// Параметры:
//  Список - динамический список, для которого треюуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Настройки - настройки, из которых могут получаться значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора, 
			Настройки, Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		Значение = Настройки.Получить(ИмяКолонки);
		Если ПриводитьЗначениеКЧислу Тогда
			Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
		КонецЕсли;
		ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
	Иначе
		Если Не СтруктураБыстрогоОтбора.Свойство(ИмяКолонки) Тогда
			Значение = Настройки.Получить(ИмяКолонки);
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Удалить(ИмяКолонки);
	
КонецПроцедуры

// Проверяет передан ли в форму списка отбор по статусу
//
// Параметры:
// ИмяКолонки - Строка - имя колонки, по которой выполняется отбор
// Значение - Произвольный - значение для отбора
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка отбор
//
// Возвращаемое значение:
// Булево
// Истина, если необходимо установить отбор по состоянию, иначе Ложь
//
Функция НеобходимОтборПоКолонкеПриСозданииНаСервере(ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство(ИмяКолонки, Значение) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет, нужно ли устанавливать отбор по статусу, загруженный из настроек или переданный в форму извне
//
// Отбор из настроек устанавливается только если отбор не передан в форму извне
//
// Параметры:
// ИмяКолонки - Строка - имя колонки, по которой выполняется отбор
// ИмяНастройки - Строка - имя настройки, при восстановлении которой требуется отбор
// Значение - Произвольный - значение для отбора
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка отбор
// Настройки - Соответствие - настройки формы
//
Функция НеобходимОтборПоКолонкеПередЗагрузкойИзНастроек(ИмяКолонки, ИмяНастройки, Значение, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	НеобходимОтборПоКолонке = Ложь;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		Значение = Настройки.Получить(ИмяНастройки);
		НеобходимОтборПоКолонке = Истина;
		
	Иначе
	
		Если Не СтруктураБыстрогоОтбора.Свойство(ИмяКолонки) Тогда
			Значение = Настройки.Получить(ИмяНастройки);
			НеобходимОтборПоКолонке = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Настройки.Удалить(ИмяНастройки);

	Возврат НеобходимОтборПоКолонке;
	
КонецФункции

// Получает текст нвигационной ссылки.
//
// Параметры:
//  Текст - Строка - Текст который содержит наивгационные ссылки
//  НомерВхождения - Число - Порядковый номер ссылки, если ссылок в тексте несколько, по умолчанию 1
//  ТолькоВнутреннююСсылку - Булево - возвращать только внутреннюю ссылку, даже если передан текст внешней ссылки
//
// Возвращаемое значение:
//  Текст навигационной ссылки 1С
Функция ТекстНавигационнойСсылки(Знач Текст, НомерВхождения = 1, ТолькоВнутреннююСсылку = Ложь) Экспорт
	
	НачалоСсылки = СтрНайти(Текст, "e1cib/data/",,,НомерВхождения);
	Если НЕ ТолькоВнутреннююСсылку Тогда
		ЭтоВнешняяСсылка = Сред(Текст,НачалоСсылки-1,1) = "#";
		Если ЭтоВнешняяСсылка Тогда
			НачалоВнешнейСсылки = СтрНайти(Текст, "e1c:",НаправлениеПоиска.СКонца, НачалоСсылки);
			Если НачалоВнешнейСсылки = 0 Тогда
				НачалоВнешнейСсылки = СтрНайти(Текст, "http:",НаправлениеПоиска.СКонца, НачалоСсылки);
			КонецЕсли;
			НачалоСсылки = НачалоВнешнейСсылки;
		КонецЕсли;
	КонецЕсли;
	НачалоНомера = СтрНайти(Текст, "?ref=",,,НомерВхождения);
	КонецСсылки = НачалоНомера + 5 + 32;// где 5 - длина ?ref=; 32 - длина номера ссылки
	Возврат Сред(Текст, НачалоСсылки, КонецСсылки - НачалоСсылки);
	
КонецФункции

// Возвращает параметры запуска приложения 1С.
// 
// Возвращаемое значение:
//  Структура - содержит параметры, которые используются в процедуре ОбщегоНазначенияСППРКлиент.ЗапуститьПриложение1СНаКлиенте.
//
Функция ПараметрыКомандыЗапускаПриложения1С() Экспорт

	ПараметрыКоманды = Новый Структура;		
	ПараметрыКоманды.Вставить("ИмяПользователя", "");
	ПараметрыКоманды.Вставить("ПарольПользователя", "");
	ПараметрыКоманды.Вставить("ПутьИБ", "");
	ПараметрыКоманды.Вставить("ВерсияПлатформы", "");
	ПараметрыКоманды.Вставить("КаталогИсполняемогоФайла", "");
	ПараметрыКоманды.Вставить("ДополнительныеПараметрыЗапуска", "");
	ПараметрыКоманды.Вставить("Отладка", Ложь);

	Возврат ПараметрыКоманды;

КонецФункции

// Возвращает Составляющие номера версии (номер редакции, номер подредакции, номер версии) по строковому коду.
//
// Параметры:
//  Код - Строка - строковое значение кода.
// Возвращаемое значение:
//  Составляющие - Структура - содержит составляющие номера версии:
//   * НомерРедации    - Число - номер редакции
//   * НомерПодредации - Число - номер подредакции
//   * НомерВерсии     - Число - номер версии.
//
Функция СоставляющиеНомераВерсииПоКоду(Знач Код) Экспорт
	
	Составляющие = Новый Структура;
	Составляющие.Вставить("НомерРедакции", 0);
	Составляющие.Вставить("НомерПодредакции", 0);
	Составляющие.Вставить("НомерВерсии", 0);
	
	ЧастиКода = СтрРазделить(Код, ".", Ложь);
	
	Если ЧастиКода.Количество() <> 3 Тогда
		Возврат Составляющие;
	КонецЕсли;
	
	ДопустимыеСимволыКода = "0123456789";
	
	НомерЧасти = 1;
	
	Для Каждого ЧастьКода из ЧастиКода Цикл
		
		СтрокаЧасти = "";
		Сч=1;
		Пока Сч <= СтрДлина(ЧастьКода) Цикл
			ТекущийСимвол = Сред(ЧастьКода, Сч,1);
			Если СтрНайти(ДопустимыеСимволыКода, ТекущийСимвол)>0 Тогда
				СтрокаЧасти = СтрокаЧасти + ТекущийСимвол;
			КонецЕсли;
			Сч = Сч + 1;
		КонецЦИкла;
		
		Если ЗначениеЗаполнено(СтрокаЧасти) Тогда
			
			ЗначениеЧислом = Число(СтрокаЧасти);
			
			Если НомерЧасти = 1 Тогда
				Составляющие.Вставить("НомерРедакции", ЗначениеЧислом);
			ИначеЕсли НомерЧасти = 2 Тогда
				Составляющие.Вставить("НомерПодредакции", ЗначениеЧислом);
			Иначе
				Составляющие.Вставить("НомерВерсии", ЗначениеЧислом);
			КонецЕсли;
			
		КонецЕсли;
		
		НомерЧасти = НомерЧасти + 1;
		
	КонецЦикла;
	
	Возврат Составляющие;
	
КонецФункции

// Формирует список времени
//
// Параметры:
//  Интервал - Число - интервал между значениями списка (в секундах)
//  НачалоИнтервала - Дата - начало интервала для заполнения списка 
//  КонецИнтервала - Дата - конец интервала для заполнения списка 
//  ДобавлятьПоследнийЧас - Булево - необходимость добавить 24 час в список
//
//  Возвращаемое значение:
//   СписокВремени - СписокЗначений - сформированный список времени.
//
Функция СписокВремени(Интервал = 3600, НачалоИнтервала = '00010101000000', КонецИнтервала = '00010101235959', ДобавлятьПоследнийЧас= Ложь) Экспорт

	СписокВремен = Новый СписокЗначений;

	ВремяСписка = НачалоИнтервала;
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(КонецИнтервала) Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;

		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);

		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
	Если ДобавлятьПоследнийЧас Тогда
		СписокВремен.Добавить(НачалоДня(КонецИнтервала), "00:00");
	КонецЕсли;
	
	Возврат СписокВремен;
	
КонецФункции

#КонецОбласти