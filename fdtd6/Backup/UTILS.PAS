unit Utils;

{$D-}

interface

uses
  SysUtils, ExtMath;

type
  TSwapProc = procedure (Index1, Index2: Integer);

function IntToStrD(Value: Integer; Digits: Byte): string;
function RoundFloat(Value: Extended; Digits: Byte): Extended;
function CutFloat(Value: Extended; Digits: Byte): Extended;
function StrIns(const Source: string; Dest: string; Pos: Byte): string;

procedure QuickSort(var Data: array of Integer; SwapProc: TSwapProc = nil); overload;
procedure QuickSort(var Data: array of Extended; SwapProc: TSwapProc = nil); overload;
procedure QuickSortS(var Data: array of string; SwapProc: TSwapProc = nil);
function FindKey(var Data: array of Integer; Key: Integer): Integer;

implementation

function IntToStrD(Value: Integer; Digits: Byte): string;
//переводит число в строку с заданным количеством цифр
//Digits=3 : 1 = 001, 10=010, 100=100, 1000=1000
var
  Tens: Integer;
begin
  Tens := Round(Degree(10, Digits - 1));
  if Value = 0 then
    Tens := Tens div 10;
  Result := IntToStr(Value);
  while Value < Tens do
  begin
    Result := '0' + Result;
    Tens := Tens div 10;
  end;
end;

function RoundFloat(Value: Extended; Digits: Byte): Extended;
//округление вещественных чисел, если 0 или 9 встречаются
//Digits раз
//Digits=3 : 0.00132999...=0.00132  345.45000...=345.45
var
  Str, Ex: string;
  Count, Count0, Count9: Integer;
  EPos: Byte;
  Digit: Integer;
begin
  Str := FloatToStr(Value);
  Ex := '';
  EPos := 0;
  for Count := 1 to Length(Str) do
  begin
    if EPos > 0 then
      Ex[Count - EPos] := Str[Count];
    if Str[Count] = 'E' then
    begin
      EPos := Count;
      SetLength(Ex, Length(Str) - EPos);
    end;
  end;

  Count := 1;
  while (Str[Count] = '0') or (Str[Count] = '.') do
    Inc(Count);

  Count0 := 0;
  Count9 := 0;
  Digit := -1;
  repeat
    if Str[Count] in ['0'..'9'] then
      Digit := StrToInt(Str[Count])
    else
      if Str[Count] <> '.' then
        Break
      else
        Digit := -1;
    if Digit = 0 then
    begin
      Inc(Count0);
      Count9 := 0;
    end;
    if Digit = 9 then
    begin
      Inc(Count9);
      Count0 := 0;
    end;
    if not ((Digit = 0 ) or (Digit = 9) or (Digit = -1)) then
    begin
      Count0 := 0;
      Count9 := 0;
    end;
    Inc(Count);
  until (Count0 = Digits) or (Count9 = Digits)
    or (Count > Length(Str));

  if Count0 = Digits then
  begin
    SetLength(Str, Count - Digits + 1);
    if Ex <> '' then
      Str := Str + 'E' + Ex;
  end;
  if Count9 = Digits then
  begin
    SetLength(Str, Count - Digits);
    if Str[Count - Digits - 1] in ['0'..'9'] then
      Str[Count - Digits - 1] := IntToStr(StrToInt(
        Str[Count - Digits - 1]) + 1)[1]
    else
      Str[Count - Digits - 2] := IntToStr(StrToInt(
        Str[Count - Digits - 2]) + 1)[1];
    Str[Count - Digits]:='0';
    if Ex <> '' then
      Str := Str + 'E' + Ex;
  end;

  Result:=StrToFloat(Str);
end;

function CutFloat(Value: Extended; Digits: Byte): Extended;
//обрезает число, оставляя Digits цифр после запятой
var
  Precision: Integer;
begin
  Precision := Round(Degree(10, Digits));
  Result := Round(Value * Precision) / Precision;
end;

function StrIns(const Source: string; Dest: string; Pos: Byte): string;
//вставить строку Source в строку Dest на позицию Pos
var
  i: Integer;
begin
  if (Pos < 1) or (Pos > Length(Dest)) then
  begin
    Result := Dest;
    Exit;
  end;
  if Pos = 1 then
  begin
    Result := Source + Dest;
    Exit;
  end;
  if Pos = Length(Dest) then
  begin
    Result := Dest + Source;
    Exit;
  end;

  SetLength(Result, Length(Dest) + Length(Source));
  for i := 1 to Length(Dest) + Length(Source) do
  begin
    if i < Pos then
      Result[i] := Dest[i];
    if (i >= Pos) and (i < Pos + Length(Source)) then
      Result[i] := Source[i - Pos + 1];
    if i >= Pos + Length(Source) then
      Result[i] := Dest[i - Length(Source)];
  end;
end;

procedure QuickSort(var Data: array of Integer; SwapProc: TSwapProc = nil); overload;
//быстрая сортировка
  procedure Sort(var Data: array of Integer; iLo, iHi: Integer);
  var
    Lo, Hi, Mid, T: Integer;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := Data[(Lo + Hi) div 2];
    repeat
      while Data[Lo] < Mid do Inc(Lo);
      while Data[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := Data[Lo];
        Data[Lo] := Data[Hi];
        Data[Hi] := T;
        if @SwapProc <> nil then
          SwapProc(Lo, Hi);
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then Sort(Data, iLo, Hi);
    if Lo < iHi then Sort(Data, Lo, iHi);
  end;

begin
  Sort(Data, Low(Data), High(Data));
end;

procedure QuickSort(var Data: array of Extended; SwapProc: TSwapProc = nil); overload;
//быстрая сортировка
  procedure Sort(var Data: array of Extended; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Mid, T: Extended;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := Data[(Lo + Hi) div 2];
    repeat
      while Data[Lo] < Mid do Inc(Lo);
      while Data[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := Data[Lo];
        Data[Lo] := Data[Hi];
        Data[Hi] := T;
        if @SwapProc <> nil then
          SwapProc(Lo, Hi);
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then Sort(Data, iLo, Hi);
    if Lo < iHi then Sort(Data, Lo, iHi);
  end;

begin
  Sort(Data, Low(Data), High(Data));
end;

procedure QuickSortS(var Data: array of string; SwapProc: TSwapProc = nil);
//быстрая сортировка
  procedure Sort(var Data: array of string; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Mid, T: string;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := Data[(Lo + Hi) div 2];
    repeat
      while Data[Lo] < Mid do Inc(Lo);
      while Data[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := Data[Lo];
        Data[Lo] := Data[Hi];
        Data[Hi] := T;
        if @SwapProc <> nil then
          SwapProc(Lo, Hi);
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then Sort(Data, iLo, Hi);
    if Lo < iHi then Sort(Data, Lo, iHi);
  end;

begin
  Sort(Data, Low(Data), High(Data));
end;

function FindKey(var Data: array of Integer; Key: Integer): Integer;
//поиск первого элемента отсортированного массива Data со значением Key
  function Find(var Data: array of Integer; Key, iLo, iHi: Integer): Integer;
  var
    Mid: Integer;
  begin
    if iLo = iHi then
      if Data[iLo] = Key then
      begin
        Result := iLo;
        Exit;
      end
      else
      begin
        Result := Low(Data) - 1;
        Exit;
      end;

    Mid := (iLo + iHi) div 2;
    if Data[Mid] = Key then
    begin
      repeat
        Dec(Mid);
      until (Data[Mid - 1] <> Key) or (Mid < Low(Data));
      Result := Mid;
      Exit;
    end;

    if Data[Mid] > Key then
      Result := Find(Data, Key, iLo, Mid)
    else
      Result := Find(Data, Key, Mid, iHi)
  end;

begin
  Result := Find(Data, Key, Low(Data), High(Data));
end;

end.
