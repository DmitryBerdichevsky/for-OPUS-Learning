﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураОтбора = Новый Структура("ТехническийПроект", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ТехническийПроект", ПараметрКоманды);
	
	ОткрытьФорму("РегистрСведений.СогласованиеТехническихПроектов.Форма.ИсторияСогласования",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно,
				 ПараметрыВыполненияКоманды.НавигационнаяСсылка);
				 
КонецПроцедуры
