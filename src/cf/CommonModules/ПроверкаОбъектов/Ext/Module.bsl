﻿
// На основании правил проверки объектов выполняет проверку 
// и записывает данные в регистр
Процедура ВыполнитьПроверкуОбъектов() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Выборка = Справочники.ПравилаПроверкиОбъектов.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если НЕ Выборка.ЭтоГруппа Тогда
			ПравилоПроверки = Выборка.Ссылка;
			ПроверкаОбъектов.ВыполнитьПроверкуПоПравилу(ПравилоПроверки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет регистр сведений данными по результатам проверки одного правила
// Если у правила не стоит флаг активности будет выполнена очистка регистра
// от предыдущих результатов проверки по этому правилу
Процедура ВыполнитьПроверкуПоПравилу(ПравилоСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПравилоСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписиРегистра = РегистрыСведений.РезультатыПроверкиОбъектов.СоздатьНаборЗаписей();
	НаборЗаписиРегистра.Отбор.ПравилоПроверкиОбъектов.Установить(ПравилоСсылка);
	
	Если ПравилоСсылка.Активно Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ПравилоСсылка.ТекстЗапроса;
		
		ТаблицаПроверки = Запрос.Выполнить().Выгрузить();
		ТаблицаПроверки.Колонки.Добавить("ПравилоПроверкиОбъектов");
		ТаблицаПроверки.ЗаполнитьЗначения(ПравилоСсылка, "ПравилоПроверкиОбъектов");
		
		НаборЗаписиРегистра.Загрузить(ТаблицаПроверки);
	КонецЕсли;

	НаборЗаписиРегистра.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Примитивная проверка текста запроса на правильность
// В качестве параметров возвращаются заполненный построитель отчета 
// и ошибка, которая не позволяет выполниться запросу
Функция СоздатьПостроительОтчетаПоПравилу(ТекстЗапроса, ЕстьОшибки = Ложь, МассивСообщений = Неопределено) Экспорт
	
	// Презумпция
	НетОшибок = Истина;
	
	// Список значений для проверки обязательных полей запроса
	ТаблицаОбязательныхПолей = Новый ТаблицаЗначений;
	ТаблицаОбязательныхПолей.Колонки.Добавить("НазваниеПоля");
	ТаблицаОбязательныхПолей.Колонки.Добавить("ТипПоля");
	
	НоваяСтрока = ТаблицаОбязательныхПолей.Добавить();
	НоваяСтрока.НазваниеПоля = "ОбъектПроверки";
	НоваяСтрока.ТипПоля = "СправочникСсылка";
	
	НоваяСтрока = ТаблицаОбязательныхПолей.Добавить();
	НоваяСтрока.НазваниеПоля = "ЭлементОбъекта";
	
	НоваяСтрока = ТаблицаОбязательныхПолей.Добавить();
	НоваяСтрока.НазваниеПоля = "Информация";
	НоваяСтрока.ТипПоля = "Строка неограниченной длины";
	
	
	Если МассивСообщений = Неопределено Тогда
		ВыдаватьСообщения = Истина;
		МассивСообщений = Новый Массив;
	Иначе
		ВыдаватьСообщения = Ложь;
	КонецЕсли;

	ПостроительОтчета = Новый ПостроительОтчета;
	
	// 1-я проверка - поместить запрос в построитель и заполнить настройки
	Попытка
		ПостроительОтчета.Текст = ТекстЗапроса;
		ПостроительОтчета.ЗаполнитьНастройки();
	Исключение
		СоставноеСообщение = Нстр("ru = 'Неправильно составлен запрос'");
		МассивСообщений.Добавить(СоставноеСообщение);
		МассивСообщений.Добавить(ОписаниеОшибки());
		ПостроительОтчета = Неопределено;
	КонецПопытки;
	
	// 2-я проверка - на наличие необходимых полей
	Если ПостроительОтчета <> Неопределено Тогда
		Для каждого СтрокаТаблицы Из ТаблицаОбязательныхПолей Цикл
			НайденноеПоле = ПостроительОтчета.ВыбранныеПоля.Найти(СтрокаТаблицы.НазваниеПоля);
			Если НайденноеПоле = Неопределено Тогда
				СоставноеСообщение = Нстр("ru = 'Отсутствует обязательное поле с псевдонимом '") + СтрокаТаблицы.НазваниеПоля+" - "+ СтрокаТаблицы.ТипПоля;
				МассивСообщений.Добавить(СоставноеСообщение);
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ВыдаватьСообщения Тогда
		Если МассивСообщений.Количество() > 0 Тогда
			Для Каждого Сообщение Из МассивСообщений Цикл
				Сообщить(Сообщение, СтатусСообщения.Важное);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПостроительОтчета;
	
КонецФункции // СоздатьПостроительОтчетаПоПравилу

// Процедура для прорисовки колонки Важность в списках регистра состояния
Процедура ВывестиВажность(ОформленияСтрок, Колонки) Экспорт
	
	Если ОформленияСтрок.Количество() = 0 ИЛИ Колонки.Найти("Важность") = Неопределено ИЛИ НЕ Колонки.Важность.Видимость Тогда
		Возврат; // Нечего оформлять;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПравилаПроверкиОбъектов.Ссылка   КАК ПравилоПроверки,
	|	ПравилаПроверкиОбъектов.Важность КАК Важность
	|ИЗ
	|	Справочник.ПравилаПроверкиОбъектов КАК ПравилаПроверкиОбъектов
	|ГДЕ
	|	ПравилаПроверкиОбъектов.Ссылка В(&СписокОбъектов)";
	
	СписокОбъектов = Новый СписокЗначений;
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		Если ОформлениеСтроки.ДанныеСтроки <> Неопределено Тогда
			СписокОбъектов.Добавить(ОформлениеСтроки.ДанныеСтроки.ПравилоПроверкиОбъектов);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("СписокОбъектов", СписокОбъектов);
	
	КоллекцияСостояний = Запрос.Выполнить().Выгрузить();
	
	КоллекцияСостояний.Индексы.Добавить("ПравилоПроверки");

	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		Если ОформлениеСтроки.ДанныеСтроки <> Неопределено Тогда
			РезультатПоиска = КоллекцияСостояний.Найти(ОформлениеСтроки.ДанныеСтроки.ПравилоПроверкиОбъектов, "ПравилоПроверки");
			Если РезультатПоиска <> Неопределено Тогда
				ОформлениеСтроки.Ячейки.Важность.УстановитьТекст(Строка(РезультатПоиска.Важность));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обновление правил проверки
Процедура ОбновитьПравилаПроверки() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Спр.Ссылка КАК Ссылка,
	|	Спр.Предустановленное КАК Предустановленное
	|ИЗ
	|	Справочник.ПравилаПроверкиОбъектов КАК Спр
	|");

	ТекущиеПравила = Запрос.Выполнить().Выгрузить();
	ТекущиеПравила.Индексы.Добавить("Ссылка");

	Макет = Справочники.ПравилаПроверкиОбъектов.ПолучитьМакет("ЭталонныеПравилаПроверки");

	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(Макет.Область(2, , Макет.ВысотаТаблицы));

	ЗагружаемыеПравила = Новый ТаблицаЗначений;
	ЗагружаемыеПравила.Колонки.Добавить("Ссылка");
	ЗагружаемыеПравила.Колонки.Добавить("Родитель");
	ЗагружаемыеПравила.Колонки.Добавить("ЭтоГруппа");
	ЗагружаемыеПравила.Колонки.Добавить("Важность");
	ЗагружаемыеПравила.Колонки.Добавить("Код");
	ЗагружаемыеПравила.Колонки.Добавить("Наименование");
	ЗагружаемыеПравила.Колонки.Добавить("Описание");
	ЗагружаемыеПравила.Колонки.Добавить("ТекстЗапроса");
	ЗагружаемыеПравила.Колонки.Добавить("Активно");

	Выборка = ПостроительЗапроса.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ЗагружаемыеПравила.Добавить();
		НоваяСтрока.Ссылка       = ЗначениеИзСтрокиВнутр(Выборка.Ссылка);
		НоваяСтрока.Родитель     = ЗначениеИзСтрокиВнутр(Выборка.Родитель);
		НоваяСтрока.ЭтоГруппа    = Булево(Число(Выборка.ЭтоГруппа));
		НоваяСтрока.Код          = Число(Выборка.Код);
		НоваяСтрока.Наименование = Выборка.Наименование;

		Если Не НоваяСтрока.ЭтоГруппа Тогда
			НоваяСтрока.Важность          = Перечисления.ВажностьПравилПроверки[Выборка.Важность];
			НоваяСтрока.Описание          = Выборка.Описание;
			НоваяСтрока.ТекстЗапроса      = Выборка.ТекстЗапроса;
			НоваяСтрока.Активно           = Булево(Число(Выборка.Активно));
		КонецЕсли
	КонецЦикла;

	Для Каждого ЗагружаемоеПравило Из ЗагружаемыеПравила Цикл
		ТекущееПравило = ТекущиеПравила.Найти(ЗагружаемоеПравило.Ссылка, "Ссылка");
		Если ТекущееПравило <> Неопределено Тогда
			Если ТекущееПравило.Предустановленное Тогда
				ТекОбъект = ТекущееПравило.Ссылка.ПолучитьОбъект();
			Иначе
				ТекОбъект = Неопределено;
			КонецЕсли;

			ТекущиеПравила.Удалить(ТекущееПравило);
		Иначе
			Если ЗагружаемоеПравило.ЭтоГруппа Тогда
				ТекОбъект = Справочники.ПравилаПроверкиОбъектов.СоздатьГруппу();
			Иначе
				ТекОбъект = Справочники.ПравилаПроверкиОбъектов.СоздатьЭлемент();
			КонецЕсли;
		КонецЕсли;

		Если ТекОбъект <> Неопределено Тогда
			Если ТекОбъект.ЭтоНовый() Тогда
				ТекОбъект.УстановитьСсылкуНового(ЗагружаемоеПравило.Ссылка);
			КонецЕсли;

			ТекОбъект.Родитель          = ЗагружаемоеПравило.Родитель;
			ТекОбъект.Код               = ЗагружаемоеПравило.Код;
			ТекОбъект.Наименование      = ЗагружаемоеПравило.Наименование;
			ТекОбъект.Предустановленное = Истина;

			Если Не ТекОбъект.ЭтоГруппа Тогда
				ТекОбъект.Описание     = ЗагружаемоеПравило.Описание;
				ТекОбъект.ТекстЗапроса = ЗагружаемоеПравило.ТекстЗапроса;
				ТекОбъект.Важность     = ЗагружаемоеПравило.Важность;
				ТекОбъект.Активно      = ЗагружаемоеПравило.Активно;
			КонецЕсли;

			ТекОбъект.Записать();
		КонецЕсли;
	КонецЦикла;

	Для Каждого ТекущееПравило Из ТекущиеПравила Цикл
		Если ТекущееПравило.Предустановленное Тогда
			ТекОбъект = ТекущееПравило.Ссылка.ПолучитьОбъект();
			ТекОбъект.УстановитьПометкуУдаления(Истина, Ложь);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Управление отметкой исключения
Процедура УстановитьСнятьОтметкуИсключения(ВыделенныеЗаписи, Отметка) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.РезультатыПроверкиОбъектов.СоздатьМенеджерЗаписи();
	
	Для каждого КлючЗаписи Из ВыделенныеЗаписи Цикл
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, КлючЗаписи);
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Исключение = Отметка;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Оформление исключений при выводе
Процедура ВывестиИсключения(ОформленияСтрок) Экспорт
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		Если ОформлениеСтроки.ДанныеСтроки <> Неопределено И ОформлениеСтроки.ДанныеСтроки.Исключение Тогда
			ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт, , , , , , Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Выполнение перепроверки для выделенных строк регистра
Процедура ВыполнитьПерепроверкуДляВыделенныхСтрокРегистра(ВыделенныеСтроки) Экспорт
	
	МассивПравил = Новый Массив;
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если МассивПравил.Найти(ВыделеннаяСтрока.ПравилоПроверкиОбъектов) = Неопределено Тогда
			ПроверкаОбъектов.ВыполнитьПроверкуПоПравилу(ВыделеннаяСтрока.ПравилоПроверкиОбъектов);
			МассивПравил.Добавить(ВыделеннаяСтрока.ПравилоПроверкиОбъектов);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры