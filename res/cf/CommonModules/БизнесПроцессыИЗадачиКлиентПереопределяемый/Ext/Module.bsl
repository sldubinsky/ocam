﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при открытии формы выбор исполнителя.
// Позволяет переопределить стандартную форму выбора.
//
// Параметры:
//  ЭлементИсполнитель   - ПолеФормы - элемент формы, в которой выбирается исполнитель.
//  РеквизитИсполнитель  - СправочникСсылка.Пользователи - выбранный ранее исполнитель.
//                         Используется для установки текущей строки в форме выбора исполнителя.
//  ТолькоПростыеРоли    - Булево - если Истина, то указывает что для выбора нужно
//                         использовать только роли без объектов адресации.
//  БезВнешнихРолей      - Булево - если Истина, то указывает, что для выбора надо использовать только роли,
//                         у которых не установлен признак ВнешняяРоль.
//  СтандартнаяОбработка - Булево - если Ложь, то не требуется выводить стандартную форму выбора исполнителя.
//
Процедура ПриВыбореИсполнителя(ЭлементИсполнитель, РеквизитИсполнитель, ТолькоПростыеРоли,
	БезВнешнихРолей, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
