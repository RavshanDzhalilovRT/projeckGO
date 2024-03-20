﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записывает версию объекта (кроме документов) в информационную базу.
//
// Параметры:
//  Источник - СправочникОбъект - записываемый объект ИБ;
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ЗаписатьВерсиюОбъекта(Источник, Отказ) Экспорт
	
	// Безусловная проверка на ОбменДанными.Загрузка не требуется, т.к. в момент записи
	// версионируемого объекта при обмене необходимо сохранить его текущую версию в истории версий.
	Если Источник.ОбменДанными.Загрузка И Источник.ОбменДанными.Отправитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(Источник, Ложь);
	
КонецПроцедуры

// Записывает версию документа в информационную базу.
//
// Параметры:
//  Источник        - ДокументОбъект - записываемый документ ИБ;
//  Отказ           - Булево - признак отказа от записи документа.
//  РежимЗаписи     - РежимЗаписиДокумента - позволяет определить выполняется запись, проведение или отмена проведения.
//                                           Изменение значения параметра позволяет изменить режим записи.
//  РежимПроведения - РежимПроведенияДокумента - позволяет определить, выполняется оперативное проведение или нет.
//                                               Изменение значения параметра позволяет изменить режим проведения.
//
Процедура ЗаписатьВерсиюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// Безусловная проверка на ОбменДанными.Загрузка не требуется, т.к. в момент записи
	// версионируемого объекта при обмене необходимо сохранить его текущую версию в истории версий.
	Если Источник.ОбменДанными.Загрузка И Источник.ОбменДанными.Отправитель = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(Источник, РежимЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Только для внутреннего использования.
//
Процедура УдалитьИнформациюОбАвтореВерсии(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ВерсииОбъектов.УдалитьИнформациюОбАвтореВерсии(Источник.Ссылка);
	
КонецПроцедуры

#КонецОбласти
