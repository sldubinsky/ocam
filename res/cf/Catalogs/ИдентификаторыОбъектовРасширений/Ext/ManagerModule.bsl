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

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ПоляЕстественногоКлюча();
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбработкаПолученияПолейПредставления(Поля,
		СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбработкаПолученияПредставления(Данные,
		Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолныеИменаТаблицСДанными() Экспорт
	
	Таблицы = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) Тогда
		Возврат Таблицы;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|ГДЕ
	|	ВерсииИдентификаторов.ВерсияРасширений = &ВерсияРасширений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВерсииИдентификаторов.ПолноеИмяОбъекта КАК ПолноеИмяОбъекта
	|ИЗ
	|	РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|ГДЕ
	|	ВерсииИдентификаторов.ВерсияРасширений = &ВерсияРасширений
	|	И ВерсииИдентификаторов.Идентификатор.БезДанных = ЛОЖЬ";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатыЗапроса[0].Пустой() Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ДанныеОбновлены(Истина, Истина);
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
	КонецЕсли;
	
	Возврат РезультатыЗапроса[1].Выгрузить().ВыгрузитьКолонку("ПолноеИмяОбъекта");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные справочника по метаданным конфигурации.
//
// Параметры:
//  ЕстьИзменения  - Булево - возвращаемое значение. В этот параметр возвращается
//                   значение Истина, если производилась запись, иначе не изменяется.
//
//  ЕстьУдаленные  - Булево - возвращаемое значение. В этот параметр возвращается
//                   значение Истина, если хотя бы один элемент справочника был помечен
//                   на удаление, иначе не изменяется.
//
//  ТолькоПроверка - Булево - не производить никаких изменений, а лишь выполнить
//                   установку флажков ЕстьИзменения, ЕстьУдаленные.
//
Процедура ОбновитьДанныеСправочника(ЕстьИзменения = Ложь, ЕстьУдаленные = Ложь, ТолькоПроверка = Ложь) Экспорт
	
	Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(ЕстьИзменения,
		ЕстьУдаленные, ТолькоПроверка, , , Истина);
	
КонецПроцедуры

// Возвращает Истина, если объект метаданных, которому соответствует
// идентификатор объектов расширений существует в справочнике и
// не помечен на удаление, но отсутствует в кэше метаданных расширений.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ИдентификаторыОбъектовРасширений - идентификатор
//                    объекта метаданных расширения.
//
// Возвращаемое значение:
//  Булево - Истина, если отключен.
//
Функция ОбъектРасширенияОтключен(Идентификатор) Экспорт
	
	СтандартныеПодсистемыПовтИсп.ИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина, Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Идентификатор);
	Запрос.УстановитьПараметр("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовРасширений КАК Идентификаторы
	|ГДЕ
	|	Идентификаторы.Ссылка = &Ссылка
	|	И НЕ Идентификаторы.ПометкаУдаления
	|	И НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|				ГДЕ
	|					ВерсииИдентификаторов.Идентификатор = Идентификаторы.Ссылка
	|					И ВерсииИдентификаторов.ВерсияРасширений = &ВерсияРасширений)";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Только для внутреннего использования.
Функция ИдентификаторыОбъектовТекущейВерсииРасширенийЗаполнены() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|ГДЕ
	|	ВерсииИдентификаторов.ВерсияРасширений = &ВерсияРасширений";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
