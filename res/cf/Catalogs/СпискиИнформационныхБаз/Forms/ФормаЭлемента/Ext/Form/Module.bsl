﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтотОбъект.Объект.Ссылка.Пустая() Тогда
		Объект.Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("УправлениеГлобальнымиСпискамиБаз") Тогда
		ПутьКГлобальнымСпискам = Константы.ПутьКГлобальнымСпискам.Получить();
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Глобальный",
			"Видимость",
			Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	Для Каждого ТекСтрока Из Объект.ДопПараметры Цикл
		Если ТекСтрока.Уровень = 0 Тогда
			ТекСтрока.Уровень = 3;
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура("ИнформационнаяБаза, ВерсияПлатформы, РазрядностьКлиентскогоПриложения,
		|ТипКлиентскогоПриложения, СкоростьКлиентскогоСоединения, ПараметрЗапуска");
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, ТекСтрока);
		
		Если ТекСтрока.Уровень = 1 Тогда
			ЭлементыДереваУр1 = ДеревоИБ.ПолучитьЭлементы();
			СтрокаУр1 = ЭлементыДереваУр1.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУр1, ТекСтрока);
			Если ТекСтрока.ПараметрыЗаполнены Тогда
				СтрокаУр1.ДопПараметрыПредставление = "Параметры базы...";
				СтрокаУр1.ДопПараметры = СтруктураПараметров;
			КонецЕсли;
		ИначеЕсли ТекСтрока.Уровень = 2 Тогда
			ЭлементыДереваУр2 = СтрокаУр1.ПолучитьЭлементы();
			СтрокаУр2 = ЭлементыДереваУр2.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУр2, ТекСтрока);
			Если ТекСтрока.ПараметрыЗаполнены Тогда
				СтрокаУр2.ДопПараметрыПредставление = "Параметры базы...";
				СтрокаУр2.ДопПараметры = СтруктураПараметров;
			КонецЕсли;
		ИначеЕсли ТекСтрока.Уровень = 3 Тогда
			ЭлементыДереваУр3 = СтрокаУр2.ПолучитьЭлементы();
			СтрокаУр3 = ЭлементыДереваУр3.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУр3, ТекСтрока);
			Если ТекСтрока.ПараметрыЗаполнены Тогда
				СтрокаУр3.ДопПараметрыПредставление = "Параметры базы...";
				СтрокаУр3.ДопПараметры = СтруктураПараметров;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
	УстановитьВидимостьНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИБВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоИБДопПараметрыПредставление" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ИнформационнаяБаза) Тогда
			
			Оп = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияФормы", ЭтаФорма);
			
			ПараметрыФормы = Новый Структура("ВерсияПлатформы, СкоростьКлиентскогоСоединения, ТипКлиентскогоПриложения, РазрядностьКлиентскогоПриложения, ПараметрЗапуска, ИнформационнаяБаза");
			Заполнено = Ложь;
			Для Каждого ТекСтрока Из Объект.ДопПараметры Цикл
				Если ТекСтрока.ИнформационнаяБаза = Элемент.ТекущиеДанные.ИнформационнаяБаза Тогда
					ЗаполнитьЗначенияСвойств(ПараметрыФормы, ТекСтрока);
					Заполнено = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ Заполнено Тогда
				Если Элемент.ТекущиеДанные.ДопПараметры <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ПараметрыФормы, Элемент.ТекущиеДанные.ДопПараметры);
				Иначе
					ПараметрыФормы = Новый Структура("ИнформационнаяБаза", Элемент.ТекущиеДанные.ИнформационнаяБаза);
				КонецЕсли;
			КонецЕсли;
			ОткрытьФорму("Справочник.СпискиИнформационныхБаз.Форма.ДополнительныеПараметры", ПараметрыФормы, ЭтаФорма,,,, Оп, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоИБИнформационнаяБаза" Тогда
		ТекДанные = Элементы.ДеревоИБ.ТекущиеДанные;
		Если ТекДанные.ПолучитьЭлементы().Количество() <> 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИБИнформационнаяБазаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Элемент.ТекстРедактирования = Строка(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
		
	ЭлементыДерева = ДеревоИБ.ПолучитьЭлементы();
	
	Для Каждого ТекСтрока Из ЭлементыДерева Цикл
		Если ЗначениеЗаполнено(ТекСтрока.ИнформационнаяБаза) Тогда
			Если ТекСтрока.ИнформационнаяБаза = ВыбранноеЗначение Тогда
				ПоказатьПредупреждение(Неопределено, "Информационная база " + Символ(34)
				+ ВыбранноеЗначение + Символ(34) + " уже есть в списке!", 15, "Дубли информационных баз!");
				ВыбранноеЗначение = ПолучитьСсылкуИБ(Элемент.ТекстРедактирования);
				Возврат;
			КонецЕсли;
		Иначе
			ЭлементыДереваУр2 = ТекСтрока.ПолучитьЭлементы();
			Для Каждого ТекСтрокаУр2 Из ЭлементыДереваУр2 Цикл
				Если ЗначениеЗаполнено(ТекСтрокаУр2.ИнформационнаяБаза) Тогда
					Если ТекСтрокаУр2.ИнформационнаяБаза = ВыбранноеЗначение Тогда
						ПоказатьПредупреждение(Неопределено, "Информационная база " + Символ(34)
						+ ВыбранноеЗначение + Символ(34) + " уже есть в списке!", 15, "Дубли информационных баз!");
						ВыбранноеЗначение = ПолучитьСсылкуИБ(Элемент.ТекстРедактирования);
						Возврат;
					КонецЕсли;
				Иначе
					ЭлементыДереваУр3 = ТекСтрокаУр2.ПолучитьЭлементы();
					Для Каждого ТекСтрокаУр3 Из ЭлементыДереваУр3 Цикл
						Если ТекСтрокаУр3.ИнформационнаяБаза = ВыбранноеЗначение Тогда
							ПоказатьПредупреждение(Неопределено, "Информационная база " + Символ(34)
							+ ВыбранноеЗначение + Символ(34) + " уже есть в списке!", 15, "Дубли информационных баз!");
							ВыбранноеЗначение = ПолучитьСсылкуИБ(Элемент.ТекстРедактирования);
							Возврат;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ТекДанные = Элементы.ДеревоИБ.ТекущиеДанные;
	ТекДанные.ДопПараметры = Неопределено;
	ТекДанные.ДопПараметрыПредставление = "";
	
КонецПроцедуры

&НаКлиенте
Процедура РасположениеСпискаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	Если НЕ ПустаяСтрока(Объект.РасположениеСписка) Тогда
		ДиалогОткрытияФайла.Каталог = СокрЛП(Объект.РасположениеСписка);
	КонецЕсли;
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.РасположениеСписка = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИБИнформационнаяБазаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДеревоИБ.ТекущиеДанные;
	
	УровеньТекСтроки = ПолучитьУровеньДереваТекущейСтроки(ТекДанные);
	Если УровеньТекСтроки = 3 И НЕ ЗначениеЗаполнено(ТекДанные.ИнформационнаяБаза) И ТекДанные.Наименование <> "" Тогда
		ПоказатьПредупреждение(Неопределено, "Максимальный уровень расположения папки - 2!", 15, "Ограничение уровня папки!");
		ТекДанные.ИнформационнаяБаза = ПолучитьСсылкуИБ(ТекДанные.Наименование);
		Возврат;
	КонецЕсли;
	
	Если ТекДанные.ПолучитьЭлементы().Количество() = 0 Тогда
		ТекДанные.Наименование = Строка(ТекДанные.ИнформационнаяБаза);
		Если НЕ ЗначениеЗаполнено(ТекДанные.ИнформационнаяБаза) Тогда
			ТекДанные.ДопПараметры = Неопределено;
			ТекДанные.ДопПараметрыПредставление = "";
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(Неопределено, "Папка содержит подчиненные элементы.", 15, "Информационная база не является папкой!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИБПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекДанные = Элементы.ДеревоИБ.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.ИнформационнаяБаза) И НЕ Копирование Тогда
		ПоказатьПредупреждение(Неопределено, "Информационная база не является папкой!", 15);
		Отказ = Истина;
	КонецЕсли;
	
	УровеньТекСтроки = ПолучитьУровеньДереваТекущейСтроки(ТекДанные);
	Если УровеньТекСтроки = 3 Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если УровеньТекСтроки = 2 Тогда
		Элементы.ДеревоИБ.ТекущаяСтрока = Элементы.ДеревоИБИнформационнаяБаза;
	КонецЕсли;
	
	ТекДанные.Уровень = УровеньТекСтроки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Отказ = ОбновлениеТабличнойЧасти();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьСписокБаз(Команда)
	
	КаталогНаДиске = Новый Файл(Объект.РасположениеСписка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(Неопределено, "Запишите элемент!", ,
				"Элемент справочника не создан!");
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		ПоказатьПредупреждение(Неопределено, "Укажите наименование списка!", ,
				"Не заполнено наименование списка!");
		Возврат;
	ИначеЕсли Не Объект.Глобальный И Не ЗначениеЗаполнено(Объект.РасположениеСписка) Тогда
		ПоказатьПредупреждение(Неопределено, "Укажите место расположения списка!", ,
				"Не заполнено расположение списка!");
		Возврат;
	ИначеЕсли Не Объект.Глобальный И Не КаталогНаДиске.Существует() Тогда
		ПоказатьПредупреждение(Неопределено,
				"Каталог """ + Объект.РасположениеСписка + """ не найден!", , "Каталог не найден!");
		Возврат;
		ИначеЕсли ЭтаФорма.Модифицированность = Истина Тогда
		ПоказатьПредупреждение(Неопределено, "Необходимо сохранить изменения!", ,
				"Изменения не сохранены!");
		Возврат;
	КонецЕсли;
		
	НедопустимыеСимволы = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(Объект.Наименование);
	Если НедопустимыеСимволы.Количество() Тогда
		ШаблонТекста = НСтр("ru = 'Наименование списка содержит запрещенные символы (%1)'");
		ТекстСообщения = СтрШаблон(ШаблонТекста, СтрСоединить(НедопустимыеСимволы, " "));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Элементы.Наименование);
		Возврат;
	КонецЕсли;
	
	ТекстовыйФайл = ПодготовитьТекстФайла();
	ТекстовыйФайл.Вывод = ИспользованиеВывода.Разрешить;
	
	ИмяФайлаСРасширением = Объект.Наименование + ".v8i";
	
	Отказ = Ложь;
	МассивОшибок = Неопределено;
	Если Объект.Глобальный Тогда
		ЗаписатьФайлНаСервере(ИмяФайлаСРасширением, ТекстовыйФайл, Отказ, МассивОшибок);
	Иначе
		ЗаписатьФайлЛокально(ИмяФайлаСРасширением, ТекстовыйФайл, Отказ, МассивОшибок);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПоказатьПредупреждение(Неопределено, "Список баз """ + ИмяФайлаСРасширением + """ успешно сохранен!");
	Иначе
		ПоказатьПредупреждение(Неопределено,
			"При сохранении файла произошла ошибка! Подробности в сообщениях и журнале регистрации.");
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(МассивОшибок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлЛокально(ИмяФайлаСРасширением, ТекстовыйФайл, Отказ, МассивОшибок)
	
	ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		Объект.РасположениеСписка, ИмяФайлаСРасширением);
	
	Попытка
		ТекстовыйФайл.Записать(ПолноеИмяФайла, КодировкаТекста.UTF8);
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			"Списки баз",
			"Информация",
			"Список баз " + Объект.Наименование + " сохранен в " + Объект.РасположениеСписка,
			,
			Истина);
	Исключение
		ПодробнаяОшибка = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); 
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(МассивОшибок, , ПодробнаяОшибка);
		Отказ = Истина;
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			"Списки баз",
			"Ошибка",
			"Ошибка при сохранении файла со списком баз. " + ПодробнаяОшибка,
			,
			Истина);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьФайлНаСервере(ИмяФайлаСРасширением, ТекстовыйФайл, Отказ, МассивОшибок)
	
	ГлобальныйПуть = Константы.ПутьКГлобальнымСпискам.Получить();
	ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		ГлобальныйПуть, ИмяФайлаСРасширением);
	
	Попытка
		ТекстовыйФайл.Записать(ПолноеИмяФайла, КодировкаТекста.UTF8);
		ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
			"Списки баз",
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.СпискиИнформационныхБаз,
			Объект.Ссылка,
			"Список баз сохранен в каталог " + ГлобальныйПуть);
		
	Исключение
		ПодробнаяОшибка = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(МассивОшибок, , ПодробнаяОшибка);
		Отказ = Истина;
		ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
			"Списки баз",
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			"Ошибка при сохранении файла со списком баз. >> " + ПодробнаяОшибка);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьТекстФайла()
	
	Перем ТекстовыйФайл, ТекСтрока, УИД;
	
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	Для Каждого ТекСтрока Из Объект.ДопПараметры Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.ИнформационнаяБаза) Тогда
			ТекстовыйФайл.ДобавитьСтроку("[" + ТекСтрока.Наименование + "]");
			УИД = Новый УникальныйИдентификатор();
			ТекстовыйФайл.ДобавитьСтроку("ID=" + УИД);
			ТекстовыйФайл.ДобавитьСтроку("OrderInList=-1");
			ТекстовыйФайл.ДобавитьСтроку("Folder=/" + ТекСтрока.ПоложениеИБВДеревеСписка);
			ТекстовыйФайл.ДобавитьСтроку("External=0");
		Иначе
			ТекстовыйФайл.ДобавитьСтроку("[" + ТекСтрока.Наименование + "]");
			ТекстовыйФайл.ДобавитьСтроку("Connect=Srvr=" + Символ(34) + ПолучитьСерверИБ(ТекСтрока.ИнформационнаяБаза) + Символ(34) + ";Ref="
				+ Символ(34) + ПолучитьИмяИБ(ТекСтрока.ИнформационнаяБаза) + Символ(34) + ";");
			ТекстовыйФайл.ДобавитьСтроку("ID=" + ПолучитьИДИБ(ТекСтрока.ИнформационнаяБаза));
			ТекстовыйФайл.ДобавитьСтроку("Folder=/" + ТекСтрока.ПоложениеИБВДеревеСписка);
			ТекстовыйФайл.ДобавитьСтроку("External=0");
			ТекстовыйФайл.ДобавитьСтроку("ClientConnectionSpeed=" + ТекСтрока.СкоростьКлиентскогоСоединения);
			ТекстовыйФайл.ДобавитьСтроку("App=" + ТекСтрока.ТипКлиентскогоПриложения);
			Если ЗначениеЗаполнено(ТекСтрока.ПараметрЗапуска) Тогда
				ТекстовыйФайл.ДобавитьСтроку("AdditionalParameters=" + ТекСтрока.ПараметрЗапуска); 
			КонецЕсли;
			ТекстовыйФайл.ДобавитьСтроку("Version=" + ТекСтрока.ВерсияПлатформы);
			ТекстовыйФайл.ДобавитьСтроку("AppArch=" + ТекСтрока.РазрядностьКлиентскогоПриложения);
		КонецЕсли;
		
	КонецЦикла;
	Возврат ТекстовыйФайл;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияФормы(РезультатЗакрытия, ДопПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;
	ЭлементыДерева = ДеревоИБ.ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из ЭлементыДерева Цикл
		Если ЗначениеЗаполнено(ТекЭлемент.ИнформационнаяБаза) Тогда
			Если ТекЭлемент.ИнформационнаяБаза = РезультатЗакрытия.ИнформационнаяБаза Тогда
				ТекЭлемент.ДопПараметры = РезультатЗакрытия;
				ТекЭлемент.ДопПараметрыПредставление = "Параметры базы...";
				Прервать;
			КонецЕсли;
		Иначе
			ЭлементыДереваУр2 = ТекЭлемент.ПолучитьЭлементы();
			Для Каждого ТекЭлементУр2 Из ЭлементыДереваУр2 Цикл
				Если ТекЭлементУр2.ИнформационнаяБаза = РезультатЗакрытия.ИнформационнаяБаза Тогда
					ТекЭлементУр2.ДопПараметры = РезультатЗакрытия;
					ТекЭлементУр2.ДопПараметрыПредставление = "Параметры базы...";
					Прервать;
				Иначе
					ЭлементыДереваУр3 = ТекЭлементУр2.ПолучитьЭлементы();
					Для Каждого ТекЭлементУр3 Из ЭлементыДереваУр3 Цикл
						Если ТекЭлементУр3.ИнформационнаяБаза = РезультатЗакрытия.ИнформационнаяБаза Тогда
							ТекЭлементУр3.ДопПараметры = РезультатЗакрытия;
							ТекЭлементУр3.ДопПараметрыПредставление = "Параметры базы...";
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
				
	Для Каждого ТекСтрока Из Объект.ДопПараметры Цикл
		Если РезультатЗакрытия.ИнформационнаяБаза = ТекСтрока.ИнформационнаяБаза Тогда
			ЗаполнитьЗначенияСвойств(ТекСтрока, РезультатЗакрытия);
			ТекСтрока.ПараметрыЗаполнены = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылкуИБ(Наименование)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеБазы1С.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ИнформационныеБазы1С КАК ИнформационныеБазы1С
	|ГДЕ
	|	ИнформационныеБазы1С.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	
	Если Выгрузка.Количество() = 1 Тогда
		Возврат Выгрузка[0].Ссылка;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСерверИБ(Ссылка)
	
	СерверСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СерверПриложений");
	Возврат Справочники.СерверыПриложений1С.ПолучитьИмяДляСтрокиСоединения(СерверСсылка);

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяИБ(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеБазы1С.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИнформационныеБазы1С КАК ИнформационныеБазы1С
	|ГДЕ
	|	ИнформационныеБазы1С.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	
	Возврат Выгрузка[0].Наименование;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИДИБ(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеБазы1С.ИД_ИнформационнойБазы КАК ИД_ИнформационнойБазы
	|ИЗ
	|	Справочник.ИнформационныеБазы1С КАК ИнформационныеБазы1С
	|ГДЕ
	|	ИнформационныеБазы1С.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	
	Возврат Выгрузка[0].ИД_ИнформационнойБазы;

КонецФункции

&НаСервереБезКонтекста
Функция СтруктураПараметров(СсылкаИБ, СсылкаСписка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпискиИБДопПараметры.ИнформационнаяБаза КАК ИнформационнаяБаза,
		|	СпискиИБДопПараметры.ВерсияПлатформы КАК ВерсияПлатформы,
		|	СпискиИБДопПараметры.СкоростьКлиентскогоСоединения КАК СкоростьКлиентскогоСоединения,
		|	СпискиИБДопПараметры.ТипКлиентскогоПриложения КАК ТипКлиентскогоПриложения,
		|	СпискиИБДопПараметры.РазрядностьКлиентскогоПриложения КАК РазрядностьКлиентскогоПриложения,
		|	СпискиИБДопПараметры.ПараметрЗапуска КАК ПараметрЗапуска
		|ИЗ
		|	Справочник.СпискиИнформационныхБаз.ДопПараметры КАК СпискиИБДопПараметры
		|ГДЕ
		|	СпискиИБДопПараметры.Ссылка В(&СсылкаСписка)
		|	И СпискиИБДопПараметры.ИнформационнаяБаза = &СсылкаИБ";
	
	Запрос.УстановитьПараметр("СсылкаИБ", СсылкаИБ);
	Запрос.УстановитьПараметр("СсылкаСписка", СсылкаСписка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИнформационнаяБаза",);
	СтруктураПараметров.Вставить("ВерсияПлатформы",);
	СтруктураПараметров.Вставить("СкоростьКлиентскогоСоединения",);
	СтруктураПараметров.Вставить("ТипКлиентскогоПриложения",);
	СтруктураПараметров.Вставить("РазрядностьКлиентскогоПриложения",);
	СтруктураПараметров.Вставить("ПараметрЗапуска",);
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПараметров,Выборка);
	КонецЦикла;
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Функция ОбновлениеТабличнойЧасти()

	Объект.ДопПараметры.Очистить();
	
	ДеревоУр1 = ДеревоИБ.ПолучитьЭлементы();
	Для Каждого ТекСтрокаУр1 Из ДеревоУр1 Цикл
		НовСтрока = Объект.ДопПараметры.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр1);
		Если ТекСтрокаУр1.ДопПараметры <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр1.ДопПараметры);
			НовСтрока.ПараметрыЗаполнены = Истина;
		КонецЕсли;	
		ДеревоУр2 = ТекСтрокаУр1.ПолучитьЭлементы();
		Если ДеревоУр2.Количество() <> 0 Тогда
			Для Каждого ТекСтрокаУр2 Из ДеревоУр2 Цикл
				НовСтрока = Объект.ДопПараметры.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр2);
				НовСтрока.ПоложениеИБВДеревеСписка = ТекСтрокаУр1.Наименование;
				Если ТекСтрокаУр2.ДопПараметры <> Неопределено Тогда
					НовСтрока.ПараметрыЗаполнены = Истина;
					ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр2.ДопПараметры);
				КонецЕсли;
				ДеревоУр3 = ТекСтрокаУр2.ПолучитьЭлементы();
				Если ДеревоУр3.Количество() <> 0 Тогда
					Для Каждого ТекСтрокаУр3 Из ДеревоУр3 Цикл
						Если НЕ ЗначениеЗаполнено(ТекСтрокаУр3.ИнформационнаяБаза) Тогда
							ПоказатьПредупреждение(Неопределено, "Максимальный уровень расположения папки - 2!", 15, "Нижний уровень только для информационных баз!");
							Возврат Истина;
						КонецЕсли;
						НовСтрока = Объект.ДопПараметры.Добавить();
						ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр3);
						НовСтрока.ПоложениеИБВДеревеСписка = ТекСтрокаУр1.Наименование + "/" + ТекСтрокаУр2.Наименование;
						Если ТекСтрокаУр3.ДопПараметры <> Неопределено Тогда
							НовСтрока.ПараметрыЗаполнены = Истина;
							ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрокаУр3.ДопПараметры);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура РасположениеСпискаПриИзменении(Элемент)
	
	КаталогНаДиске = Новый Файл(Объект.РасположениеСписка);
	Если КаталогНаДиске.Существует()Тогда
		Возврат;
	Иначе
		ПоказатьПредупреждение(Неопределено, "Каталог " + Символ(34) + Объект.РасположениеСписка + Символ(34) + " не найден!", 15, "Каталог не найден!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьУровеньДереваТекущейСтроки(ТекущаяСтрока)
	
	УровеньТекущейСтроки = 1;
	
	РодительТекущейСтроки = ТекущаяСтрока.ПолучитьРодителя();
	Пока РодительТекущейСтроки <> Неопределено Цикл
		
		УровеньТекущейСтроки = УровеньТекущейСтроки + 1;  
		РодительТекущейСтроки = РодительТекущейСтроки.ПолучитьРодителя();
		
	КонецЦикла;
	
	Возврат УровеньТекущейСтроки;
	
КонецФункции

&НаКлиенте
Процедура ДеревоИБПриИзменении(Элемент)
	
	ЭтаФорма.Модифицированность = Истина;
	
	ТекДанные = Элементы.ДеревоИБ.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УровеньНовСтроки = ПолучитьУровеньДереваТекущейСтроки(ТекДанные);
	ТекДанные.Уровень = УровеньНовСтроки;
	Если УровеньНовСтроки = 3 Тогда
		Элементы.ДеревоИБ.ТекущаяСтрока = ТекДанные.ПолучитьИдентификатор();
		Элементы.ДеревоИБ.ТекущийЭлемент = Элементы["ДеревоИБ" + "ИнформационнаяБаза"];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьНаКлиенте()
	УстановитьВидимостьГлобальногоПути();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьГлобальногоПути()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПутьКГлобальнымСпискам",
		"Видимость",
		Объект.Глобальный);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РасположениеСписка",
		"Видимость",
		Не Объект.Глобальный);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГлобальныйПриИзменении(Элемент)
	УстановитьВидимостьГлобальногоПути();
КонецПроцедуры

#КонецОбласти












