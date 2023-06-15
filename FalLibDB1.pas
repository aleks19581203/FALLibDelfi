unit FalLibDB1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;
  function FalPack ( Table :TTable ;  // входная база
                    NameTable :  PChar ; // имя базы можно взять из свойств
                    Query1 :TQuery) : integer;  // пустой запрос
  function CreateDBF1 (namedbf : string ;  // имя создаваемой dbf - базы
                      namestolb : string ; // имя столбца
                      tipstolb : string ;  // тип столбца N C D
                      lenstolb : integer ; // длина столбца
                      lenznak : integer    // количество десятичных знаков
                      ) : boolean;
  function FALInsertRecord (namedbf : string ;  // имя dbf - базы куда пишем
                            pole : string;      // поля куда пишем в строковом виде
                            value : string      // значения соответсвенно
                            ) : boolean  ;
implementation

var
  Query3 : TQuery;
// --- Функция упаковки  базы
// упаковка базы оплат
// FalPack (TableOPLAT,'oplat.dbf',Query1);

function FalPack ( Table :TTable ;  // входная база
                   NameTable : PChar ; // имя базы можно взять из свойств
                   Query1 :TQuery) : integer;  // пустой запрос
begin
  //ShowMessage('ВОШЛИ В FALPACK');
  // упаковка базы
  // Действия с базой данных
  Table.Close;  // базу оплат закрыть
  // упаковка базы оплат
  // копируем базу не упакованную
  CopyFile(NameTable,'FAL_0001.dbf',false);
  //ShowMessage('Скопировали');
  // чистим базу физически
  Table.Exclusive := True ;
  Table.EmptyTable ;
  Table.Exclusive := False ;
  // копируем в базу с упаковкой
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('INSERT INTO '+Table.TableName);
  Query1.SQL.Add('SELECT *' );
  Query1.SQL.Add('FROM FAL_0001.DBF' );
  Query1.ExecSQL;
  // удаляем рабочий файл
  DeleteFile('FAL_0001.dbf');
  Table.Open;  // базу оплат открыть
  FalPack := 1 ; // все выполнено 
end ; // функции упаковки

// Функция создает базу данных DBF путем добавления столбцов. При каждом
// обращении к функции к базе добавляется 1 столбец. TRUE - если все хорошо
// FALSE - если не все хорошо.
//CreateDBF1 ('fff.dbf','oklad','N',10,2) - пример обращения ;

function CreateDBF1 ( namedbf : string ;   // имя создаваемой dbf - базы
                      namestolb : string ; // имя столбца
                      tipstolb : string ;  // тип столбца N C D
                      lenstolb : integer ; // длина столбца
                      lenznak : integer    // количество десятичных знаков
                      ) : boolean;
                      // 1 ошибка - не тот символ N C D
                      // 2 ошибка - поле с одинаковым именем
                      // 3 Внимание - временные файлы пока форму не уничтожишь
                      //              Похоже это другие открытые Query.Проверить на
                      //              формах без других Query
                      // 4 Ошибка - при 'D' поле не может иметь имени DATA
                      // 5 Ошибка - baza.dbf - полное имя с расширением должно быть
var
   Exists : boolean ; // Существует ли  файл ?

begin
   //ShowMessage('ВОШЛИ');
   CreateDBF1 := false ;  // пока ничего не сделали
   Query3 := TQuery.Create(Application);  //Создаем Query - собственник App..
   Exists := FileExists(namedbf);
   if  not Exists  // если НЕ существует  БАЗА namedbf
   then
     //Создаем пустой столбец
     begin
       //ShowMessage('Пишем пустой столбец');
       Query3.SQL.Clear;
       Query3.SQL.Add('CREATE TABLE "'+namedbf + '"');
       Query3.SQL.Add('(RABFAL11 CHAR(2))');
       Query3.ExecSQL;
       Query3.Close ;
     end ;
   // ДОБАВЛЯЕМ СТОЛБЕЦ
   begin  // БЛОК ДОБАВЛЕНИЯ СТОЛБЦА
       //ShowMessage('Добавляем столбец') ;
       Query3.SQL.Clear;
       Query3.SQL.Add('ALTER TABLE "'+namedbf + '"'+'     ADD');
       if tipstolb = 'N' then
          begin
            Query3.SQL.Add(namestolb + ' NUMERIC ('+ IntToStr(lenstolb)+','+ IntToStr(lenznak)+')' );  //в скобках- (размер,десятичных зн)
          end;
       if tipstolb = 'C' then
          begin
            Query3.SQL.Add( namestolb +  '  CHAR(' +IntToStr(lenstolb)+  ')' );
          end;
       if tipstolb = 'D' then
          begin
            Query3.SQL.Add(namestolb +' DATE');
          end;
       try // пытаемся выполнить запрос
        Query3.ExecSQL;
       except // если произошла ошибка
          ShowMessage('Ошибка функции CreateDBF1 ' + namedbf +' ' + namestolb + ' ' + tipstolb + ' ' + IntToStr(lenstolb)+ ' '+ IntToStr(lenznak));
          exit ;
       end ;
       Query3.Close ;

   end ;// БЛОК ДОБАВЛЕНИЯ СТОЛБЦА
   if  not Exists  // если НЕ существует  БАЗА namedbf
   then
     // УДАЛЕНИЕ ПУСТОГО СТОЛБЦА
     begin
       //ShowMessage('Удаляем пустой столбец');
       Query3.SQL.Clear;
       Query3.SQL.Add('ALTER TABLE "'+namedbf + '"'+'     DROP');
       Query3.SQL.Add('RABFAL11 ');
       Query3.ExecSQL;
       Query3.Close ;
     end ;
   // может быть использовать метод FREE - для освобождения   
   CreateDBF1 := true ; // до конца добрались
end ;// CREATEDBF

// Не сделана !!!
function FALInsertRecord (namedbf : string ;  // имя dbf - базы куда пишем
                            pole : string;      // поля куда пишем в строковом виде
                            value : string      // значения соответсвенно
                            ) : boolean  ;
begin
  //FALInsertRecord := false ;  // пока ничего не сделали
  Query3 := TQuery.Create(Application);  //Создаем Query - собственник App..
  Query3.Close;
  Query3.SQL.Clear;
  Query3.SQL.Add('insert into ');
  Query3.SQL.Add(namedbf);


  FALInsertRecord := true ;  // Все сделали
end; // FALInsertRecord



end.
