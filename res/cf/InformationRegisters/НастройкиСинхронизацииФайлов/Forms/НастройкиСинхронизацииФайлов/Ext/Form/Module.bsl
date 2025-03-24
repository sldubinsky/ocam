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
	
	Если Параметры.Свойство("ВладелецФайла") Тогда
		ТекущийВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Параметры.ВладелецФайла));
		ВладелецФайла        = Параметры.ВладелецФайла;
	КонецЕсли;
	
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	
	АвтоматическиСинхронизироватьФайлы       = АвтоматическаяСинхронизацияВключена();
	
	Элементы.Расписание.Заголовок            = ТекущееРасписание();
	Элементы.Расписание.Доступность          = АвтоматическиСинхронизироватьФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастроитьРасписание.Видимость = Ложь;
		Элементы.Расписание.Видимость          = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Элементы.ДеревоОбъектовМетаданных.Шапка = Ложь;
		Элементы.ДеревоОбъектовМетаданныхУчетнаяЗапись.Видимость = Ложь;
		Элементы.ДеревоОбъектовМетаданныхПравилоОтбора.Видимость = Ложь;
		Элементы.ДеревоОбъектовМетаданныхСинхронизировать.Видимость = Ложь;
		Элементы.ДеревоОбъектовМетаданныхТипВладельцаФайла.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСинхронизироватьФайлыПриИзменении(Элемент)
	
	УстановитьПараметрРегламентногоЗадания("Использование", АвтоматическиСинхронизироватьФайлы);
	Элементы.Расписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхСинхронизироватьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.УчетнаяЗапись) Тогда
		ТекущиеДанные.Синхронизировать = Ложь;
		ОткрытьФормуНастроек();
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПолучитьЭлементы().Количество() > 1 Тогда
		УстановитьЗначениеСинхронизацииПодчиненнымОбъектам(ТекущиеДанные.Синхронизировать);
	Иначе
		ЗаписатьТекущиеНастройки();
	КонецЕсли;
	
	Если Не ТекущиеДанные.Синхронизировать И ТекущиеДанные.ПредыдущаяСинхронизация Тогда
	
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбОтключенииСинхронизации", ЭтотОбъект);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Завершить и отключить синхронизацию файлов для ""%1""?'"), 
			ТекущиеДанные.СинонимНаименованияОбъекта);
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ТекущиеДанные.ПредыдущаяСинхронизация = ТекущиеДанные.Синхронизировать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ЕстьНастройки = ЗначениеЗаполнено(ТекущиеДанные.УчетнаяЗапись);
		Элементы.ДеревоОбъектовМетаданныхКонтекстноеМенюУдалить.Доступность                        = ЕстьНастройки;
		Элементы.ФормаДеревоОбъектовМетаданныхУдалить.Доступность                                  = ЕстьНастройки;
		Элементы.ФормаИзменитьНастройкуСинхронизации.Доступность                                   = ЕстьНастройки;
		Элементы.ДеревоОбъектовМетаданныхКонтекстноеМенюИзменитьНастройкуСинхронизации.Доступность = ЕстьНастройки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастроек();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПравилоОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Удаление настройки приведет к прекращению синхронизации 
		|по заданным в ней правилам. Продолжить?'");
		
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНастройкуЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияЭлемента(Команда)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если Не СтрокаДерева.ВозможностьДетализации Тогда
		ТекстСообщения = НСтр("ru = 'Добавление настройки возможно только для иерархических справочников'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	// Исключим из списка выбора уже существующие настройки.
	СуществующиеНастройки = СтрокаДерева.ПолучитьЭлементы();
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокСуществующих = Новый Массив;
	Для Каждого Настройка Из СуществующиеНастройки Цикл
		СписокСуществующих.Добавить(Настройка.ВладелецФайла);
	КонецЦикла;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующих;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(СтрокаДерева.ВладелецФайла), ПараметрыФормыВыбора, Элементы.ДеревоОбъектовМетаданных);
	
КонецПроцедуры

&НаКлиенте
Процедура Синхронизировать(Команда)
	
	СинхронизироватьФайлы();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНастройкуСинхронизации(Команда)
	
	ОткрытьФормуНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВопросаОбОтключенииСинхронизации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные.ПредыдущаяСинхронизация = Ложь;
		СинхронизироватьФайлы();
	Иначе
		Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные.Синхронизировать = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьФайлы()
	
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	УстановитьВидимостьКомандыСинхронизировать();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРегламентногоЗадания("Расписание", Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	ДеревоНастроек = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоНастроек.Строки.Очистить();
	
	ТаблицаВладельцевФайлов = Новый ТаблицаЗначений;
	ТаблицаВладельцевФайлов.Колонки.Добавить("ВладелецФайла");
	ТаблицаВладельцевФайлов.Колонки.Добавить("ТипВладельцаФайла");
	ТаблицаВладельцевФайлов.Колонки.Добавить("ИмяВладельцаФайла");
	ТаблицаВладельцевФайлов.Колонки.Добавить("ЭтоФайл", Новый ОписаниеТипов("Булево"));
	ТаблицаВладельцевФайлов.Колонки.Добавить("ВозможностьДетализации", Новый ОписаниеТипов("Булево"));
	
	ИсключенияСинхронизацииФайлов = Новый Соответствие;
	Для каждого ИсключениеСинхронизации Из РаботаСФайламиСлужебный.ПриОпределенииОбъектовИсключенияСинхронизацииФайлов() Цикл
		ИсключенияСинхронизацииФайлов[ИсключениеСинхронизации] = Истина;
	КонецЦикла;
	
	МетаданныеВладельцев = Новый Массив;
	Для Каждого Справочник Из Метаданные.Справочники Цикл
		
		Если Справочник.Реквизиты.Найти("ВладелецФайла") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
		ТипыВладельцевФайлов = Справочник.Реквизиты.ВладелецФайла.Тип.Типы();
		Для Каждого ТипВладельца Из ТипыВладельцевФайлов Цикл
			
			МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельца);
			Если ИсключенияСинхронизацииФайлов[МетаданныеВладельца] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			МетаданныеВладельцев.Добавить(МетаданныеВладельца.ПолноеИмя());
			
			НоваяСтрока                        = ТаблицаВладельцевФайлов.Добавить();
			НоваяСтрока.ВладелецФайла          = ТипВладельца;
			НоваяСтрока.ТипВладельцаФайла      = Справочник;
			НоваяСтрока.ИмяВладельцаФайла      = МетаданныеВладельца.ПолноеИмя();
			НоваяСтрока.ВозможностьДетализации = Истина;
			НоваяСтрока.ЭтоФайл                = Не СтрЗаканчиваетсяНа(Справочник.Имя, "ПрисоединенныеФайлы");
			
		КонецЦикла;
		
	КонецЦикла;
	
	НастройкиСинхронизации = РегистрыСведений.НастройкиСинхронизацииФайлов.ТекущиеНастройкиСинхронизации();
	НастройкиСинхронизации.Индексы.Добавить("ИдентификаторВладельца, ЭтоФайл");
	
	ИдентификаторыВладельцев = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(МетаданныеВладельцев);
	
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	
	ВладельцыФайлов = Новый Массив;
	Для Каждого СведенияОВладельце Из ТаблицаВладельцевФайлов Цикл
		
		ТипВладельцаФайла = СведенияОВладельце.ТипВладельцаФайла; // ОбъектМетаданныхСправочник
		Если СтрНачинаетсяС(ТипВладельцаФайла.Имя, "Удалить")
			Или ВладельцыФайлов.Найти(СведенияОВладельце.ИмяВладельцаФайла) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВладельцыФайлов.Добавить(СведенияОВладельце.ИмяВладельцаФайла);
		
		Если ВсеСправочники.СодержитТип(СведенияОВладельце.ВладелецФайла) Тогда
			Если УзелСправочники = Неопределено Тогда
				УзелСправочники = ДеревоНастроек.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
		ИначеЕсли ВсеДокументы.СодержитТип(СведенияОВладельце.ВладелецФайла) Тогда
			Если УзелДокументы = Неопределено Тогда
				УзелДокументы = ДеревоНастроек.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(СведенияОВладельце.ВладелецФайла) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоНастроек.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
		КонецЕсли;
		
		ИдентификаторОбъекта = ИдентификаторыВладельцев[СведенияОВладельце.ИмяВладельцаФайла];
		Отбор = Новый Структура("ИдентификаторВладельца, ЭтоФайл", ИдентификаторОбъекта, СведенияОВладельце.ЭтоФайл);
		ДетализированныеНастройки = НастройкиСинхронизации.НайтиСтроки(Отбор);
		Если ДетализированныеНастройки.Количество() > 0 Тогда
			Для Каждого Настройка Из ДетализированныеНастройки Цикл
				ПравилоОтбора                               = Настройка.ПравилоОтбора.Получить(); // НастройкиКомпоновкиДанных
				ДетализированнаяНастройка                   = НоваяСтрокаТаблицы.Строки.Добавить();
				ДетализированнаяНастройка.ВладелецФайла     = Настройка.ВладелецФайла;
				ДетализированнаяНастройка.ТипВладельцаФайла = Настройка.ТипВладельцаФайла;
				
				ЕстьПравилоОтбора = Ложь;
				Если ПравилоОтбора <> Неопределено Тогда
					ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
				КонецЕсли;
				
				Если Не ПустаяСтрока(Настройка.Наименование) Тогда
					ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.Наименование;
				Иначе
					ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.ВладелецФайла;
				КонецЕсли;
				
				ЕстьПравилоОтбора = Ложь;
				Если ПравилоОтбора <> Неопределено Тогда
					ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
				КонецЕсли;
				
				ДетализированнаяНастройка.Синхронизировать        = Настройка.Синхронизировать;
				ДетализированнаяНастройка.ПредыдущаяСинхронизация = Настройка.Синхронизировать;
				ДетализированнаяНастройка.УчетнаяЗапись    = Настройка.УчетнаяЗапись;
				ДетализированнаяНастройка.ЭтоФайл          = Настройка.ЭтоФайл;
				ДетализированнаяНастройка.ПравилоОтбора    =
					?(ЕстьПравилоОтбора, НСтр("ru = 'Выбранные файлы'"), НСтр("ru = 'Все файлы'"));
				
			КонецЦикла;
		КонецЕсли;
		
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(СведенияОВладельце.ВладелецФайла);
		НоваяСтрокаТаблицы.ВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(СведенияОВладельце.ВладелецФайла);
		НоваяСтрокаТаблицы.ТипВладельцаФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(СведенияОВладельце.ТипВладельцаФайла);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		НоваяСтрокаТаблицы.ЭтоФайл = СведенияОВладельце.ЭтоФайл;
		НоваяСтрокаТаблицы.ВозможностьДетализации = СведенияОВладельце.ВозможностьДетализации;
		
		Отбор = Новый Структура("ВладелецФайла, ЭтоФайл", НоваяСтрокаТаблицы.ВладелецФайла, НоваяСтрокаТаблицы.ЭтоФайл);
		НайденныеНастройки = НастройкиСинхронизации.НайтиСтроки(Отбор);
		
		Если НайденныеНастройки.Количество() > 0 Тогда
			
			ПравилоОтбора = НайденныеНастройки[0].ПравилоОтбора.Получить(); // НастройкиКомпоновкиДанных
			
			НоваяСтрокаТаблицы.Синхронизировать = НайденныеНастройки[0].Синхронизировать;
			НоваяСтрокаТаблицы.УчетнаяЗапись    = НайденныеНастройки[0].УчетнаяЗапись;
			Если ПравилоОтбора <> Неопределено И ПравилоОтбора.Отбор.Элементы.Количество() > 0 Тогда
				НоваяСтрокаТаблицы.ПравилоОтбора = ?(ПустаяСтрока(НайденныеНастройки[0].Наименование), 
					НСтр("ru = 'Выбранные файлы'"), НайденныеНастройки[0].Наименование);
			Иначе
				НоваяСтрокаТаблицы.ПравилоОтбора = НСтр("ru = 'Все файлы'");
			КонецЕсли;
			
		Иначе
			НоваяСтрокаТаблицы.Синхронизировать = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
			НоваяСтрокаТаблицы.ПравилоОтбора = НСтр("ru = 'Все файлы'");
		КонецЕсли;
		
		НоваяСтрокаТаблицы.ПредыдущаяСинхронизация = НоваяСтрокаТаблицы.Синхронизировать;
		
	КонецЦикла;
	
	Для Каждого УзелВерхнегоУровня Из ДеревоНастроек.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоНастроек, "ДеревоОбъектовМетаданных");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекущиеНастройки()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла,
		ТекущиеДанные.Синхронизировать,
		ТекущиеДанные.УчетнаяЗапись,
		ТекущиеДанные.ЭтоФайл);
	
КонецПроцедуры

// Параметры:
//   ВыбранноеЗначение - Структура:
//   * ВладелецФайла - ЛюбаяСсылка
//   * НоваяНастройка - Булево
//   * Наименование - Строка
//   ДополнительныеПараметры - Структура
//
&НаКлиенте
Процедура УстановитьНастройкиОтбора(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Перем ОбновляемаяСтрока;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	СтрокаВладелец = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ДополнительныеПараметры.Идентификатор);
	
	// Строка с возможностью детализации
	Если СтрокаВладелец.ВладелецФайла <> ВыбранноеЗначение.ВладелецФайла Тогда
		ЭлементВладелец   = СтрокаВладелец.ПолучитьЭлементы();
		
		// Для новой настройки можно выбрать учетную запись, отличающуюся от существующей.
		ЭтоНоваяНастройка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
								ДополнительныеПараметры,
								"НоваяНастройка",
								Ложь);
		Если НЕ ЭтоНоваяНастройка Тогда
			ОбновляемаяСтрока = СтрокаВладельцаВКоллекции(ЭлементВладелец, ВыбранноеЗначение);
		КонецЕсли;
		
		Если ОбновляемаяСтрока = Неопределено Тогда
			ОбновляемаяСтрока = ЭлементВладелец.Добавить();
		КонецЕсли;
	Иначе
		ОбновляемаяСтрока = СтрокаВладелец;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ОбновляемаяСтрока, ВыбранноеЗначение);
	
	Если ВыбранноеЗначение.ЕстьПравилоОтбора Тогда
		ОбновляемаяСтрока.ПравилоОтбора =
			?( ЗначениеЗаполнено(ВыбранноеЗначение.Наименование), ВыбранноеЗначение.Наименование, НСтр("ru = 'Выбранные файлы'"));
	Иначе
		ОбновляемаяСтрока.ПравилоОтбора = НСтр("ru = 'Все файлы'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтрокаВладельцаВКоллекции(ЭлементВладелец, ВыбранноеЗначение)
	Перем ОбновляемаяСтрока;
	Для Каждого СтрокаНастройки Из ЭлементВладелец Цикл
			Если СтрокаНастройки.ВладелецФайла = ВыбранноеЗначение.ВладелецФайла 
					И СтрокаНастройки.УчетнаяЗапись = ВыбранноеЗначение.УчетнаяЗапись Тогда
				ОбновляемаяСтрока = СтрокаНастройки;
				Прервать;
			КонецЕсли;
	КонецЦикла;
	
	Возврат ОбновляемаяСтрока;
КонецФункции

&НаСервере
Процедура УстановитьЗначениеСинхронизацииПодчиненнымОбъектам(Знач Синхронизировать)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() <> Неопределено Тогда
			УстановитьЗначениеСинхронизацииОбъекта(ЭлементДерева, Синхронизировать);
			Продолжить;
		КонецЕсли;
		Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
			УстановитьЗначениеСинхронизацииОбъекта(ПодчиненныйЭлементДерева, Синхронизировать);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеСинхронизацииОбъекта(ВыбранныйОбъект, Знач Синхронизировать)
	
	ВыбранныйОбъект.Синхронизировать = Синхронизировать;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		Синхронизировать,
		ВыбранныйОбъект.УчетнаяЗапись,
		ВыбранныйОбъект.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ВладелецФайла, ТипВладельцаФайла, Синхронизировать, УчетнаяЗапись, ЭтоФайл)
	
	Настройка                   = РегистрыСведений.НастройкиСинхронизацииФайлов.СоздатьМенеджерЗаписи();
	Настройка.ВладелецФайла     = ВладелецФайла;
	Настройка.ТипВладельцаФайла = ТипВладельцаФайла;
	Настройка.Синхронизировать  = Синхронизировать;
	Настройка.УчетнаяЗапись     = УчетнаяЗапись;
	Настройка.ЭтоФайл           = ЭтоФайл;
	Настройка.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВладелецФайла)
		Или Не ЗначениеЗаполнено(ТекущиеДанные.ТипВладельцаФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВладелецФайла",     ТекущиеДанные.ВладелецФайла);
	Отбор.Вставить("ТипВладельцаФайла", ТекущиеДанные.ТипВладельцаФайла);
	Отбор.Вставить("УчетнаяЗапись",     ТекущиеДанные.УчетнаяЗапись);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.УчетнаяЗапись) Тогда
		
		ТипЗначения = Тип("РегистрСведенийКлючЗаписи.НастройкиСинхронизацииФайлов");
		ПараметрыКлюча = Новый Массив(1);
		ПараметрыКлюча[0] = Отбор;
		
		КлючЗаписи = Новый(ТипЗначения, ПараметрыКлюча);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
	Иначе
		ПараметрыФормы = Отбор;
		ПараметрыФормы.Вставить("ЭтоФайл", ТекущиеДанные.ЭтоФайл);
	КонецЕсли;
	ПараметрыФормы.Вставить("ЗапрещатьИзменятьУчетнуюЗапись", Истина);
	
	ДополнительныеПараметры = Новый Структура();
	Если ТекущиеДанные.ВозможностьДетализации Тогда
		ДополнительныеПараметры.Вставить("Идентификатор", ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		ДополнительныеПараметры.Вставить("Идентификатор", ТекущиеДанные.ПолучитьРодителя().ПолучитьИдентификатор());
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("УстановитьНастройкиОтбора", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.ФормаЗаписи", 
		ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

&НаСервере
Функция ПутьФормыВыбора(ВладелецФайла)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВладелецФайла);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаСервере
Функция ОчиститьДанныеНастройки()
	
	ПараметрыВызоваСервера = Новый Структура();
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Подсистема ""Работа с файлами"": Отключение синхронизации файлов с облачным сервисом'");
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("РаботаСФайламиСлужебный.ОсвободитьЗахваченныеФайлыФон",
		ПараметрыВызоваСервера, ПараметрыВыполненияВФоне);
	
	Возврат ФоновоеЗадание;
	
КонецФункции

// Параметры:
//   Результат - Структура
//   ДополнительныеПараметры - Структура:
//   * ТекущаяСтрока - Число
//
&НаКлиенте
Процедура ОчиститьДанныеНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Результат.Статус <> "Выполнено" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ОчиститьДанныеНастройкиНаСервере(ДополнительныеПараметры.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
		НастройкаДляУдаления.Синхронизировать = Ложь;
		УстановитьЗначениеСинхронизацииПодчиненнымОбъектам(Ложь);
		ЗаписатьТекущиеНастройки();
		
		ДополнительныеПараметрыВызова = Новый Структура();
		ДополнительныеПараметрыВызова.Вставить("ТекущаяСтрока", Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
		
		ФоновоеЗадание = ОчиститьДанныеНастройки();
		НастройкиОжидания                                = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания           = Истина;
		Обработчик = Новый ОписаниеОповещения("ОчиститьДанныеНастройкиЗавершение", ЭтотОбъект, ДополнительныеПараметрыВызова);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСинхронизациюФайлов(Команда)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Или СтрокаДерева.ПолучитьРодителя() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.ВозможностьДетализации Тогда
		ВладелецФайла = СтрокаДерева.ВладелецФайла;
		Идентификатор = СтрокаДерева.ПолучитьИдентификатор();
	Иначе
		ВладелецФайла = СтрокаДерева.ПолучитьРодителя().ВладелецФайла;
		Идентификатор = СтрокаДерева.ПолучитьРодителя().ПолучитьИдентификатор();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",     ВладелецФайла);
	ПараметрыФормы.Вставить("ТипВладельцаФайла", СтрокаДерева.ТипВладельцаФайла);
	ПараметрыФормы.Вставить("ЭтоФайл",           СтрокаДерева.ЭтоФайл);
	ПараметрыФормы.Вставить("НоваяНастройка",    Истина);
	ПараметрыФормы.Вставить("Идентификатор",     Идентификатор);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьНастройкиОтбора", ЭтотОбъект, ПараметрыФормы);
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.ФормаЗаписи", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание        = "";
	ИдентификаторФоновогоЗадания = "";
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) И Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		ТекущееФоновоеЗадание        = "";
		ОбновитьФлагиСинхронизации(ДеревоОбъектовМетаданных.ПолучитьЭлементы());
		ТолькоПросмотр = Ложь;
		УстановитьВидимостьКомандыСинхронизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФлагиСинхронизации(Строки)
	
	Для Каждого Строка Из Строки Цикл
		
		Строка.ПредыдущаяСинхронизация = Строка.Синхронизировать;
		Если Строка.ПолучитьЭлементы().Количество() > 0 Тогда
			ОбновитьФлагиСинхронизации(Строка.ПолучитьЭлементы());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗаданиеМетаданные = Метаданные.РегламентныеЗадания.СинхронизацияФайлов;
	
	Отбор = Новый Структура;
	ИмяМетода = РегламентноеЗаданиеМетаданные.ИмяМетода;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияСинхронизации = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияСинхронизации.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияСинхронизации[0].УникальныйИдентификатор;
	Иначе
		ПараметрыЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыЗадания.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), РегламентноеЗаданиеМетаданные.Синоним);
		РезультатЗадания = ДлительныеОперации.ВыполнитьВФоне(РегламентноеЗаданиеМетаданные.ИмяМетода, Новый Структура, ПараметрыЗадания);
		Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
			ИдентификаторФоновогоЗадания = РезультатЗадания.ИдентификаторЗадания;
		КонецЕсли;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Синхронизация";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКомандыСинхронизировать()
	
	ПодчиненныеСтраницы = Элементы.СинхронизацияФайлов.ПодчиненныеЭлементы;
	Если ПустаяСтрока(ТекущееФоновоеЗадание) Тогда
		Элементы.СинхронизацияФайлов.ТекущаяСтраница  = ПодчиненныеСтраницы.Синхронизация;
		Элементы.ДеревоОбъектовМетаданных.Доступность = Истина;
	Иначе
		Элементы.СинхронизацияФайлов.ТекущаяСтраница  = ПодчиненныеСтраницы.СтатусФоновогоЗадания;
		Элементы.ДеревоОбъектовМетаданных.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПараметра)
	
	РаботаСФайламиСлужебный.УстановитьПараметрРегламентногоЗаданияСинхронизацииФайлов(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПоУмолчанию)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияФайлов);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияФайлов.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для Каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

&НаСервере
Функция ТекущееРасписание()
	Возврат ПолучитьПараметрРегламентногоЗадания("Расписание", Новый РасписаниеРегламентногоЗадания);
КонецФункции

&НаСервере
Функция АвтоматическаяСинхронизацияВключена()
	Возврат ПолучитьПараметрРегламентногоЗадания("Использование", Ложь);
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхСинонимНаименованияОбъекта");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Синхронизировать");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ВажнаяНадписьШрифт);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхПравилоОтбора");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Синхронизировать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхУчетнаяЗапись");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Синхронизировать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.УчетнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеНастройкиНаСервере(Знач ТекущаяСтрока)
	
	НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(НастройкаДляУдаления.УчетнаяЗапись) Тогда
		МенеджерЗаписи                   = РегистрыСведений.НастройкиСинхронизацииФайлов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ВладелецФайла     = НастройкаДляУдаления.ВладелецФайла;
		МенеджерЗаписи.ТипВладельцаФайла = НастройкаДляУдаления.ТипВладельцаФайла;
		МенеджерЗаписи.УчетнаяЗапись     = НастройкаДляУдаления.УчетнаяЗапись;
		МенеджерЗаписи.ЭтоФайл           = НастройкаДляУдаления.ЭтоФайл;
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Удалить();
		
		РодительЭлементаНастроек = НастройкаДляУдаления.ПолучитьРодителя();
		Если РодительЭлементаНастроек <> Неопределено Тогда
			// Родительскую настройку удалять из дерева не нужно, достаточно очистить настраиваемые поля.
			НастройкаДляУдаления.ПодПапкаОблачногоСервиса = "";
			НастройкаДляУдаления.ПравилоОтбора            = "";
			НастройкаДляУдаления.Синхронизировать         = Ложь;
			НастройкаДляУдаления.УчетнаяЗапись            = Неопределено;
			Если Не НастройкаДляУдаления.ВозможностьДетализации Тогда
				РодительЭлементаНастроек.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
			КонецЕсли;
		Иначе
			ДеревоОбъектовМетаданных.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти