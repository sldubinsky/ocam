﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ИмяФормыИсточникаСообщения", "");
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		ДополнительныеПараметры.ИмяФормыИсточникаСообщения = ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	КонецЕсли;
	
	ШаблоныСообщенийКлиент.СформироватьСообщение(ПараметрКоманды, "Письмо",,, ДополнительныеПараметры);
КонецПроцедуры

#КонецОбласти
