﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает отчет по версиям объекта в режиме сравнения версий.
//
// Параметры:
//  Ссылка                       - ЛюбаяСсылка - ссылка на версионируемый объект;
//  АдресСериализованногоОбъекта - Строка - адрес двоичных данных сравниваемой версии
//                                          объекта во временном хранилище.
//
Процедура ОткрытьОтчетПоИзменениям(Ссылка, АдресСериализованногоОбъекта) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ссылка", Ссылка);
	Параметры.Вставить("АдресСериализованногоОбъекта", АдресСериализованногоОбъекта);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", Параметры);
	
КонецПроцедуры

// Показывает сохраненную версию объекта.
//
// Параметры:
//  Ссылка                       - ЛюбаяСсылка - ссылка на версионируемый объект;
//  АдресСериализованногоОбъекта - Строка - адрес двоичных данных версии объекта во временном хранилище.
//
Процедура ОткрытьОтчетПоВерсииОбъекта(Ссылка, АдресСериализованногоОбъекта) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ссылка", Ссылка);
	Параметры.Вставить("АдресСериализованногоОбъекта", АдресСериализованногоОбъекта);
	Параметры.Вставить("ПоВерсии", Истина);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", Параметры);
	
КонецПроцедуры

// Обработчик события ОбработкаОповещения для формы, на которой требуется отобразить флажок хранения истории изменения.
//
// Параметры:
//   ИмяСобытия - Строка - имя события, которое было получено обработчиком события на форме.
//   ХранитьИсториюИзменений - Число - реквизит, в который будет помещено значение.
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
//		МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
//		МодульВерсионированиеОбъектовКлиент.ОбработкаОповещенияИзмененияФлажкаХранитьИсторию(
//			ИмяСобытия, 
//			ХранитьИсториюИзменений);
//	КонецЕсли;
//
Процедура ОбработкаОповещенияИзмененияФлажкаХранитьИсторию(Знач ИмяСобытия, ХранитьИсториюИзменений) Экспорт
	
	Если ИмяСобытия = "ИзменилсяРежимХраненияИсторииИзменений" Тогда
		ХранитьИсториюИзменений = ВерсионированиеОбъектовСлужебныйВызовСервера.ЗначениеФлажкаХранитьИсторию();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриИзменении для флажка, выполняющего переключение режима хранения истории изменений.
// Флажок должен быть связан с реквизитом типа Булево.
// 
// Параметры:
//   ЗначениеФлажкаХранитьИсториюИзменений - Булево - новое значение флажка, которое требуется обработать.
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
//		МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
//		МодульВерсионированиеОбъектовКлиент.ПриИзмененииФлажкаХранитьИсторию(ХранитьИсториюИзменений);
//	КонецЕсли;
//
Процедура ПриИзмененииФлажкаХранитьИсторию(ЗначениеФлажкаХранитьИсториюИзменений) Экспорт
	
	ВерсионированиеОбъектовСлужебныйВызовСервера.УстановитьРежимХраненияИсторииИзменений(
		ЗначениеФлажкаХранитьИсториюИзменений);
	
	Оповестить("ИзменилсяРежимХраненияИсторииИзменений");
	
КонецПроцедуры

// Открывает форму управления версионированием объектов.
// Не забудьте команду, выполняющую вызов процедуры, 
// установить зависимой от функциональной опции ИспользоватьВерсионированиеОбъектов.
//
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
//		МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
//		МодульВерсионированиеОбъектовКлиент.ПоказатьНастройку();
//	КонецЕсли;
//
Процедура ПоказатьНастройку() Экспорт
	
	ОткрытьФорму("РегистрСведений.НастройкиВерсионированияОбъектов.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает отчет о версии или о сравнении версий.
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - ссылка на объект;
//  СравниваемыеВерсии - Массив - коллекция сравниваемых версий. Если версия одна, то открывается отчет о версии.
//
Процедура ОткрытьОтчетСравненияВерсий(Ссылка, СравниваемыеВерсии) Экспорт
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка", Ссылка);
	ПараметрыОтчета.Вставить("СравниваемыеВерсии", СравниваемыеВерсии);
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

// Открывает список версий объекта.
//
// Параметры:
//  Ссылка        - ЛюбаяСсылка - версионируемый объект;
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма, из которой открывается история изменений.
//
Процедура ПоказатьИсториюИзменений(Ссылка, ФормаВладелец) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ссылка", Ссылка);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", ФормаВладелец.ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборХранимыхВерсий", ПараметрыОткрытия, ФормаВладелец);
	
КонецПроцедуры

#КонецОбласти
