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
	
	ОбновитьКлючиДоступаКЭлементамДанных = Истина;
	ОбновитьПраваНаКлючиДоступа = Истина;
	УдалитьУстаревшиеСлужебныеДанные = Истина;
	
	Если Не СтандартныеПодсистемыСервер.ВерсияПрограммыОбновленаДинамически() Тогда
		СпискиСОграничением = УправлениеДоступомСлужебныйПовтИсп.СпискиСОграничением();
	Иначе
		СпискиСОграничением = УправлениеДоступомСлужебный.ДействующиеПараметрыОграниченияДоступа(Неопределено,
			Неопределено, Ложь);
	КонецЕсли;
	
	Списки = Новый Массив;
	Списки.Добавить("Справочник.НаборыГруппДоступа");
	Для Каждого ОписаниеСписка Из СпискиСОграничением Цикл
		ПолноеИмя = ОписаниеСписка.Ключ;
		Списки.Добавить(ПолноеИмя);
		Если Не УправлениеДоступомСлужебный.ЭтоСсылочныйТипТаблицы(ПолноеИмя) Тогда
			Продолжить;
		КонецЕсли;
		ПустаяСсылка = ПредопределенноеЗначение(ПолноеИмя + ".ПустаяСсылка");
		ТипыОбъектовОбновленияДоступа.Добавить(ПустаяСсылка, Строка(ТипЗнч(ПустаяСсылка)));
		ИменаТаблицТиповОбъектовОбновленияДоступа.Добавить(ПустаяСсылка, ПолноеИмя);
	КонецЦикла;
	ТипыОбъектовОбновленияДоступа.СортироватьПоПредставлению();
	
	Идентификаторы = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(Списки);
	
	Для Каждого ОписаниеИдентификатора Из Идентификаторы Цикл
		СпискиДляОбновления.Добавить(ОписаниеИдентификатора.Значение,
			Строка(ОписаниеИдентификатора.Значение), Истина);
	КонецЦикла;
	
	СпискиДляОбновления.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектОбновленияДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущийЭлементТипа = ТипыОбъектовОбновленияДоступа.НайтиПоЗначению(
		ВыбранныйТипОбъектаОбновленияДоступа);
	
	Если ТекущийЭлементТипа = Неопределено Тогда
		ТекущийЭлементТипа = ТипыОбъектовОбновленияДоступа[0];
	КонецЕсли;
	
	ТипыОбъектовОбновленияДоступа.ПоказатьВыборЭлемента(
		Новый ОписаниеОповещения("ОбъектОбновленияДоступаНачалоВыбораПродолжение", ЭтотОбъект),
		НСтр("ru = 'Выбор типа данных'"),
		ТекущийЭлементТипа);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьДоступКОбъекту(Команда)
	
	Если Не ЗначениеЗаполнено(ОбъектОбновленияДоступа) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите объект.'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступКОбъекту(Команда)
	
	ПоказатьПредупреждение(, ОбновитьДоступКОбъектуНаСервере());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапланироватьОбновлениеДоступаСписков(Команда)
	
	Если Не ОбновитьКлючиДоступаКЭлементамДанных
	   И Не ОбновитьПраваНаКлючиДоступа
	   И Не УдалитьУстаревшиеСлужебныеДанные Тогда
	
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите хотя бы один вид обновления.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗапланироватьОбновлениеДоступаСписковНаСервере() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите хотя бы один список.'"));
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ОбновлениеКлючейДоступаКДанным", Новый Структура, Неопределено);
	Оповестить("Запись_ОбновлениеКлючейДоступаПользователей", Новый Структура, Неопределено);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление запланировано.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбновитьДоступКОбъектуНаСервере()
	
	Если Не ЗначениеЗаполнено(ОбъектОбновленияДоступа) Тогда
		Возврат НСтр("ru = 'Выберите объект.'");
	КонецЕсли;
	
	ПолноеИмя = ОбъектОбновленияДоступа.Метаданные().ПолноеИмя();
	ИдентификаторТранзакции = Новый УникальныйИдентификатор;
	
	Текст = "";
	
	ОбновитьДоступКОбъектуДляВидаПользователей(ОбъектОбновленияДоступа,
		ПолноеИмя, ИдентификаторТранзакции, Ложь, Текст);
	
	ОбновитьДоступКОбъектуДляВидаПользователей(ОбъектОбновленияДоступа,
		ПолноеИмя, ИдентификаторТранзакции, Истина, Текст);
	
	Возврат Текст;
	
КонецФункции

&НаСервере
Процедура ОбновитьДоступКОбъектуДляВидаПользователей(СсылкаНаОбъект, ПолноеИмя, ИдентификаторТранзакции, ДляВнешнихПользователей, Текст)
	
	ПараметрыОграничения = УправлениеДоступомСлужебный.ПараметрыОграничения(ПолноеИмя,
		ИдентификаторТранзакции, ДляВнешнихПользователей);
	
	Текст = Текст + ?(Текст = "", "", Символы.ПС + Символы.ПС);
	Если ДляВнешнихПользователей Тогда
		Если ПараметрыОграничения.ДоступЗапрещен Тогда
			Текст = Текст + НСтр("ru = 'Для внешних пользователей (доступ запрещен):'");
			
		ИначеЕсли ПараметрыОграничения.ОграничениеОтключено Тогда
			Текст = Текст + НСтр("ru = 'Для внешних пользователей (ограничение отключено):'");
		Иначе
			Текст = Текст + НСтр("ru = 'Для внешних пользователей:'");
		КонецЕсли;
	Иначе
		Если ПараметрыОграничения.ДоступЗапрещен Тогда
			Текст = Текст + НСтр("ru = 'Для пользователей (доступ запрещен):'");
			
		ИначеЕсли ПараметрыОграничения.ОграничениеОтключено Тогда
			Текст = Текст + НСтр("ru = 'Для пользователей (ограничение отключено):'");
		Иначе
			Текст = Текст + НСтр("ru = 'Для пользователей:'");
		КонецЕсли;
	КонецЕсли;
	
	КлючДоступаИсточникаУстарел = УправлениеДоступомСлужебный.КлючДоступаИсточникаУстарел(
		СсылкаНаОбъект, ПараметрыОграничения);
	
	ЕстьИзмененияПрав = Ложь;
	
	УправлениеДоступомСлужебный.ОбновитьКлючиДоступаЭлементовДанныхПриЗаписи(СсылкаНаОбъект,
		ПараметрыОграничения, ИдентификаторТранзакции, Истина, ЕстьИзмененияПрав);
	
	Если ПараметрыОграничения.БезЗаписиКлючейДоступа Тогда
		Если ПараметрыОграничения.ДоступЗапрещен
		 Или ПараметрыОграничения.ОграничениеОтключено Тогда
			Текст = Текст + Символы.ПС + НСтр("ru = 'Обновление не требуется. Ключи доступа к объектам этого типа не нужны.'");
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru = 'Обновление не требуется. Объекты этого типа используют ключи доступа к их владельцам.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если КлючДоступаИсточникаУстарел Тогда
		Текст = Текст + Символы.ПС + НСтр("ru = '1. Обновлен ключ доступа к объекту.'");
	Иначе
		Текст = Текст + Символы.ПС + НСтр("ru = '1. Обновление не требуется. Ключ доступа к объекту не устарел.'");
	КонецЕсли;
	
	Если ЕстьИзмененияПрав Тогда
		Если ПараметрыОграничения.ЕстьОграничениеПоПользователям Тогда
			Если ДляВнешнихПользователей Тогда
				Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновлены права на ключ доступа у внешних пользователей или групп доступа.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновлены права на ключ доступа у пользователей или групп доступа.'");
			КонецЕсли;
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновлены права на ключ доступа у групп доступа.'");
		КонецЕсли;
	Иначе
		Если ПараметрыОграничения.ЕстьОграничениеПоПользователям Тогда
			Если ДляВнешнихПользователей Тогда
				Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновление не требуется. Права на ключ доступа у внешних пользователей и групп доступа не устарели.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновление не требуется. Права на ключ доступа у пользователей и групп доступа не устарели.'");
			КонецЕсли;
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru = '2. Обновление не требуется. Права на ключ доступа у групп доступа не устарели.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапланироватьОбновлениеДоступаСписковНаСервере()
	
	Списки = Новый Массив;
	Для Каждого ЭлементСписка Из СпискиДляОбновления Цикл
		Если ЭлементСписка.Пометка Тогда
			Списки.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если Списки.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Списки.Количество() = СпискиДляОбновления.Количество() Тогда
		Списки = Неопределено;
	КонецЕсли;
	
	Если ОбновитьКлючиДоступаКЭлементамДанных Или ОбновитьПраваНаКлючиДоступа Тогда
		ПараметрыПланирования = УправлениеДоступомСлужебный.ПараметрыПланированияОбновленияДоступа();
		ПараметрыПланирования.ЭтоПродолжениеОбновления = Истина;
		Если Не ОбновитьКлючиДоступаКЭлементамДанных Тогда
			ПараметрыПланирования.КлючиДоступаКДанным = Ложь;
		КонецЕсли;
		Если Не ОбновитьПраваНаКлючиДоступа Тогда
			ПараметрыПланирования.РазрешенныеКлючиДоступа = Ложь;
		КонецЕсли;
		ПараметрыПланирования.Описание = "ПланированиеОбновленияДоступаВручную";
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступа(Списки, ПараметрыПланирования);
	КонецЕсли;
	
	Если УдалитьУстаревшиеСлужебныеДанные Тогда
		ПараметрыПланирования = УправлениеДоступомСлужебный.ПараметрыПланированияОбновленияДоступа();
		ПараметрыПланирования.ЭтоОбработкаУстаревшихЭлементов = Истина;
		ПараметрыПланирования.Описание = "ПланированиеОбновленияДоступаВручную";
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступа(Списки, ПараметрыПланирования);
	КонецЕсли;
	
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Ложь);
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Истина);
	
	Возврат Истина;
	
КонецФункции

// Продолжение обработчика события ОбъектОбновленияДоступаНачалоВыбора.
&НаКлиенте
Процедура ОбъектОбновленияДоступаНачалоВыбораПродолжение(ВыбранныйЭлемент, Неопределен) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйТипОбъектаОбновленияДоступа = ВыбранныйЭлемент.Значение;
	Если ТипЗнч(ОбъектОбновленияДоступа) <> ТипЗнч(ВыбранныйТипОбъектаОбновленияДоступа) Тогда
		ОбъектОбновленияДоступа = ВыбранныйТипОбъектаОбновленияДоступа;
	КонецЕсли;
	
	ЗначениеДоступаНачалоВыбораЗавершение();
	
КонецПроцедуры

// Завершение обработчика события ОбъектОбновленияДоступаНачалоВыбора.
&НаКлиенте
Процедура ЗначениеДоступаНачалоВыбораЗавершение()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ОбъектОбновленияДоступа);
	
	ЭлементСписка = ИменаТаблицТиповОбъектовОбновленияДоступа.НайтиПоЗначению(
		ВыбранныйТипОбъектаОбновленияДоступа);
	
	Если ЭлементСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяФормыВыбора = ЭлементСписка.Представление + ".ФормаВыбора";
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, Элементы.ОбъектОбновленияДоступа);
	
КонецПроцедуры

#КонецОбласти
