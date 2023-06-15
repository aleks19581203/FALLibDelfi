unit FalLibDB1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;
  function FalPack ( Table :TTable ;  // ������� ����
                    NameTable :  PChar ; // ��� ���� ����� ����� �� �������
                    Query1 :TQuery) : integer;  // ������ ������
  function CreateDBF1 (namedbf : string ;  // ��� ����������� dbf - ����
                      namestolb : string ; // ��� �������
                      tipstolb : string ;  // ��� ������� N C D
                      lenstolb : integer ; // ����� �������
                      lenznak : integer    // ���������� ���������� ������
                      ) : boolean;
  function FALInsertRecord (namedbf : string ;  // ��� dbf - ���� ���� �����
                            pole : string;      // ���� ���� ����� � ��������� ����
                            value : string      // �������� �������������
                            ) : boolean  ;
implementation

var
  Query3 : TQuery;
// --- ������� ��������  ����
// �������� ���� �����
// FalPack (TableOPLAT,'oplat.dbf',Query1);

function FalPack ( Table :TTable ;  // ������� ����
                   NameTable : PChar ; // ��� ���� ����� ����� �� �������
                   Query1 :TQuery) : integer;  // ������ ������
begin
  //ShowMessage('����� � FALPACK');
  // �������� ����
  // �������� � ����� ������
  Table.Close;  // ���� ����� �������
  // �������� ���� �����
  // �������� ���� �� �����������
  CopyFile(NameTable,'FAL_0001.dbf',false);
  //ShowMessage('�����������');
  // ������ ���� ���������
  Table.Exclusive := True ;
  Table.EmptyTable ;
  Table.Exclusive := False ;
  // �������� � ���� � ���������
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('INSERT INTO '+Table.TableName);
  Query1.SQL.Add('SELECT *' );
  Query1.SQL.Add('FROM FAL_0001.DBF' );
  Query1.ExecSQL;
  // ������� ������� ����
  DeleteFile('FAL_0001.dbf');
  Table.Open;  // ���� ����� �������
  FalPack := 1 ; // ��� ��������� 
end ; // ������� ��������

// ������� ������� ���� ������ DBF ����� ���������� ��������. ��� ������
// ��������� � ������� � ���� ����������� 1 �������. TRUE - ���� ��� ������
// FALSE - ���� �� ��� ������.
//CreateDBF1 ('fff.dbf','oklad','N',10,2) - ������ ��������� ;

function CreateDBF1 ( namedbf : string ;   // ��� ����������� dbf - ����
                      namestolb : string ; // ��� �������
                      tipstolb : string ;  // ��� ������� N C D
                      lenstolb : integer ; // ����� �������
                      lenznak : integer    // ���������� ���������� ������
                      ) : boolean;
                      // 1 ������ - �� ��� ������ N C D
                      // 2 ������ - ���� � ���������� ������
                      // 3 �������� - ��������� ����� ���� ����� �� ����������
                      //              ������ ��� ������ �������� Query.��������� ��
                      //              ������ ��� ������ Query
                      // 4 ������ - ��� 'D' ���� �� ����� ����� ����� DATA
                      // 5 ������ - baza.dbf - ������ ��� � ����������� ������ ����
var
   Exists : boolean ; // ���������� ��  ���� ?

begin
   //ShowMessage('�����');
   CreateDBF1 := false ;  // ���� ������ �� �������
   Query3 := TQuery.Create(Application);  //������� Query - ����������� App..
   Exists := FileExists(namedbf);
   if  not Exists  // ���� �� ����������  ���� namedbf
   then
     //������� ������ �������
     begin
       //ShowMessage('����� ������ �������');
       Query3.SQL.Clear;
       Query3.SQL.Add('CREATE TABLE "'+namedbf + '"');
       Query3.SQL.Add('(RABFAL11 CHAR(2))');
       Query3.ExecSQL;
       Query3.Close ;
     end ;
   // ��������� �������
   begin  // ���� ���������� �������
       //ShowMessage('��������� �������') ;
       Query3.SQL.Clear;
       Query3.SQL.Add('ALTER TABLE "'+namedbf + '"'+'     ADD');
       if tipstolb = 'N' then
          begin
            Query3.SQL.Add(namestolb + ' NUMERIC ('+ IntToStr(lenstolb)+','+ IntToStr(lenznak)+')' );  //� �������- (������,���������� ��)
          end;
       if tipstolb = 'C' then
          begin
            Query3.SQL.Add( namestolb +  '  CHAR(' +IntToStr(lenstolb)+  ')' );
          end;
       if tipstolb = 'D' then
          begin
            Query3.SQL.Add(namestolb +' DATE');
          end;
       try // �������� ��������� ������
        Query3.ExecSQL;
       except // ���� ��������� ������
          ShowMessage('������ ������� CreateDBF1 ' + namedbf +' ' + namestolb + ' ' + tipstolb + ' ' + IntToStr(lenstolb)+ ' '+ IntToStr(lenznak));
          exit ;
       end ;
       Query3.Close ;

   end ;// ���� ���������� �������
   if  not Exists  // ���� �� ����������  ���� namedbf
   then
     // �������� ������� �������
     begin
       //ShowMessage('������� ������ �������');
       Query3.SQL.Clear;
       Query3.SQL.Add('ALTER TABLE "'+namedbf + '"'+'     DROP');
       Query3.SQL.Add('RABFAL11 ');
       Query3.ExecSQL;
       Query3.Close ;
     end ;
   // ����� ���� ������������ ����� FREE - ��� ������������   
   CreateDBF1 := true ; // �� ����� ���������
end ;// CREATEDBF

// �� ������� !!!
function FALInsertRecord (namedbf : string ;  // ��� dbf - ���� ���� �����
                            pole : string;      // ���� ���� ����� � ��������� ����
                            value : string      // �������� �������������
                            ) : boolean  ;
begin
  //FALInsertRecord := false ;  // ���� ������ �� �������
  Query3 := TQuery.Create(Application);  //������� Query - ����������� App..
  Query3.Close;
  Query3.SQL.Clear;
  Query3.SQL.Add('insert into ');
  Query3.SQL.Add(namedbf);


  FALInsertRecord := true ;  // ��� �������
end; // FALInsertRecord



end.
