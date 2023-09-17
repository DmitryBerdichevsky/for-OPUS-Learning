﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	НеРедактируемыеРеквизиты.Добавить("Владелец");
	НеРедактируемыеРеквизиты.Добавить("ХранилищеОписания");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

Функция СформироватьПечатныеФормы(МассивОбъектов, СУчетомПриемника=Ложь, ДанныеСоответствия=Неопределено) Экспорт
	
	ПечатныеФормы = Новый Соответствие;
	
	ТекстЗапроса = ТекстЗапросаДляФормированияОписания(СУчетомПриемника);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Если СУчетомПриемника Тогда
		Запрос.УстановитьПараметр("ТаблицаСоответствияВидовДоступа", ДанныеСоответствия.ВидыДоступа);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Документ = Новый ТабличныйДокумент;
		ОбработатьЭлементВыборки(Выборка, Документ, Ложь);
		
		СтруктураПечатныхФорм = Новый Структура;
		СтруктураПечатныхФорм.Вставить("Описание", Документ);
		СтруктураПечатныхФорм.Вставить("ОписаниеПриемника", Неопределено);

		Если СУчетомПриемника И ЗначениеЗаполнено(Выборка.ПриемникСсылка) Тогда
			ДокументПриемника = Новый ТабличныйДокумент;
			ОбработатьЭлементВыборки(Выборка, ДокументПриемника, Истина);
			СтруктураПечатныхФорм.Вставить("ОписаниеПриемника", ДокументПриемника);
		КонецЕсли;
		
		ПечатныеФормы.Вставить(Выборка.Ссылка, СтруктураПечатныхФорм);
	КонецЦикла;
	
	Возврат ПечатныеФормы;
	
КонецФункции

// Выполняет печать описаний и схем переданных объектов
//
// Параметры:
//  МассивОбъектов - массив объектов, подлежащих печати
//
Процедура Печать(МассивОбъектов, ПечатныеФормы) Экспорт
	
	СоответствиеПечатныхФорм = СформироватьПечатныеФормы(МассивОбъектов);
	
	ПечатныеФормы = Новый Массив;
	
	Для Каждого ЭлементСоответствия из СоответствиеПечатныхФорм Цикл
		ПечатныеФормы.Добавить(ЭлементСоответствия.Значение.Описание);
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьПредустановленныеВидыДоступа(Проект) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыДоступа.Ссылка КАК Ссылка,
	|	ВидыДоступа.Имя КАК Имя
	|ИЗ
	|	Справочник.ВидыДоступа КАК ВидыДоступа
	|ГДЕ
	|	ВидыДоступа.Имя В (&МассивИмен)
	|	И ВидыДоступа.Владелец = &Проект"
	;
	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("Пользователи");
	МассивИмен.Добавить("ВнешниеПользователи");
	МассивИмен.Добавить("ПоОбъектуДоступа");
	МассивИмен.Добавить("ПоУсловию");
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивИмен", МассивИмен);
	Запрос.УстановитьПараметр("Проект", Проект);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаРезультата.Найти("Пользователи", "Имя") = Неопределено Тогда
		ВидДоступа = Справочники.ВидыДоступа.СоздатьЭлемент();
		ВидДоступа.Наименование = "Пользователи";
		ВидДоступа.Имя = "Пользователи";
		ВидДоступа.Владелец = Проект;
		ВидДоступа.Записать();
	КонецЕсли;
	
	Если ТаблицаРезультата.Найти("ВнешниеПользователи", "Имя") = Неопределено Тогда
		ВидДоступа = Справочники.ВидыДоступа.СоздатьЭлемент();
		ВидДоступа.Наименование = "Внешние пользователи";
		ВидДоступа.Имя = "ВнешниеПользователи";
		ВидДоступа.Владелец = Проект;
		ВидДоступа.Записать();
	КонецЕсли;
	
	Если ТаблицаРезультата.Найти("ПоОбъектуДоступа", "Имя") = Неопределено Тогда
		ВидДоступа = Справочники.ВидыДоступа.СоздатьЭлемент();
		ВидДоступа.Наименование = "<Объект>";
		ВидДоступа.Имя = "ПоОбъектуДоступа";
		ВидДоступа.Владелец = Проект;
		ВидДоступа.Записать();
	КонецЕсли;
	
	Если ТаблицаРезультата.Найти("ПоУсловию", "Имя") = Неопределено Тогда
		ВидДоступа = Справочники.ВидыДоступа.СоздатьЭлемент();
		ВидДоступа.Наименование = "<Условие>";
		ВидДоступа.Имя = "ПоУсловию";
		ВидДоступа.Владелец = Проект;
		ВидДоступа.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПредопределенныеВидыДоступа(Проект) Экспорт
	
	Результат = Новый Соответствие;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыДоступа.Ссылка КАК Ссылка,
	|	ВидыДоступа.Имя КАК Имя
	|ИЗ
	|	Справочник.ВидыДоступа КАК ВидыДоступа
	|ГДЕ
	|	ВидыДоступа.Имя В(&ИменаПредопределенных)
	|	И ВидыДоступа.Владелец = &Проект"
	;
	
	ИменаПредопределенных = Новый массив;
	ИменаПредопределенных.Добавить("Пользователи");
	ИменаПредопределенных.Добавить("ВнешниеПользователи");
	ИменаПредопределенных.Добавить("ПоОбъектуДоступа");
	ИменаПредопределенных.Добавить("ПоУсловию");
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИменаПредопределенных", ИменаПредопределенных);
	Запрос.УстановитьПараметр("Проект", Проект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Имя, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Результат;
	
КОнецФункции

Функция ВидДоступаЯвляетсяПредопределенным(Имя) Экспорт
	
	Если Имя = "Пользователи"
		ИЛИ Имя = "ВнешниеПользователи"
		ИЛИ Имя = "ПоОбъектуДоступа"
		ИЛИ Имя = "ПоУсловию" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

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

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаДляФормированияОписания(СУчетомПриемника)
	
	Если СУчетомПриемника Тогда
	
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаСоответствияВидовДоступа.Источник КАК Источник,
		|	ТаблицаСоответствияВидовДоступа.Приемник КАК Приемник
		|ПОМЕСТИТЬ ВТСоответствиеВидовДоступа
		|ИЗ
		|	&ТаблицаСоответствияВидовДоступа КАК ТаблицаСоответствияВидовДоступа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыДоступа.Ссылка КАК Ссылка,
		|	ВидыДоступаПриемник.Ссылка КАК ПриемникСсылка,
		|	ВидыДоступа.Код КАК Код,
		|	ВидыДоступаПриемник.Код КАК ПриемникКод,
		|	ВидыДоступа.Наименование КАК Наименование,
		|	ВидыДоступаПриемник.Наименование КАК ПриемникНаименование,
		|	ВидыДоступа.Описание КАК Описание,
		|	ВидыДоступаПриемник.Описание КАК ПриемникОписание,
		|	ВидыДоступа.Имя КАК Имя,
		|	ВидыДоступаПриемник.Имя КАК ПриемникИмя,
		|	ВидыДоступа.ИмеетПредустановленныеЗначения КАК ИмеетПредустановленныеЗначения,
		|	ЕСТЬNULL(ВидыДоступаПриемник.ИмеетПредустановленныеЗначения, Ложь) КАК ПриемникИмеетПредустановленныеЗначения,
		|	ВидыДоступа.РазделПроекта КАК РазделПроекта,
		|	ВидыДоступаПриемник.РазделПроекта КАК ПриемникРазделПроекта,
		|	ВидыДоступа.ТипыЗначенийРеквизитов.(
		|		""Тип значения реквизита"" КАК ВидПодраздела,
		|		"""" КАК НомерПодраздела,
		|		ТипЗначенияРеквизита.Наименование КАК ЗаголовокПодраздела,
		|		ТипЗначенияРеквизита КАК Ссылка,
		|		"""" КАК Текст1,
		|		"""" КАК Текст2,
		|		NULL КАК Гиперссылка,
		|		ЕСТЬNULL(ТипЗначенияРеквизита.ПометкаУдаления, ЛОЖЬ) КАК ПометкаУдаления,
		|		"""" КАК СлужебнаяИнформация,
		|		ТипЗначенияРеквизита.Родитель.Код КАК КодРодителя
		|	) КАК ТипыЗначенийРеквизитов,
		|	ВидыДоступаПриемник.ТипыЗначенийРеквизитов.(
		|		""Тип значения реквизита"" КАК ВидПодраздела,
		|		"""" КАК НомерПодраздела,
		|		ТипЗначенияРеквизита.Наименование КАК ЗаголовокПодраздела,
		|		ТипЗначенияРеквизита КАК Ссылка,
		|		"""" КАК Текст1,
		|		"""" КАК Текст2,
		|		NULL КАК Гиперссылка,
		|		ЕСТЬNULL(ТипЗначенияРеквизита.ПометкаУдаления, ЛОЖЬ) КАК ПометкаУдаления,
		|		"""" КАК СлужебнаяИнформация,
		|		ТипЗначенияРеквизита.Родитель.Код КАК КодРодителя
		|	) КАК ПриемникТипыЗначенийРеквизитов,
		|	ВидыДоступа.РазделыПроекта.(
		|		Раздел КАК Раздел
		|	) КАК РазделыПроекта,
		|	ВидыДоступаПриемник.РазделыПроекта.(
		|		Раздел КАК Раздел
		|	) КАК ПриемникРазделыПроекта
		|ИЗ
		|	Справочник.ВидыДоступа КАК ВидыДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСоответствиеВидовДоступа КАК ВТСоответствиеВидовДоступа
		|		ПО ВидыДоступа.Ссылка = ВТСоответствиеВидовДоступа.Источник
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыДоступа КАК ВидыДоступаПриемник
		|		ПО (ВТСоответствиеВидовДоступа.Приемник = ВидыДоступаПриемник.Ссылка)
		|ГДЕ
		|	ВидыДоступа.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код"
		;
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыДоступа.Ссылка КАК Ссылка,
		|	ВидыДоступа.Код КАК Код,
		|	ВидыДоступа.Наименование КАК Наименование,
		|	ВидыДоступа.Описание КАК Описание,
		|	ВидыДоступа.Имя КАК Имя,
		|	ВидыДоступа.ИмеетПредустановленныеЗначения,
		|	ВидыДоступа.РазделПроекта КАК РазделПроекта,
		|	ВидыДоступа.ТипыЗначенийРеквизитов.(
		|		""Тип значения реквизита"" КАК ВидПодраздела,
		|		"""" КАК НомерПодраздела,
		|		ТипЗначенияРеквизита.Наименование КАК ЗаголовокПодраздела,
		|		ТипЗначенияРеквизита КАК Ссылка,
		|		"""" КАК Текст1,
		|		"""" КАК Текст2,
		|		NULL КАК Гиперссылка,
		|		ЕСТЬNULL(ТипЗначенияРеквизита.ПометкаУдаления, ЛОЖЬ) КАК ПометкаУдаления,
		|		"""" КАК СлужебнаяИнформация,
		|		ТипЗначенияРеквизита.Родитель.Код КАК КодРодителя
		|	) КАК ТипыЗначенийРеквизитов,
		|	ВидыДоступа.РазделыПроекта.(
		|		Раздел КАК Раздел
		|	)
		|ИЗ
		|	Справочник.ВидыДоступа КАК ВидыДоступа
		|ГДЕ
		|	ВидыДоступа.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код"
		;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура СформироватьОписаниеОбъекта(Выборка, Документ, ДляПриемника)
	
	// Заголовок документа
	ИмяПоля = ?(ДляПриемника, "ПриемникСсылка", "Ссылка");
	ОписаниеОбъектов.ВывестиЗаголовокОбъекта(НСтр("ru='Вид доступа'"), Выборка[ИмяПоля], , Документ);
	
	// Имя
	ОписаниеОбъектов.ВывестиЗаголовокРаздела(НСтр("ru='Имя'"), Документ);
	ИмяПоля = ?(ДляПриемника, "ПриемникИмя", "Имя");
	ОписаниеОбъектов.ВывестиТекстПоАбзацам(Выборка[ИмяПоля], , Документ);
	
	// Разделы проекта
	ОписаниеОбъектов.ВывестиЗаголовокРаздела(НСтр("ru='Раздел проекта'"), Документ);
	ИмяПоля = ?(ДляПриемника, "ПриемникРазделПроекта", "РазделПроекта");
	ОписаниеОбъектов.ВывестиТекстПоАбзацам(Выборка[ИмяПоля], 1, Документ, Выборка[ИмяПоля]);
	
	ИмяТЧ = ?(ДляПриемника, "ПриемникРазделыПроекта", "РазделыПроекта");
	РазделыПроекта = Выборка[ИмяТЧ].Выгрузить();
	
	Если РазделыПроекта.Количество()>0 Тогда
		ОписаниеОбъектов.ВывестиЗаголовокРаздела(НСтр("ru='Дополнительные разделы'"), Документ);
		
		Для Каждого СтрокаТЧ из РазделыПроекта Цикл
			ОписаниеОбъектов.ВывестиТекстПоАбзацам(СтрокаТЧ.Раздел, 1, Документ, СтрокаТЧ.Раздел);
		КонецЦикла;
	КонецЕсли;
	
	// Описание
	ОписаниеОбъектов.ВывестиЗаголовокРаздела(НСтр("ru='Описание вида доступа'"), Документ);
	ИмяПоля = ?(ДляПриемника, "ПриемникОписание", "Описание");
	ОписаниеОбъектов.ВывестиТекстПоАбзацам(Выборка[ИмяПоля], , Документ);
	
	// Вывод табличной части
	ИмяТЧ = ?(ДляПриемника, "ПриемникТипыЗначенийРеквизитов", "ТипыЗначенийРеквизитов");
	ТипыЗначенийРеквизитов = Выборка[ИмяТЧ].Выгрузить();
	ТипыЗначенийРеквизитов.Сортировать("КодРодителя, ЗаголовокПодраздела");
	
	Если ТипыЗначенийРеквизитов.Количество() > 0 Тогда
		ОписаниеОбъектов.ВывестиЗаголовокРаздела(НСтр("ru='Типы значений реквизитов'"), Документ);
		ОписаниеОбъектов.ВывестиПодразделы(ТипыЗначенийРеквизитов, , , Документ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьЭлементВыборки(Выборка, Документ, ДляПриемника)
	
	ОписаниеОбъектов.НастроитьОписаниеОбъекта(Документ);
	Документ.НачатьАвтогруппировкуСтрок();
	
	СформироватьОписаниеОбъекта(Выборка, Документ, ДляПриемника);
	
	Документ.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли