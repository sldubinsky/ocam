﻿
//Функция - Выполнить входящий обработчик
//
//Параметры:
//	КлассСообщения - Строка - Класс сообщения
//	СтруктураСообщения - Структура - Структура сообщения
//	СостояниеСообщения - Перечисление.сшпСтатусыСообщений - Возвращает статус сообщения
//	ТекстОшибки - Строка - Возвращает текст ошибки
//
//Возвращаемое значение:
//	Булево - результат выполнения обработчика
//
Функция ВыполнитьВходящийОбработчик(Знач КлассСообщения, Знач СтруктураСообщения, СостояниеСообщения, ТекстОшибки) Экспорт
	
	СткОбработчик = сшпКэшируемыеФункции.ПолучитьОбработчик(КлассСообщения, Перечисления.сшпТипыИнтеграции.Входящая, сшпФункциональныеОпции.ВерсияОбработчиков());
	ФорматСообщения = сшпФункциональныеОпции.ФорматСообщения();
	Задержка = 0;
	ДатаРегистрации = ТекущаяДата();
	Компонента = Обработки.сшпВызовыКомпоненты.Создать();
	Компонента.ИнициализироватьКомпоненту();
	СостояниеСообщения = Перечисления.сшпСтатусыСообщений.Обработано;
	ИдШаблона = СткОбработчик.ИдентификаторШаблона;
	ВерсияШаблона = СткОбработчик.Версия;
	
	Если Не СткОбработчик.ОбработчикНайден Тогда
		
		ТекстОшибки = "Отсутствует обработчик для класса " + КлассСообщения;
		
		Возврат Ложь;
		
	ИначеЕсли СткОбработчик.Отключен Тогда
		
		ТекстОшибки = "Обработчик для класса " + КлассСообщения + " найден, но отключен.";
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ТелоСообщения = сшпОбщегоНазначения.ПреобразоватьСтруктуруПоФормату(ФорматСообщения, СтруктураСообщения);
	
	ОбъектСообщение = сшпОбщегоНазначения.СформироватьСтруктуруПакета("DTP", КлассСообщения, ТелоСообщения);
	
	Попытка
		
		//@skip-check server-execution-safe-mode
		Выполнить(СткОбработчик.ПроцедураОбработки);
		
	Исключение
		
		ТекстОшибки = сшпОбщегоНазначения.ПолучитьТекстОшибкиОбработчика(ИнформацияОбОшибке());
		
		СостояниеСообщения = Перечисления.сшпСтатусыСообщений.ОшибкаОбработки;
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Если Не СостояниеСообщения = Перечисления.сшпСтатусыСообщений.Обработано Тогда
		
		ТекстОшибки = "Обработчик для класса " + КлассСообщения + " вернул состояние " + Строка(СостояниеСообщения);
		
		Возврат Ложь;		
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

//Функция - Поместить в очередь исходящих
//
//Параметры:
//	ТипОбъекта - Строка - Наименование типа объекта помещаемого в очередь
//	Объект - Структура/Объект/Ссылка - Сущность для выполнения кода обработчика
//
//Возвращаемое значение:
//	Булево - результат выполнения
//
Функция ПоместитьВОчередьИсходящих(Знач ТипОбъекта, Знач Объект) Экспорт
	
	ФорматСериализация = сшпФункциональныеОпции.ФорматСериализации();
	СсылкаНаОбъект = Неопределено;
	
	Если сшпКэшируемыеФункции.УчаствуетВИнтеграции(ТипОбъекта, сшпФункциональныеОпции.ВерсияОбработчиков()) Тогда
	
		МетодХранения = сшпКэшируемыеФункции.ПолучитьМетодХранения(ТипОбъекта, сшпФункциональныеОпции.ВерсияОбработчиков());
		
		Если МетодХранения = Перечисления.сшпМетодХранения.Сериализация Тогда
								
			ЗначениеХранения = сшпОбщегоНазначения.СериализоватьОбъект(ФорматСериализация, Объект);
				
		Иначе
			
			ФорматСериализация = сшпФункциональныеОпции.ФорматСообщения();
				
			Если ТипЗнч(Объект) = Тип("Отбор") ИЛИ 
			 	ТипЗнч(Объект) = Тип("Структура") Тогда
					
				ЗначениеХранения = Объект;
					
			Иначе
					
				ЗначениеХранения = Объект.Ссылка;
				СсылкаНаОбъект = ЗначениеХранения;
					
			КонецЕсли;			
			
		КонецЕсли;
		
		сшпРаботаСДанными.ПоместитьВОчередьИсходящих(ТипОбъекта, ЗначениеХранения, ФорматСериализация, МетодХранения, Истина, Ложь, СсылкаНаОбъект);
	
		Возврат Истина;
	
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;
	
КонецФункции

// Функция - Взять событие в обработку
// 
// Параметры:
// 	ИдентификаторСобытия - УникальныйИдентификатор - Идентификатор события
// 	ИдентификаторСообщения - УникальныйИдентификатор - Идентификатор сообщения
//
//Возвращаемое значение:
//	Булево - результат выполнения
//
Функция ВзятьСобытиеВОбработку(ИдентификаторСобытия, ИдентификаторСообщения) Экспорт
	
	РегСвед = РегистрыСведений.сшпСостояниеСообщений.СоздатьНаборЗаписей();
	РегСвед.ДополнительныеСвойства.Вставить("СШПНеобрабатывать", Истина);
	РегСвед.Отбор.ИдентификаторСобытия.Установить(ИдентификаторСобытия);
	
	РегСвед.Прочитать();
	
	Если РегСвед.Выбран() Тогда
		
		РегСвед[0].ИдентификаторСообщения = ИдентификаторСообщения;
		РегСвед[0].СтатусСообщения = Перечисления.сшпСтатусыСообщений.ПакетнаяОбработка;
	
		Попытка
			РегСвед.Записать(Истина);
			Возврат Истина;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации("Datareon.ВзятьСобытиеВОбработку", УровеньЖурналаРегистрации.Ошибка, Метаданные.ОбщиеМодули.сшпПользовательскиеМетоды, , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат Ложь;
		КонецПопытки;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Функция - Отправить сообщение
//
// Параметры:
//  СтруктураСообщения - Структура - Структура сообщения ESB, для отправки
// 
// Возвращаемое значение:
//  Булево - Результат отправки
//
Функция ОтправитьСообщение(Знач СтруктураСообщения) Экспорт
	
	ТипКоннектора = сшпФункциональныеОпции.ТипИспользуемогоКоннектораESB();
	
	Если ТипКоннектора = Перечисления.сшпТипыКоннекторовESB.SOAP ИЛИ 
		ТипКоннектора = Перечисления.сшпТипыКоннекторовESB.REST Тогда
		
		Коннектор = сшпВзаимодействиеСАдаптером.ПолучитьКоннектор();
		Если Коннектор = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Попытка
			сшпОбслуживаниеОчередей.ОтправитьСообщение(Коннектор, СтруктураСообщения, Ложь);
		Исключение
			Возврат Ложь;
		КонецПопытки;
		
	ИначеЕсли ТипКоннектора = Перечисления.сшпТипыКоннекторовESB.Tcp Тогда
		
		Если Не сшпTcp.ОтправитьСообщениеБезОчереди(СтруктураСообщения) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Если Не сшпPipe.ОтправитьСообщениеБезОчереди(СтруктураСообщения) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Функция - Получить обработчик по имени
// 
// Параметры:
// 	НаименованиеОбработчика - Строка - Наименование обработчика для поиска
// Возвращаемое значение:
// 	Структура, ФиксированнаяСтруктура - Описание обработчика
//
Функция ПолучитьОбработчикПоИмени(НаименованиеОбработчика) Экспорт
	
	Возврат сшпКэшируемыеФункции.ПолучитьОбработчикПоИмени(НаименованиеОбработчика);
	
КонецФункции

// Процедура - Зарегистировать в журнале адаптера
// 
// Параметры:
// 	Уровень - УровеньЖурналаРегистрации - Уровень логирования
// 	Текст - Строка - Текст для лога
//
Процедура ЗарегистироватьВЖурналеАдаптера(Уровень, Текст) Экспорт
	
	сшпОбщегоНазначения.ЗарегистрироватьЗаписьВЖурнале(Уровень, Неопределено, Текст);
	
КонецПроцедуры