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
	
	Если УправлениеСвойствамиСлужебный.ДополнительноеСвойствоИспользуется(Параметры.Ссылка) Тогда
		
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектИспользуется;
		
		Элементы.РазрешитьРедактирование.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоРеквизита;
		Иначе
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоСведения;
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "СвойствоИспользуется");
		Элементы.КнопкиПояснения.Видимость = Ложь;
	Иначе
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектНеИспользуется;
		Элементы.ОбъектИспользуется.Видимость = Ложь; // Для компактного отображения формы.
		
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоРеквизита;
		Иначе
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоСведения;
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "СвойствоНеИспользуется");
		Элементы.КнопкиПредупреждения.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	РазблокируемыеРеквизиты.Добавить("ТипЗначения");
	РазблокируемыеРеквизиты.Добавить("Имя");
	РазблокируемыеРеквизиты.Добавить("ИдентификаторДляФормул");
	
	Закрыть(РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
