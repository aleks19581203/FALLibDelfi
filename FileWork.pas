unit FileWork;

interface
uses
  Windows, SysUtils ,Dialogs;
  
type ReadFile = object
//   private
     f1 : file of byte ;
     function OpenFile ( FileName: string ):boolean ;
     Function CloseFile1 : boolean ;
     function ReadWord : Word ;
     function ReadDWord : DWord ;
     function ReadByte : Byte ;
     function SeekByte (NumberByte:integer) : boolean ;
     Function EndFile : Boolean ;
end ; // type

implementation
//--------------------------------------------------------------------------

Function ReadFile.EndFile : boolean ;
begin
  if Eof(f1)  then
  begin
   //ShowMessage(' Есть конец файла') ;
   result:= true ;
  end
  else
  begin
   //ShowMessage('Нет конца файла') ;
   result := false ;
  end
end ;

Function ReadFile.CloseFile1 : boolean ;
begin
 CloseFile(f1);
 result := true ;
end ;//  процедуры 
//--------------------------------------------------------------------------
function ReadFile.OpenFile ( FileName: string ):boolean ;
begin
 AssignFile(f1, FileName);   // File selected in dialog box
 Reset(f1);
 result := true ;
end;
//--------------------------------------------------------------------------
function ReadFile.ReadDWord : DWord ;
var
 byte1 : Byte;
 byte2 : Byte ;
 byte3 : Byte ;
 byte4 : Byte ;
begin
  Read (F1,byte1);
  Read (F1,byte2);
  Read (F1,byte3);
  Read (F1,byte4);
  result := StrToInt('$'+IntToHex(byte4,2)+ IntToHex(byte3,2)+
                IntToHex(byte2,2)+ IntToHex(byte1,2));
end ;
//--------------------------------------------------------------------------
function ReadFile.ReadWord : Word ;
var
 byte1 : Byte;
 byte2 : byte ;
begin
  Read (F1,byte1);
  Read (F1,byte2);
  result := StrToInt('$'+IntToHex(byte2,2)+ IntToHex(byte1,2));
end ;
///--------------------------------------------------------------------------
function ReadFile.ReadByte : Byte ;
var
 byte1 : Byte;
begin
  Read (F1,byte1);
  result := byte1;
end ;
//--------------------------------------------------------------------------
function ReadFile.SeekByte (NumberByte:integer): boolean ;
begin
 Seek (f1,NumberByte) ;
 result := true ;
end ;
//--------------------------------------------------------------------------

end.
