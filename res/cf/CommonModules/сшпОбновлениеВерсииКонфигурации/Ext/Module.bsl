﻿
#Область ОбновлениеКонфигурации

// Функция возвращает версию сборки 1С которой была собрана данная конфигурация
//
// Возвращаемое значение:
//  Строка - Версия сборки
Функция ВерсияСборки1С() Экспорт
	Возврат "8.3.21.1775";
КонецФункции

// Функция возвращает версию компоненты
//
// Возвращаемое значение:
//  Строка - Версия компоненты
Функция ВерсияКомпоненты() Экспорт
	Возврат "260";
КонецФункции

// Функция возвращает версию конфигурации
//
// Возвращаемое значение:
//  Строка - Версия конфигурации
Функция ВерсияКонфигурации() Экспорт
	Возврат "1.4.6.0036";
КонецФункции

// Функция - Получает актуальную версию текущей конфигурации
//
Функция ПолучитьАктуальнуюВерсию()
	Возврат 10406;
КонецФункции

// Функция - Выполнить обновление данных конфигурации
//
// Возвращаемое значение:
//	Булево - Признак выполеннного обновления.
//
Функция ВыполнитьОбновлениеДанныхКонфигурации() Экспорт
	
	ТекущаяВерсия = сшпКэшируемыеФункции.ВерсияПодсистемы();
	
	Если ТекущаяВерсия < 10120 тогда
		
		ОбновлениеВерсии10120();
		
	КонецЕсли;
	
	Если ТекущаяВерсия < 10121 Тогда
		
		ОбновлениеВерсии10121();
		
	КонецЕсли;
	
	Если ТекущаяВерсия < 10200 Тогда
		
		ОбновлениеВерсии10200();
		
	КонецЕсли;
	
	Если ТекущаяВерсия < 10202 Тогда
		
		ОбновлениеВерсии10202();
		
	КонецЕсли;
	
	Если ТекущаяВерсия <= 10309 Тогда
			 	
		Если ОбновлениеВерсии10400() тогда
			НоваяВерсия = 10401;
		Иначе
			Возврат УстановитьВерсию(10309, ТекущаяВерсия);	
		КонецЕсли;	
		
	КонецЕсли;		
	
	Если ТекущаяВерсия <= 10401 Тогда
		
		Если ОбновлениеВерсии10403() Тогда
			НоваяВерсия = 10403;
		Иначе
			Возврат УстановитьВерсию(10401, ТекущаяВерсия);	
		КонецЕсли;
			
	КонецЕсли;
	
	Если ТекущаяВерсия <= 10403 Тогда
		
		Если ОбновлениеВерсии10404() Тогда
			НоваяВерсия = 10404;
		Иначе
			Возврат УстановитьВерсию(10403, ТекущаяВерсия);	
		КонецЕсли;
		
	КонецЕсли;		
	
	Если ТекущаяВерсия <= 10404 Тогда
		
		Если ОбновлениеВерсии10405() Тогда
			НоваяВерсия = 10405;
		Иначе
			Возврат УстановитьВерсию(10404, ТекущаяВерсия);	
		КонецЕсли;
	
	КонецЕсли;
	
	НоваяВерсия = ПолучитьАктуальнуюВерсию();
		
	Возврат УстановитьВерсию(НоваяВерсия, ТекущаяВерсия);
	
КонецФункции	

// Функция - Установить версию
// 
// Параметры:
// 	НоваяВерсия - Число - новая версия
// 	ТекущаяВерсия - Число - текущая версия
// Возвращаемое значение:
// 	Булево - выполнено или нет изменение версии
Функция УстановитьВерсию(НоваяВерсия, ТекущаяВерсия)
	
	ОбновлениеВыполнено = Ложь;
	
	Если НоваяВерсия <> ТекущаяВерсия Тогда
		 
		Константы.сшпВерсияПодсистемы.Установить(НоваяВерсия); 
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		ОбновлениеВыполнено = Истина;
	
	КонецЕсли;
	
	Возврат ОбновлениеВыполнено
	
КонецФункции


// Функция - ОбновлениеВерсии10405
//
Функция ОбновлениеВерсии10405()
	
	РезультатВыполнения= Истина;
	
	Попытка

		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	сшпСостояниеСообщений.ИдентификаторСобытия
			|ИЗ
			|	РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеСообщений
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сшпОчередьИсходящихСообщений КАК сшпОчередьИсходящихСообщений
			|		ПО сшпСостояниеСообщений.ИдентификаторСобытия = сшпОчередьИсходящихСообщений.ИдентификаторСобытия
			|ГДЕ
			|	сшпОчередьИсходящихСообщений.ИдентификаторСобытия ЕСТЬ NULL"
		);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Набор = РегистрыСведений.сшпСостояниеСообщений.СоздатьНаборЗаписей();
			Набор.Отбор.ИдентификаторСобытия.Установить(Выборка.ИдентификаторСобытия);
			Набор.ОбменДанными.Загрузка = Истина;
			Набор.Записать();
		КонецЦикла;
	
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			"Datareon.Обновление до версии 1.4.5", 
			УровеньЖурналаРегистрации.Ошибка, 
			Метаданные.ОбщиеМодули.сшпОбновлениеВерсииКонфигурации, , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)
		);
		РезультатВыполнения= Ложь;
	КонецПопытки;
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Функция - ОбновлениеВерсии10404
//
Функция ОбновлениеВерсии10404()
	
	Попытка
		сшпРаботаСКонстантами.УстановитьИдентификаторИБ();
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Процедура - ОбновлениеВерсии10403
//
Функция ОбновлениеВерсии10403()
	
	ПустойИдентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	РезультатВыполнения= Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сшпСостояниеСообщений.ИдентификаторСобытия КАК ИдентификаторСобытия
	               |ИЗ
	               |	РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеСообщений
	               |ГДЕ
	               |	сшпСостояниеСообщений.ИдентификаторСообщения = &ПустойИдентифкатор";
	Запрос.УстановитьПараметр("ПустойИдентифкатор", ПустойИдентификатор);
	
	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл
		
		РегСвед = РегистрыСведений.сшпСостояниеСообщений.СоздатьМенеджерЗаписи();
		РегСвед.ИдентификаторСобытия = Результат.ИдентификаторСобытия;
		РегСвед.ИдентификаторСообщения = ПустойИдентификатор;
		
		РегСвед.Прочитать();
		
		Если РегСвед.Выбран() Тогда
			
			РегСвед.ИдентификаторСообщения = РегСвед.ИдентификаторСобытия;
			
			Попытка
				РегСвед.Записать();
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации("Datareon.Обновление до версии 1.4.3", УровеньЖурналаРегистрации.Ошибка, Метаданные.ОбщиеМодули.сшпОбновлениеВерсииКонфигурации, , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
				РезультатВыполнения = Ложь;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
			
	Возврат РезультатВыполнения;			
			
КонецФункции

// Процедура - ОбновлениеВерсии10400
// 
Функция ОбновлениеВерсии10400()
	
	РезультатОбновления = Истина;
	
	ИмяРегистраОчередьОтправляемыхСообщений = "";
	Если Метаданные.РегистрыСведений.Найти("удалитьСшпОчередьОтправляемыхСообщений") <> Неопределено Тогда
		ИмяРегистраОчередьОтправляемыхСообщений = "удалитьСшпОчередьОтправляемыхСообщений";
	ИначеЕсли Метаданные.РегистрыСведений.Найти("сшпОчередьОтправляемыхСообщений") <> Неопределено Тогда
		ИмяРегистраОчередьОтправляемыхСообщений = "сшпОчередьОтправляемыхСообщений";
	КонецЕсли;
	
	ИмяРегистраОчередьВходящихСообщений = "";
	Если Метаданные.РегистрыСведений.Найти("удалитьСшпОчередьВходящихСообщений") <> Неопределено Тогда
		ИмяРегистраОчередьВходящихСообщений = "удалитьСшпОчередьВходящихСообщений";
	ИначеЕсли Метаданные.РегистрыСведений.Найти("сшпОчередьВходящихСообщений") <> Неопределено Тогда
		ИмяРегистраОчередьВходящихСообщений = "сшпОчередьВходящихСообщений";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяРегистраОчередьОтправляемыхСообщений) Тогда
		РезультатОбновления = ОбработатьОчередьОтправляемыхСообщенийОбновлениеВерсии10400(ИмяРегистраОчередьОтправляемыхСообщений);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяРегистраОчередьВходящихСообщений) Тогда
		РезультатОбновления = РезультатОбновления И ОбработатьОчередьВходящихСообщенийОбновлениеВерсии10400(ИмяРегистраОчередьВходящихСообщений);
	КонецЕсли;

	Если Не РезультатОбновления тогда
		ЗаписьЖурналаРегистрации("Datareon.Обновление до версии 1.4.0", УровеньЖурналаРегистрации.Ошибка,
			Метаданные.ОбщиеМодули.сшпОбновлениеВерсииКонфигурации, , "Не удалось перейти на версию 1.4.0");		
	КонецЕсли;			

	Возврат РезультатОбновления;
	
КонецФункции

Функция ОбработатьОчередьВходящихСообщенийОбновлениеВерсии10400(ИмяРегистраОчередьВходящихСообщений)
	РезультатОбновления = Истина;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	сшпОчередьВходящихСообщений.ИдентификаторСообщения,
		|	сшпОчередьВходящихСообщений.Хранилище,
		|	сшпСостояниеСообщений.СтатусСообщения
		|ИЗ
		|	РегистрСведений." + ИмяРегистраОчередьВходящихСообщений + " КАК сшпОчередьВходящихСообщений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеСообщений
		|		ПО сшпОчередьВходящихСообщений.ИдентификаторСообщения = сшпСостояниеСообщений.ИдентификаторСообщения
		|		И сшпСостояниеСообщений.СтатусСообщения В (
		|			ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.Новое),
		|			ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.ОжиданиеОбработки),
		|			ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.ВОбработке),
		|			ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.ОшибкаОбработки),
		|			ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.ОтсутствуетОбработчик)
		|		)"
	);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
	
		Пока РезультатЗапроса.Следующий() Цикл
			
				
			Сообщение = РезультатЗапроса.Хранилище.Получить();
			Если Не ОбработатьВходящееСообщениеОбновлениеКонфигурации10400(сшпФункциональныеОпции.ФорматСообщения(), Сообщение) Тогда
				
				xdtoПакет = сшпОбщегоНазначения.ПолучитьОбъектXDTO(сшпКэшируемыеФункции.ФорматСообщенийПоУмолчанию(), Сообщение);
				Пакет = сшпОбщегоНазначения.СформироватьСтруктуруПакета("Esb-OldMessageDatagram", "", xdtoПакет.Body);
				ЗаполнитьЗначенияСвойств(Пакет, xdtoПакет, , "Type");
				Если ТипЗнч(Пакет.ReplyTo) = Тип("ОбъектXDTO") Тогда
					Пакет.ReplyTo = Неопределено;
				КонецЕсли;
				
				ОтправкаСлужебныйРезультат = Ложь;
				
				Если сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.SOAP Тогда
					
					Коннектор = сшпВзаимодействиеСАдаптером.ПолучитьКоннектор();
					ОтправкаСлужебныйРезультат = сшпSOAPСервис.ОтправитьСообщение(Коннектор, Пакет);
					
				ИначеЕсли сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.REST Тогда
					
					Коннектор = сшпВзаимодействиеСАдаптером.ПолучитьКоннектор();
					ОтправкаСлужебныйРезультат = сшпHTTPСервис.ОтправитьСообщение(Коннектор, Пакет);					
					
				ИначеЕсли сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.PIPE Тогда
					
					Если Не сшпФункциональныеОпции.ОтключитьСоединение() Тогда
						сшпPipe.УстановитьСоединениеИОтправитьСлужебноеСообщение(Пакет);
						ОтправкаСлужебныйРезультат = Истина;
					Иначе
						ОтправкаСлужебныйРезультат = Ложь;
					КонецЕсли;
					
				ИначеЕсли сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.TCP Тогда
					
					Если Не сшпФункциональныеОпции.ОтключитьСоединение() Тогда
						сшпTcp.УстановитьСоединениеИОтправитьСлужебноеСообщение(Пакет);
						ОтправкаСлужебныйРезультат = Истина;
					Иначе
						ОтправкаСлужебныйРезультат = Ложь;
					КонецЕсли;
					
				КонецЕсли;					
									
				Если ОтправкаСлужебныйРезультат Тогда
					
					сшпРаботаСДанными.УстановитьСостояниеСообщения(РезультатЗапроса.ИдентификаторСообщения, Перечисления.сшпСтатусыСообщений.ОбработкаОтменена);	
					
				Иначе
					
					РезультатОбновления = Ложь;
					
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЦикла;
	
	КонецЕсли;
			
	Возврат РезультатОбновления;
КонецФункции


Функция ОбработатьОчередьОтправляемыхСообщенийОбновлениеВерсии10400(ИмяРегистраОчередьОтправляемыхСообщений)
	
	РезультатОбновления = Истина;

	Если Метаданные.РегистрыСведений.сшпОчередьИсходящихСообщений.Измерения.Найти("ИдентификаторСообщения") <> Неопределено Тогда
		ИмяРеквизитаИдентификаторСообщения = "ИдентификаторСообщения";
	Иначе
		ИмяРеквизитаИдентификаторСообщения = "ИдентификаторСобытия";
	КонецЕсли;

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	сшпОчередьОтправляемыхСообщений.ИдентификаторСообщения,
		|	сшпОчередьОтправляемыхСообщений.Хранилище,
		|	сшпСостояниеСообщений.СтатусСообщения,
		|	сшпОчередьИсходящихСообщений." + ИмяРеквизитаИдентификаторСообщения + " КАК ИдентификаторБазовогоСообщения,
		|	сшпСостояниеИсходящихСообщений.СтатусСообщения КАК СтатусИсходящегоСообщения	
		|ИЗ
		|	РегистрСведений." + ИмяРегистраОчередьОтправляемыхСообщений + " КАК сшпОчередьОтправляемыхСообщений
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеСообщений
		|		ПО сшпОчередьОтправляемыхСообщений.ИдентификаторСообщения = сшпСостояниеСообщений.ИдентификаторСообщения
		|			И сшпСостояниеСообщений.СтатусСообщения В (
		|				ЗНАЧЕНИЕ(Перечисление.сшпСтатусыСообщений.ОжиданиеОтправки)
		|			)
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сшпОчередьИсходящихСообщений сшпОчередьИсходящихСообщений
		|		ПО сшпОчередьИсходящихСообщений." + ИмяРеквизитаИдентификаторСообщения + " = сшпОчередьОтправляемыхСообщений.ИдентификаторБазовогоСообщения
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеИсходящихСообщений
		|		ПО сшпОчередьИсходящихСообщений." + ИмяРеквизитаИдентификаторСообщения + " = сшпСостояниеИсходящихСообщений.ИдентификаторСообщения"
	);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
	
		Пока РезультатЗапроса.Следующий() Цикл
			
				
			Если РезультатЗапроса.СтатусСообщения = Перечисления.сшпСтатусыСообщений.Отправлено 
				И РезультатЗапроса.СтатусИсходящегоСообщения = Перечисления.сшпСтатусыСообщений.Обработано Тогда
				
				Если ЗначениеЗаполнено(РезультатЗапроса.ИдентификаторБазовогоСообщения) Тогда 
				
					сшпРаботаСДанными.УстановитьСостояниеСообщения(
						РезультатЗапроса.ИдентификаторБазовогоСообщения,
						Перечисления.сшпСтатусыСообщений.ОтправкаПодтверждена
					);
					
				КонецЕсли;
				
			Иначе
				// Отправляемых, просто отправляем по текущему протоколу
							
				//Подготовка сообщения к отправке
				ТекИдентификатор = РезультатЗапроса.ИдентификаторСообщения;
				Сообщение = РезультатЗапроса.Хранилище.Получить();
				Сообщение.Id = ТекИдентификатор;
				
				ОтправкаРезультат = Ложь;
				
				Если сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.SOAP Тогда
					
					Коннектор = сшпВзаимодействиеСАдаптером.ПолучитьКоннектор();
					ОтправкаРезультат = сшпSOAPСервис.ОтправитьСообщение(Коннектор, Сообщение);
					Если ОтправкаРезультат Тогда
						сшпРаботаСДанными.УстановитьСостояниеСообщения(
							РезультатЗапроса.ИдентификаторСообщения, 
							Перечисления.сшпСтатусыСообщений.ОтправкаПодтверждена
						);
						Если ЗначениеЗаполнено(РезультатЗапроса.ИдентификаторБазовогоСообщения) Тогда 
							сшпРаботаСДанными.УстановитьСостояниеСообщения(
								РезультатЗапроса.ИдентификаторБазовогоСообщения,
								Перечисления.сшпСтатусыСообщений.ОтправкаПодтверждена
							);
						КонецЕсли;
					КонецЕсли;
					
				ИначеЕсли сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.REST Тогда
				
					Коннектор = сшпВзаимодействиеСАдаптером.ПолучитьКоннектор();
					ОтправкаРезультат = сшпHTTPСервис.ОтправитьСообщение(Коннектор, Сообщение);					
					Если ОтправкаРезультат Тогда
						сшпРаботаСДанными.УстановитьСостояниеСообщения(
							РезультатЗапроса.ИдентификаторБазовогоСообщения,
							Перечисления.сшпСтатусыСообщений.ОтправкаПодтверждена
						);
						Если ЗначениеЗаполнено(РезультатЗапроса.ИдентификаторБазовогоСообщения) Тогда 
							сшпРаботаСДанными.УстановитьСостояниеСообщения(
								РезультатЗапроса.ИдентификаторСообщения, 
								Перечисления.сшпСтатусыСообщений.ОтправкаПодтверждена
							);
						КонецЕсли;
					КонецЕсли;
							
				ИначеЕсли сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.PIPE ИЛИ 
				 сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB() = Перечисления.сшпТипыКоннекторовESB.TCP Тогда
					
					Если ЗначениеЗаполнено(РезультатЗапроса.ИдентификаторБазовогоСообщения) Тогда
					
						сшпРаботаСДанными.УстановитьСостояниеСообщения(
							РезультатЗапроса.ИдентификаторБазовогоСообщения, 
							Перечисления.сшпСтатусыСообщений.ОжиданиеОбработки
						);
						сшпРаботаСДанными.УстановитьСостояниеСообщения(
							РезультатЗапроса.ИдентификаторСообщения, 
							Перечисления.сшпСтатусыСообщений.ОтправкаОтменена
						);
							
					Иначе
							
						ЗаписьЖурналаРегистрации("Datareon.Обновление до версии 1.4.0", УровеньЖурналаРегистрации.Предупреждение, , , 
							"Не удалось найти сообщение " + Строка(РезультатЗапроса.ИдентификаторСообщения) + " в очереди исходящих! Сообщение не может быть отправлено!");
						сшпРаботаСДанными.УстановитьСостояниеСообщения(РезультатЗапроса.ИдентификаторСообщения, Перечисления.сшпСтатусыСообщений.ОтправкаОтменена);
							
					КонецЕсли;
				
				КонецЕсли;
				
				Если Не ОтправкаРезультат Тогда
					
					РезультатОбновления = Ложь;
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
			
	КонецЕсли;
	
	Возврат РезультатОбновления;
	
КонецФункции

// Процедура - ОбновлениеВерсии10120
// 
Процедура ОбновлениеВерсии10120()
	
	текНабор = РегистрыСведений.сшпРепозиторийОбъектовИнтеграции.СоздатьНаборЗаписей();
	текНабор.Прочитать();
	
	Для Каждого текЗапись Из текНабор Цикл
		
		Если Не ЗначениеЗаполнено(текЗапись.ПроцедураОбработки) Тогда
			
			текЗапись.ПроцедураОбработки = текЗапись.ДляУдаленияПроцедураОбработки.Получить();
		
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(текЗапись.Версия) Тогда
			
			текЗапись.Версия = "1";
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(текЗапись.ИдентификаторШаблона) Тогда
			
			текЗапись.ИдентификаторШаблона = Новый УникальныйИдентификатор;
		
		КонецЕсли;
	
	КонецЦикла;
	
	текНабор.Записать(Истина);

КонецПроцедуры

// Процедура - ОбновлениеВерсии10121
//
Процедура ОбновлениеВерсии10121()
	
	текНабор = РегистрыСведений.сшпРепозиторийОбъектовИнтеграции.СоздатьНаборЗаписей();
	текНабор.Прочитать();
	
	Для Каждого текЗапись Из текНабор Цикл
		
		Если Не ЗначениеЗаполнено(текЗапись.МетодХранения) Тогда
			
			текЗапись.МетодХранения = Перечисления.сшпМетодХранения.Сериализация;
			
		КонецЕсли;
		
	КонецЦикла;
	
	текНабор.Записать(Истина);
	
	ЗапросОбъект = Новый Запрос("ВЫБРАТЬ
	|	тбРепозиторий.ИдентификаторШаблона
	|ИЗ
	|	РегистрСведений.сшпРепозиторийОбъектовИнтеграции КАК тбРепозиторий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сшпСтатусыОбработчиков КАК тбСтатусы
	|		ПО тбРепозиторий.ИдентификаторШаблона = тбСтатусы.ИдентификаторОбработчика
	|ГДЕ
	|	тбСтатусы.ИдентификаторОбработчика ЕСТЬ NULL");
	ЗапросРезультат = ЗапросОбъект.Выполнить();
	
	Если Не ЗапросРезультат.Пустой() Тогда
		
		ЗапросВыборка = ЗапросРезультат.Выбрать();
		
		Пока ЗапросВыборка.Следующий() Цикл
			
			сшпРаботаСДанными.УстановитьСтатусОбработчика(ЗапросВыборка.ИдентификаторШаблона, Перечисления.сшпСтатусыОбработчиков.Включен);
		
		КонецЦикла;
			
	КонецЕсли;
		
КонецПроцедуры	

// Процедура - ОбновлениеВерсии10200
//
Процедура ОбновлениеВерсии10200()
	
	//Удаление статусов несуществующих обработчиков
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	сшпСтатусыОбработчиков.ИдентификаторОбработчика
		|ИЗ
		|	РегистрСведений.сшпСтатусыОбработчиков КАК сшпСтатусыОбработчиков
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сшпРепозиторийОбъектовИнтеграции КАК сшпРепозиторийОбъектовИнтеграции
		|		ПО сшпСтатусыОбработчиков.ИдентификаторОбработчика = сшпРепозиторийОбъектовИнтеграции.ИдентификаторШаблона
		|ГДЕ
		|	сшпРепозиторийОбъектовИнтеграции.ИдентификаторШаблона ЕСТЬ NULL ";	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗаписьСтатус = РегистрыСведений.сшпСтатусыОбработчиков.СоздатьМенеджерЗаписи();
		ЗаписьСтатус.ИдентификаторОбработчика = ВыборкаДетальныеЗаписи.ИдентификаторОбработчика;
		ЗаписьСтатус.Удалить();
	
	КонецЦикла;

	//Установка параметров очистки очередей из значения по умолчанию
	сшпДлительностьХраненияСообщенийПоОчередямИСостояниям = Константы.сшпДлительностьХраненияСообщенийПоОчередямИСостояниям.Получить().Получить();
	сшпДлительностьХраненияСообщений = сшпРаботаСКонстантами.ПолучитьДлительностьХраненияПоУмолчанию();
	
	Если Не ЗначениеЗаполнено(сшпДлительностьХраненияСообщенийПоОчередямИСостояниям) И ЗначениеЗаполнено(сшпДлительностьХраненияСообщений) Тогда
		 
		НачатьТранзакцию();
		
		ТаблицаДлительности = сшпРаботаСКонстантами.ПолучитьДлительностьХранения();
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Входящая, Перечисления.сшпСтатусыСообщений.Обработано, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Входящая, Перечисления.сшпСтатусыСообщений.ОбработкаОтменена, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Исходящая, Перечисления.сшпСтатусыСообщений.Обработано, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Исходящая, Перечисления.сшпСтатусыСообщений.ОбработкаОтменена, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Системная, Перечисления.сшпСтатусыСообщений.Обработано, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Системная, Перечисления.сшпСтатусыСообщений.ОбработкаОтменена, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Отправки, Перечисления.сшпСтатусыСообщений.Отправлено, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.Отправки, Перечисления.сшпСтатусыСообщений.ОтправкаОтменена, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.ОтправкиСистемныхСообщений, Перечисления.сшпСтатусыСообщений.Отправлено, сшпДлительностьХраненияСообщений);
		ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, Перечисления.сшпТипыОчередей.ОтправкиСистемныхСообщений, Перечисления.сшпСтатусыСообщений.ОтправкаОтменена, сшпДлительностьХраненияСообщений);
			
		ИмяКонстанты = "сшпДлительностьХраненияСообщенийПоОчередямИСостояниям";
		ЗначениеКонстанты = Новый ХранилищеЗначения(ТаблицаДлительности);
		ТекущееЗначение = сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты(ИмяКонстанты);
		
		Если Не ТекущееЗначение = ЗначениеКонстанты Тогда
			
			Константы[ИмяКонстанты].Установить(ЗначениеКонстанты);
			
		КонецЕсли; 
		
		сшпРаботаСКонстантами.УстановитьЗначениеКонстанты("сшпДлительностьХраненияСообщений", 0);
		
		ЗафиксироватьТранзакцию();
	
	КонецЕсли;

КонецПроцедуры	

// Процедура - ОбновлениеВерсии10202
//
Процедура ОбновлениеВерсии10202()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	сшпСостояниеСообщений.ИдентификаторСобытия
		|ИЗ
		|	РегистрСведений.сшпСостояниеСообщений КАК сшпСостояниеСообщений
		|ГДЕ
		|	сшпСостояниеСообщений.ЗадержкаЧисло = 0
		|	И сшпСостояниеСообщений.СтатусСообщения В(&СтатусыСообщений)";	
 	Запрос.УстановитьПараметр("СтатусыСообщений", сшпКэшируемыеФункции.ПоучитьСписокРабочихСтатусов());
 	
 	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МЗ = РегистрыСведений.сшпСостояниеСообщений.СоздатьМенеджерЗаписи();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		МЗ.ИдентификаторСобытия = ВыборкаДетальныеЗаписи.ИдентификаторСобытия;
		МЗ.Прочитать();
		
		МЗ.ЗадержкаЧисло = сшпОбщегоНазначения.ПеревестиДатуВЧисло(МЗ.ДатаИзменения, МЗ.Задержка);
		
		МЗ.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбработатьВходящееСообщениеОбновлениеКонфигурации10400(Формат, Сообщение)
	
	ФорматОберткиСообщения = сшпКэшируемыеФункции.ФорматСообщенийПоУмолчанию();

	xdtoПакет = сшпОбщегоНазначения.ПолучитьОбъектXDTO(ФорматОберткиСообщения, Сообщение);

	ВремяОжидания = ?(сшпФункциональныеОпции.АвтоматическийСтартОбработчиков(), сшпКэшируемыеФункции.ДлительностьОжиданияПриАвтоматическомСтарте(), сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпДлительностьОжидания")) * 1000;
	
	Идентификатор = ?(ТипЗнч(xdtoПакет.Id) = Тип("Строка"), Новый УникальныйИдентификатор(xdtoПакет.Id), xdtoПакет.Id);	

	ФорматСообщения = Формат; // контекст вызова обработчика.	

	КлассСообщения = ?(ТипЗнч(xdtoПакет.ClassId) = Тип("Строка"), xdtoПакет.ClassId, "");	

	ДатаРегистрации = ТекущаяДатаСеанса(); // контекст вызова обработчика.
	
	ОстатокВремениОжидания = ВремяОжидания;	
	Пока ОстатокВремениОжидания > 0 Цикл
		
		СтартОжидания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
		Если Не ПолучитьФункциональнуюОпцию("сшпИспользоватьСШП") Или ПолучитьФункциональнуюОпцию("сшпОтключитьПотоки") Тогда
			
			Возврат Ложь;
			
		ИначеЕсли сшпОбслуживаниеОчередей.ИдетОбработкаСистемныхСобытий() Тогда //Если включена обработка системных событий приостанавливаем рабочие потоки
			
			сшпОбщегоНазначения.Ожидание(1);
			
			ОстатокВремениОжидания = ОстатокВремениОжидания - (ТекущаяУниверсальнаяДатаВМиллисекундах() - СтартОжидания);
			
			Продолжить;
			
		КонецЕсли;

		СткОбработчик = сшпКэшируемыеФункции.ПолучитьОбработчик(КлассСообщения, Перечисления.сшпТипыИнтеграции.Входящая, сшпФункциональныеОпции.ВерсияОбработчиков());
		
		Если Не ЗначениеЗаполнено(СткОбработчик.ПроцедураОбработки) Тогда
			
			Возврат Ложь;
			
		Иначе

			Если СткОбработчик.Статус = Перечисления.сшпСтатусыОбработчиков.Отключен Тогда
			
				Возврат Ложь;
		
			Иначе
			
				Попытка
					
					Задержка = 0; // контекст вызова обработчика.
					текЗаголовокЖурнала = "Datareon. Получение объекта события"; // контекст вызова обработчика.
					ТекстОшибки = "";
					ОбъектСобытия = сшпОбщегоНазначения.ЗаписатьОбъектВПоток(ФорматОберткиСообщения, xdtoПакет);
					ИдШаблона = СткОбработчик.ИдентификаторШаблона; // контекст вызова обработчика.
					ВерсияШаблона = СткОбработчик.Версия; // контекст вызова обработчика.
					СостояниеСообщения = Перечисления.сшпСтатусыСообщений.Обработано; // Переменная для установки нового состояние сообщения
					ОбъектСообщение = сшпОбщегоНазначения.ПолучитьОбъектXDTO(ФорматОберткиСообщения, ОбъектСобытия); // контекст вызова обработчика.
					
					//@skip-check server-execution-safe-mode
					Выполнить(сткОбработчик.ПроцедураОбработки);
									
					Возврат СостояниеСообщения = Перечисления.сшпСтатусыСообщений.Обработано;
											
				Исключение
					
					ТекстОшибки = сшпОбщегоНазначения.ПолучитьТекстОшибкиОбработчика(ИнформацияОбОшибке());				
					ЗаписьЖурналаРегистрации("Datareon. Обработка сообщения", УровеньЖурналаРегистрации.Ошибка, , Идентификатор, ТекстОшибки);
					
					Возврат Ложь;
					
				КонецПопытки;		
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Процедура - ДобавитьНастройкуВТаблицуДлительности
//
// Параметры:
//	ТаблицаДлительности - ТаблицаЗначений - таблица длительности 
//	ТипОчереди - Перечисление.сшпТипыОчередей - тип очереди 
//	Статус - Перечисление.сшпСтатусыСообщений - статус
//	Длительность - Число - длительность
//
Процедура ДобавитьНастройкуВТаблицуДлительности(ТаблицаДлительности, ТипОчереди, Статус, Длительность)
	
	НоваяСтрока = ТаблицаДлительности.Добавить();
	
	НоваяСтрока.ТипОчереди = ТипОчереди;
	НоваяСтрока.СтатусСообщения = Статус;
	НоваяСтрока.ДлительностьХранения = Длительность;
	
КонецПроцедуры

// Процедура - ПроверитьИспользованиеПараметров
//
// Параметры:
//	Параметры - Структура - Параметры сообщения 
//
Процедура ПроверитьИспользованиеПараметров(Параметры) Экспорт
	
	ТекущаяВерсия = сшпКэшируемыеФункции.ВерсияПодсистемы();
	
	Если ТекущаяВерсия > 10200 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого текПараметр Из Параметры Цикл
		
		Если текПараметр.Ключ = "IsUpdatedFromCsa" И текПараметр.Значение = Истина Тогда 
			
			Константы.сшпВерсияПодсистемы.Установить(ПолучитьАктуальнуюВерсию());
			
			Возврат;
		
		КонецЕсли;
		
	КонецЦикла;
	
	МассивПараметровКУдалению = Новый Массив;
	МассивПараметровКУдалению.Добавить("AutoStartProcessing");
	МассивПараметровКУдалению.Добавить("SerializationFormat");
	МассивПараметровКУдалению.Добавить("ShutDown");
	МассивПараметровКУдалению.Добавить("WaitingTime");
	МассивПараметровКУдалению.Добавить("MaxFlowIn");
	МассивПараметровКУдалению.Добавить("MaxFlowOut");
	МассивПараметровКУдалению.Добавить("MaxFlowSend");
	МассивПараметровКУдалению.Добавить("LiveTime");
	МассивПараметровКУдалению.Добавить("LiveTimeDefault");
	
	Для Каждого ЭлементМассива Из МассивПараметровКУдалению Цикл 
		
		Если Параметры.Свойство(ЭлементМассива) Тогда 
			
			Параметры.Удалить(ЭлементМассива);
		
		КонецЕсли;
	
	КонецЦикла;
	
	//Отправка сообщения на адптер для применения настроек
	
	ДлительностьХраненияСтрокой = "";
	
	Таблица = сшпРаботаСКонстантами.ПолучитьДлительностьХранения();
	
	Для Каждого Колонка Из Таблица.Колонки Цикл
		
		ДлительностьХраненияСтрокой = ДлительностьХраненияСтрокой + Колонка.Имя + ";";
	
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из Таблица Цикл
		
		НоваяСтрока = "";
		Для Каждого Колонка Из Таблица.Колонки Цикл 
			
			НоваяСтрока = НоваяСтрока + XMLСтрока(СтрокаТЧ[Колонка.Имя]) + ";";
		
		КонецЦикла;
		
		ДлительностьХраненияСтрокой = ДлительностьХраненияСтрокой + Символы.ПС + НоваяСтрока;
	
	КонецЦикла;
	
	СвойстваСообщения = Новый Структура;	
	СвойстваСообщения.Вставить("AdapterType", "");
	СвойстваСообщения.Вставить("Uri", "");
	СвойстваСообщения.Вставить("ConfigurationName", "");
	СвойстваСообщения.Вставить("EndpointName", "");
	СвойстваСообщения.Вставить("MessageFormat", "");
	СвойстваСообщения.Вставить("ServerMode", "");
	СвойстваСообщения.Вставить("MaxBatchSize", "");
	СвойстваСообщения.Вставить("LiveTime", ДлительностьХраненияСтрокой);
	СвойстваСообщения.Вставить("AutoStartProcessing", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпАвтоматическийСтартОбработчиков"));
	СвойстваСообщения.Вставить("WaitingTime", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпДлительностьОжидания"));
	СвойстваСообщения.Вставить("MaxFlowIn", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпМаксимальноеКоличествоПотоковОбработкиВходящих"));
	СвойстваСообщения.Вставить("MaxFlowOut", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпМаксимальноеКоличествоПотоковОбработкиИсходящих"));
	СвойстваСообщения.Вставить("ShutDown", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпОтключитьПотокиОбработкиДанных"));
	СвойстваСообщения.Вставить("SerializationFormat", Строка(сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпФорматДляСериализации")));
	СвойстваСообщения.Вставить("LiveTimeDefault", сшпРаботаСКонстантами.ПолучитьЗначениеКонстанты("сшпДлительностьХраненияСообщений"));
	
	Сообщение = сшпОбщегоНазначения.СформироватьСтруктуруПакета("SSM","CSA");
	Сообщение.Properties = СвойстваСообщения;
	
	сшпВзаимодействиеСАдаптером.ОтправитьСистемноеСообщениеБезОчереди(Сообщение);
	
КонецПроцедуры

#КонецОбласти
