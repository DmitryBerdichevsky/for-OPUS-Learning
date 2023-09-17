﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("Массив") и ПараметрКоманды.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТипаДата = Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТекстЗаголовка = НСтр("ru='Указание даты предстоящей контрольной точки'");
	
	УказаннаяДата = '00010101';
	
	Структура = Новый Структура("ПараметрКоманды, УказаннаяДата", ПараметрКоманды, УказаннаяДата);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, Структура);
	
	ПоказатьВводЗначения(ОписаниеОповещения, УказаннаяДата,ТекстЗаголовка, ОписаниеТипаДата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Значение, ДополнительныеПараметры) Экспорт
    
    ПараметрКоманды = ДополнительныеПараметры.ПараметрКоманды;
    УказаннаяДата = ?(Значение = Неопределено, ДополнительныеПараметры.УказаннаяДата, Значение);
    
    
    Если (Значение <> Неопределено) Тогда
        УстановитьДатуПредстоящейКонтрольнойТочки(ПараметрКоманды, УказаннаяДата);
    Иначе
        Возврат;
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьДатуПредстоящейКонтрольнойТочки(МассивТехническихПроектов, Дата)

	Для Каждого ТехническийПроект из МассивТехническихПроектов Цикл
		
		Объект = ТехническийПроект.ПолучитьОбъект();
		
		Если Не Объект.ИспользуютсяКонтрольныеТочкиПроекта Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для технического проекта ""%1"" не используются контрольные точки.'"), Объект.Наименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ТехническийПроект);
			Продолжить;
			
		КонецЕсли;
		
		Попытка
			Объект.Заблокировать();
		Исключение
			СоставноеСообщение = НСтр(" ru= ""Не удалось установить дату для технического проекта: %Проект% по причине: %ОписаниеОшибки%""; ");
			СоставноеСообщение = СтрЗаменить(СоставноеСообщение, "%Проект%", ТехническийПроект);
			СоставноеСообщение = СтрЗаменить(СоставноеСообщение, "%ОписаниеОшибки%", ОписаниеОшибки());
			Сообщить(СоставноеСообщение);
		КонецПопытки;
		
		Попытка
			
			Для Каждого СтрокаТЧ из Объект.КонтрольныеТочки Цикл
				Если СтрокаТЧ.Статус = Перечисления.СтатусыКонтрольныхТочекТехническихПроектов.Назначена Тогда
					СтрокаТЧ.СрокПрохождения = Дата;
					ТехническиеПроекты.ПересчитатьСрокиИДлительностьКонтрольныхТочекСервер(СтрокаТЧ, "СрокПрохождения", Объект);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Объект.Записать();
			Объект.Разблокировать();
		Исключение
			СоставноеСообщение = НСтр(" ru= ""Не удалось установить дату для технического проекта: %Проект% по причине: %ОписаниеОшибки%""; "); 
			СоставноеСообщение = СтрЗаменить(СоставноеСообщение, "%Проект%", ТехническийПроект);
			СоставноеСообщение = СтрЗаменить(СоставноеСообщение, "%ОписаниеОшибки%", ОписаниеОшибки());
			Сообщить(СоставноеСообщение);
		КонецПопытки;
		
	КонецЦикла;
				
КонецПроцедуры

#КонецОбласти