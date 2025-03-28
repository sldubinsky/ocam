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

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.РазрешеноИзменятьВарианты = Ложь;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - РасширениеУправляемойФормыДляОтчета - форма отчета, где:
//     * Отчет - ДанныеФормыСтруктура
//             - ОтчетОбъект
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	Если ЖурналРегистрации.СмещениеВремениСервера() = 0 Тогда
		ПараметрКД = Форма.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатыВЧасовомПоясеСервера");
		Если ТипЗнч(ПараметрКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			ПараметрКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОтчета:
//    * Отчет - ДанныеФормыСтруктура
//            - ОтчетОбъект
//  СвойстваНастройки - см. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.СвойстваНастройки
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	ИмяПоля = Строка(СвойстваНастройки.ПолеКД);
	Если ИмяПоля = "ПараметрыДанных.СкрытьРегламентныеЗадания" Тогда
		МассивРегламентныхЗаданий = СписокВсехРегламентныхЗаданий();
		СвойстваНастройки.ЗначенияДляВыбора.Очистить();
		Для Каждого Элемент Из МассивРегламентныхЗаданий Цикл
			СвойстваНастройки.ЗначенияДляВыбора.Добавить(Элемент.УИД, Элемент.Наименование);
		КонецЦикла;
		СвойстваНастройки.ЗначенияДляВыбора.СортироватьПоПредставлению();
	КонецЕсли;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровкиОбъект, СтандартнаяОбработка, АдресХранилища)
	
	Если ОбщегоНазначения.РазделениеВключено()
		Или Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ВызватьИсключение НСтр("ru = 'Работа отчета в приложении в интернете не поддерживается.'");
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Период = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период").Значение; // СтандартныйПериод
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение;
	ДатыВЧасовомПоясеСервера = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ДатыВЧасовомПоясеСервера").Значение;
	Если ДатыВЧасовомПоясеСервера Тогда
		СмещениеВремениСервера = 0;
	Иначе
		СмещениеВремениСервера = ЖурналРегистрации.СмещениеВремениСервера();
	КонецЕсли;
	
	Если ВариантОтчета <> "ДиаграммаГанта" Тогда
		СхемаКомпоновкиДанных.Параметры.ПериодДень.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
	КонецЕсли;
	
	Если ВариантОтчета = "КонтрольЖурналаРегистрации" Тогда
		РезультатФормированияОтчета = Отчеты.АнализЖурналаРегистрации.
			СформироватьОтчетКонтрольЖурналаРегистрации(Период.ДатаНачала, Период.ДатаОкончания, СмещениеВремениСервера);
		// ОтчетПустой - параметр, показывающий наличие информации в отчете. Необходим для рассылки отчетов.
		ОтчетПустой = РезультатФормированияОтчета.ОтчетПустой;
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
		ДокументРезультат.Вывести(РезультатФормированияОтчета.Отчет);
	ИначеЕсли ВариантОтчета = "ДиаграммаГанта" Тогда
		ПродолжительностьРаботыРегламентныхЗаданий(НастройкиОтчета, ДокументРезультат, КомпоновщикНастроек, СмещениеВремениСервера);
	Иначе
		ПараметрыОтчета = ПараметрыОтчетаАктивностьПользователя(НастройкиОтчета);
		ПараметрыОтчета.Вставить("ДатаНачала", Период.ДатаНачала);
		ПараметрыОтчета.Вставить("ДатаОкончания", Период.ДатаОкончания);
		ПараметрыОтчета.Вставить("ВариантОтчета", ВариантОтчета);
		ПараметрыОтчета.Вставить("ДатыВЧасовомПоясеСервера", ДатыВЧасовомПоясеСервера);
		Если ВариантОтчета = "АнализАктивностиПользователей" Тогда
			СхемаКомпоновкиДанных.Параметры.Пользователь.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
		КонецЕсли;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровкиОбъект);
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ДанныеОтчета = Отчеты.АнализЖурналаРегистрации.ДанныеИзЖурналаРегистрации(ПараметрыОтчета);
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ДанныеОтчета.ОтчетПустой);
		ДанныеОтчета.Удалить("ОтчетПустой");
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ДанныеОтчета, ДанныеРасшифровкиОбъект, Истина);
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ПроцессорВывода.НачатьВывод();
		Пока Истина Цикл
			ЭлементРезультата = ПроцессорКомпоновки.Следующий();
			Если ЭлементРезультата = Неопределено Тогда
				Прервать;
			Иначе
				ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			КонецЕсли;
		КонецЦикла;
		ДокументРезультат.ПоказатьУровеньГруппировокСтрок(1);
		ПроцессорВывода.ЗакончитьВывод();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение;
	Если ВариантОтчета = "ДиаграммаГанта" Тогда
		ПериодДень = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодДень").Значение;
		НачалоВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("НачалоВыборки");
		КонецВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("КонецВыборки");
		
		Если Не ЗначениеЗаполнено(ПериодДень.Дата) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля День.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НачалоВыборки.Значение)
		И ЗначениеЗаполнено(КонецВыборки.Значение)
		И НачалоВыборки.Значение > КонецВыборки.Значение
		И НачалоВыборки.Использование 
		И КонецВыборки.Использование Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Значение начала периода не может быть больше значения конца.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ВариантОтчета = "АктивностьПользователя" Тогда
		
		Пользователь = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Пользователь").Значение;
		
		Если Не ЗначениеЗаполнено(Пользователь) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля Пользователь.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если Отчеты.АнализЖурналаРегистрации.ИмяПользователяИБ(Пользователь) = Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Формирование отчета возможно только для пользователя, которому указано имя для входа в программу.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ВариантОтчета = "АнализАктивностиПользователей" Тогда
		
		ПользователиИГруппы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПользователиИГруппы").Значение;
		
		Если ТипЗнч(ПользователиИГруппы) = Тип("СправочникСсылка.Пользователи") Тогда
			
			Если Отчеты.АнализЖурналаРегистрации.ИмяПользователяИБ(ПользователиИГруппы) = Неопределено Тогда
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru = 'Формирование отчета возможно только для пользователя, которому указано имя для входа в программу.'"), , );
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПользователиИГруппы) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля Пользователи.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыОтчетаАктивностьПользователя(НастройкиОтчета)
	
	ПользователиИГруппы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПользователиИГруппы").Значение;
	Пользователь = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Пользователь").Значение;
	ВыводитьБизнесПроцессы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьБизнесПроцессы");
	ВыводитьЗадачи = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьЗадачи");
	ВыводитьСправочники = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьСправочники");
	ВыводитьДокументы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьДокументы");
	
	Если Не ВыводитьБизнесПроцессы.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьБизнесПроцессы", Ложь);
	КонецЕсли;
	Если Не ВыводитьЗадачи.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьЗадачи", Ложь);
	КонецЕсли;
	Если Не ВыводитьСправочники.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьСправочники", Ложь);
	КонецЕсли;
	Если Не ВыводитьДокументы.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьДокументы", Ложь);
	КонецЕсли;		
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ПользователиИГруппы", ПользователиИГруппы);
	ПараметрыОтчета.Вставить("Пользователь", Пользователь);
	ПараметрыОтчета.Вставить("ВыводитьБизнесПроцессы", ВыводитьБизнесПроцессы.Значение);
	ПараметрыОтчета.Вставить("ВыводитьЗадачи", ВыводитьЗадачи.Значение);
	ПараметрыОтчета.Вставить("ВыводитьСправочники", ВыводитьСправочники.Значение);
	ПараметрыОтчета.Вставить("ВыводитьДокументы", ВыводитьДокументы.Значение);
	
	Возврат ПараметрыОтчета;
КонецФункции

Процедура ПродолжительностьРаботыРегламентныхЗаданий(НастройкиОтчета, ДокументРезультат, КомпоновщикНастроек, СмещениеВремениСервера)
	ВыводитьЗаголовок = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьЗаголовок");
	ВыводитьОтбор = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
	ЗаголовокОтчета = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("Заголовок");
	ПериодДень = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодДень").Значение;
	НачалоВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("НачалоВыборки");
	КонецВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("КонецВыборки");
	МинимальнаяПродолжительностьСеансовРегламентныхЗаданий = НастройкиОтчета.ПараметрыДанных.Элементы.Найти(
																"МинимальнаяПродолжительностьСеансовРегламентныхЗаданий");
	ОтображатьФоновыеЗадания = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ОтображатьФоновыеЗадания");
	СкрытьРегламентныеЗадания = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СкрытьРегламентныеЗадания");
	РазмерОдновременноСессий = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("РазмерОдновременноСессий");
	
	// Проверка наличия флажка использовать у параметров.
	Если Не МинимальнаяПродолжительностьСеансовРегламентныхЗаданий.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("МинимальнаяПродолжительностьСеансовРегламентныхЗаданий", 0);
	КонецЕсли;
	Если Не ОтображатьФоновыеЗадания.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ОтображатьФоновыеЗадания", Ложь);
	КонецЕсли;
	Если Не СкрытьРегламентныеЗадания.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("СкрытьРегламентныеЗадания", "");
	КонецЕсли;
	Если Не РазмерОдновременноСессий.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("РазмерОдновременноСессий", 0);
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(НачалоВыборки.Значение) Тогда
		ПериодДеньДатаНачала = НачалоДня(ПериодДень);
	ИначеЕсли Не НачалоВыборки.Использование Тогда
		ПериодДеньДатаНачала = НачалоДня(ПериодДень);
	Иначе
		ПериодДеньДатаНачала = Дата(Формат(ПериодДень.Дата, "ДЛФ=D") + " " + Формат(НачалоВыборки.Значение, "ДЛФ=T"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонецВыборки.Значение) Тогда
		ПериодДеньДатаОкончания = КонецДня(ПериодДень);
	ИначеЕсли Не КонецВыборки.Использование Тогда
		ПериодДеньДатаОкончания = КонецДня(ПериодДень);
	Иначе
		ПериодДеньДатаОкончания = Дата(Формат(ПериодДень.Дата, "ДЛФ=D") + " " + Формат(КонецВыборки.Значение, "ДЛФ=T"));
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ДатаНачала", ПериодДеньДатаНачала);
	ПараметрыЗаполнения.Вставить("ДатаОкончания", ПериодДеньДатаОкончания);
	ПараметрыЗаполнения.Вставить("РазмерОдновременноСессий", РазмерОдновременноСессий.Значение);
	ПараметрыЗаполнения.Вставить("МинимальнаяПродолжительностьСеансовРегламентныхЗаданий", 
								  МинимальнаяПродолжительностьСеансовРегламентныхЗаданий.Значение);
	ПараметрыЗаполнения.Вставить("ОтображатьФоновыеЗадания", ОтображатьФоновыеЗадания.Значение);
	ПараметрыЗаполнения.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	ПараметрыЗаполнения.Вставить("ВыводитьОтбор", ВыводитьОтбор);
	ПараметрыЗаполнения.Вставить("ЗаголовокОтчета", ЗаголовокОтчета);
	ПараметрыЗаполнения.Вставить("СкрытьРегламентныеЗадания", СкрытьРегламентныеЗадания.Значение);
	ПараметрыЗаполнения.Вставить("СмещениеВремениСервера", СмещениеВремениСервера);
	
	РезультатФормированияОтчета =
		Отчеты.АнализЖурналаРегистрации.СформироватьОтчетПоПродолжительностиРаботыРегламентныхЗаданий(ПараметрыЗаполнения);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", РезультатФормированияОтчета.ОтчетПустой);
	ДокументРезультат.Вывести(РезультатФормированияОтчета.Отчет);
КонецПроцедуры

// Возвращаемое значение:
//  Массив из Структура:
//    * УИД - УникальныйИдентификатор
//    * Наименование - Строка
//
Функция СписокВсехРегламентныхЗаданий()
	УстановитьПривилегированныйРежим(Истина);
	СписокРегламентныхЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(Новый Структура);
	МассивРегламентныхЗаданий = Новый Массив;
	Для Каждого Элемент Из СписокРегламентныхЗаданий Цикл
		Если Элемент.Наименование <> "" Тогда
			МассивРегламентныхЗаданий.Добавить(Новый Структура("УИД, Наименование", Элемент.УникальныйИдентификатор, 
																			Элемент.Наименование));
		ИначеЕсли Элемент.Метаданные.Синоним <> "" Тогда
			МассивРегламентныхЗаданий.Добавить(Новый Структура("УИД, Наименование", Элемент.УникальныйИдентификатор,
																			Элемент.Метаданные.Синоним));
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРегламентныхЗаданий;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли