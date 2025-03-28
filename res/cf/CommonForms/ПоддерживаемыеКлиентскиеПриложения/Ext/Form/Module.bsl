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
	
	Если ТипЗнч(Параметры.ПоддерживаемыеКлиенты) = Тип("Структура") Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПоддерживаемыеКлиенты);
	КонецЕсли;
	
	Доступна = БиблиотекаКартинок.ВнешняяКомпонентаДоступна;
	НеДоступна = БиблиотекаКартинок.ВнешняяКомпонентаНеДоступна;
	
	Элементы.Windows_x86_1СПредприятие.Картинка = ?(Windows_x86, Доступна, НеДоступна);
	Элементы.Windows_x86_Chrome.Картинка = ?(Windows_x86_Chrome, Доступна, НеДоступна);
	Элементы.Windows_x86_Firefox.Картинка = ?(Windows_x86_Firefox, Доступна, НеДоступна);
	Элементы.Windows_x86_MSIE.Картинка = ?(Windows_x86_MSIE, Доступна, НеДоступна);
	Элементы.Windows_x86_64_1СПредприятие.Картинка = ?(Windows_x86_64, Доступна, НеДоступна);
	Элементы.Windows_x86_64_Chrome.Картинка = ?(Windows_x86_Chrome, Доступна, НеДоступна);
	Элементы.Windows_x86_64_Firefox.Картинка = ?(Windows_x86_Firefox, Доступна, НеДоступна);
	Элементы.Windows_x86_64_MSIE.Картинка = ?(Windows_x86_64_MSIE, Доступна, НеДоступна);
	Элементы.Linux_x86_1СПредприятие.Картинка = ?(Linux_x86, Доступна, НеДоступна);
	Элементы.Linux_x86_Chrome.Картинка = ?(Linux_x86_Chrome, Доступна, НеДоступна);
	Элементы.Linux_x86_Firefox.Картинка = ?(Linux_x86_Firefox, Доступна, НеДоступна);
	Элементы.Linux_x86_64_1СПредприятие.Картинка = ?(Linux_x86_64, Доступна, НеДоступна);
	Элементы.Linux_x86_64_Chrome.Картинка = ?(Linux_x86_64_Chrome, Доступна, НеДоступна);
	Элементы.Linux_x86_64_Firefox.Картинка = ?(Linux_x86_64_Firefox, Доступна, НеДоступна);
	Элементы.MacOS_x86_64_1СПредприятие.Картинка = ?(MacOS_x86_64, Доступна, НеДоступна);
	Элементы.MacOS_x86_64_Safari.Картинка = ?(MacOS_x86_64_Safari, Доступна, НеДоступна);
	Элементы.MacOS_x86_64_Chrome.Картинка = ?(MacOS_x86_64_Chrome, Доступна, НеДоступна);
	Элементы.MacOS_x86_64_Firefox.Картинка = ?(MacOS_x86_64_Firefox, Доступна, НеДоступна);
	
КонецПроцедуры

#КонецОбласти