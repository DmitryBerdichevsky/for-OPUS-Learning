﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Отчет.ОтветыНаВопросыТехническихПроектов.Форма",
		Новый Структура("Отбор,СформироватьПриОткрытии", Новый Структура("Вопрос", ПараметрКоманды), Истина),
		,
		"Вопрос=" + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры
