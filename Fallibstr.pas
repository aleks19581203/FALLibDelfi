//версия 4.0  (x.y x-количество функций y - номер подверсии)
unit Fallibstr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,StdCtrls, ComCtrls, ExtCtrls;
  Function FALDelSubst   (StringBig ,Substr : string) : string ;
  Function FALGiveMeWord (Nword : integer; InString , Separator : string) : string ;
  Function FALReplicate (Len : integer; Simvol : string) : string ;
  Function FALStrBetweenWord (StringBig,WordFirst,WordSecond : string) : string ;


implementation

// Функция удаления подстроки Substr из строки StringBig.Если такой подстроки нет
// строка StringBig остается без изменений.Делается один раз.
// FALDelSubst ( '12345', '123') = '45'
// Как бы вычитание строк
Function FALDelSubst (StringBig ,Substr : string) : string  ;
Var
  Str1 : string ;
  Index : integer;
Begin
 Index := Pos(Substr,StringBig) ;
 if Index > 0 // нашли позицию с какой начинается
 then  begin
         //ShowMessage('FALDelSubst Строка найдена');
         Str1 := StringBig ;
         Delete (Str1, Index,Length(Substr));
         FALDelSubst := Str1 ;   // Строка изменилась
         //ShowMessage( 'FALDelSubst '+StringBig + ' - ' + Substr + ' = '+ Str1);
       end
 else  begin
         //ShowMessage('FALDelSubst Строка не найдена') ;
         FALDelSubst := StringBig ;   // Строка не изменилась
       end
 //end_if
End ; // FALDelSubstr


// Функция находит слово в строке Instring ,заключенное между разделителями
// Separator.Разделитель может встречаться ТОЛЬКО ОДИН раз подряд. Номер слова - Nword.
// Подразумевается что слово ограничено с двух сторон разделителем
// str := FALGiveMeWord (1, '|111  | 222 |   333|' , '|') равно  "111  "
// если слово не найдено возвращается ''

Function FALGiveMeWord (Nword : integer; InString , Separator : string) : string ;
var
 wordtemp : string ;
 index,Nw : integer;
 First : boolean ;
 cikl ,ciklword : boolean ;
Begin
 FALGiveMeWord := '';
 ciklword := true ;
 Index := 1; // номер буквы в строке
 First := false; // первый разделитель не встречался
 Nw:= 1 ; // первое слово
 while ciklword do  // цикл слов
 begin
  cikl := true ;  // внутренний цикл
  wordtemp := '';
  while cikl do
  begin
      if InString[index] <> Separator
      then begin
          if First = true then  wordtemp := wordtemp+ InString[index]
      end
      else  begin
          if First = false
          then First := true
          else cikl := false
      end ; //else
      Index := Index+1 ;
      if Index > Length(InString) then cikl := false // выходим из первого цикла
  end  ; // cikl
  Index := Index -1 ;
  First := false;
  if Nw = Nword // если номер выделенного слова равен нужному
  then ciklword := false  // то выход из цикла слов
  else Nw:= Nw+1 ;     // иначе - следующее слово
 end  ;// ciklword
 FALGiveMeWord := wordtemp;
End; // FALGiveMeWord

// Функция повторяет символ Simvol до длины Len
//  Если отрицательная длина или нулевая длина - строка остается неизменной
//  FALReplicate (5 , '1') = 11111
Function FALReplicate (Len : integer; Simvol : string) : string ;
var
 strrab : string ;
Begin
 if Len <= 0 then ShowMessage('FALReplicate Длина не может быть отрицательной или 0')
 else
  begin
    strrab := Simvol;
    while Length(strrab) < Len do  strrab := Simvol + strrab  ;  // символы слева
  end ;
 FALReplicate := strrab ;
End ;


// функция возвращает подстроку из строки , заключенную между двумя словами.
// Cлова возвращаются тоже. Если какого либо слова нет во входной строке
// - возвращается '' (пустая строка).
// FALStrBetweenWord ( '1234567890' '23' ,'90' ) = '234567890'
// FALStrBetweenWord ( '1234567890' '23' ,'a' ) = ''
// входные слова предполагаются ненулевыми
Function FALStrBetweenWord (StringBig,WordFirst,WordSecond : string) : string ;
var
  PosFirst  : integer ; // позиция первого слова во входной строке
  PosSecond : integer ; // позиция второго слова во входной строке
  LenSecond : integer ; // длина второго слова
  LenResult : integer ; // длина выходной строки
begin
  PosFirst  := Pos(WordFirst,StringBig) ;
  PosSecond := Pos(WordSecond,StringBig) ;
  LenSecond := Length(WordSecond);

  // проверка присутствия слов
  if (PosFirst = 0) or (PosSecond =0)then
  begin
     ShowMessage('FALStrBetweenWord Первое или второе слово не присутствуют в строке') ;
     Result := '' ;
     exit
  end ;

  // если второе слово раньше первого  - ошибка выход ''
  if (PosFirst > PosSecond )then
  begin
     ShowMessage('FALStrBetweenWord Первое слово позже второго ') ;
     Result := '' ;
     exit
  end ;


  // вычисление длины выходной строки
  LenResult := PosSecond - PosFirst + LenSecond ;
  // значение функции
  Result := Copy (
                  StringBig,  // строка, откуда копируется
                  PosFirst,   // место начала
                  LenResult   // длина
                 )
end ;


end. // модуля
