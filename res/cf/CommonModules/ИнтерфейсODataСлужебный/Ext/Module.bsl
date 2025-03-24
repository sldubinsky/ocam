﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает объект метаданных по типу ссылки
//
// Параметры:
//  ТипСсылки - Тип,
//
// Возвращаемое значение:
//   ОбъектМетаданных
//
Функция ОбъектМетаданныхПоТипуСсылки(Знач ТипСсылки) Экспорт
	
	БизнесПроцесс = СсылкиТочекМаршрутаБизнесПроцессов().Получить(ТипСсылки);
	Если БизнесПроцесс = Неопределено Тогда
		Ссылка = Новый(ТипСсылки);
		МетаданныеСсылки = Ссылка.Метаданные();
	Иначе
		МетаданныеСсылки = Метаданные.БизнесПроцессы[БизнесПроцесс];
	КонецЕсли;
	
	Возврат МетаданныеСсылки;
	
КонецФункции

// Возвращает: ссылочный ли это тип или нет.
//
// Параметры:
//  ПроверяемыйТип - Тип - проверяемый тип.
//
// Возвращаемое значение:
//   Булево - Истина - если тип примитивный.
//
Функция ЭтоСсылочныйТип(Знач ПроверяемыйТип) Экспорт
	
	Возврат ОписаниеСсылочныхТипов().СодержитТип(ПроверяемыйТип);
	
КонецФункции

// Проверяет, что тип содержит набор ссылочных типов.
//
// Параметры:
//  ОписаниеТипов - ОписаниеТипов.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоНаборТиповСсылок(Знач ОписаниеТипов) Экспорт
	
	Если ОписаниеТипов.Типы().Количество() < 2 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СериализацияОписанияТипов = СериализаторXDTO.ЗаписатьXDTO(ОписаниеТипов);
	
	Если СериализацияОписанияТипов.TypeSet.Количество() > 0 Тогда
		
		СодержитНаборыСсылок = Ложь;
		
		Для Каждого НаборТипов Из СериализацияОписанияТипов.TypeSet Цикл
			
			Если НаборТипов.URIПространстваИмен = "http://v8.1c.ru/8.1/data/enterprise/current-config" Тогда
				
				Если НаборТипов.ЛокальноеИмя = "AnyRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "CatalogRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "DocumentRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "BusinessProcessRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "TaskRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfAccountsRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ExchangePlanRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfCharacteristicTypesRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfCalculationTypesRef" Тогда
					
					СодержитНаборыСсылок = Истина;
					Прервать;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат СодержитНаборыСсылок;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных последовательности.
//
// Параметры:
//  ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоНаборЗаписейПоследовательности(Знач ОбъектМетаданных) Экспорт
	
	Возврат ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, ИнтерфейсODataСлужебныйПовтИсп.КлассыМетаданныхВМоделиКонфигурации().Последовательности);
	
КонецФункции

// Проверяет, является ли переданный объект метаданных перерасчетом.
//
// Параметры:
//  ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоНаборЗаписейПерерасчета(Знач ОбъектМетаданных) Экспорт
	
	Возврат ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, ИнтерфейсODataСлужебныйПовтИсп.КлассыМетаданныхВМоделиКонфигурации().Перерасчеты);
	
КонецФункции

// Проверяет, является ли переданный объект метаданных набором записей.
//
// Параметры:
//  ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоНаборЗаписей(Знач ОбъектМетаданных) Экспорт
	
	КлассыМетаданных = ИнтерфейсODataСлужебныйПовтИсп.КлассыМетаданныхВМоделиКонфигурации();
	Возврат ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, КлассыМетаданных.РегистрыСведений)
		Или ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, КлассыМетаданных.РегистрыНакопления)
		Или ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, КлассыМетаданных.РегистрыБухгалтерии)
		Или ЭтоОбъектМетаданныхКласса(ОбъектМетаданных, КлассыМетаданных.РегистрыРасчета)
		Или ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) 
		Или ЭтоНаборЗаписейПерерасчета(ОбъектМетаданных);
	
КонецФункции

#Область ОбработчикиСобытий

Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	Состав = ОбщегоНазначения.ВычислитьВБезопасномРежиме("ПолучитьСоставСтандартногоИнтерфейсаOData()");
	СериализуемыйСостав = Новый Массив();
	
	Для Каждого ЭлементСостава Из Состав Цикл
		СериализуемыйСостав.Добавить(ЭлементСостава.ПолноеИмя());
	КонецЦикла;
	
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл("xml", ТипДанныхДляСоставаСтандартногоИнтерфейсаOData());
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	
	Сериализатор = СериализаторXDTO;
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
	
	ПрефиксыПространствИмен = ПрефиксыПространствИмен();
	Для Каждого ПрефиксПространстваИмен Из ПрефиксыПространствИмен Цикл
		ПотокЗаписи.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен.Значение, ПрефиксПространстваИмен.Ключ);
	КонецЦикла;
	
	Сериализатор.ЗаписатьXML(ПотокЗаписи, СериализуемыйСостав, НазначениеТипаXML.Явное);
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	ИмяФайла = Контейнер.ПолучитьПроизвольныйФайл(ТипДанныхДляСоставаСтандартногоИнтерфейсаOData());
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"), "Data");
		
	КонецЕсли;
	
	Если Не ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Состав = СериализаторXDTO.ПрочитатьXML(ПотокЧтения);
	ПотокЧтения.Закрыть();
	
	Если Состав.Количество() > 0 Тогда
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме("УстановитьСоставСтандартногоИнтерфейсаOData(Параметры)", Состав);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает описание типов, содержащее все ссылочные типы объектов метаданных, существующих
// в конфигурации.
//
// Возвращаемое значение:
//   ОписаниеТипов
//
Функция ОписаниеСсылочныхТипов()
	
	ОписаниеТипаЛюбаяСсылкаXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://v8.1c.ru/8.1/data/core", "TypeDescription"));
	ОписаниеТипаЛюбаяСсылкаXDTO.TypeSet.Добавить(СериализаторXDTO.ЗаписатьXDTO(Новый РасширенноеИмяXML(
		"http://v8.1c.ru/8.1/data/enterprise/current-config", "AnyRef")));
	ОписаниеТипаЛюбаяСсылка = СериализаторXDTO.ПрочитатьXDTO(ОписаниеТипаЛюбаяСсылкаXDTO);
	
	Возврат ОписаниеТипаЛюбаяСсылка;
	
КонецФункции

// Возвращает ссылки точек маршрута бизнес-процессов.
//
// Возвращаемое значение:
//   ФиксированноеСоответствие из КлючИЗначение:
//                        * Ключ - Тип - тип ТочкаМаршрутаБизнесПроцессаСсылка,
//                        * Значение - Строка - имя бизнес-процесса.
//
Функция СсылкиТочекМаршрутаБизнесПроцессов()
	
	СсылкиТочекМаршрутаБизнесПроцессов = Новый Соответствие();
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл
		СсылкиТочекМаршрутаБизнесПроцессов.Вставить(Тип("ТочкаМаршрутаБизнесПроцессаСсылка." + БизнесПроцесс.Имя), БизнесПроцесс.Имя);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СсылкиТочекМаршрутаБизнесПроцессов);
	
КонецФункции

Функция СвойстваОбъектаМоделиКонфигурации(Знач Модель, Знач ОбъектМетаданных) Экспорт
	
	Если ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданных") Тогда
		Имя = ОбъектМетаданных.Имя;
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	Иначе
		ПолноеИмя = ОбъектМетаданных;
		Имя = СтрРазделить(ПолноеИмя, ".").Получить(1);
	КонецЕсли;
	
	Для Каждого КлассМодели Из Модель Цикл
		ОписаниеОбъекта = КлассМодели.Значение.Получить(Имя);
		Если ОписаниеОбъекта <> Неопределено Тогда
			Если ПолноеИмя = ОписаниеОбъекта.ПолноеИмя Тогда
				Возврат ОписаниеОбъекта;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
	
КонецФункции

Функция ЭтоОбъектМетаданныхКласса(Знач ОбъектМетаданных, Знач Класс) Экспорт
	
	Если ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданных") Тогда
		Имя = ОбъектМетаданных.Имя;
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	Иначе
		ПолноеИмя = ОбъектМетаданных;
		Имя = СтрРазделить(ПолноеИмя, ".").Получить(1);
	КонецЕсли;
	
	ГруппаМодели = ИнтерфейсODataСлужебныйПовтИсп.ОписаниеМоделиДанныхКонфигурации().Получить(Класс);
	
	ОписаниеОбъекта = ГруппаМодели.Получить(Имя);
	
	Если ОписаниеОбъекта <> Неопределено Тогда
		
		Возврат ПолноеИмя = ОписаниеОбъекта.ПолноеИмя;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ТипДанныхДляСоставаСтандартногоИнтерфейсаOData()
	
	Возврат "StandardODataInterfaceContent"; // Не локализуется
	
КонецФункции

Функция ПрефиксыПространствИмен()
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("http://www.w3.org/2001/XMLSchema", "xs");
	Результат.Вставить("http://www.w3.org/2001/XMLSchema-instance", "xsi");
	Результат.Вставить("http://v8.1c.ru/8.1/data/core", "v8");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise", "ns");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise/current-config", "cc");
	Результат.Вставить("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "dmp");
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти