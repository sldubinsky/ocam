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
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выполнения операции.'");
	КонецЕсли;
	
	Если Не ПользователиСлужебныйПовтИсп.ВерсияПредприятияПоддерживаетВосстановлениеПаролей() Тогда
		ВызватьИсключение НСтр("ru = 'Восстановление паролей пользователей не поддерживается.
			|Обновите версию платформы 1С: Предприятие.'");
	КонецЕсли;
	
	ПрочитьНастройкиВосстановленияПароля();
	
	Если ОтображатьГиперссылкуПомощи И ПустаяСтрока(НавигационнаяСсылкаПомощи) Тогда
		Элементы.НавигационнаяСсылкаПомощи.ОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		УчетнаяЗаписьПочты                      = Неопределено;
		Элементы.ГруппаНастройкиПочты.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		Элементы.ГруппаНастройкиПочты.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантВосстановленияПароляПриИзменении(Элемент)
	
	Если ВариантВосстановленияПароля = "ЧерезЭлектроннуюПочту" Тогда
		Элементы.ВариантыВосстановления.ТекущаяСтраница = Элементы.ЭлектроннаяПочта;
	Иначе
		Элементы.ВариантыВосстановления.ТекущаяСтраница = Элементы.ПереходПоСсылке;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстанавливатьПарольПриИзменении(Элемент)
	
	Если ВосстанавливатьПароль Тогда
		Элементы.ВариантВосстановленияПароля.Доступность = Истина;
		Элементы.ВариантыВосстановления.Доступность      = Истина;
	Иначе
		Элементы.ВариантВосстановленияПароля.Доступность = Ложь;
		Элементы.ВариантыВосстановления.Доступность      = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НужнаПомощьПриИзменении(Элемент)
	
	Элементы.НавигационнаяСсылкаПомощи.Доступность = ОтображатьГиперссылкуПомощи;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиПоПочтеПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиПоНастройкеПочтыПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиСтандартныйСервисПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ШифрованиеПриПолученииПочтыПриИзменении(Элемент)
	
	Если ШифрованиеПриОтправкеПочты = "Авто" Тогда
		ПортSMTP = 25;
	Иначе
		ПортSMTP = 465
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НастройкиВосстановленияПароляКорректные() Тогда
		СохранитьНастройкиВосстановленияПароля();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если НастройкиВосстановленияПароляКорректные() Тогда
		СохранитьНастройкиВосстановленияПароля();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылкаПомощиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаПомощи);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПодтверждения(Команда)
	
	ВставитьПараметрВШаблон("&VerificationCode");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрИмяПользователя(Команда)
	
	ВставитьПараметрВШаблон("&UserPresentation");
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКонфигурации(Команда)
	
	ВставитьПараметрВШаблон("&ApplicationPresentation");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	
	Если НастройкиВосстановленияПароляКорректные() Тогда
		СохранитьНастройкиВосстановленияПароля();
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	Флаг = ВариантОтправкиПоПочте = "РучнаяНастройка";
	Элементы.ГруппаСерверSMTP.Доступность       = Флаг;
	Элементы.ГруппаПользовательSMTP.Доступность = Флаг;
	Элементы.ИмяОтправителя.Доступность         = Флаг;
	
	Если Флаг Тогда
		Элементы.ГруппаРучныеНастройкиПочты.Показать();	
	КонецЕсли;
	
	Флаг = ВариантОтправкиПоПочте <> "СтандартныйСервис";
	Элементы.ТемаПисьма.Доступность                            = Флаг;
	Элементы.ГруппаКнопкиФорматированногоДокумента.Доступность = Флаг;
	Элементы.ТекстСообщения.Доступность                        = Флаг;
	
	Если Флаг Тогда
		Элементы.ГруппаТекстСообщения.Показать();
	Иначе
		Элементы.ГруппаТекстСообщения.Скрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НастройкиВосстановленияПароляКорректные()
	
	ОчиститьСообщения();
	
	НастройкиКорректные = Истина;
	
	Если ОтображатьГиперссылкуПомощи И ПустаяСтрока(НавигационнаяСсылкаПомощи) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен адрес страницы помощи'"),,
					"НавигационнаяСсылкаПомощи");
		НастройкиКорректные = Ложь;
		
	КонецЕсли;
	
	Если ВариантВосстановленияПароля <> "ЧерезЭлектроннуюПочту" Тогда
		
		Если ПустаяСтрока(НавигационнаяСсылкаВосстановленияПароля) Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен адрес страницы восстановления пароля'"),,
					"НавигационнаяСсылкаВосстановленияПароля");
				НастройкиКорректные = Ложь;
				
		КонецЕсли;
		
		Возврат НастройкиКорректные;
		
	КонецЕсли;
	
	Если ВариантОтправкиПоПочте = "ВнешнийПочтовыйСервер" Тогда
		
		Если Не ЗначениеЗаполнено(УчетнаяЗаписьПочты) Тогда
		
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнены настройки почты'"),,
				"УчетнаяЗаписьПочты");
			НастройкиКорректные = Ложь;
			
		ИначеЕсли Не УчетнаяЗаписьНастроена(УчетнаяЗаписьПочты) Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Почта не настроена для отправки писем'"),,
				"УчетнаяЗаписьПочты");
			НастройкиКорректные = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли ВариантОтправкиПоПочте = "РучнаяНастройка" Тогда
		
		Если ПустаяСтрока(АдресСервераSMTP) Тогда
		
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен адрес сервера SMTP'"),,
				"АдресСервераSMTP");
			НастройкиКорректные = Ложь;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ПользовательSMTP) Тогда
		
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен пользователь SMTP'"),,
				"ПользовательSMTP");
			НастройкиКорректные = Ложь;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ПарольSMTP) Тогда
		
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен пароль SMTP'"),,
				"ПарольSMTP");
			НастройкиКорректные = Ложь;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ИмяОтправителя) Тогда
		
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнено имя отправителя'"),,
				"ИмяОтправителя");
			НастройкиКорректные = Ложь;
			
		КонецЕсли;

		
	КонецЕсли;
	
	Возврат НастройкиКорректные;
	
КонецФункции

&НаСервереБезКонтекста
Функция УчетнаяЗаписьНастроена(УчетнаяЗапись)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		Возврат МодульРаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(УчетнаяЗапись, Истина, Ложь);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ВставитьПараметрВШаблон(ИмяПараметра)
	
	Если ТекущийЭлемент.Имя = Элементы.ТемаПисьма.Имя Тогда
		ТемаПисьма = ТемаПисьма + " " + ИмяПараметра;
	Иначе
		ЗакладкаДляВставкиНачало = Неопределено;
		ЗакладкаДляВставкиКонец  = Неопределено;
		Элементы.ТекстСообщения.ПолучитьГраницыВыделения(ЗакладкаДляВставкиНачало, ЗакладкаДляВставкиКонец);
		ТекстСообщения.Вставить(ЗакладкаДляВставкиКонец, ИмяПараметра);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновоеЗаполнениеПочтыПользователей()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение почты пользователей для восстановления пароля'");
	
	ДлительныеОперации.ВыполнитьВФоне("ПользователиСлужебный.ЗаполнитьПочтуДляВосстановленияПароляУПользователейВФоне",
		Новый Структура, ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Функция ТребуетсяЗапускЗаполненияПочтыПользователей()
	
	Если Не ПользователиСлужебныйПовтИсп.ВерсияПредприятияПоддерживаетВосстановлениеПаролей() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ВосстанавливатьПароль Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Настройки = ПользователиСлужебный.НастройкиВосстановленияПароля();
	Если Настройки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Предыдущие значение
	Если Настройки.СпособВосстановленияПароля <> ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("Нет") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		Если ПользовательИБ.ЗапрещеноВосстанавливатьПароль = Ложь Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиВосстановленияПароля()
	
	ЗапуститьФоновоеЗаполнениеПочтыПользователей = ТребуетсяЗапускЗаполненияПочтыПользователей();
	
	Если ПарольИзменен Тогда
		ТекущийПарольSMTP = ПарольSMTP;
	Иначе
		ТекущиеНастройки = ПользователиСлужебный.НастройкиВосстановленияПароля();
		Если ТекущиеНастройки <> Неопределено Тогда
			ТекущийПарольSMTP = ТекущиеНастройки.ПарольSMTP;
		Иначе
			ТекущийПарольSMTP = "";
		КонецЕсли;
	КонецЕсли;
	
	Вложения = Новый Структура;
	ТекстСообщения.ПолучитьHTML(ТекстСообщенияHTML, Вложения);
	
	Для каждого Вложение Из Вложения Цикл
		
		ФорматИзображения = ?(Вложение.Значение.Формат() <> ФорматКартинки.НеизвестныйФормат,
			НРег(Вложение.Значение.Формат()), НРег(ФорматКартинки.PNG));
			
		ТекстКартинки = "src=""data:image/" + ФорматИзображения + ";base64," + Base64Строка(Вложение.Значение.ПолучитьДвоичныеДанные()) + """";
		ТекстСообщенияHTML = СтрЗаменить(ТекстСообщенияHTML,
			"src=""" + Вложение.Ключ + """", 
			ТекстКартинки);
			
	КонецЦикла;
	
	Настройки = ПользователиСлужебный.НовыеНастройкиВосстановленияПароля();
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект, СписокПолейНастроек());
	
	Настройки.Заголовок  = ТемаПисьма;
	Настройки.ПарольSMTP = ТекущийПарольSMTP;
	
	Если ВосстанавливатьПароль Тогда
		
		Если ВариантВосстановленияПароля = "ПереходПоСсылке" Тогда
			Настройки.СпособВосстановленияПароля = 
				ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ПереходПоНавигационнойСсылке");
		ИначеЕсли ВариантОтправкиПоПочте = "СтандартныйСервис" Тогда
			Настройки.СпособВосстановленияПароля = 
				ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияЧерезСтандартныйСервис");
		ИначеЕсли ВариантОтправкиПоПочте = "ВнешнийПочтовыйСервер" Тогда
			Настройки.СпособВосстановленияПароля = 
				ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияПоЗаданнымПараметрам");
			
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
				
				МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
				НастройкиУчетнойЗаписиДляОтправкиПочта = МодульРаботаСПочтовымиСообщениямиСлужебный.НастройкиУчетнойЗаписиДляОтправкиПочта(УчетнаяЗаписьПочты);
				ЗаполнитьЗначенияСвойств(Настройки, НастройкиУчетнойЗаписиДляОтправкиПочта);
				
			КонецЕсли;
			
		Иначе
			
			Настройки.СпособВосстановленияПароля = 
				ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияПоЗаданнымПараметрам");
			ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект, "АдресСервераSMTP, ПарольSMTP, ПользовательSMTP, ПортSMTP,ИмяОтправителя");
			Настройки.ИспользоватьSSL = ШифрованиеПриОтправкеПочты = "SSL";
			
		КонецЕсли;
	Иначе
		Настройки.СпособВосстановленияПароля = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("Нет");
	КонецЕсли;
	
	УстановитьУчетнуюЗаписьДляВосстановленияПароля(УчетнаяЗаписьПочты, ВариантОтправкиПоПочте = "ВнешнийПочтовыйСервер");
	ПользователиСлужебный.УстановитьНастройкиВосстановленияПароля(Настройки);
	
	Если ЗапуститьФоновоеЗаполнениеПочтыПользователей Тогда
		ЗапуститьФоновоеЗаполнениеПочтыПользователей();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитьНастройкиВосстановленияПароля()
	
	ВариантОтправкиПоПочте      = "СтандартныйСервис";
	ВариантВосстановленияПароля = "ЧерезЭлектроннуюПочту";
	
	СведенияОбУчетнойЗаписи = НастройкиУчетнойЗаписиДляВосстановленияПароля();
	
	Если ТипЗнч(СведенияОбУчетнойЗаписи) = Тип("Структура") Тогда
		УчетнаяЗаписьПочты = СведенияОбУчетнойЗаписи.УчетнаяЗаписьПочты;
	КонецЕсли;
	
	Настройки = ПользователиСлужебный.НастройкиВосстановленияПароля();
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки, СписокПолейНастроек());
	
	Если ЗначениеЗаполнено(Настройки.ПарольSMTP) Тогда
		ПарольSMTP = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	ШифрованиеПриОтправкеПочты = ?(Настройки.ИспользоватьSSL, "SSL", "Авто");
	
	Если ПустаяСтрока(ТекстСообщенияHTML) Тогда
		ТекстСообщенияHTML = ТекстПоУмолчанию();
	КонецЕсли;
	ТекстСообщения.УстановитьHTML(ТекстСообщенияHTML, Новый Структура);
	
	ТемаПисьма = ?(ЗначениеЗаполнено(Настройки.Заголовок),
		Настройки.Заголовок, НСтр("ru='Восстановление пароля'"));
	
	Если Настройки.СпособВосстановленияПароля = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("Нет") Тогда
		ВосстанавливатьПароль = Ложь;
		
	Иначе
		ВосстанавливатьПароль = Истина;
		Если Настройки.СпособВосстановленияПароля = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияЧерезСтандартныйСервис") Тогда
			ВариантОтправкиПоПочте = "СтандартныйСервис";
		Иначе
			Если Настройки.СпособВосстановленияПароля = 
					ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияПоЗаданнымПараметрам") Тогда
				Элементы.ВариантыВосстановления.ТекущаяСтраница = Элементы.ЭлектроннаяПочта;
				ВариантВосстановленияПароля = "ЧерезЭлектроннуюПочту";
				Если СведенияОбУчетнойЗаписи.Используется Тогда
					ВариантОтправкиПоПочте = "ВнешнийПочтовыйСервер";
				Иначе
					ВариантОтправкиПоПочте = "РучнаяНастройка";
					Элементы.ГруппаРучныеНастройкиПочты.Показать();
				КонецЕсли;
			Иначе
				Элементы.ВариантыВосстановления.ТекущаяСтраница = Элементы.ПереходПоСсылке;
				ВариантВосстановленияПароля = "ПереходПоСсылке";
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокПолейНастроек()
	
	Возврат "ДлительностьБлокировкиЗапросаОбновленияКодаПодтверждения,
	|МаксимальноеКоличествоНеуспешныхПопытокПроверкиКодаПодтверждения,НавигационнаяСсылкаВосстановленияПароля,
	|ОтображатьГиперссылкуПомощи,НавигационнаяСсылкаПомощи,ДлинаКодаПодтверждения,ТекстСообщенияHTML,
	|АдресСервераSMTP,ПортSMTP,ИспользоватьSSL,ПользовательSMTP,ИмяОтправителя";
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстПоУмолчанию()
	
	ШаблонСообщенияHTML = НСтр("ru='Здравствуйте, %1
	|
	|Мы получили запрос на восстановление пароля от %2.
	|
	|Введите код %3 для сброса пароля.
	|
	|Если восстановление пароля не запрашивалось, сообщите об этом техническому специалисту.'");
	
	ТекстСообщенияHTML = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщенияHTML,
		"&UserPresentation", "&ApplicationPresentation", "&VerificationCode");
	
	Возврат ТекстСообщенияHTML;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьУчетнуюЗаписьДляВосстановленияПароля(УчетнаяЗаписьПочты, Используется)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		
		МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
		
		СведенияОбУчетнойЗаписи = МодульРаботаСПочтовымиСообщениямиСлужебный.ОписаниеНастроекУчетнойЗаписиДляВосстановленияПароля();
		СведенияОбУчетнойЗаписи.УчетнаяЗаписьПочты = УчетнаяЗаписьПочты;
		СведенияОбУчетнойЗаписи.Используется       = Используется;
		
		МодульРаботаСПочтовымиСообщениямиСлужебный.СохранитьНастройкиУчетнойЗаписиДляВосстановленияПароля(СведенияОбУчетнойЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиУчетнойЗаписиДляВосстановленияПароля()
	
	СведенияОбУчетнойЗаписи = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
		СведенияОбУчетнойЗаписи = МодульРаботаСПочтовымиСообщениямиСлужебный.НастройкиУчетнойЗаписиДляВосстановленияПароля();
	КонецЕсли;
	
	Возврат СведенияОбУчетнойЗаписи;
	
КонецФункции

#КонецОбласти