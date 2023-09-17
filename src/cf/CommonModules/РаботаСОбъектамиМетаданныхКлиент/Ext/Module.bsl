﻿#Область ПрограммныйИнтерфейс

Функция ПараметрыЗаполненияТаблицыОбъектов() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыВыполнения", Новый Структура("Вариант"));
	Результат.Вставить("Действие");
	
	Возврат Результат; 
	
КонецФункции

Процедура ЗаполнитьТаблицуОбъектовМетаданных(ТаблицаОбъектов, ПараметрыВыполнения) Экспорт
	
	Если ТаблицаОбъектов.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список объектов не пуст.'");
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Очистить'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Оставить существующие строки'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
		ПараметрыОповещения.Вставить("ТаблицаОбъектов", ТаблицаОбъектов);
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьТаблицуОбъектовОбъектыЗавершение", ЭтотОбъект, ПараметрыОповещения),
						ТекстВопроса,
						СписокКнопок);
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьПоРезультатамПоиска(ПараметрыВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуОбъектовОбъектыЗавершение(ОчиститьТаблицу, ДополнительныеПараметры) Экспорт
	
	Если ОчиститьТаблицу = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли ОчиститьТаблицу = КодВозвратаДиалога.Да Тогда
		ДополнительныеПараметры.ТаблицаОбъектов.Очистить();
	КонецЕсли;
	
	ЗаполнитьПоРезультатамПоиска(ДополнительныеПараметры.ПараметрыВыполнения)
	
КонецПроцедуры

Процедура ЗаполнитьПоРезультатамПоиска(Параметры)
	
	ОбработчикВвода = Новый ОписаниеОповещения("ЗаполнитьПоРезультатамПоискаЗавершение", ЭтотОбъект, Параметры);
	
	Если Параметры.ПараметрыВыполнения.Вариант = "ГлобальныйПоиск" Тогда
		ЗаголовокДиалога = НСтр("ru = 'Вставьте результаты глобального поиска по конфигурации'");
	ИначеЕсли Параметры.ПараметрыВыполнения.Вариант = "ПоискСсылок" Тогда 
		ЗаголовокДиалога = НСтр("ru = 'Вставьте результаты поиска ссылок на объект'");
	ИначеЕсли Параметры.ПараметрыВыполнения.Вариант = "СписокОбъектов" Тогда 
		ЗаголовокДиалога = НСтр("ru = 'Вставьте список объектов для захвата'");
	Иначе
		ТекстИсключения = НСтр("ru = 'Неизвестный вариант вызова'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(ОбработчикВвода, "", ЗаголовокДиалога);
	
КонецПроцедуры

Процедура ЗаполнитьПоРезультатамПоискаЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ПараметрыВыполнения.Действие, Результат);
	
КонецПроцедуры

#КонецОбласти
