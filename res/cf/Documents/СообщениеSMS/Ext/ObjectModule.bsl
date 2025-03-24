﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Взаимодействия

// Процедура формирует строки списка участников.
//
// Параметры:
//  Контакты  - Массив - массив структур, описывающих участников взаимодействия.
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Адресаты, Перечисления.ТипыКонтактнойИнформации.Телефон, Истина);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ВзаимодействияСобытия.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		МодульШаблоныСообщений = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщений");
		Если МодульШаблоныСообщений.ЭтоШаблон(ДанныеЗаполнения) Тогда
			ЗаполнитьНаОснованииШаблона(ДанныеЗаполнения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Тема = Взаимодействия.ТемаПоТекстуСообщения(ТекстСообщения);
	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);
	
	Если Метаданные.ОбщиеМодули.Найти("ВзаимодействияЛокализация") <> Неопределено Тогда 
		
		МодульВзаимодействияЛокализация = ОбщегоНазначения.ОбщийМодуль("ВзаимодействияЛокализация");
		
		Для Каждого СтрокаАдресаты Из Адресаты Цикл
			МодульВзаимодействияЛокализация.ОтформатироватьТелефонныйНомерДляОтправки(СтрокаАдресаты.КакСвязаться, СтрокаАдресаты.НомерДляОтправки);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииШаблона(ШаблонСсылка)
	
	МодульШаблоныСообщений = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщений");
	Сообщение = МодульШаблоныСообщений.СформироватьСообщение(ШаблонСсылка, Неопределено, Новый УникальныйИдентификатор);
	
	ТекстСообщения  = Сообщение.Текст;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли