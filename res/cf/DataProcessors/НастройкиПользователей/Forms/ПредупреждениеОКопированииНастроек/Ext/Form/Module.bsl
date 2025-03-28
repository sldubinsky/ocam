﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОткрытыеКопируемыеФормы = Параметры.ОткрытыеКопируемыеФормы;
	Элементы.ГруппаАктивныеПользователи.Видимость    = Параметры.ЕстьАктивныеПользователиПолучатели;
	Элементы.ГруппаОткрытыеКопируемыеФормы.Видимость = ЗначениеЗаполнено(ОткрытыеКопируемыеФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокАктивныхПользователейНажатие(Элемент)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОткрытыеФормыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ПоказатьПредупреждение(, ОткрытыеКопируемыеФормы);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Скопировать(Команда)
	
	Если Параметры.Действие <> "СкопироватьИЗакрыть" Тогда
		Закрыть();
	КонецЕсли;
	
	Результат = Новый Структура("Действие", Параметры.Действие);
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
