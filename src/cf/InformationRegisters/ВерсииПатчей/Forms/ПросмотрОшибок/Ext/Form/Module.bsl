﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыПатча) Тогда
		ПараметрыПатча = ПолучитьИзВременногоХранилища(Параметры.ПараметрыПатча);
		ПараметрыПатча = ПараметрыПатча.Получить();
	Иначе
		СвойствВерсииПатча = ПатчиСлужебный.ЗначенияСвойствВерсииПатча(Параметры.УникальныйИдентификатор, "Параметры");
		ПараметрыПатча = СвойствВерсииПатча.Параметры.Получить()
	КонецЕсли;
	
	ЛогОшибок = СтрСоединить(ПараметрыПатча.ЛогОшибок, Символы.ПС);
	Документ.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(ЛогОшибок));
	
КонецПроцедуры

#КонецОбласти