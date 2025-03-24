﻿Процедура ПодготовитьПредопределенныеЭлементы() Экспорт
	
	// первичное заполнение предопределенных элементов
	ПрототипСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Контуры.Продуктив");
	ПрототипОбъект = ПрототипСсылка.ПолучитьОбъект();
	ПрототипОбъект.ОписаниеКонтура = "Рабочие базы";
	ПрототипОбъект.ТипКонтура = Перечисления.ТипыКонтуров.Продуктив;
	ПрототипОбъект.Записать();
	
	ПрототипСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Контуры.НочныеКопии");
	ПрототипОбъект = ПрототипСсылка.ПолучитьОбъект();
	ПрототипОбъект.ОписаниеКонтура = "Ночные копии рабочих баз";
	ПрототипОбъект.ТипКонтура = Перечисления.ТипыКонтуров.Тестирование;
	ПрототипОбъект.Записать();
	
	ПрототипСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Контуры.Предрелиз");
	ПрототипОбъект = ПрототипСсылка.ПолучитьОбъект();
	ПрототипОбъект.ОписаниеКонтура = "Предрелизные копии рабочих баз";
	ПрототипОбъект.ТипКонтура = Перечисления.ТипыКонтуров.Тестирование;
	ПрототипОбъект.Записать();
	
	ПрототипСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Контуры.Разработка");
	ПрототипОбъект = ПрототипСсылка.ПолучитьОбъект();
	ПрототипОбъект.ОписаниеКонтура = "Разработка";
	ПрототипОбъект.ТипКонтура = Перечисления.ТипыКонтуров.Разработка;
	ПрототипОбъект.Записать();
	
КонецПроцедуры

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|  ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

