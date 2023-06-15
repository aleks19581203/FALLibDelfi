//������ 4.0  (x.y x-���������� ������� y - ����� ���������)
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

// ������� �������� ��������� Substr �� ������ StringBig.���� ����� ��������� ���
// ������ StringBig �������� ��� ���������.�������� ���� ���.
// FALDelSubst ( '12345', '123') = '45'
// ��� �� ��������� �����
Function FALDelSubst (StringBig ,Substr : string) : string  ;
Var
  Str1 : string ;
  Index : integer;
Begin
 Index := Pos(Substr,StringBig) ;
 if Index > 0 // ����� ������� � ����� ����������
 then  begin
         //ShowMessage('FALDelSubst ������ �������');
         Str1 := StringBig ;
         Delete (Str1, Index,Length(Substr));
         FALDelSubst := Str1 ;   // ������ ����������
         //ShowMessage( 'FALDelSubst '+StringBig + ' - ' + Substr + ' = '+ Str1);
       end
 else  begin
         //ShowMessage('FALDelSubst ������ �� �������') ;
         FALDelSubst := StringBig ;   // ������ �� ����������
       end
 //end_if
End ; // FALDelSubstr


// ������� ������� ����� � ������ Instring ,����������� ����� �������������
// Separator.����������� ����� ����������� ������ ���� ��� ������. ����� ����� - Nword.
// ��������������� ��� ����� ���������� � ���� ������ ������������
// str := FALGiveMeWord (1, '|111  | 222 |   333|' , '|') �����  "111  "
// ���� ����� �� ������� ������������ ''

Function FALGiveMeWord (Nword : integer; InString , Separator : string) : string ;
var
 wordtemp : string ;
 index,Nw : integer;
 First : boolean ;
 cikl ,ciklword : boolean ;
Begin
 FALGiveMeWord := '';
 ciklword := true ;
 Index := 1; // ����� ����� � ������
 First := false; // ������ ����������� �� ����������
 Nw:= 1 ; // ������ �����
 while ciklword do  // ���� ����
 begin
  cikl := true ;  // ���������� ����
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
      if Index > Length(InString) then cikl := false // ������� �� ������� �����
  end  ; // cikl
  Index := Index -1 ;
  First := false;
  if Nw = Nword // ���� ����� ����������� ����� ����� �������
  then ciklword := false  // �� ����� �� ����� ����
  else Nw:= Nw+1 ;     // ����� - ��������� �����
 end  ;// ciklword
 FALGiveMeWord := wordtemp;
End; // FALGiveMeWord

// ������� ��������� ������ Simvol �� ����� Len
//  ���� ������������� ����� ��� ������� ����� - ������ �������� ����������
//  FALReplicate (5 , '1') = 11111
Function FALReplicate (Len : integer; Simvol : string) : string ;
var
 strrab : string ;
Begin
 if Len <= 0 then ShowMessage('FALReplicate ����� �� ����� ���� ������������� ��� 0')
 else
  begin
    strrab := Simvol;
    while Length(strrab) < Len do  strrab := Simvol + strrab  ;  // ������� �����
  end ;
 FALReplicate := strrab ;
End ;


// ������� ���������� ��������� �� ������ , ����������� ����� ����� �������.
// C���� ������������ ����. ���� ������ ���� ����� ��� �� ������� ������
// - ������������ '' (������ ������).
// FALStrBetweenWord ( '1234567890' '23' ,'90' ) = '234567890'
// FALStrBetweenWord ( '1234567890' '23' ,'a' ) = ''
// ������� ����� �������������� ����������
Function FALStrBetweenWord (StringBig,WordFirst,WordSecond : string) : string ;
var
  PosFirst  : integer ; // ������� ������� ����� �� ������� ������
  PosSecond : integer ; // ������� ������� ����� �� ������� ������
  LenSecond : integer ; // ����� ������� �����
  LenResult : integer ; // ����� �������� ������
begin
  PosFirst  := Pos(WordFirst,StringBig) ;
  PosSecond := Pos(WordSecond,StringBig) ;
  LenSecond := Length(WordSecond);

  // �������� ����������� ����
  if (PosFirst = 0) or (PosSecond =0)then
  begin
     ShowMessage('FALStrBetweenWord ������ ��� ������ ����� �� ������������ � ������') ;
     Result := '' ;
     exit
  end ;

  // ���� ������ ����� ������ �������  - ������ ����� ''
  if (PosFirst > PosSecond )then
  begin
     ShowMessage('FALStrBetweenWord ������ ����� ����� ������� ') ;
     Result := '' ;
     exit
  end ;


  // ���������� ����� �������� ������
  LenResult := PosSecond - PosFirst + LenSecond ;
  // �������� �������
  Result := Copy (
                  StringBig,  // ������, ������ ����������
                  PosFirst,   // ����� ������
                  LenResult   // �����
                 )
end ;


end. // ������
