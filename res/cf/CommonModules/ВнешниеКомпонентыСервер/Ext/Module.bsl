﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Параметры для вызова ВнешниеКомпонентыСервер.ПодключитьКомпоненту.
//
// Возвращаемое значение:
//  Структура:
//    * ИдентификаторыСозданияОбъектов - Массив из Строка - идентификаторы экземпляров модуля объекта,
//              используется только для компонент, у которых есть несколько идентификаторов создания объектов.
//              При задании параметр Идентификатор будет использоваться только для определения компоненты.
//
Функция ПараметрыПодключения() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИдентификаторыСозданияОбъектов", Новый Массив);
	
	Возврат Параметры;
	
КонецФункции

// Подключает на сервере 1С:Предприятия внешнюю компоненту из хранилища внешних компонент,
// выполненную по технологии Native API или COM.
// В модели сервиса разрешено только подключение общих внешних компонент, одобренных администратором сервиса.
//
// Параметры:
//  Идентификатор - Строка - идентификатор объекта внешней компоненты.
//  Версия        - Строка - версия компоненты.
//  ПараметрыПодключения - см. ВнешниеКомпонентыСервер.ПодключитьКомпоненту.
//
// Возвращаемое значение:
//   Структура - результат подключения компоненты:
//     * Подключено - Булево - признак подключения;
//     * ПодключаемыйМодуль - ОбъектВнешнейКомпоненты - экземпляр объекта внешней компоненты;
//                          - ФиксированноеСоответствие из КлючИЗначение - экземпляры объектов внешней компоненты,
//                            указанные в ПараметрыПодключения.ИдентификаторыСозданияОбъектов:
//                            ** Ключ - Строка - идентификатор,
//                            ** Значение - ОбъектВнешнейКомпоненты - экземпляр объекта внешней компоненты.
//     * ОписаниеОшибки - Строка - краткое описание ошибки. 
//
Функция ПодключитьКомпоненту(Знач Идентификатор, Версия = Неопределено, ПараметрыПодключения = Неопределено) Экспорт
	
	РезультатПроверки = ВнешниеКомпонентыСлужебный.ПроверитьПодключениеКомпоненты(Идентификатор, Версия, ПараметрыПодключения);
	Если Не ПустаяСтрока(РезультатПроверки.ОписаниеОшибки) Тогда
		Результат = Новый Структура;
		Результат.Вставить("Подключено", Ложь);
		Результат.Вставить("ПодключаемыйМодуль", Неопределено);
		Результат.Вставить("Версия", Версия);
		Результат.Вставить("ОписаниеОшибки", РезультатПроверки.ОписаниеОшибки);
		Возврат Результат;		
	КонецЕсли;	
	Возврат ОбщегоНазначения.ПодключитьКомпонентуПоИдентификатору(РезультатПроверки.Идентификатор, РезультатПроверки.Местоположение);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент

// Возвращает таблицу описаний внешних компонент, которые требуется обновлять автоматически с Портала 1С:ИТС.
//
// Возвращаемое значение:
//   см. ПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент
//
Функция АвтоматическиОбновляемыеКомпоненты() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
			|	ВнешниеКомпоненты.Версия КАК Версия
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.ОбновлятьСПортала1СИТС";
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");
		ОписаниеВнешнихКомпонент = МодульПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент();
		
		Пока Выборка.Следующий() Цикл
			ОписаниеКомпоненты = ОписаниеВнешнихКомпонент.Добавить();
			ОписаниеКомпоненты.Идентификатор = Выборка.Идентификатор;
			ОписаниеКомпоненты.Версия = Выборка.Версия;
		КонецЦикла;
		
		Возврат ОписаниеВнешнихКомпонент;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Действие недоступно, т.к. отсутствует подсистема ""%1"".'"),
			"ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	КонецЕсли;
	
КонецФункции

// Выполняет обновление внешних компонент.
//
// Параметры:
//  ДанныеВнешнихКомпонент - ТаблицаЗначений - сведения об обновляемых компонентах:
//    * Идентификатор - Строка - идентификатор.
//    * Версия - Строка - версия.
//    * ДатаВерсии - Строка - дата версии.
//    * Наименование - Строка - наименование.
//    * ИмяФайла - Строка - имя файла.
//    * АдресФайла - Строка - адрес файла.
//    * КодОшибки - Строка - код ошибки.
//  АдресРезультата - Строка - адрес временного хранилища.
//      Если указан, в него будет помещено описание результата операции.
//
Процедура ОбновитьВнешниеКомпоненты(ДанныеВнешнихКомпонент, АдресРезультата = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
	
		Результат = "";
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка,
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
			|	ВнешниеКомпоненты.Версия КАК Версия,
			|	ВнешниеКомпоненты.ДатаВерсии КАК ДатаВерсии
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор В(&Идентификаторы)";
		
		Запрос.УстановитьПараметр("Идентификаторы", ДанныеВнешнихКомпонент.ВыгрузитьКолонку("Идентификатор"));
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		// Обход результата запроса.
		Для каждого СтрокаРезультата Из ДанныеВнешнихКомпонент Цикл
			
			ПредставлениеКомпоненты = ВнешниеКомпонентыСлужебный.ПредставлениеКомпоненты(
				СтрокаРезультата.Идентификатор, СтрокаРезультата.Версия);
			
			КодОшибки = СтрокаРезультата.КодОшибки;
			
			Если ЗначениеЗаполнено(КодОшибки) Тогда
				
				Если КодОшибки = "АктуальнаяВерсия" Тогда
					Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = '%1 - актуальная версия.'"), ПредставлениеКомпоненты) + Символы.ПС;
					Продолжить;
				КонецЕсли;
				
				ИнформацияОбОшибке = "";
				Если КодОшибки = "ОтсутствуетКомпонента" Тогда 
					ИнформацияОбОшибке = НСтр("ru = 'В сервисе отсутствует данная внешняя компонента'");
				ИначеЕсли КодОшибки = "ФайлНеЗагружен" Тогда 
					ИнформацияОбОшибке = НСтр("ru = 'Ошибка при попытке загрузки файла внешней компоненты из сервиса'");
				КонецЕсли;
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось загрузить внешнюю компоненту %1 из сервиса:
					           |%2'"),
					ПредставлениеКомпоненты, ИнформацияОбОшибке);
				
				Результат = Результат + ПредставлениеКомпоненты + " - " + ИнформацияОбОшибке + Символы.ПС;
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,,	ТекстОшибки);
				
				Продолжить;
			КонецЕсли;
			
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтрокаРезультата.АдресФайла);
			Информация = ВнешниеКомпонентыСлужебный.ИнформацияОКомпонентеИзФайла(ДвоичныеДанные, Ложь);
			
			Если Не Информация.Разобрано Тогда 
				Результат = Результат + ПредставлениеКомпоненты + " - " + Информация.ОписаниеОшибки + Символы.ПС;
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, Информация.ОписаниеОшибки);
				Продолжить;
			КонецЕсли;
			
			// Поиск ссылки.
			Отбор = Новый Структура("Идентификатор", СтрокаРезультата.Идентификатор);
			Если Выборка.НайтиСледующий(Отбор) Тогда 
				
				// Когда уже загружена компонента по дате более свежая, чем на Портале 1С:ИТС, обновление не следует выполнять.
				Если Выборка.ДатаВерсии > СтрокаРезультата.ДатаВерсии Тогда 
					ПредставлениеКомпоненты = ВнешниеКомпонентыСлужебный.ПредставлениеКомпоненты(
						СтрокаРезультата.Идентификатор, Выборка.Версия);
					Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = '%1 - в программе более новая версия, чем в сервисе (%2 от %3).'"), 
						ПредставлениеКомпоненты, СтрокаРезультата.Версия, Формат(СтрокаРезультата.ДатаВерсии, "ДЛФ=Д")) + Символы.ПС;
					Продолжить;
				КонецЕсли;
				
				НачатьТранзакцию();
				Попытка
					
					Блокировка = Новый БлокировкаДанных;
					ЭлементБлокировки = Блокировка.Добавить("Справочник.ВнешниеКомпоненты");
					ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
					Блокировка.Заблокировать();
					
					Объект = Выборка.Ссылка.ПолучитьОбъект();
					Объект.Заблокировать();
					
					ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты); // По данным манифеста.
					ЗаполнитьЗначенияСвойств(Объект, СтрокаРезультата);     // По данным с сайта.
					
					Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);
					
					Объект.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Загружена с Портала 1С:ИТС. %1.'"),
						ТекущаяДатаСеанса());
					
					Объект.Записать();
					
					Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = '%1 - успешно обновлена.'"), ПредставлениеКомпоненты) + Символы.ПС;
					
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					Результат = Результат + ПредставлениеКомпоненты
						+ " - " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) + Символы.ПС;
					
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
							ОбщегоНазначения.КодОсновногоЯзыка()),
						УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(АдресРезультата) Тогда 
			ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		КонецЕсли;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Действие недоступно, т.к. отсутствует подсистема ""%1"".'"),
			"ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура:
//      * Идентификатор - Строка
//      * Версия - Строка
//      * ДатаВерсии - Дата
//      * Наименование - Строка
//      * ИмяФайла - Строка
//      * ПутьКФайлу - Строка
//
Функция ОписаниеПоставляемойОбщейКомпоненты() Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("Идентификатор");
	Описание.Вставить("Версия");
	Описание.Вставить("ДатаВерсии");
	Описание.Вставить("Наименование");
	Описание.Вставить("ИмяФайла");
	Описание.Вставить("ПутьКФайлу");
	Возврат Описание;
	
КонецФункции

// Выполняет обновление общих внешних компонент.
//
// Параметры:
//  ОписаниеКомпоненты - см. ОписаниеПоставляемойОбщейКомпоненты.
//
Процедура ОбновитьОбщуюКомпоненту(ОписаниеКомпоненты) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный.ОбновитьОбщуюКомпоненту(ОписаниеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент

#КонецОбласти

#КонецОбласти
