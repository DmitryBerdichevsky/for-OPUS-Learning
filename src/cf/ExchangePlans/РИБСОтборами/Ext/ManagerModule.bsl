﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Вызывается при получении настроек
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
    Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных = Истина;
	
КонецПроцедуры

// Вызывается при получении описания варианта настройки
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет создать начальный образ нового узла распределенной информационной базы 
		|с отборами (по проектам, пользователям и т.д.).'");
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена для СППР (с отборами)";
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = ПоясняющийТекст;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.РИБСОтборами.Форма.ПодробнаяИнформация";
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = "";
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база с фильтрами'");
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "https://users.v8.1c.ru/distribution/project/Modeling";
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "\1c\Modeling";
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена = "Создание узла распределенной информационной базы";
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = "Создать узел распределенной информационной базы";
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена = "Настройка узла распределенной информационной базы";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
Функция ОбщиеДанныеУзлов()
	
	ДанныеУзлов = Новый Массив;
	
	ДанныеУзлов.Добавить("ИспользоватьОтборПоПроектам");
	ДанныеУзлов.Добавить("ИспользоватьСкрытиеИменПользователей");
	ДанныеУзлов.Добавить("СинхронизироватьДополнительныеОтчетыИОбработки");
	ДанныеУзлов.Добавить("СинхронизироватьРезультатыПроверкиОбъектов");
	ДанныеУзлов.Добавить("ИспользоватьОтборПоГруппамДоступа");
	ДанныеУзлов.Добавить("ИспользоватьОтборПоПапкамФайлов");
	ДанныеУзлов.Добавить("ИспользоватьОтборПоРазделамПроектов");
	ДанныеУзлов.Добавить("Проекты");
	ДанныеУзлов.Добавить("Пользователи");
	ДанныеУзлов.Добавить("ПапкиФайлов");
	ДанныеУзлов.Добавить("ГруппыДоступа");
	ДанныеУзлов.Добавить("РазделыПроектов");
	
	Возврат СтрСоединить(ДанныеУзлов,",");
	
КонецФункции

// Определяет несколько вариантов настройки расписания выполнения обмена данными;
// Рекомендуется указывать не более 3 вариантов;
// Эти варианты должны быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  ВариантыНастройки - СписокЗначений - список расписаний обмена данными
//
Функция ВариантыНастройкиРасписания() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	// Расписание №1
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание1 = Новый РасписаниеРегламентногоЗадания;
	Расписание1.ДниНедели                = ДниНедели;
	Расписание1.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание1.ПериодПовтораДней        = 1; // каждый день
	Расписание1.Месяцы                   = Месяцы;
	
	// Расписание №2
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание2 = Новый РасписаниеРегламентногоЗадания;
	Расписание2.ВремяНачала              = Дата('00010101080000');
	Расписание2.ВремяКонца               = Дата('00010101200000');
	Расписание2.ПериодПовтораВТечениеДня = 3600; // каждый час
	Расписание2.ПериодПовтораДней        = 1; // каждый день
	Расписание2.ДниНедели                = ДниНедели;
	Расписание2.Месяцы                   = Месяцы;
	
	// Расписание №3
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	
	Расписание3 = Новый РасписаниеРегламентногоЗадания;
	Расписание3.ДниНедели         = ДниНедели;
	Расписание3.ВремяНачала       = Дата('00010101020000');
	Расписание3.ПериодПовтораДней = 1; // каждый день
	Расписание3.Месяцы            = Месяцы;
	
	// возвращаемое значение функции
	ВариантыНастройки = Новый СписокЗначений;
	
	ВариантыНастройки.Добавить(Расписание1, "Один раз в 15 минут, кроме субботы и воскресенья");
	ВариантыНастройки.Добавить(Расписание2, "Каждый час с 8:00 до 20:00, ежедневно");
	ВариантыНастройки.Добавить(Расписание3, "Каждую ночь в 2:00, кроме субботы и воскресенья");
	
	Возврат ВариантыНастройки;
	
КонецФункции

// Определяет версию платформы базы-приемника для создания СОМ-подключения;
// Возможные варианты возвращаемого значения: "V81"; "V82"
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 3 - версия платформы базы-приемника (V81; V82)
//
Функция ВерсияПлатформыИнформационнойБазы() Экспорт
	
	Возврат "V82";
	
КонецФункции

Функция ПрефиксНастройкиОбменаДанными() Экспорт
	
	Возврат "В";
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	Возврат ОбменДаннымиСППРКлиентСервер.ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле);
КонецФункции

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	
	Возврат "";
	
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Возврат "";
	
КонецФункции

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	
	Возврат Новый Структура("ВсеСправочники, ДетальныйОтбор", Ложь, Неопределено);
	
КонецФункции

// Заполняет таблицу формы, которая показывает текущие ограничения выгрузки данных по проекту.
Процедура ЗаполнитьТаблицуСинхронизацияПоПроекту(СинхронизацияПоПроекту) Экспорт
	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Тех.проекты'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "ТехническиеПроекты";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Задачи'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "Задачи";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Ошибки'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "Ошибки";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Целевые задачи'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "ЦелевыеЗадачи";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Идеи'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "Идеи";
	
	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Регламенты'");
	СтрТаб.ЕстьПубликуемые = Истина;
	СтрТаб.Постфикс = "Регламенты"; 

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Функц.модель'");
	СтрТаб.ЕстьПубликуемые = Ложь;
	СтрТаб.Постфикс = "ФункциональнуюМодель";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Данные учета времени'");
	СтрТаб.ЕстьПубликуемые = Ложь;
	СтрТаб.Постфикс = "ДанныеУчетаВремени";

	СтрТаб = СинхронизацияПоПроекту.Добавить();
	СтрТаб.ЭлементДанных = НСтр("ru='Календари'");
	СтрТаб.ЕстьПубликуемые = Ложь;
	СтрТаб.Постфикс = "Календари";

КонецПроцедуры

#КонецОбласти

#КонецЕсли