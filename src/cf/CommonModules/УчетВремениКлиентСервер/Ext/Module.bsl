﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ВременныеИнтервалыПересекаются(НачалоИнтервала1, ОкончаниеИнтервала1, НачалоИнтервала2, ОкончаниеИнтервала2) Экспорт
	
	Результат = Ложь;
	
	Если НачалоИнтервала2 > НачалоИнтервала1 И НачалоИнтервала2 < ОкончаниеИнтервала1
		ИЛИ ОкончаниеИнтервала2 > НачалоИнтервала1 И ОкончаниеИнтервала2 < ОкончаниеИнтервала1
		ИЛИ НачалоИнтервала1 > НачалоИнтервала2 И НачалоИнтервала1 < ОкончаниеИнтервала2
		ИЛИ ОкончаниеИнтервала1 > НачалоИнтервала2 И ОкончаниеИнтервала1 < ОкончаниеИнтервала2
		ИЛИ НачалоИнтервала1 = НачалоИнтервала2 И ОкончаниеИнтервала1 = ОкончаниеИнтервала2 Тогда
		
		Результат = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработатьПереключениеХронометража(ДанныеХронометража, Форма, Работа) Экспорт
	
	Если Форма.Элементы.Найти("ПереключитьХронометраж") <> Неопределено Тогда
		
		Если ДанныеХронометража.Работа = Работа Тогда
			Если ДанныеХронометража.ХронометражВключен Тогда
				Форма.Элементы.ПереключитьХронометраж.Пометка = Истина;
			Иначе
				Форма.Элементы.ПереключитьХронометраж.Пометка = Ложь;
			КонецЕсли;
		Иначе
			Если ДанныеХронометража.ХронометражВключен Тогда
				Форма.Элементы.ПереключитьХронометраж.Пометка = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти