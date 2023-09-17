﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	НеРедактируемыеРеквизиты.Добавить("Владелец");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтрольныеТочкиТехническихПроектов.Ссылка,
	|	КонтрольныеТочкиТехническихПроектов.Код КАК Код,
	|	КонтрольныеТочкиТехническихПроектов.Наименование
	|ИЗ
	|	Справочник.КонтрольныеТочкиТехническихПроектов КАК КонтрольныеТочкиТехническихПроектов
	|ГДЕ
	|	НЕ КонтрольныеТочкиТехническихПроектов.ПометкаУдаления
	|	И КонтрольныеТочкиТехническихПроектов.Используется
	|	И (НЕ &ОтбиратьПоНаименованию
	|			ИЛИ КонтрольныеТочкиТехническихПроектов.Наименование ПОДОБНО &СтрокаПоиска)
	|	И (НЕ &ОтбиратьПоПроектам
	|			ИЛИ КонтрольныеТочкиТехническихПроектов.Владелец = &Проект)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код"
	;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Запрос.УстановитьПараметр("Проект", Параметры.Отбор.Владелец);
		Запрос.УстановитьПараметр("ОтбиратьПоПроектам", Истина);
	Иначе
		Запрос.УстановитьПараметр("Проект", Неопределено);
		Запрос.УстановитьПараметр("ОтбиратьПоПроектам", Ложь);
	КонецЕсли;
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("ОтбиратьПоНаименованию", Истина);
	Иначе
		Запрос.УстановитьПараметр("СтрокаПоиска", "");
		Запрос.УстановитьПараметр("ОтбиратьПоНаименованию", Ложь);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений();
		
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Код) + ". " + Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
