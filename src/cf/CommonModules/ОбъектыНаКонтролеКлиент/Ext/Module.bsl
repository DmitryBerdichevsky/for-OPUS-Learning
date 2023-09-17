﻿////////////////////////////////////////////////////////////////////////////////
//  Клиентские процедуры и функции подсистемы "Объекты на контроле"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет команду поставки объекта на контроль из формы элемента.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма в которой была выполнена команда.
//  Команда - Команда - выполняемая команда.
//
Процедура ВыполнитьКомандуПостановкиНаКонтрольИзФормыОбъекта(Форма, Команда) Экспорт
	
	ОчиститьСообщения();
	
	СпискиКонтроля = Форма.СпискиКонтроля;
	
	НомерСписка = Число(Прав(Команда.Имя, СтрДлина(Команда.Имя) - СтрДлина("ПоставитьНаКонтроль_")));
	
	ДанныеСписка = СпискиКонтроля[НомерСписка];
	
	Если ДанныеСписка.СтатусКонтроля <> "НеНаКонтроле" Тогда
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СписокКонтроля", ДанныеСписка.СписокКонтроля);
		ПараметрыФормы.Вставить("ОбъектКонтроля", Форма.Объект.Ссылка);
	
		ОткрытьФорму("Обработка.КонтрольОбъектов.Форма.ИсторияКонтроля", ПараметрыФормы,
		             Форма,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ПараметрыПостановкиНаКонтроль = ОбъектыНаКонтролеКлиентСервер.НовыйПараметрыПостановкиНаКонтроль();
		
		ОбъектыКонтроля = Новый Массив;
		ОбъектыКонтроля.Добавить(Форма.Объект.Ссылка);
		
		ПараметрыПостановкиНаКонтроль.СписокКонтроля = ДанныеСписка.СписокКонтроля;
		ПараметрыПостановкиНаКонтроль.ОбъектКонтроля = ОбъектыКонтроля;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма",                         Форма);
		ДополнительныеПараметры.Вставить("СпискиКонтроля",                СпискиКонтроля);
		ДополнительныеПараметры.Вставить("ПараметрыПостановкиНаКонтроль", ПараметрыПостановкиНаКонтроль);
		ДополнительныеПараметры.Вставить("ДанныеСписка",                  ДанныеСписка);
		
		ОписаниеОбработчикаУказанияРешения = Новый ОписаниеОповещения("ПослеВыбораТекущегоРешенияПриПостановкеОбъектаНаКонтрольИзФормыОбъекта",
		                                                              ЭтотОбъект,
		                                                              ДополнительныеПараметры);
		
		ОткрытьФорму("Обработка.КонтрольОбъектов.Форма.РешениеПриПостановкеНаКонтроль", ПараметрыПостановкиНаКонтроль, Форма,,,,
		             ОписаниеОбработчикаУказанияРешения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет команду поставки объекта на контроль из формы списка.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма в которой была выполнена команда.
//  Команда - Команда - выполняемая команда.
//
Процедура ВыполнитьКомандуПостановкиНаКонтрольИзФормыСписка(Форма, Команда) Экспорт
	
	ОчиститьСообщения();
	
	СпискиКонтроля = Форма.СпискиКонтроля;
	
	ДанныеКоманды = СтрРазделить(Команда.Имя, "_", Ложь);
	Если ДанныеКоманды.Количество() < 3 Тогда
		Возврат;
	КонецЕсли;
	
	НомерСписка  = Число(ДанныеКоманды[2]);
	ИмяСписка    = ДанныеКоманды[1];
	ДанныеСписка = СпискиКонтроля[НомерСписка];
	
	ОбъектыКПостановке = Новый Массив;
	ВыделенныеСтроки = Форма.Элементы[ИмяСписка].ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка")
			И ЗначениеЗаполнено(ВыделеннаяСтрока)Тогда
			
			ОбъектыКПостановке.Добавить(ВыделеннаяСтрока);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбъектыКПостановке.Количество() > 0 Тогда
		
		ДанныеОбъектовКПостановке = ОбъектыНаКонтролеВызовСервера.ДанныеОбъектовКонтроляДляПостановкиНаКонтроль(ОбъектыКПостановке, ДанныеСписка.СписокКонтроля);
		ЕстьОбъектыНеНаКонтроле = Ложь;
		Для Каждого ДанныеОбъектаКПостановке Из ДанныеОбъектовКПостановке Цикл
			Если ДанныеОбъектаКПостановке.СтатусКонтроля = "НеНаКонтроле" Тогда
				ЕстьОбъектыНеНаКонтроле = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьОбъектыНеНаКонтроле Тогда
			ВывестиИнформациюНетОбъектовКПостановкеИзФормыСписка(ДанныеОбъектовКПостановке);
			Возврат;
		КонецЕсли;
		
		ПараметрыПостановкиНаКонтроль = ОбъектыНаКонтролеКлиентСервер.НовыйПараметрыПостановкиНаКонтроль();
		
		ПараметрыПостановкиНаКонтроль.СписокКонтроля = ДанныеСписка.СписокКонтроля;
		ПараметрыПостановкиНаКонтроль.ОбъектКонтроля = ОбъектыКПостановке;
		ПараметрыПостановкиНаКонтроль.ДатаКонтроля = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма",          Форма);
		ДополнительныеПараметры.Вставить("СписокКонтроля", ДанныеСписка.СписокКонтроля);
		
		ОписаниеОбработчикаУказанияРешения = Новый ОписаниеОповещения("ПослеВыбораТекущегоРешенияПриПостановкеОбъектаНаКонтрольИзФормыСписка",
		                                                              ЭтотОбъект,
		                                                              ДополнительныеПараметры);
		
		ОткрытьФорму("Обработка.КонтрольОбъектов.Форма.РешениеПриПостановкеНаКонтроль", ПараметрыПостановкиНаКонтроль, Форма,,,,
		             ОписаниеОбработчикаУказанияРешения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ТекстОповещения = СтрШаблон(НСтр("ru = 'Ни один объект не поставлен на контроль'"));
		ПоказатьОповещениеПользователя(НСтр("ru = 'Постановка объектов на контроль'") ,, ТекстОповещения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет команду открытия истории контроля.
//
// Параметры:
//  ЭлементФормыСписок  - ТаблицаФормы - список, из которого была вызвана команда.
//
Процедура ОткрытьИсториюКонтроляИзСпискаКонтроля(ЭлементФормыСписок) Экспорт
	
	ТекущиеДанные = ЭлементФормыСписок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементФормыСписок.ТекущаяСтрока) <> Тип("РегистрСведенийКлючЗаписи.ОбъектыНаКонтроле") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокКонтроля", ТекущиеДанные.СписокКонтроля);
	ПараметрыФормы.Вставить("ОбъектКонтроля", ТекущиеДанные.ОбъектКонтроля);
	
	ОткрытьФорму("Обработка.КонтрольОбъектов.Форма.ИсторияКонтроля", ПараметрыФормы,
	             ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Формирует массив строк динамического списка, для которых выполняется команда постановки на контроль
//
// Параметры:
//  ЭлементФормыСписок  - ТаблицаФормы - список, из которого была вызвана команда.
//  Отказ  - Булево - признак невозможности выполнить команду.
//
// Возвращаемое значение:
//   Массив   - содержит ключи записей РС "Объекты на контроле"
//
Функция ИзменяемыеСтрокиСписка(ЭлементФормыСписок, Отказ) Экспорт

	ВыделенныеСтроки = ЭлементФормыСписок.ВыделенныеСтроки;
	СтрокиКИзменению = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("РегистрСведенийКлючЗаписи.ОбъектыНаКонтроле") Тогда
			СтрокиКИзменению.Добавить(ВыделеннаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокиКИзменению.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрано ни одной записи контроля для изменения'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, ЭлементФормыСписок.Имя,, Отказ);
	КонецЕсли;
	
	Возврат СтрокиКИзменению;

КонецФункции

// Определяет данные изменяемой записи, елси она одна
//
// Параметры:
//  ЭлементФормыСписок      - ТаблицаФормы - список, из которого была вызвана команда.
//  ИзменяемыеСтрокиСписка  - Массив - содержит ключи строк, для которых выполняется команда
//
// Возвращаемое значение:
//   Структура - см.ОбъектыНаКонтролеКлиентСервер.НовыйДанныеЗаписиКонтроля
//
Функция ДанныеИзменяемыхСтрок(ЭлементФормыСписок, ИзменяемыеСтрокиСписка) Экспорт

	Если ИзменяемыеСтрокиСписка.Количество() = 1 Тогда
		
		ДанныеЗаписи = ОбъектыНаКонтролеКлиентСервер.НовыйДанныеЗаписиКонтроля();
		ДанныеСтроки = ЭлементФормыСписок.ДанныеСтроки(ИзменяемыеСтрокиСписка[0]);
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаписи, ДанныеСтроки);
		
		Возврат ДанныеЗаписи;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВывестиИнформациюНетОбъектовКПостановкеИзФормыСписка(ДанныеОбъектовКПостановке)
	
	Для Каждого ДанныеОбъектаКПостановке Из ДанныеОбъектовКПостановке Цикл
		
		ТекстСообщения = ОбъектыНаКонтролеКлиентСервер.ТекстСообщенияОбъектУжеНаКонтроле(ДанныеОбъектаКПостановке.СтатусКонтроля,
		                                                                                 ДанныеОбъектаКПостановке.ОбъектКонтроля);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ДанныеОбъектаКПостановке.ОбъектКонтроля);
		
	КонецЦикла;
	
	ТекстОповещения = СтрШаблон(НСтр("ru = 'Ни один объект не поставлен на контроль'"));
	ПоказатьОповещениеПользователя(НСтр("ru = 'Постановка объектов на контроль'") ,, ТекстОповещения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

Процедура ПослеВыбораТекущегоРешенияПриПостановкеОбъектаНаКонтрольИзФормыОбъекта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено 
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеОбъектовДляПостановкиНаКонтроль = Новый Массив;
	Для Каждого ДанныеОбъекта Из Результат.ОбъектыКонтроля Цикл
		
		ПараметрыПостановки = ОбъектыНаКонтролеКлиентСервер.НовыйПараметрыПостановкиНаКонтроль();
		ПараметрыПостановки.СписокКонтроля          = ДополнительныеПараметры.ДанныеСписка.СписокКонтроля;
		ПараметрыПостановки.ОбъектКонтроля          = ДанныеОбъекта.ОбъектКонтроля;
		ПараметрыПостановки.Ответственный           = ДанныеОбъекта.Ответственный;
		ПараметрыПостановки.ТехническийПроект       = ДанныеОбъекта.ТехническийПроект;
		ПараметрыПостановки.ОжидаемаяДатаВыполнения = ДанныеОбъекта.ОжидаемаяДатаВыполнения;
		ПараметрыПостановки.Решение                 = Результат.Решение;
		ПараметрыПостановки.СтатусКонтроля          = ДанныеОбъекта.СтатусКонтроля;
		
		ДанныеОбъектовДляПостановкиНаКонтроль.Добавить(ПараметрыПостановки);
		
	КонецЦикла;
	
	ОбъектыНаКонтролеВызовСервера.РезультатПостановкиМассиваОбъектовНаКонтроль(ДанныеОбъектовДляПостановкиНаКонтроль);
	
	ДополнительныеПараметры.ДанныеСписка.СтатусКонтроля = "НаКонтроле";
	
	ТекстОповещения = НСтр("ru = 'Объект поставлен на контроль'");
	ПоказатьОповещениеПользователя(НСтр("ru = 'Постановка объекта на контроль'") ,, ТекстОповещения, БиблиотекаКартинок.Информация32);
	
	ОбъектыНаКонтролеКлиентСервер.ОбновитьЭлементыФормыПоставитьНаКонтроль(ДополнительныеПараметры.Форма, ДополнительныеПараметры.СпискиКонтроля);
	
КонецПроцедуры

Процедура ПослеВыбораТекущегоРешенияПриПостановкеОбъектаНаКонтрольИзФормыСписка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено 
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеОбъектовДляПостановкиНаКонтроль = Новый Массив;
	Для Каждого ДанныеОбъекта Из Результат.ОбъектыКонтроля Цикл
		
		ПараметрыПостановки = ОбъектыНаКонтролеКлиентСервер.НовыйПараметрыПостановкиНаКонтроль();
		ПараметрыПостановки.СписокКонтроля          = ДополнительныеПараметры.СписокКонтроля;
		ПараметрыПостановки.ОбъектКонтроля          = ДанныеОбъекта.ОбъектКонтроля;
		ПараметрыПостановки.Ответственный           = ДанныеОбъекта.Ответственный;
		ПараметрыПостановки.ТехническийПроект       = ДанныеОбъекта.ТехническийПроект;
		ПараметрыПостановки.ОжидаемаяДатаВыполнения = ДанныеОбъекта.ОжидаемаяДатаВыполнения;
		ПараметрыПостановки.Решение                 = Результат.Решение;
		ПараметрыПостановки.СтатусКонтроля          = ДанныеОбъекта.СтатусКонтроля;
		
		ДанныеОбъектовДляПостановкиНаКонтроль.Добавить(ПараметрыПостановки);
		
	КонецЦикла;
	
	РезультатПостановкиНаКонтроль = ОбъектыНаКонтролеВызовСервера.РезультатПостановкиМассиваОбъектовНаКонтроль(ДанныеОбъектовДляПостановкиНаКонтроль);
		
	Если РезультатПостановкиНаКонтроль.ПоставленоНаКонтроль = 0 Тогда
		
		ТекстОповещения = СтрШаблон(НСтр("ru = 'Ни один объект не поставлен на контроль'"));
		
		Если ДанныеОбъектовДляПостановкиНаКонтроль.Количество() = 1 Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СписокКонтроля", ДополнительныеПараметры.СписокКонтроля);
			ПараметрыФормы.Вставить("ОбъектКонтроля", ДанныеОбъектовДляПостановкиНаКонтроль[0].ОбъектКонтроля);
		
			ОткрытьФорму("Обработка.КонтрольОбъектов.Форма.ИсторияКонтроля", ПараметрыФормы,
			             ДополнительныеПараметры.Форма,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
		КонецЕсли;
			
	Иначе
		
		ТекстОповещения = СтрШаблон(НСтр("ru = 'Поставлено объектов на контроль - %1 из %2'"), 
		                            РезультатПостановкиНаКонтроль.ПоставленоНаКонтроль, 
		                            РезультатПостановкиНаКонтроль.ВсегоОбъектов);
		
	КонецЕсли;
	
	Если ДанныеОбъектовДляПостановкиНаКонтроль.Количество() > 1 Тогда
		
		Для Каждого ДанныеСообщения Из РезультатПостановкиНаКонтроль.СообщенияПользователю Цикл
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеСообщения.ТекстСообщения, ДанныеСообщения.ОбъектКонтроля);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Постановка объектов на контроль'") ,, ТекстОповещения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

