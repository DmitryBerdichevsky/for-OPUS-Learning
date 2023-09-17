﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область МаксимальныйСтатусЗадачи

Процедура РассчитатьВсеМаксимальныеСтатусыЗадач(ОпределятьНаправлениеИсполнителю = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗадачиПроцесса.Предмет КАК Предмет
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		РассчитатьМаксимальныйСтатусЗадачПоПредмету(Выборка.Предмет, ОпределятьНаправлениеИсполнителю);
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьМаксимальныйСтатусЗадачПоПредмету(Предмет, ОпределятьНаправлениеИсполнителю = Истина) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	ЗадачиПроцесса.Ссылка
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|ГДЕ
	|	ЗадачиПроцесса.Предмет = &Предмет";
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	МассивРассчитываемыхЗадач = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	РассчитатьМаксимальныйСтатусМассиваЗадач(МассивРассчитываемыхЗадач, ОпределятьНаправлениеИсполнителю);
	
КонецПроцедуры

Процедура РассчитатьМаксимальныйСтатусМассиваЗадач(МассивРассчитываемыхЗадач, ОпределятьНаправлениеИсполнителю = Истина) Экспорт

	Если МассивРассчитываемыхЗадач.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю = Новый ТаблицаЗначений;
	ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю.Колонки.Добавить("Задача",      Новый ОписаниеТипов("СправочникСсылка.ЗадачиПроцесса"));
	ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю.Колонки.Добавить("НовыйСтатус", Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыЗадачПроцессов"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	ЗадачиПроцесса.Родитель КАК Задача,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ЗадачиПроцесса.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Выполнена)
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ) КАК ДоступноВыполнениеПоДочерним
	|ПОМЕСТИТЬ ПоДочерним
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|ГДЕ
	|	ЗадачиПроцесса.Родитель В(&МассивРасчитываемыхЗадач)
	|	И НЕ ЗадачиПроцесса.ПометкаУдаления
	|	И ЗадачиПроцесса.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Отменена)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиПроцесса.Родитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиПроцессаПредшествующиеЗадачи.Ссылка КАК Задача,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ЗадачиПроцессов.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Выполнена)
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ) КАК ДоступноНачалоВыполненияПоПредшественникам
	|ПОМЕСТИТЬ ПоПредшествующим
	|ИЗ
	|	Справочник.ЗадачиПроцесса.ПредшествующиеЗадачи КАК ЗадачиПроцессаПредшествующиеЗадачи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцессов
	|		ПО ЗадачиПроцессаПредшествующиеЗадачи.ПредшествующаяЗадача = ЗадачиПроцессов.Ссылка
	|			И НЕ ЗадачиПроцессов.ПометкаУдаления
	|			И ЗадачиПроцессов.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Отменена)
	|ГДЕ
	|	ЗадачиПроцессаПредшествующиеЗадачи.Ссылка В(&МассивРасчитываемыхЗадач)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиПроцессаПредшествующиеЗадачи.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка КАК Задача,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ЗадачиПроцессаРодитель.Ссылка ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			КОГДА ЗадачиПроцессаРодитель.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.ПринятаКВыполнению)
	|					ИЛИ ЗадачиПроцессаРодитель.ПометкаУдаления
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ) КАК ДоступноНачалоВыполненияПоРодителю
	|ПОМЕСТИТЬ ПоРодителю
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцессаРодитель
	|		ПО ЗадачиПроцесса.Родитель = ЗадачиПроцессаРодитель.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Ссылка В(&МассивРасчитываемыхЗадач)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиПроцесса.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка КАК Задача,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ЗадачиПроцессаРодитель.Ссылка ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			КОГДА ЗадачиПроцессаРодитель.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Выполнена), ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Отменена))
	|					ИЛИ ЗадачиПроцессаРодитель.ПометкаУдаления
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ) КАК ДоступноЗапланированоПоРодителю
	|ПОМЕСТИТЬ ЗапланированаПоРодителю
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцессаРодитель
	|		ПО ЗадачиПроцесса.Родитель = ЗадачиПроцессаРодитель.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Ссылка В(&МассивРасчитываемыхЗадач)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиПроцесса.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЗадачиПроцессаПредшествующиеЗадачи.ПредшествующаяЗадача КАК Задача,
	|	МИНИМУМ(ВЫБОР
	|		КОГДА ЗадачиПроцесса.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.ПринятаКВыполнению), ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Выполнена))
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ) КАК ДоступнаЗапланированаПоПоследующим
	|ПОМЕСТИТЬ ЗапланированаПоПоследующим
	|ИЗ
	|Справочник.ЗадачиПроцесса.ПредшествующиеЗадачи КАК ЗадачиПроцессаПредшествующиеЗадачи
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|	ПО ЗадачиПроцессаПредшествующиеЗадачи.Ссылка = ЗадачиПроцесса.Ссылка
	|ГДЕ
	|	ЗадачиПроцессаПредшествующиеЗадачи.ПредшествующаяЗадача В(&МассивРасчитываемыхЗадач)
	|	И НЕ ЗадачиПроцесса.ПометкаУдаления
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиПроцессаПредшествующиеЗадачи.ПредшествующаяЗадача
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка                                                           КАК ЗадачаПроцесса,
	|	ЗадачиПроцесса.Статус                                                           КАК Статус,
	|	ЕСТЬNULL(ПоДочерним.ДоступноВыполнениеПоДочерним, ИСТИНА)                       КАК ДоступноВыполнениеПоДочерним,
	|	ЕСТЬNULL(ПоПредшествующим.ДоступноНачалоВыполненияПоПредшественникам, ИСТИНА)   КАК ДоступноНачалоВыполненияПоПредшественникам,
	|	ЕСТЬNULL(ПоРодителю.ДоступноНачалоВыполненияПоРодителю, ИСТИНА)                 КАК ДоступноНачалоВыполненияПоРодителю,
	|	ЕСТЬNULL(ЗапланированаПоРодителю.ДоступноЗапланированоПоРодителю, ИСТИНА)       КАК ДоступноЗапланированоПоРодителю,
	|	ЕСТЬNULL(ЗапланированаПоПоследующим.ДоступнаЗапланированаПоПоследующим, ИСТИНА) КАК ДоступнаЗапланированаПоПоследующим,
	|	ВЫБОР
	|		КОГДА ЗадачиПроцесса.ПометкаУдаления
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК НеобходимоОпределениеМаксимальноВозможногоСтатуса,
	|	ЕСТЬNULL(СостоянияЗадачПроцессов.МаксимальныйВозможныйСтатус, ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.ПустаяСсылка)) КАК ТекущийМаксимальныйВозможныйСтатус
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоДочерним КАК ПоДочерним
	|		ПО (ПоДочерним.Задача = ЗадачиПроцесса.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоПредшествующим КАК ПоПредшествующим
	|		ПО ЗадачиПроцесса.Ссылка = ПоПредшествующим.Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоРодителю КАК ПоРодителю
	|		ПО ЗадачиПроцесса.Ссылка = ПоРодителю.Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗапланированаПоРодителю КАК ЗапланированаПоРодителю
	|		ПО ЗадачиПроцесса.Ссылка = ЗапланированаПоРодителю.Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗапланированаПоПоследующим КАК ЗапланированаПоПоследующим
	|		ПО ЗадачиПроцесса.Ссылка = ЗапланированаПоПоследующим.Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияЗадачПроцессов КАК СостоянияЗадачПроцессов
	|		ПО СостоянияЗадачПроцессов.ЗадачаПроцесса = ЗадачиПроцесса.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Ссылка В(&МассивРасчитываемыхЗадач)";
	
	Запрос.УстановитьПараметр("МассивРасчитываемыхЗадач", МассивРассчитываемыхЗадач);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.ПустаяСсылка();
		
		Если Выборка.НеобходимоОпределениеМаксимальноВозможногоСтатуса Тогда
			
			Если Выборка.ДоступноВыполнениеПоДочерним
				И Выборка.ДоступноНачалоВыполненияПоПредшественникам
				И Выборка.ДоступноНачалоВыполненияПоРодителю Тогда
				
				НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Выполнена;
				
			ИначеЕсли Выборка.ДоступноНачалоВыполненияПоПредшественникам
				И Выборка.ДоступноНачалоВыполненияПоРодителю Тогда
				
				НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.ПринятаКВыполнению;
				
			Иначе
				
				НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Запланирована;
				
			КонецЕсли;
			
			Если Выборка.Статус = Перечисления.СтатусыЗадачПроцессов.Отменена Тогда
				
				Если Не Выборка.ДоступноЗапланированоПоРодителю 
					Или Не Выборка.ДоступнаЗапланированаПоПоследующим Тогда
					
					НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Отменена;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НовыйМаксимальныйВозможныйСтатус <> Выборка.ТекущийМаксимальныйВозможныйСтатус Тогда
			
			ЗаписатьНовыйМаксимальноВозможныйСтатус(Выборка.ЗадачаПроцесса, НовыйМаксимальныйВозможныйСтатус);
			
			Если ОпределятьНаправлениеИсполнителю Тогда
				
				ОпределитьНеобходимостьНаправленияЗадачиИсполнителю(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю, 
				                                                    Выборка, 
				                                                    НовыйМаксимальныйВозможныйСтатус);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОпределятьНаправлениеИсполнителю Тогда
	
		НаправитьТребуемыеЗадачиИсполнителям(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьНеобходимостьНаправленияЗадачиИсполнителю(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю, 
	                                                          Выборка,
	                                                          НовыйМаксимальныйВозможныйСтатус)
	
	Если Выборка.ТекущийМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Запланирована
		И (НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.ПринятаКВыполнению
		Или НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Выполнена) Тогда
		
		ДобавитьЗадачуВТаблицуЗадачПоКоторымТребуетсяНаправлениеИсполнителю(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю,
		                                                                    Выборка.ЗадачаПроцесса,
		                                                                    Перечисления.СтатусыЗадачПроцессов.ПринятаКВыполнению);
		
	ИначеЕсли Выборка.ТекущийМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.ПринятаКВыполнению
		И НовыйМаксимальныйВозможныйСтатус = Перечисления.СтатусыЗадачПроцессов.Выполнена Тогда
		
		ДобавитьЗадачуВТаблицуЗадачПоКоторымТребуетсяНаправлениеИсполнителю(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю,
		                                                                    Выборка.ЗадачаПроцесса,
		                                                                    Перечисления.СтатусыЗадачПроцессов.Выполнена);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НаправитьТребуемыеЗадачиИсполнителям(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиКНаправлениюИсполнителю.Задача      КАК Задача,
	|	ЗадачиКНаправлениюИсполнителю.НовыйСтатус КАК НовыйСтатус
	|ПОМЕСТИТЬ ЗадачиКОбработке
	|ИЗ
	|	&ЗадачиКНаправлениюИсполнителю КАК ЗадачиКНаправлениюИсполнителю
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиКОбработке.Задача                                    КАК Задача,
	|	МАКСИМУМ(ЗадачиПроцессаПротоколВзаимодействия.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ПоследниеЗаписиПротоколаВзаимодействий
	|ИЗ
	|	ЗадачиКОбработке КАК ЗадачиКОбработке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса.ПротоколВзаимодействия КАК ЗадачиПроцессаПротоколВзаимодействия
	|		ПО ЗадачиКОбработке.Задача = ЗадачиПроцессаПротоколВзаимодействия.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиКОбработке.Задача
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиКОбработке.Задача                                                                                             КАК Задача,
	|	ЗадачиКОбработке.НовыйСтатус                                                                                        КАК НовыйСтатус,
	|	ЗадачиПроцесса.Статус                                                                                               КАК ТекущийСтатус,
	|	ЗадачиПроцесса.Исполнитель                                                                                          КАК Исполнитель,
	|	ЗадачиПроцесса.Контролирующий                                                                                       КАК Контролирующий,
	|	ЕСТЬNULL(ЗадачиПроцессаПротоколВзаимодействия.ТекстПоручения, """")                                                 КАК ТекстПоручения,
	|	ЕСТЬNULL(ЗадачиПроцессаПротоколВзаимодействия.ИсполнительПоручения, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)) КАК ИсполнительПоручения
	|ИЗ
	|	ЗадачиКОбработке КАК ЗадачиКОбработке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ПО ЗадачиКОбработке.Задача = ЗадачиПроцесса.Ссылка
	|			И ЗадачиПроцесса.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Отменена)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследниеЗаписиПротоколаВзаимодействий КАК ПоследниеЗаписиПротоколаВзаимодействий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса.ПротоколВзаимодействия КАК ЗадачиПроцессаПротоколВзаимодействия
	|			ПО ПоследниеЗаписиПротоколаВзаимодействий.Задача = ЗадачиПроцессаПротоколВзаимодействия.Ссылка
	|				И ПоследниеЗаписиПротоколаВзаимодействий.НомерСтроки = ЗадачиПроцессаПротоколВзаимодействия.НомерСтроки
	|		ПО ЗадачиКОбработке.Задача = ПоследниеЗаписиПротоколаВзаимодействий.Задача";
	
	Запрос.УстановитьПараметр("ЗадачиКНаправлениюИсполнителю", ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НовыйСтатус = Выборка.ТекущийСтатус Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ИсполнительПоручения) Тогда
			
			Если Не ПустаяСтрока(Выборка.ТекстПоручения) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Выборка.ИсполнительПоручения <> Выборка.Исполнитель Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Задача);
		Исключение
			//Если задача заблокирована, то направление не выполняем.
			Продолжить;
		КонецПопытки;
		
		Если Выборка.НовыйСтатус = Перечисления.СтатусыЗадачПроцессов.Выполнена Тогда
			
			Если ЗначениеЗаполнено(Выборка.Контролирующий) И (Выборка.Контролирующий <> Выборка.Исполнитель) Тогда
				
				ТекстПоручения = НСтр("ru = 'Задача готова к отправке на проверку контролирующему.'");
				
			Иначе
				
				ТекстПоручения = НСтр("ru = 'Задача готова к выполнению.'");
				
			КонецЕсли;
			
			
		ИначеЕсли Выборка.НовыйСтатус = Перечисления.СтатусыЗадачПроцессов.ПринятаКВыполнению Тогда
			
			ТекстПоручения = НСтр("ru = 'Задача готова к началу выполнения.'");
			
		КонецЕсли;
		
		ТекстПоручения =  ТекстПоручения + Символы.ПС + НСтр("ru = 'Поручение сформировано автоматически при изменении статуса других задач.'");
		
		ЗадачаОбъект = Выборка.Задача.ПолучитьОбъект();
		
		ДанныеДляНаправления = Новый Структура;
		ДанныеДляНаправления.Вставить("ТекстПоручения",               ТекстПоручения);
		ДанныеДляНаправления.Вставить("ИсполнительПорученияПоЗадаче", Выборка.Исполнитель);
		
		ЗадачиПроцессов.ЗаполнитьПеренаправляемуюЗадачу(ЗадачаОбъект, ТекущийПользователь, ДанныеДляНаправления);
		ЗадачаОбъект.ОбменДанными.Загрузка = Истина;
		Попытка
			ЗадачаОбъект.Записать();
		Исключение
			//Если по какой то причине не удалось записать, то процесс не останавливаем.
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЗадачуВТаблицуЗадачПоКоторымТребуетсяНаправлениеИсполнителю(ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю,
	                                                                          Задача,
	                                                                          НовыйСтатус)
	
	НоваяСтрока = ТаблицаЗадачПоКоторымТребуетсяНаправлениеИсполнителю.Добавить();
	НоваяСтрока.Задача      = Задача;
	НоваяСтрока.НовыйСтатус = НовыйСтатус;
	
КонецПроцедуры

Процедура ЗаписатьНовыйМаксимальноВозможныйСтатус(ЗадачаПроцесса, НовыйМаксимальныйВозможныйСтатус) Экспорт
	
	ЗаписываемыеДанные = Новый Структура;
	ЗаписываемыеДанные.Вставить("МаксимальныйВозможныйСтатус", НовыйМаксимальныйВозможныйСтатус);
	
	ЗаписатьДанные(ЗадачаПроцесса, ЗаписываемыеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ЗонаЗадачи

Процедура РассчитатьВсеЗоныЗадач() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗадачиПроцесса.Предмет КАК Предмет
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		РассчитатьЗонуЗадачПоПредмету(Выборка.Предмет);
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьЗонуЗадачПоПредмету(Предмет) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|ГДЕ
	|	ЗадачиПроцесса.Предмет = &Предмет";
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	МассивРассчитываемыхЗадач = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	РассчитатьЗонуМассиваЗадач(МассивРассчитываемыхЗадач);
	
КонецПроцедуры

Процедура РассчитатьЗонуМассиваЗадач(МассивРассчитываемыхЗадач) Экспорт
	
	Если МассивРассчитываемыхЗадач.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка                                                                 КАК ЗадачаПроцесса,
	|	ЗадачиПроцесса.ПометкаУдаления                                                        КАК ПометкаУдаления,
	|	ЗадачиПроцесса.КрайняяДатаОкончания                                                   КАК КрайняяДатаОкончания,
	|	ЗадачиПроцесса.ПлановаяДлительность                                                   КАК ПлановаяДлительность,
	|	ЗадачиПроцесса.ФактическаяДатаНачала                                                  КАК ФактическаяДатаНачала,
	|	ЗадачиПроцесса.Статус                                                                 КАК Статус,
	|	ЕСТЬNULL(СостоянияЗадачПроцессов.Зона, ЗНАЧЕНИЕ(Перечисление.ЗоныЗадач.ПустаяСсылка)) КАК Зона
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияЗадачПроцессов КАК СостоянияЗадачПроцессов
	|		ПО СостоянияЗадачПроцессов.ЗадачаПроцесса = ЗадачиПроцесса.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Ссылка В(&МассивРассчитываемыхЗадач)";
	
	Запрос.УстановитьПараметр("МассивРассчитываемыхЗадач", МассивРассчитываемыхЗадач);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		НоваяЗонаЗадачи = ЗадачиПроцессов.РасчитаннаяЗонаЗадачи(Выборка);
		Если НоваяЗонаЗадачи <> Выборка.Зона Тогда
			ЗаписатьНовуюЗонуЗадачи(Выборка.ЗадачаПроцесса, НоваяЗонаЗадачи);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьНовуюЗонуЗадачи(ЗадачаПроцесса, НоваяЗонаЗадачи) Экспорт
	
	ЗаписываемыеДанные = Новый Структура;
	ЗаписываемыеДанные.Вставить("Зона", НоваяЗонаЗадачи);
	
	ЗаписатьДанные(ЗадачаПроцесса, ЗаписываемыеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область УпорядочиваниеЗадач

Процедура УпорядочитьЗадачиПоМассивуРодителей(МассивРассчитываемыхЗадач, Предмет) Экспорт
	
	Граф = ЗадачиПроцессов.ГрафПоПредмету(Предмет);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка                                                            КАК Задача,
	|	ЗадачиПроцесса.Родитель                                                          КАК Родитель,
	|	ЕСТЬNULL(ИерархияЗадачПроцесса.Уровень, 0) + 1                                   КАК Уровень,
	|	ЕСТЬNULL(СостоянияЗадачПроцессов.ЗначениеУпорядочивания, -1)                     КАК ТекущееЗначениеУпорядочивания,
	|	ЕСТЬNULL(СостоянияЗадачПроцессов.МаксимальноеЗначениеУпорядочиванияНаУровне, -1) КАК ТекущееМаксимальноеЗначениеУпорядочиванияНаУровне
	|ИЗ
	|	Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияЗадачПроцесса КАК ИерархияЗадачПроцесса
	|		ПО (ИерархияЗадачПроцесса.ЗадачаПроцесса = ЗадачиПроцесса.Ссылка)
	|			И (ИерархияЗадачПроцесса.Родитель = ЗадачиПроцесса.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияЗадачПроцессов КАК СостоянияЗадачПроцессов
	|		ПО СостоянияЗадачПроцессов.ЗадачаПроцесса = ЗадачиПроцесса.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Родитель В(&МассивРодителей)
	|	И НЕ ЗадачиПроцесса.ПометкаУдаления
	|	И НЕ ЗадачиПроцесса.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Отменена), ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.ПустаяСсылка))
	|	И ЗадачиПроцесса.Предмет = &Предмет
	|ИТОГИ ПО
	|	Родитель";
	
	Запрос.УстановитьПараметр("МассивРодителей", МассивРассчитываемыхЗадач);
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	ВыборкаРодитель = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРодитель.Следующий() Цикл
	
		ТаблицаДляРасчета = ЗадачиПроцессов.ПустаяТаблицаДляРасчетаУпорядочивания();
		
		ВыборкаЗадачи = ВыборкаРодитель.Выбрать();
		Пока ВыборкаЗадачи.Следующий() Цикл
			НоваяСтрока = ТаблицаДляРасчета.Добавить();
			НоваяСтрока.Задача                                            = ВыборкаЗадачи.Задача;
			НоваяСтрока.ЗначениеУпорядочивания                            = 0;
			НоваяСтрока.Уровень                                           = ВыборкаЗадачи.Уровень;
			НоваяСтрока.МаксимальноеЗначениеУпорядочиванияНаУровне        = 0;
			НоваяСтрока.ТекущееЗначениеУпорядочивания                     = ВыборкаЗадачи.ТекущееЗначениеУпорядочивания;
			НоваяСтрока.ТекущееМаксимальноеЗначениеУпорядочиванияНаУровне = ВыборкаЗадачи.ТекущееМаксимальноеЗначениеУпорядочиванияНаУровне;
		КонецЦикла;
		
		УпорядочитьЗадачи(ТаблицаДляРасчета, Граф, Ложь);
		ЗаписатьДанныеУпорядочиванияПоКоллекции(ТаблицаДляРасчета, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УпорядочитьЗадачиПоПредмету(Предмет) Экспорт
	
	Граф = ЗадачиПроцессов.ГрафПоПредмету(Предмет);
	ДеревоЗадач = ЗадачиПроцессов.ДеревоЗадачПроцесса(Предмет);
	УпорядочитьЗадачи(ДеревоЗадач.Строки, Граф);
	ЗаписатьДанныеУпорядочиванияПоКоллекции(ДеревоЗадач.Строки, Истина);
	
КонецПроцедуры

Процедура УпорядочитьЗадачи(КоллекцияСтрок, Граф, ВключаяПодчиненные = Истина)
	
	Если КоллекцияСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗадачТекущегоПодчинения = Новый Массив;
	Для Каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		
		МассивЗадачТекущегоПодчинения.Добавить(СтрокаКоллекции.Задача);
		
	КонецЦикла;
	
	МаксимальноеЗначениеУпорядочивания = 1;
	
	Для Каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		
		СтрокаКоллекции.ЗначениеУпорядочивания = 1;
		
		ПредшествующиеЗадачи = Граф.Получить(СтрокаКоллекции.Задача);
		Если ПредшествующиеЗадачи = Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		МассивЦепочек = Новый Массив;
		
		Для Каждого ПредшествующаяЗадача Из ПредшествующиеЗадачи Цикл
			
			ДобавитьЗадачуВЦепочку(СтрокаКоллекции.Задача, ПредшествующаяЗадача, МассивЦепочек, Граф);
			
		КонецЦикла;
		
		Для Каждого Цепочка Из МассивЦепочек Цикл
			
			КоличествоЭлементовКоллекции = Цепочка.Количество();
	
			Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
				
				Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
				
				Если МассивЗадачТекущегоПодчинения.Найти(Цепочка[Индекс]) = Неопределено Тогда
					
					Цепочка.Удалить(Индекс);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если Цепочка.Количество() = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаКоллекции.ЗначениеУпорядочивания = Макс(СтрокаКоллекции.ЗначениеУпорядочивания, Цепочка.Количество());
			
		КонецЦикла;
		
		МаксимальноеЗначениеУпорядочивания = Макс(МаксимальноеЗначениеУпорядочивания, СтрокаКоллекции.ЗначениеУпорядочивания);
		
	КонецЦикла;
	
	Для Каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		
		СтрокаКоллекции.МаксимальноеЗначениеУпорядочиванияНаУровне = МаксимальноеЗначениеУпорядочивания;
		Если ВключаяПодчиненные Тогда
			УпорядочитьЗадачи(СтрокаКоллекции.Строки, Граф);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры 

Процедура ДобавитьЗадачуВЦепочку(Задача, ПредшествующаяЗадача, МассивЦепочек, Граф)
	
	ЦепочкаНайдена = Ложь;
	
	Для Каждого Цепочка Из МассивЦепочек Цикл
		
		ИндексЭлементаТекущейЗадачи        = Цепочка.Найти(Задача);
		ИндексЭлементаПредшествующейЗадачи = Цепочка.Найти(ПредшествующаяЗадача);
		
		Если ИндексЭлементаПредшествующейЗадачи <> Неопределено Тогда
			
			ЦепочкаНайдена = Истина;
			Возврат;
			
		ИначеЕсли ИндексЭлементаТекущейЗадачи = 0 Тогда
			
			ЦепочкаНайдена = Истина;
			Цепочка.Вставить(0, ПредшествующаяЗадача);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЦепочкаНайдена Тогда
		
		Цепочка = Новый Массив;
		Цепочка.Добавить(ПредшествующаяЗадача);
		Цепочка.Добавить(Задача);
		
		МассивЦепочек.Добавить(Цепочка);
		
	КонецЕсли;
	
	ПредшествующиеЗадачи = Граф.Получить(ПредшествующаяЗадача);
	Если ПредшествующиеЗадачи = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
		
	Для Каждого ЗадачаПредшественник Из ПредшествующиеЗадачи Цикл
		
		ДобавитьЗадачуВЦепочку(ПредшествующаяЗадача, ЗадачаПредшественник, МассивЦепочек, Граф);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаписатьДанныеУпорядочиванияПоКоллекции(СтрокиКоллекции, ВключаяПодчиненные = Истина)

	Для Каждого СтрокаКоллекции Из СтрокиКоллекции Цикл
		
		ВыполнятьЗапись = Истина;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаКоллекции, "ТекущееЗначениеУпорядочивания") Тогда
			
			Если СтрокаКоллекции.ТекущееЗначениеУпорядочивания = СтрокаКоллекции.ЗначениеУпорядочивания
				И СтрокаКоллекции.МаксимальноеЗначениеУпорядочиванияНаУровне = СтрокаКоллекции.ТекущееМаксимальноеЗначениеУпорядочиванияНаУровне Тогда
				
				ВыполнятьЗапись = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВыполнятьЗапись Тогда
			
			ДанныеЗаписи = Новый Структура;
			ДанныеЗаписи.Вставить("ЗначениеУпорядочивания", СтрокаКоллекции.ЗначениеУпорядочивания);
			ДанныеЗаписи.Вставить("Уровень", СтрокаКоллекции.Уровень);
			ДанныеЗаписи.Вставить("МаксимальноеЗначениеУпорядочиванияНаУровне", СтрокаКоллекции.МаксимальноеЗначениеУпорядочиванияНаУровне);
			
			РегистрыСведений.СостоянияЗадачПроцессов.ЗаписатьДанные(СтрокаКоллекции.Задача, ДанныеЗаписи);
			
		КонецЕсли;
		
		Если ВключаяПодчиненные Тогда
			ЗаписатьДанныеУпорядочиванияПоКоллекции(СтрокаКоллекции.Строки);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

Процедура ЗаписатьДанные(ЗадачаПроцесса, ЗаписываемыеДанные) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗадачаПроцесса.Установить(ЗадачаПроцесса);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ЗадачаПроцесса = ЗадачаПроцесса;
		
	Иначе
		
		ЗаписьНабора = НаборЗаписей[0];
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписываемыеДанные);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура УдалитьЗаписиПоПредмету(Предмет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СостоянияЗадачПроцессов.ЗадачаПроцесса КАК ЗадачаПроцесса
	|ИЗ
	|	РегистрСведений.СостоянияЗадачПроцессов КАК СостоянияЗадачПроцессов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ПО СостоянияЗадачПроцессов.ЗадачаПроцесса = ЗадачиПроцесса.Ссылка
	|ГДЕ
	|	ЗадачиПроцесса.Предмет = &Предмет";
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		УдалитьЗаписиПоЗадаче(Выборка.ЗадачаПроцесса);
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьЗаписиПоЗадаче(ЗадачаПроцесса) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗадачаПроцесса.Установить(ЗадачаПроцесса);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли