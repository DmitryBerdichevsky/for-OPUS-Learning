﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ОбъектМетаданных", ПараметрКоманды);
	ОткрытьФорму("Справочник.Ошибки.Форма.ОшибкиПоОбъектуМетаданных",
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти