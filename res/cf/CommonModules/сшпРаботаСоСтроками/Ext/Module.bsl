﻿#Область ПрограммныйИнтерфейс

// Реализации функции глобального контекста СтрРазделить
// 
// Параметры:
// 	Строка - Строка - разделяемая строка
// 	Разделитель - Строка - строка, по которой будет выполняется разделение исходной строки
// 	ВключатьПустые - Булево - Указывает необходимость включать в результат пустые строки, 
// 							  которые могут образоваться в результате разделения исходной строки. 
// 							  Значение по умолчанию: Истина
// 	
// Возвращаемое значение:
// 	Массив из Строка - массив подстрок, полученных после разделения
Функция _СтрРазделить(Знач Строка, Знач Разделитель = ",", Знач ВключатьПустые = Истина) Экспорт

	Возврат СтрРазделить(Строка, Разделитель, ВключатьПустые);

КонецФункции

// Реализации функции глобального контекста СтрЗаканчиваетсяНа
// 
// Параметры:
// 	Строка - Строка - проверяемая строка
// 	СтрокаПоиска - Строка - подстрока поиска
// Возвращаемое значение:
// 	Булево - Истина - начинается, Ложь - нет
Функция _СтрЗаканчиваетсяНа(Строка, СтрокаПоиска) Экспорт

	Возврат СтрЗаканчиваетсяНа(Строка, СтрокаПоиска);

КонецФункции

// Реализации функции глобального контекста СтрНачинаетсяС
// 
// Параметры:
// 	Строка - Строка - проверяемая строка
// 	СтрокаПоиска - Строка - подстрока поиска
// Возвращаемое значение:
// 	Булево - Истина - заканчивается, Ложь - нет
Функция _СтрНачинаетсяС(Строка, СтрокаПоиска) Экспорт

	Возврат СтрНачинаетсяС(Строка, СтрокаПоиска);

КонецФункции

// Реализации функции глобального контекста СтрСоединить
// 
// Параметры:
// 	Строки - Массив - массив строк, из которого надо получить итоговую строку
// 	Разделитель - Строка - разделитель строк в итоговой строке
// Возвращаемое значение:
// 	Строка - итоговая строка
Функция _СтрСоединить(Строки, Разделитель) Экспорт

	Возврат СтрСоединить(Строки, Разделитель);

КонецФункции	

// Реализации функции глобального контекста СтрНайти
// 
// Параметры:
// 	Строка - Строка - строка, в которой нужно выполнить поиск
// 	СтрокаПоиска - Строка - строка поиска
// Возвращаемое значение:
// 	Число - номер перового символа найденой строки поиска
Функция _СтрНайти(Строка, СтрокаПоиска) Экспорт

	Возврат СтрНайти(Строка, СтрокаПоиска);

КонецФункции

// Реализации функции глобального контекста СтрШаблон
// 
// Параметры:
// 	Шаблон - Строка - Содержит шаблон конечной строки. 
// 					  Шаблон может состоять из обычного текста и параметров, 
// 					  которые начинаются с подстановочного знака % (процента) 
// 	п1 - Строка - параметр подстановки
// 	п2 - Строка - параметр подстановки
// 	п3 - Строка - параметр подстановки
// 	п4 - Строка - параметр подстановки
// 	п5 - Строка - параметр подстановки
// 	п6 - Строка - параметр подстановки
// 	п7 - Строка - параметр подстановки
// 	п8 - Строка - параметр подстановки
// 	п9 - Строка - параметр подстановки
// 	п10 - Строка - параметр подстановки
// Возвращаемое значение:
// 	Строка - итоговая строка по шаблону
Функция _СтрШаблон(Шаблон, п1 = Неопределено, п2 = Неопределено, п3 = Неопределено, п4 = Неопределено,
	п5 = Неопределено, п6 = Неопределено, п7 = Неопределено, п8 = Неопределено, п9 = Неопределено, п10 = Неопределено) Экспорт

	Возврат СтрШаблон(Шаблон, п1, п2, п3, п4, п5, п6, п7, п8, п9, п10);

КонецФункции	

// Функция замены непечатаемых символов
// 
// Параметры:
// 	Строка - Строка - обрабатываемая строка
// Возвращаемое значение:
// 	Строка - строка без непечатаемых символов
Функция _СтрЗаменитьНепечатаемые(Знач Строка) Экспорт

	Результат = СтрЗаменить(Строка, " ", " ");
	Возврат Результат;

КонецФункции

// Функция удаления недопустимых символов
// 
// Параметры:
// 	Строка - Строка - обрабатываемая строка
// Возвращаемое значение:
// 	Строка - строка с удаленными символами
Функция УдалитьНайтиНедопустимыеСимволыXML(Знач Строка) Экспорт
	Результат = Строка;
	ИндексСимвола = НайтиНедопустимыеСимволыXML(Результат);

	Пока ИндексСимвола <> 0 Цикл
		Результат		 = СтрЗаменить(Результат, Сред(Результат, ИндексСимвола, 1), "");
		ИндексСимвола	 = НайтиНедопустимыеСимволыXML(Результат);
	КонецЦикла;

	Возврат Результат;
КонецФункции

#КонецОбласти