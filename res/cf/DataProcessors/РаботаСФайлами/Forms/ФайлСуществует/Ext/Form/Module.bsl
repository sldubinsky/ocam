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
	
	ПрименитьДляВсех = Параметры.ПрименитьДляВсех;
	ТекстСообщения   = Параметры.ТекстСообщения;
	БазовоеДействие  = Параметры.БазовоеДействие;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьКнопкуУмолчания(БазовоеДействие);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаписатьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Да);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Пропустить);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Прервать);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьКнопкуУмолчания(ДействиеПоУмолчанию)
	
	Если ДействиеПоУмолчанию = ""
	 Или ДействиеПоУмолчанию = "Пропустить" Тогда
		
		Элементы.Пропустить.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ДействиеПоУмолчанию = "Да" Тогда
		Элементы.Перезаписать.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ДействиеПоУмолчанию = "Прервать" Тогда
		Элементы.Прервать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
