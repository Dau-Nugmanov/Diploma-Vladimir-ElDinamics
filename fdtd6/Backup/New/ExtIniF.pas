unit ExtIniF;

{ћодуль описывает ini-файл, в котором переменные типа Boolean
записываютс€ как строки ("True" или "False")}

{$D-}

interface

uses
  IniFiles;

type
  TExtIniFile=class(TIniFile)
  public
    procedure WriteBoolAsString(const Section, Ident: string;
      const Value: Boolean);
    function ReadStringAsBool(const Section, Ident: string;
      Default: Boolean): Boolean;
  end;

function BoolToStr(Value: Boolean): string;
function StrToBool(Value: string): Boolean;

implementation

function BoolToStr(Value: Boolean): string;
begin
  if Value then
    Result := 'True'
  else
    Result := 'False';
end;

function StrToBool(Value: string): Boolean;
begin
  Result := Value = 'True';
end;

procedure TExtIniFile.WriteBoolAsString;
begin
  WriteString(Section, Ident, BoolToStr(Value));
end;

function TExtIniFile.ReadStringAsBool;
begin
  Result:=StrToBool(ReadString(Section, Ident, BoolToStr(Default)));
end;

end.
