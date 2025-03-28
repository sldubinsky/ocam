﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает конструктор формул.
//
// Параметры:
//  Параметры - см. ПараметрыРедактированияФормулы
//  ОбработчикЗавершения - ОписаниеОповещения 
//
Процедура НачатьРедактированиеФормулы(Параметры, ОбработчикЗавершения) Экспорт
	
	ОткрытьФорму("Обработка.КонструкторФормул.Форма.РедактированиеФормулы", Параметры, , , , , ОбработчикЗавершения);
	
КонецПроцедуры

// Конструктор параметра ПараметрыФормулы для функции ПредставлениеФормулы.
// 
// Возвращаемое значение:
//  Структура:
//   * Формула - Строка
//   * Операнды - Строка - адрес во временном хранилище коллекции операндов. Коллекция может быть одного из трех типов: 
//                         ТаблицаЗначений - см. ТаблицаПолей
//                         ДеревоЗначений - см. ДеревоПолей
//                         СхемаКомпоновкиДанных  - список операндов будет взят из коллекции ДоступныеПоляОтбора
//                                                  компоновщика настроек. Имя коллекции может быть переопределено
//                                                  в параметре ИмяКоллекцииСКД.
//   * Операторы - Строка - адрес во временном хранилище коллекции операторов. Коллекция может быть одного из трех типов: 
//                         ТаблицаЗначений - см. ТаблицаПолей
//                         ДеревоЗначений - см. ДеревоПолей
//                         СхемаКомпоновкиДанных  - список операндов будет взят из коллекции ДоступныеПоляОтбора
//                                                  компоновщика настроек. Имя коллекции может быть переопределено
//                                                  в параметре ИмяКоллекцииСКД.
//   * ИмяКоллекцииСКДОперандов  - Строка - имя коллекции полей в компоновщике настроек. Параметр необходимо
//                                          использовать, если в параметре Операнды передана схема компоновки данных.
//                                          Значение по умолчанию - ДоступныеПоляОтбора.
//   * ИмяКоллекцииСКДОператоров - Строка - имя коллекции полей в компоновщике настроек. Параметр необходимо
//                                          использовать, если в параметре Операторы передана схема компоновки данных.
//                                          Значение по умолчанию - ДоступныеПоляОтбора.
//   * Наименование - Неопределено - наименование не используется для формулы, соответствующее поле не выводится.
//                  - Строка       - наименование формулы. Если заполнено или пустое, соответствующее поле выводится
//                                   на в форме конструктора.
//   * ДляЗапроса   - Булево - формула предназначена для вставки в запрос. Данный параметр влияет на состав операторов
//                             по умолчанию, а также на выбор алгоритма проверки формулы.
//
Функция ПараметрыРедактированияФормулы() Экспорт
	
	Возврат КонструкторФормулКлиентСервер.ПараметрыРедактированияФормулы();
	
КонецФункции

// Обработчик разворачивания подключаемого списка.
// 
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - владелец списка.
//  Элемент - ТаблицаФормы - список, в котором выполняется разворачивание строки.
//  Строка  - Число - идентификатор строки списка.
//  Отказ   - Булево - признак отказа от разворачивания.
//
Процедура СписокПолейПередРазворачиванием(Форма, Элемент, Строка, Отказ) Экспорт
	
	Элемент.ТекущаяСтрока = Строка;
	КоллекцияЭлементов = Форма[Элемент.Имя].НайтиПоИдентификатору(Строка).ПолучитьЭлементы();
	Если КоллекцияЭлементов.Количество() > 0 И КоллекцияЭлементов[0].Поле = Неопределено Тогда
		Отказ = Истина;
		Форма.ПодключитьОбработчикОжидания("Подключаемый_РазвернутьТекущийЭлементСпискаПолей", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик разворачивания подключаемого списка.
// Разворачивает текущий элемент списка.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
// 
Процедура РазвернутьТекущийЭлементСпискаПолей(Форма) Экспорт
	
	СписокПолей = Форма.ТекущийЭлемент;
	ИдентификаторСтроки = СписокПолей.ТекущаяСтрока;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
	ПараметрыЗаполнения.Вставить("ИмяСписка", СписокПолей.Имя);
	
	Форма.Подключаемый_ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения);
	СписокПолей.Развернуть(ИдентификаторСтроки);
	
КонецПроцедуры

// Обработчик перетаскивания подключаемого списка
// 
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - владелец списка.
//  Элемент - ТаблицаФормы - список, в котором выполняется перетаскивание.
//  ПараметрыПеретаскивания - ПараметрыПеретаскивания - содержит перетаскиваемое значение, тип действия 
//                                                      и возможные действия при перетаскивании.
//  Выполнение - Булево - если Ложь, перетаскивание не начнется.
//
Процедура СписокПолейНачалоПеретаскивания(Форма, Элемент, ПараметрыПеретаскивания, Выполнение) Экспорт
	
	ИмяСпискаПолей = Элемент.Имя;
	Реквизит = Форма[ИмяСпискаПолей].НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	НастройкиСпискаПолей = КонструкторФормулКлиентСервер.НастройкиСпискаПолей(Форма, ИмяСпискаПолей);
	Если НастройкиСпискаПолей.СкобкиПредставлений Тогда
		ПараметрыПеретаскивания.Значение = "[" + Реквизит.ПредставлениеПутиКДанным + "]";
	Иначе
		ПараметрыПеретаскивания.Значение = Реквизит.ПредставлениеПутиКДанным;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает описание текущего выбранного поля подключаемого списка.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - владелец списка.
//  ИмяСпискаПолей - Строка - имя списка, установленное при вызове КонструкторФормул.ДобавитьСписокПолейНаФорму.
//  
// Возвращаемое значение:
//  Структура:
//   * Имя - Строка
//   * Заголовок - Строка
//   * ПутьКДанным - Строка
//   * ПредставлениеПутиКДанным - Строка
//   * Тип - ОписаниеТипов
//   * Родитель - см. ВыбранноеПолеВСпискеПолей
//
Функция ВыбранноеПолеВСпискеПолей(Форма, ИмяСпискаПолей = Неопределено) Экспорт
	
	Если Форма.ПодключенныеСпискиПолей.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяСпискаПолей = Неопределено Тогда
		СписокПолей = Форма.ТекущийЭлемент; // ТаблицаФормы
		ИмяСпискаПолей = СписокПолей.Имя;
		Если КонструкторФормулКлиентСервер.НастройкиСпискаПолей(Форма, ИмяСпискаПолей)= Неопределено Тогда
			ИмяСпискаПолей = Форма.ПодключенныеСпискиПолей[0].ИмяСпискаПолей;
		КонецЕсли;
	КонецЕсли;
	
	СписокПолей = Форма.Элементы[ИмяСпискаПолей];
	ТекущиеДанные = СписокПолей.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОписаниеВыбранногоПоля(ТекущиеДанные);
	
КонецФункции

// Обработчик события строки поиска подключаемого списка.
// 
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - владелец списка.
//  Элемент - ПолеФормы - строка поиска.
//  Текст - Строка - текст в строке поиска.
//  СтандартнаяОбработка - Булево - если Ложь, стандартное действие выполнено не будет.
//
Процедура СтрокаПоискаИзменениеТекстаРедактирования(Форма, Элемент, Текст, СтандартнаяОбработка) Экспорт
	
	Форма[Элемент.Имя] = Текст;
	Форма.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьПоискВСпискеПолей");
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьПоискВСпискеПолей", 0.5, Истина);
	
КонецПроцедуры

// Обработчик события строки поиска подключаемого списка.
// 
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - владелец списка.
//  Элемент - ПолеФормы - строка поиска.
//  СтандартнаяОбработка - Булево - если Ложь, стандартное действие выполнено не будет.
//
Процедура СтрокаПоискаОчистка(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтрокаПоискаИзменениеТекстаРедактирования(Форма, Элемент, "", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  Оператор - см. ВыбранноеПолеВСпискеПолей
//
Функция ВыражениеДляВставки(Оператор) Экспорт
	
	Результат = Оператор.Заголовок + "()";
	
	Если Не ЗначениеЗаполнено(Оператор.Родитель) Тогда
		Возврат "";
	КонецЕсли;
	
	ГруппаОператоров = Оператор.Родитель; // см. ВыбранноеПолеВСпискеПолей
	ИмяГруппыОператоров = ГруппаОператоров.Имя;
	
	Если ИмяГруппыОператоров = "Разделители" Тогда
		Результат = "+ """ + Оператор.Заголовок + """ +";
		Если Оператор.Имя = "[ ]" Тогда
			Результат = "+ "" "" +";
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяГруппыОператоров = "ЛогическиеОператорыИКонстанты"
		Или ИмяГруппыОператоров = "Операторы"
		Или ИмяГруппыОператоров = "ОперацииНадСтроками"
		Или ИмяГруппыОператоров = "ЛогическиеОперации"
		Или ИмяГруппыОператоров = "ОперацииСравнения" И Оператор.Имя <> "В" Тогда
		Результат = Оператор.Заголовок;
	КонецЕсли;
	
	Если ИмяГруппыОператоров = "ПрочиеФункции" Тогда
		Если Оператор.Имя = "[?]" Или Оператор.Имя = "Формат" Тогда
			Результат = Оператор.Заголовок + "(,,)";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеВыбранногоПоля(Поле)
	
	Результат = Новый Структура;
	Результат.Вставить("Имя");
	Результат.Вставить("Заголовок");
	Результат.Вставить("ПутьКДанным");
	Результат.Вставить("ПредставлениеПутиКДанным");
	Результат.Вставить("Тип");
	Результат.Вставить("Родитель");
	
	ЗаполнитьЗначенияСвойств(Результат, Поле);
	
	Родитель = Поле.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		Результат.Родитель = ОписаниеВыбранногоПоля(Родитель);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
