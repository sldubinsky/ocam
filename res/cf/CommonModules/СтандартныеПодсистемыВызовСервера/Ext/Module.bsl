﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает состояние отмены при создании форм рабочего стола.
// Требуется, если при запуске программы возникает необходимость
// взаимодействия с пользователем (интерактивная обработка).
//
// Используется из одноименной процедуры в модуле СтандартныеПодсистемыКлиент.
// Прямой вызов на сервере имеет смысл для сокращения серверных вызовов,
// если при подготовке параметров клиента через модуль ПовтИсп уже
// известно, что интерактивная обработка требуется.
//
// Если прямой вызов сделан из процедуры получения параметров клиент,
// то состояние на клиенте будет обновлено автоматически, в другом случае
// это нужно сделать самостоятельно на клиенте с помощью одноименной процедуры
// в модуле СтандартныеПодсистемыКлиент.
//
// Параметры:
//  Скрыть - Булево - если установить Истина, состояние будет установлено,
//           если установить Ложь, состояние будет снято (после этого
//           можно выполнить метод ОбновитьИнтерфейс и формы рабочего
//           стола будут пересозданы).
//
Процедура СкрытьРабочийСтолПриНачалеРаботыСистемы(Скрыть = Истина) Экспорт
	
	Если ТекущийРежимЗапуска() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Сохранение или восстановление состава форм начальной страницы.
	КлючОбъекта         = "Общее/НастройкиНачальнойСтраницы";
	КлючОбъектаХранения = "Общее/НастройкиНачальнойСтраницыПередОчисткой";
	СохраненныеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъектаХранения, "");
	
	Если ТипЗнч(Скрыть) <> Тип("Булево") Тогда
		Скрыть = ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения");
	КонецЕсли;
	
	Если Скрыть Тогда
		Если ТипЗнч(СохраненныеНастройки) <> Тип("ХранилищеЗначения") Тогда
			ТекущиеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта);
			СохраняемыеНастройки = Новый ХранилищеЗначения(ТекущиеНастройки);
			ХранилищеСистемныхНастроек.Сохранить(КлючОбъектаХранения, "", СохраняемыеНастройки);
		КонецЕсли;
		СтандартныеПодсистемыСервер.УстановитьПустуюФормуНаРабочийСтол();
	Иначе
		Если ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения") Тогда
			СохраненныеНастройки = СохраненныеНастройки.Получить();
			Если СохраненныеНастройки = Неопределено Тогда
				ХранилищеСистемныхНастроек.Удалить(КлючОбъекта, Неопределено,
					ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
			Иначе
				ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, "", СохраненныеНастройки);
			КонецЕсли;
			ХранилищеСистемныхНастроек.Удалить(КлючОбъектаХранения, Неопределено,
				ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
		КонецЕсли;
	КонецЕсли;
	
	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);
	
	Если Скрыть Тогда
		ТекущиеПараметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Истина);
		
	ИначеЕсли ТекущиеПараметры.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено Тогда
		ТекущиеПараметры.Удалить("СкрытьРабочийСтолПриНачалеРаботыСистемы");
	КонецЕсли;
	
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
	
КонецПроцедуры

// См. ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек.
Функция РасчетныеПоказателиЯчеек(Знач ТабличныйДокумент, ВыделенныеОбласти, УникальныйИдентификатор = Неопределено) Экспорт 
	
	Если УникальныйИдентификатор = Неопределено Тогда 
		Возврат ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(ТабличныйДокумент, ВыделенныеОбласти);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Расчет показателей ячеек'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения, 
		"ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек",
		ТабличныйДокумент,
		ВыделенныеОбласти);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода конфигурации
// при запуске, т.е. в обработчиках событий ПередНачаломРаботыСистемы, ПриНачалеРаботыСистемы.
//
// Только для вызова из СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске.
//
Функция ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	НовыеПараметры = Новый Структура;
	ДобавитьПоправкиКВремени(НовыеПараметры, Параметры);
	ОбработатьПараметрыКлиентаНаСервере(Параметры);
	
	ЗапомнитьВременныеПараметры(Параметры);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Параметры, НовыеПараметры);
	
	Если Параметры.ПолученныеПараметрыКлиента <> Неопределено Тогда
		Если НЕ Параметры.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
			// Обновить состояние скрытия рабочего стола, если при предыдущем
			// запуске произошел сбой до момента штатного восстановления.
			СкрытьРабочийСтолПриНачалеРаботыСистемы(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
	КонецЕсли;
	
	ПользователиСлужебный.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры, Неопределено, Ложь);
	
	ИнтеграцияПодсистемБСП.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	
	ПрикладныеПараметры = Новый Структура;
	ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(ПрикладныеПараметры);
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Возврат ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода конфигурации. 
// Только для вызова из СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента.
//
Функция ПараметрыРаботыКлиента(СвойстваКлиента) Экспорт
	
	Параметры = Новый Структура;
	ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента);
	ОбработатьПараметрыКлиентаНаСервере(СвойстваКлиента);
	
	ИнтеграцияПодсистемБСП.ПриДобавленииПараметровРаботыКлиента(Параметры);
	
	ПрикладныеПараметры = Новый Структура;
	ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента(ПрикладныеПараметры);
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// См. РаботаВМоделиСервиса.ВойтиВОбластьДанных.
Процедура ВойтиВОбластьДанных(Знач ОбластьДанных) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ВойтиВОбластьДанных(ОбластьДанных);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет право на отключение логики работы системы и
// скрывает рабочий стол на сервере, если право есть,
// в противном случае вызывает исключение.
// 
Процедура ПроверитьПравоОтключитьЛогикуНачалаРаботыСистемы(СвойстваКлиента) Экспорт
	
	ОбработатьПараметрыКлиентаНаСервере(СвойстваКлиента);
	СкрытьРабочийСтолПриНачалеРаботыСистемы(Истина);
	
	ВходВОбластьДанных = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Если Не ВходВОбластьДанных
	   И Не ПравоДоступа("Администрирование", Метаданные)
	 Или ВходВОбластьДанных
	   И Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		
		ТекстОшибки = НСтр("ru = 'Недостаточно прав для работы с отключенной логикой начала работы системы.'");
	Иначе
		ТекстОшибки = ПользователиСлужебный.ОшибкаПроверкиПравТекущегоПользователяПриВходе();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		СвойстваКлиента.Вставить("ОшибкаНетПраваОтключитьЛогикуНачалаРаботыСистемы", ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ЗаписатьОшибкуВЖурналРегистрацииПриЗапускеИлиЗавершении(ПрекратитьРаботу, Знач Событие, Знач ТекстОшибки) Экспорт
	
	Если Событие = "Запуск" Тогда
		ИмяСобытия = НСтр("ru = 'Запуск программы'", ОбщегоНазначения.КодОсновногоЯзыка());
		Если ПрекратитьРаботу Тогда
			НачалоОписанияОшибки = НСтр("ru = 'Запуск программы невозможен по причине:'");
		Иначе
			НачалоОписанияОшибки = НСтр("ru = 'Возникла исключительная ситуация при запуске программы:'");
		КонецЕсли;
	Иначе
		ИмяСобытия = НСтр("ru = 'Завершение программы'", ОбщегоНазначения.КодОсновногоЯзыка());
		НачалоОписанияОшибки = НСтр("ru = 'Возникла исключительная ситуация при завершении программы:'");
	КонецЕсли;
	
	ОписаниеОшибки = НачалоОписанияОшибки + Символы.ПС + Символы.ПС + ТекстОшибки;
	ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки);

КонецПроцедуры

// Вызывается из обработчика ожидания каждые 20 минут, например, для контроля
// динамического обновления и окончания срока действия учетной записи пользователя.
//
// Параметры:
//  Параметры - Структура - в структуру следует вставить свойства для дальнейшего анализа на клиенте.
//
Процедура ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры) Экспорт
	
	КонфигурацияБазыДанныхИзмененаДинамически = КонфигурацияБазыДанныхИзмененаДинамически();
	Параметры.Вставить("КонфигурацияБазыДанныхИзмененаДинамически", КонфигурацияБазыДанныхИзмененаДинамически
		Или Справочники.ВерсииРасширений.РасширенияИзмененыДинамически());
	
	ДинамическиеИзменения = Справочники.ВерсииРасширений.ДинамическиИзмененныеРасширения();
	
	МожноОповещать = Истина;
	Если ДинамическиеИзменения.Исправления <> Неопределено
		И ДинамическиеИзменения.Расширения = Неопределено
		И Не КонфигурацияБазыДанныхИзмененаДинамически Тогда
		// Изменился только состав исправлений, необходимо проверить возможность отображения оповещения.
		Если ДинамическиеИзменения.Исправления.Добавлено <> 0
			И ДинамическиеИзменения.Исправления.Удалено = 0 Тогда
			РасписаниеОповещения = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("КонтрольДинамическогоОбновления", "РасписаниеПроверкиПатчей");
			Если ТипЗнч(РасписаниеОповещения) = Тип("Структура")
				И РасписаниеОповещения.Свойство("Расписание")
				И ТипЗнч(РасписаниеОповещения.Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
				ТекущаяДатаСеанса = ТекущаяДатаСеанса();
				МожноОповещать = РасписаниеОповещения.Расписание.ТребуетсяВыполнение(ТекущаяДатаСеанса, РасписаниеОповещения.ПоследнееОповещение);
				Если МожноОповещать Тогда
					РасписаниеОповещения.ПоследнееОповещение = ТекущаяДатаСеанса;
					ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("КонтрольДинамическогоОбновления", "РасписаниеПроверкиПатчей", РасписаниеОповещения);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДинамическиеИзменения.Вставить("КонфигурацияБазыДанныхИзмененаДинамически", КонфигурацияБазыДанныхИзмененаДинамически);
	СообщениеПользователю = СтандартныеПодсистемыСервер.ТекстСообщенияПриДинамическомОбновлении(ДинамическиеИзменения);
	ОповещатьПользователя = СтандартныеПодсистемыСервер.ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы();
	ДинамическиеИзменения.Вставить("СообщениеПользователю", СообщениеПользователю);
	ДинамическиеИзменения.Вставить("ОповещатьПользователя", ОповещатьПользователя И МожноОповещать);
	Параметры.Вставить("ДинамическиеИзмененияКонфигурации", ДинамическиеИзменения);
	
	ПользователиСлужебный.ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		МодульЦентрМониторингаСлужебный.ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры.ЦентрМониторинга);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает полное имя объекта метаданных по его типу.
Функция ПолноеИмяОбъектаМетаданных(Тип) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОбъектМетаданных.ПолноеИмя();
КонецФункции

// Возвращает имя объекта метаданных по типу.
//
// Параметры:
//  Источник - Тип - объект.
//
// Возвращаемое значение:
//   Строка
//
Функция ИмяОбъектаМетаданных(Тип) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОбъектМетаданных.Имя;
КонецФункции

// См. СтандартныеПодсистемыСервер.ВерсияБиблиотеки.
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат СтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными.

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для справочника ИдентификаторыОбъектовМетаданных.

// См. Справочники.ИдентификаторыОбъектовМетаданных.ПредставлениеИдентификатора
Функция ПредставлениеИдентификатораОбъектаМетаданных(Ссылка) Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ПредставлениеИдентификатора(Ссылка);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента)
	
	ДатаСеанса = ТекущаяДатаСеанса();
	ДатаСеансаУниверсальная = УниверсальноеВремя(ДатаСеанса, ЧасовойПоясСеанса());
	
	Параметры.Вставить("ПоправкаКВремениСеанса", ДатаСеанса - СвойстваКлиента.ТекущаяДатаНаКлиенте);
	Параметры.Вставить("ПоправкаКУниверсальномуВремени", ДатаСеансаУниверсальная - ДатаСеанса);
	Параметры.Вставить("СмещениеСтандартногоВремени", СмещениеСтандартногоВремени(ЧасовойПоясСеанса()));
	Параметры.Вставить("СмещениеДатыКлиента", ТекущаяУниверсальнаяДатаВМиллисекундах()
		- СвойстваКлиента.ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте);
	
КонецПроцедуры

Процедура ЗапомнитьВременныеПараметры(Параметры)
	
	Параметры.Вставить("ИменаВременныхПараметров", Новый Массив);
	
	Для каждого КлючИЗначение Из Параметры Цикл
		ИменаВременныхПараметров = Параметры.ИменаВременныхПараметров; // Массив
		ИменаВременныхПараметров.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьПараметрыКлиентаНаСервере(Знач Параметры)
	
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПервыйСерверныйВызовВыполнен") <> Истина Тогда
		// Первый серверный вызов с клиента при запуске.
		ПараметрыКлиента = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);
		ПараметрыКлиента.Вставить("ПервыйСерверныйВызовВыполнен", Истина);
		ПараметрыКлиента.Вставить("ПараметрЗапуска", Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы", Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске", ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент", Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоМобильныйКлиент", Параметры.ЭтоМобильныйКлиент);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент", Параметры.ЭтоLinuxКлиент);
		ПараметрыКлиента.Вставить("ЭтоMacOSКлиент", Параметры.ЭтоMacOSКлиент);
		ПараметрыКлиента.Вставить("ЭтоWindowsКлиент", Параметры.ЭтоWindowsКлиент);
		ПараметрыКлиента.Вставить("ИспользуемыйКлиент", Параметры.ИспользуемыйКлиент);
		ПараметрыКлиента.Вставить("ОперативнаяПамять", Параметры.ОперативнаяПамять);
		ПараметрыКлиента.Вставить("КаталогПрограммы", Параметры.КаталогПрограммы);
		ПараметрыКлиента.Вставить("ИдентификаторКлиента", Параметры.ИдентификаторКлиента);
		ПараметрыКлиента.Вставить("РазрешениеОсновногоЭкрана", Параметры.РазрешениеОсновногоЭкрана);
		
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);
		
		Если СтрНайти(НРег(Параметры.ПараметрЗапуска), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
			ОбновлениеИнформационнойБазыСлужебный.УстановитьЗапускОбновленияИнформационнойБазы(Истина);
		КонецЕсли;
		
		Если Не ОбщегоНазначения.РазделениеВключено() Тогда
			Если ПланыОбмена.ГлавныйУзел() <> Неопределено
				Или ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
				// Предотвращение случайного обновления предопределенных данных в подчиненном узле РИБ:
				// - при запуске с временно отмененным главным узлом;
				// - при реструктуризации данных в процессе восстановления узла.
				Если ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()
					<> ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически Тогда
					УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы(
					ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически);
				КонецЕсли;
				Если ПланыОбмена.ГлавныйУзел() <> Неопределено
					И Не ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
					// Сохранение главного узла для возможности восстановления.
					СтандартныеПодсистемыСервер.СохранитьГлавныйУзел();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрНайти(Параметры.ПараметрЗапуска, "ОтключитьЛогикуНачалаРаботыСистемы") = 0 Тогда
			РегистрыСведений.ПараметрыРаботыВерсийРасширений.ПриПервомСерверномВызове();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры)
	
	ПараметрыКлиента = Параметры;
	Параметры = Новый Структура;
	
	Для каждого ИмяВременногоПараметра Из ПараметрыКлиента.ИменаВременныхПараметров Цикл
		Параметры.Вставить(ИмяВременногоПараметра, ПараметрыКлиента[ИмяВременногоПараметра]);
		ПараметрыКлиента.Удалить(ИмяВременногоПараметра);
	КонецЦикла;
	Параметры.Удалить("ИменаВременныхПараметров");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы =
		ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
			"СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ПараметрыКлиента);
	
КонецФункции

Функция КомпонентаПоследнейВерсии(Идентификатор, Местоположение, ВнешняяКомпонента) Экспорт
	
	Возврат СтандартныеПодсистемыСервер.КомпонентаПоследнейВерсии(Идентификатор, Местоположение, ВнешняяКомпонента);
	
КонецФункции

#КонецОбласти
