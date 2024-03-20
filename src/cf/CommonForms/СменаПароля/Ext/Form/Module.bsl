﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриВходеВПрограмму        = Параметры.ПриВходеВПрограмму;
	ВернутьПарольБезУстановки = Параметры.ВернутьПарольБезУстановки;
	СтарыйПароль              = Параметры.СтарыйПароль;
	ИмяДляВхода               = Параметры.ИмяДляВхода;
	
	Если ВернутьПарольБезУстановки Или ЗначениеЗаполнено(Параметры.Пользователь) Тогда
		Пользователь = Параметры.Пользователь;
	Иначе
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	Если Не ВернутьПарольБезУстановки Тогда
		ДополнительныеПараметры.Вставить("ПроверятьДействительностьПользователя");
		ДополнительныеПараметры.Вставить("ПроверятьНаличиеПользователяИБ");
	КонецЕсли;
	Если Не ПользователиСлужебный.ВозможноИзменитьПароль(Пользователь, ДополнительныеПараметры) Тогда
		ТекстОшибки = ДополнительныеПараметры.ТекстОшибки;
		Возврат;
	КонецЕсли;
	ЭтоТекущийПользовательИБ = ДополнительныеПараметры.ЭтоТекущийПользовательИБ;
	ПарольУстановлен         = ДополнительныеПараметры.ПарольУстановлен;
	Если Не ЗначениеЗаполнено(ИмяДляВхода) Тогда
		ИмяДляВхода = ДополнительныеПараметры.ИмяДляВхода;
	КонецЕсли;
	
	Если Не ВернутьПарольБезУстановки Тогда
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Пользователь, , УникальныйИдентификатор);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если Не ПриВходеВПрограмму Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось открыть форму смены пароля по причине:
					           |
					           |%1'"),
					ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				Возврат;
			КонецЕсли;
		КонецПопытки;
	КонецЕсли;
	
	Если Не ПриВходеВПрограмму Тогда
		Элементы.ПояснениеПриВходе.Видимость = Ложь;
		Элементы.ФормаЗакрытьФорму.Заголовок = НСтр("ru = 'Отмена'");
		
	ИначеЕсли Не ПарольУстановлен Тогда
		Элементы.ПояснениеПриВходе.Заголовок =
			НСтр("ru = 'Для входа в программу установите пароль.'")
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	Если Не ЭтоТекущийПользовательИБ
	 Или Не ПарольУстановлен Тогда
		
		Элементы.СтарыйПароль.Видимость = Ложь;
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Установка пароля'");
		
	ИначеЕсли Параметры.СтарыйПароль <> Неопределено Тогда
		ТекущийЭлемент = Элементы.НовыйПароль;
	
	ИначеЕсли ПриВходеВПрограмму
	        И ЭтоТекущийПользовательИБ
	        И Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		Элементы.СтарыйПароль.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.НовыйПароль.Подсказка  = ПользователиСлужебный.ПодсказкаДляНовогоПароля();
	Элементы.НовыйПароль2.Подсказка = ПользователиСлужебный.ПодсказкаДляНовогоПароля();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ПоказатьТекстОшибкиИСообщитьОЗакрытии", 0.1, Истина);
	Иначе
		ПроверитьПодтверждениеПароля();
		ОбновитьОбработчикОжиданияПоказатьСтарыйПароль();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПроверитьПодтверждениеПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ПроверитьПодтверждениеПароля(Элемент);
	ОбновитьОбработчикОжиданияПоказатьСтарыйПароль();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНовыйПарольПриИзменении(Элемент)
	
	ПоказыватьНовыйПарольПриИзмененииНаСервере();
	ПроверитьПодтверждениеПароля();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПароль(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДляВнешнегоПользователя",
		ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи"));
	
	ОткрытьФорму("ОбщаяФорма.НовыйПароль", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	Если Не ПоказыватьНовыйПароль И НовыйПароль <> Подтверждение Тогда
		ТекущийЭлемент = Элементы.Подтверждение;
		Элементы.Подтверждение.ВыделенныйТекст = Элементы.Подтверждение.ТекстРедактирования;
		ПоказатьПредупреждение(, НСтр("ru = 'Подтверждение пароля указано некорректно.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ВернутьПарольБезУстановки
	   И Не ЭтоТекущийПользовательИБ
	   И ОбщегоНазначенияКлиент.РазделениеВключено()
	   И ПарольПользователяСервиса = Неопределено Тогда
		
		ПользователиСлужебныйКлиент.ЗапроситьПарольДляАутентификацииВСервисе(
			Новый ОписаниеОповещения("УстановитьПарольЗавершение", ЭтотОбъект),
			ЭтотОбъект,
			ПарольПользователяСервиса);
	Иначе
		УстановитьПарольЗавершение(Null, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОбработчикОжиданияПоказатьСтарыйПароль()
	
	Если ПриВходеВПрограмму
	   И ЭтоТекущийПользовательИБ
	   И ПарольУстановлен
	   И Не Элементы.СтарыйПароль.Видимость Тогда
		
		ОтключитьОбработчикОжидания("ПоказатьСтарыйПарольОбработчикОжидания");
		ПодключитьОбработчикОжидания("ПоказатьСтарыйПарольОбработчикОжидания", 60, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтарыйПарольОбработчикОжидания()
	
	Элементы.СтарыйПароль.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТекстОшибкиИСообщитьОЗакрытии()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	ПоказатьПредупреждение(Новый ОписаниеОповещения(
		"ПоказатьТекстОшибкиИСообщитьОЗакрытииЗавершение", ЭтотОбъект), ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТекстОшибкиИСообщитьОЗакрытииЗавершение(Контекст) Экспорт
	
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии);
		ОписаниеОповещенияОЗакрытии = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодтверждениеПароля(ПолеПароля = Неопределено)
	
	Если ПоказыватьНовыйПароль Тогда
		ПарольСовпадает = Истина;
	
	ИначеЕсли ПолеПароля = Элементы.НовыйПароль
	      Или ПолеПароля = Элементы.НовыйПароль2 Тогда
		
		ПарольСовпадает = (ПолеПароля.ТекстРедактирования = Подтверждение);
		
	ИначеЕсли ПолеПароля = Элементы.Подтверждение Тогда
		ПарольСовпадает = (НовыйПароль = ПолеПароля.ТекстРедактирования);
	Иначе
		ПарольСовпадает = (НовыйПароль = Подтверждение);
	КонецЕсли;
	
	Элементы.НадписьПарольНеСовпадает.Видимость = Не ПарольСовпадает;
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьНовыйПарольПриИзмененииНаСервере()
	
	Элементы.Подтверждение.Доступность = Не ПоказыватьНовыйПароль;
	
	Элементы.НовыйПароль.Видимость  = Не ПоказыватьНовыйПароль;
	Элементы.НовыйПароль2.Видимость =    ПоказыватьНовыйПароль;
	
	Если ПоказыватьНовыйПароль Тогда
		Подтверждение = "";
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УстановитьПароль.
&НаКлиенте
Процедура УстановитьПарольЗавершение(НовыйПарольПользователяСервиса, Контекст) Экспорт
	
	Если НовыйПарольПользователяСервиса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыйПарольПользователяСервиса <> Null Тогда
		ПарольПользователяСервиса = НовыйПарольПользователяСервиса;
	КонецЕсли;
	
	ТекстОшибки = УстановитьПарольНаСервере();
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		Элементы.ФормаУстановитьПароль.Доступность = Ложь;
		ПодключитьОбработчикОжидания("ВернутьРезультатИЗакрытьФорму", 0.1, Истина);
	Иначе
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьПарольНаСервере()
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Пользователь",              Пользователь);
	ПараметрыВыполнения.Вставить("ИмяДляВхода",               ИмяДляВхода);
	ПараметрыВыполнения.Вставить("НовыйПароль",               НовыйПароль);
	ПараметрыВыполнения.Вставить("СтарыйПароль",              СтарыйПароль);
	ПараметрыВыполнения.Вставить("ПриВходеВПрограмму",        ПриВходеВПрограмму);
	ПараметрыВыполнения.Вставить("ПарольПользователяСервиса", ПарольПользователяСервиса);
	ПараметрыВыполнения.Вставить("ТолькоПроверить",           ВернутьПарольБезУстановки);
	
	Если Не ОбщегоНазначения.РазделениеВключено()
	   И Не Элементы.СтарыйПароль.Видимость Тогда
		ПараметрыВыполнения.СтарыйПароль = Неопределено;
	КонецЕсли;
	
	Попытка
		ТекстОшибки = ПользователиСлужебный.ОбработатьНовыйПароль(ПараметрыВыполнения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если ПараметрыВыполнения.Свойство("ОшибкаЗаписанаВЖурналРегистрации") Тогда
			ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПараметрыВыполнения.СтарыйПарольСовпадает Тогда
		ТекущийЭлемент = Элементы.СтарыйПароль;
		СтарыйПароль = "";
	КонецЕсли;
	
	ПарольПользователяСервиса = ПараметрыВыполнения.ПарольПользователяСервиса;
	
	Возврат ТекстОшибки;
	
КонецФункции

&НаКлиенте
Процедура ВернутьРезультатИЗакрытьФорму()
	
	Результат = Новый Структура;
	Если ВернутьПарольБезУстановки Тогда
		Результат.Вставить("НовыйПароль",  НовыйПароль);
		Результат.Вставить("СтарыйПароль", ?(Элементы.СтарыйПароль.Видимость, СтарыйПароль, Неопределено));
	Иначе
		Результат.Вставить("УстановленПустойПароль", НовыйПароль = "");
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
