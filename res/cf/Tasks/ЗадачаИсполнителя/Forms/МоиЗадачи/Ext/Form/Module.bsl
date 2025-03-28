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
	
	УстановитьУсловноеОформление();
	
	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);
	УстановитьОтбор(ПараметрыОтбора);
	
	ПараметрыОтбораФормы = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.Отбор);
	Параметры.Отбор.Очистить();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаНачала.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ПараметрыОтбораФормы <> Неопределено Тогда
		// Перекладываем элементы фиксированного отбора в недоступные пользовательские настройки.
		Для каждого ЭлементОтбора Из ПараметрыОтбораФормы Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
		КонецЦикла;
		
		ЗначениеОтбора = Неопределено;
		Если ПараметрыОтбораФормы.Свойство("Выполнена", ЗначениеОтбора) Тогда
			Настройки["ПоказыватьВыполненные"] = ЗначениеОтбора;
		КонецЕсли;
		
		ПараметрыОтбораФормы.Очистить();
	КонецЕсли;
	
	СгруппироватьПоКолонкеНаСервере(Настройки["РежимГруппировки"]);
	УстановитьОтбор(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("Важность");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("ПредметСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоСроку(Команда)
	СгруппироватьПоКолонке("СрокДляГруппировки");
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВыполненныеПриИзменении(Элемент)
	
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, 
		Родитель, Группа);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено
		И Элемент.ТекущиеДанные.Свойство("ПринятаКИсполнению")
		И НЕ Элемент.ТекущиеДанные.ПринятаКИсполнению Тогда
			ДоступностьПунктаПринятьКИсполнению(Истина);
	Иначе
			ДоступностьПунктаПринятьКИсполнению(Ложь);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
	ДоступностьПунктаПринятьКИсполнению(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	ДоступностьПунктаПринятьКИсполнению(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьБизнесПроцесс(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредметЗадачи(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьПредметЗадачи(Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Если НЕ ПустаяСтрока(РежимГруппировки) Тогда
		ПоказыватьВыполненные = Ложь;
		УстановитьОтборНаКлиенте();
	КонецЕсли;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Если НЕ ПустаяСтрока(РежимГруппировки) Тогда
		ПоказыватьВыполненные = Ложь;
		ПараметрыОтбора = Новый Соответствие();
		ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);	
		УстановитьОтбор(ПараметрыОтбора);	
	КонецЕсли;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНаКлиенте()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоказыватьВыполненные", ПоказыватьВыполненные);	
	УстановитьОтбор(ПараметрыОтбора);	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	Если ПараметрыОтбора["ПоказыватьВыполненные"] Тогда
		СгруппироватьПоКолонкеНаСервере("");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Выполнена", Ложь, , , Не ПараметрыОтбора["ПоказыватьВыполненные"]);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	Элементы.Список.Обновить();
	// Цвет просроченных задач зависит от значения текущей даты,
	// поэтому нужно переинициализировать условное оформление.
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьПунктаПринятьКИсполнению(ЗначениеФлага)
	
	Элементы.ПринятьКИсполнению.Доступность                      = ЗначениеФлага;
	Элементы.СписокКонтекстноеМенюПринятьКИсполнению.Доступность = ЗначениеФлага;
	Элементы.СписокКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Не ЗначениеФлага;

КонецПроцедуры

#КонецОбласти