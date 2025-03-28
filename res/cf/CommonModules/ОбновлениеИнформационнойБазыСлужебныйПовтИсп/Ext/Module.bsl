﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает минимальную версию информационной базы среди всех областей данных.
//
// Возвращаемое значение:
//  Строка - например, "2.3.1.4".
//
Функция МинимальнаяВерсияИБ() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль(
			"ОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса");
		
		МинимальнаяВерсияОбластейДанных = МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса.МинимальнаяВерсияОбластейДанных();
	Иначе
		МинимальнаяВерсияОбластейДанных = Неопределено;
	КонецЕсли;
	
	ВерсияИБ = ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(Метаданные.Имя);
	
	Если МинимальнаяВерсияОбластейДанных = Неопределено Тогда
		МинимальнаяВерсияИБ = ВерсияИБ;
	Иначе
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, МинимальнаяВерсияОбластейДанных) > 0 Тогда
			МинимальнаяВерсияИБ = МинимальнаяВерсияОбластейДанных;
		Иначе
			МинимальнаяВерсияИБ = ВерсияИБ;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МинимальнаяВерсияИБ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверить необходимость обновления информационной базы при смене версии конфигурации.
//
Функция НеобходимоОбновлениеИнформационнойБазы() Экспорт
	
	Если ОбновлениеИнформационнойБазыСлужебный.НеобходимоВыполнитьОбновление(
			Метаданные.Версия, ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(Метаданные.Имя)) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не ОбновлениеИнформационнойБазыСлужебный.ВыполненаРегистрацияОтложенныхОбработчиковОбновления() Тогда
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запустить = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ЗапуститьОбновлениеИнформационнойБазы");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Запустить <> Неопределено И ОбновлениеИнформационнойБазыСлужебный.ЕстьПраваНаОбновлениеИнформационнойБазы() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает соответствие имен и идентификаторов отложенных обработчиков
// и их очередей.
//
Функция ОчередьОтложенногоОбработчикаОбновления() Экспорт
	
	Обработчики        = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	ОписанияПодсистем  = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем();
	Для Каждого ИмяПодсистемы Из ОписанияПодсистем.Порядок Цикл
		ОписаниеПодсистемы = ОписанияПодсистем.ПоИменам.Получить(ИмяПодсистемы);
		Если ОписаниеПодсистемы.РежимВыполненияОтложенныхОбработчиков <> "Параллельно" Тогда
			Продолжить;
		КонецЕсли;
		
		Модуль = ОбщегоНазначения.ОбщийМодуль(ОписаниеПодсистемы.ОсновнойСерверныйМодуль);
		Модуль.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЦикла;
	
	Отбор = Новый Структура;
	Отбор.Вставить("РежимВыполнения", "Отложенно");
	ОтложенныеОбработчики = Обработчики.НайтиСтроки(Отбор);
	
	ОчередьПоИмени          = Новый Соответствие;
	ОчередьПоИдентификатору = Новый Соответствие;
	Для Каждого ОтложенныйОбработчик Из ОтложенныеОбработчики Цикл
		Если ОтложенныйОбработчик.ОчередьОтложеннойОбработки = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОчередьПоИмени.Вставить(ОтложенныйОбработчик.Процедура, ОтложенныйОбработчик.ОчередьОтложеннойОбработки);
		Если ЗначениеЗаполнено(ОтложенныйОбработчик.Идентификатор) Тогда
			ОчередьПоИдентификатору.Вставить(ОтложенныйОбработчик.Идентификатор, ОтложенныйОбработчик.ОчередьОтложеннойОбработки);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Соответствие;
	Результат.Вставить("ПоИмени", ОчередьПоИмени);
	Результат.Вставить("ПоИдентификатору", ОчередьПоИдентификатору);
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Кеширует типы объектов метаданных при проверке наличия
// записываемого объекта на составе плана обмена ОбновлениеИнформационнойБазы.
// 
// Возвращаемое значение:
//  Соответствие
//
Функция КешПроверкиЗарегистрированныхОбъектов() Экспорт
	
	Возврат Новый Соответствие;
	
КонецФункции

#КонецОбласти
