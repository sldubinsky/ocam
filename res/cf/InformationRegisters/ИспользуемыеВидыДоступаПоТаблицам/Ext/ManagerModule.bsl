﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные регистра при изменении использования видов доступа.
//
// Параметры:
//  Таблицы       - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//                - СправочникСсылка.ИдентификаторыОбъектовРасширений
//                - Массив - значения указанных выше типов.
//                - Неопределено - без отбора.
//
//  ТипыЗначенийДоступа - ОпределяемыйТип.ЗначениеДоступа
//                      - Массив - значения указанного выше типа.
//                      - Неопределено - без отбора.
//
//  ЕстьИзменения - Булево - (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(Таблицы = Неопределено, ТипыЗначенийДоступа = Неопределено,
			ЕстьИзменения = Неопределено) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицыГруппДоступа.Таблица КАК Таблица,
	|	ЗначенияГруппДоступаПоУмолчанию.ТипЗначенийДоступа КАК ТипЗначенийДоступа,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	РегистрСведений.ЗначенияГруппДоступаПоУмолчанию КАК ЗначенияГруппДоступаПоУмолчанию
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
	|		ПО (ТаблицыГруппДоступа.ГруппаДоступа = ЗначенияГруппДоступаПоУмолчанию.ГруппаДоступа)
	|			И (НЕ ЗначенияГруппДоступаПоУмолчанию.ВсеРазрешеныБезИсключений)
	|			И (ВЫБОР
	|				КОГДА ТаблицыГруппДоступа.ПравоДобавление
	|					ТОГДА НЕ ТаблицыГруппДоступа.ПравоДобавлениеБезОграничения
	|				КОГДА ТаблицыГруппДоступа.ПравоИзменение
	|					ТОГДА НЕ ТаблицыГруппДоступа.ПравоИзменениеБезОграничения
	|				ИНАЧЕ НЕ ТаблицыГруппДоступа.ПравоЧтениеБезОграничения
	|			КОНЕЦ)
	|			И (&УсловиеОтбораТиповЗначений1)
	|			И (&УсловиеОтбораТаблиц1)";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("Таблица",            "&УсловиеОтбораТаблиц2"));
	Поля.Добавить(Новый Структура("ТипЗначенийДоступа", "&УсловиеОтбораТиповЗначений2"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ИспользуемыеВидыДоступаПоТаблицам");
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, Таблицы, "Таблицы",
		"&УсловиеОтбораТаблиц1:ТаблицыГруппДоступа.Таблица
		|&УсловиеОтбораТаблиц2:СтарыеДанные.Таблица");
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, ТипыЗначенийДоступа, "ТипыЗначенийДоступа",
		"&УсловиеОтбораТиповЗначений1:ЗначенияГруппДоступаПоУмолчанию.ТипЗначенийДоступа
		|&УсловиеОтбораТиповЗначений2:СтарыеДанные.ТипЗначенийДоступа");
	
	Если ТипыЗначенийДоступа <> Неопределено
	   И Таблицы = Неопределено Тогда
		
		ИзмеренияОтбора = "ТипЗначенийДоступа";
	Иначе
		ИзмеренияОтбора = Неопределено;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.ИспользуемыеВидыДоступаПоТаблицам");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Данные = Новый Структура;
		Данные.Вставить("МенеджерРегистра",      РегистрыСведений.ИспользуемыеВидыДоступаПоТаблицам);
		Данные.Вставить("ИзмененияСоставаСтрок", Запрос.Выполнить().Выгрузить());
		Данные.Вставить("ИзмеренияОтбора",       ИзмеренияОтбора);
		
		ЕстьТекущиеИзменения = Ложь;
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(Данные, ЕстьТекущиеИзменения);
		
		Если ЕстьТекущиеИзменения Тогда
			ЕстьИзменения = Истина;
			УправлениеДоступомСлужебный.ЗапланироватьОбновлениеПараметровОграниченияДоступа(
				"ПриИзмененииИспользованияВидовДоступаПоТаблицам");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
