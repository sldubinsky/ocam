﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Форматирует строку в соответствии с заданным шаблоном.
// Возможные значения тегов в шаблоне:
// - <span style="Имя свойства: Имя элемента стиля">Строка</span> - оформляет текст описанными
//      в атрибуте style элементами стиля.
// - <b> Строка </b> - выделяет строку элементом стиля ВажнаяНадписьШрифт,
//      который соответствует полужирному шрифту.
// - <a href="Ссылка">Строка</a> - добавляет гиперссылку.
// - <img src="Календарь"> - добавляет картинку из библиотеки картинок.
// Атрибут style применяется для оформления текста. Атрибут может быть использован для тегов span и a.
// Вначале следует имя стилевого свойства, затем через двоеточие имя элемента стиля.
// Стилевые свойства:
//  - color - Определяет цвет текста. Например, color: ГиперссылкаЦвет;
//  - background-color - Определяет цвет фона у текста. Например, background-color: ИтогиФонГруппы;
//  - font - Определяет шрифт текста.Например, font: ОсновнойЭлементСписка.
// Стилевые свойства разделяются точкой с запятой. Например, style="color: ГиперссылкаЦвет; font: ОсновнойЭлементСписка"
// Вложенные теги не поддерживаются.
//
// Параметры:
//  ШаблонСтроки - Строка - строка, содержащая теги форматирования.
//  Параметр<n>  - Строка - значение подставляемого параметра.
//
// Возвращаемое значение:
//  ФорматированнаяСтрока - преобразованная строка.
//
// Пример:
//  1. СтроковыеФункцииКлиент.ФорматированнаяСтрока(НСтр("ru='
//       <span style=""color: ЗаблокированныйРеквизитЦвет; font: ВажнаяНадписьШрифт"">Минимальная</span> версия программы <b>1.1</b>. 
//       <a href = ""Обновление"">Обновите</a> программу.'"));
//  2. СтроковыеФункцииКлиент.ФорматированнаяСтрока(НСтр("ru='Режим: <img src=""РедактироватьВДиалоге"">
//       <a style=""color: ИзмененноеЗначениеРеквизитаЦвет; background-color: ИзмененноеЗначениеРеквизитаФон""
//       href=""e1cib/command/Обработка.Редактор"">Редактирование</a>'"));
//  3. СтроковыеФункцииКлиент.ФорматированнаяСтрока(НСтр("ru='Текущая дата <img src=""Календарь"">
//       <span style=""font:ВажнаяНадписьШрифт"">%1</span>'"), ТекущаяДатаСеанса());
//
Функция ФорматированнаяСтрока(Знач ШаблонСтроки, Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено,
	Знач Параметр3 = Неопределено, Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено) Экспорт
	
	ЭлементыСтиля = СтандартныеПодсистемыКлиент.ЭлементыСтиля();
	Возврат СтроковыеФункцииКлиентСервер.СформироватьФорматированнуюСтроку(ШаблонСтроки, ЭлементыСтиля, Параметр1, Параметр2, Параметр3, Параметр4, Параметр5);
	
КонецФункции

// Преобразует исходную строку в транслит.
// Может использоваться для отправки SMS-сообщений латиницей или для сохранения
// файлов и папок, чтобы обеспечить возможность их переноса между разными операционными системами.
// Обратное преобразование из латинских символов не предусмотрено.
//
// Параметры:
//  Значение - Строка - произвольная строка.
//
// Возвращаемое значение:
//  Строка - строка, в которой кириллица заменена на транслит.
//
Функция СтрокаЛатиницей(Знач Значение) Экспорт
	
	ПравилаТранслитерации = Новый Соответствие;
	СтандартныеПодсистемыКлиентСерверЛокализация.ПриЗаполненииПравилТранслитерации(ПравилаТранслитерации);
	Возврат ОбщегоНазначенияСлужебныйКлиентСервер.СтрокаЛатиницей(Значение, ПравилаТранслитерации);
	
КонецФункции

// Возвращает представление периода в нижнем регистре или с заглавной буквы,
//  если с него начинается фраза (предложение).
//  Например, если требуется вывести представление периода в заголовке отчета
//  в формате "Продажи за [ДатаНачала] - [ДатаОкончания]", то ожидается, что
//  результат будет выглядеть так: "Продажи за февраль 2020 г. - март 2020 г.".
//  Т.е. - строчно, т.к. "февраль 2020 г. - март 2020 г." не является началом предложения.
//
// Параметры:
//  ДатаНачала - Дата - начало периода.
//  ДатаОкончания - Дата - конец периода.
//  ФорматнаяСтрока - Строка - определяет способ форматирования периода.
//  СЗаглавнойБуквы - Булево - Истина, если с представления периода начинается предложение.
//                    По умолчанию - Ложь.
//
// Возвращаемое значение:
//   Строка - представление периода в требуемом формате и регистре.
//
Функция ПредставлениеПериодаВТексте(ДатаНачала, ДатаОкончания, ФорматнаяСтрока = "", СЗаглавнойБуквы = Ложь) Экспорт 
	
	Возврат ОбщегоНазначенияСлужебныйКлиентСервер.ПредставлениеПериодаВТексте(
		ДатаНачала, ДатаОкончания, ФорматнаяСтрока, СЗаглавнойБуквы);
	
КонецФункции

#КонецОбласти

