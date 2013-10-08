unit ExtMath;

{Модуль с математическими функциями
TParser - переводит строку в функцию
Degree - возводит число X в степень A
Log - десятичный логарифм
GetPeriod - период итерационной функции Funct с начальным условием
  X0, переходным процессом Idle; возвращает период или: -1 при
  расходимости, 0 при хаосе или периоде > MaxPeriod
  (не опробовано)
GetPeriod2D и GetPeriod3D - тоже для двумерного и трехмерного
  случаев (не опробовано)
RangeKut4 - метод Ранге-Кута 4-го порядка (не опробовано)
Newton - нахождение корня уравнения методом Ньютона
FindRoot - нахождение корня уравнения методом секущих}


{$DEFINE DEBUG_ONLY}

{$IFNDEF DEBUG_ONLY}
{$D-}
{$ENDIF}

interface

uses
  SysUtils;

type
  TCustomFunction = function(X: Extended): Extended;
  TCustomFunction2D = function(X, Y: Extended): Extended;
  TCustomFunction3D = function(X, Y, Z: Extended): Extended;

//function Degree(X, A: Integer): Extended; overload;
function Degree(X, A: Extended): Extended; //overload;
function Log(X: Extended): Extended;
function GetPeriod(var Funct: TCustomFunction; const X0: Extended;
  Eps: Extended; Idle, MaxPeriod: Integer): Integer;
function GetPeriod2D(var FunctX, FunctY: TCustomFunction2D;
  const X0, Y0: Extended; Eps: Extended; Idle, MaxPeriod: Integer): Integer;
function GetPeriod3D(var FunctX, FunctY, FunctZ: TCustomFunction3D;
  const X0, Y0, Z0: Extended; Eps: Extended; Idle, MaxPeriod: Integer): Integer;
procedure RangeKut4(var X: Extended; var Funct: TCustomFunction;
  Step: Extended);
function Newton(var Funct: TCustomFunction; NearRoot: Extended;
  var Root: Extended; Precision: Extended; MaxCount: Integer): Boolean;
function FindRoot(var Funct: TCustomFunction; Left, Right: Extended;
  var Root: Extended; Precision: Extended; MaxCount: Integer): Boolean;

const
  LeftLimit: Extended = 0.0;
  RightLimit: Extended = 0.0;

implementation

const
  Big=1e100;

{function Degree(X, A: Integer): Extended;
begin
  if X = 0 then
  begin
    Result := 0;
    Exit;
  end;
  Result := 1;
  if A > 0 then
    Result := X * Degree(X, A - 1);
  if A < 0 then
    Result := 1 / X * Degree(X, A + 1);
end;

function Degree(X, A: Extended): Extended;
begin
  Result := Exp(A * Ln(X));
end;}

function Degree(X, A: Extended): Extended;
asm
  FLD tbyte ptr [ebp+$8]
  FLD tbyte ptr [ebp+$14]
  FYL2X
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADD
  FSCALE
  FFREE ST(1)
end;

function Log(X: Extended): Extended;
begin
  Result := Ln(X) / Ln(10);
end;

function GetPeriod(var Funct: TCustomFunction; const X0: Extended;
  Eps: Extended; Idle, MaxPeriod: Integer): Integer;
var
  X, XSt: Extended;
  i: Integer;
begin
  if (Idle < 0) or (MaxPeriod < 1) then
    raise Exception.Create('Неправильный параметр');
  X := X0;
  for i := 0 to Idle - 1 do
  begin
    X := Funct(X);
    if Abs(X )>= Big then
    begin
      Result := -1;
      Exit;
    end;
  end;
  Result := 0;
  XSt := X;
  for i := 0 to MaxPeriod - 1 do
  begin
    X := Funct(X);
    if Abs(X) >= Big then
    begin
      Result := 0;
      Exit;
    end;
    if Abs(X - XSt) <= Eps then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function GetPeriod2D(var FunctX, FunctY: TCustomFunction2D;
  const X0, Y0: Extended; Eps: Extended; Idle, MaxPeriod: Integer): Integer;
var
  X, Y, XSt, YSt, XT: Extended;
  i: Integer;
begin
  if (Idle < 0) or (MaxPeriod < 1) then
    raise Exception.Create('Неправильный параметр');
  X := X0;
  Y := Y0;
  for i := 0 to Idle - 1 do
  begin
    XT := FunctX(X, Y);
    Y := FunctY(X, Y);
    X := XT;
    if (Abs(X) >= Big) or (Abs(Y) >= Big) then
    begin
      Result := -1;
      Exit;
    end;
  end;
  Result := 0;
  XSt := X;
  YSt := Y;
  for i := 0 to MaxPeriod - 1 do
  begin
    XT := FunctX(X, Y);
    Y := FunctY(X, Y);
    X := XT;
    if (Abs(X) >= Big) or (Abs(Y) >= Big) then
    begin
      Result := 0;
      Exit;
    end;
    if Sqrt(Sqr(X - XSt) + Sqr(Y - YSt)) <= Eps then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function GetPeriod3D(var FunctX, FunctY, FunctZ: TCustomFunction3D;
  const X0, Y0, Z0: Extended; Eps: Extended; Idle, MaxPeriod: Integer): Integer;
var
  X, Y, Z, XSt, YSt, ZSt, XT, YT: Extended;
  i: Integer;
begin
  if (Idle < 0) or (MaxPeriod < 1) then
    raise Exception.Create('Неправильный параметр');
  X := X0;
  Y := Y0;
  Z := Z0;
  for i := 0 to Idle - 1 do
  begin
    XT := FunctX(X, Y, Z);
    YT := FunctY(X, Y, Z);
    Z := FunctZ(X, Y, Z);
    X := XT;
    Y := YT;
    if (Abs(X) >= Big) or (Abs(Y) >= Big) or (Abs(Z) >= Big) then
    begin
      Result := -1;
      Exit;
    end;
  end;
  Result := 0;
  XSt := X;
  YSt := Y;
  ZSt := Z;
  for i := 0 to MaxPeriod - 1 do
  begin
    XT := FunctX(X, Y, Z);
    YT := FunctY(X, Y, Z);
    Z := FunctZ(X, Y, Z);
    X := XT;
    Y := YT;
    if (Abs(X) >= Big) or (Abs(Y) >= Big) or (Abs(Z) >= Big) then
    begin
      Result := 0;
      Exit;
    end;
    if Sqrt(Sqr(X - XSt) + Sqr(Y - YSt) + Sqr(Z - ZSt)) <= Eps then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

procedure RangeKut4(var X: Extended; var Funct: TCustomFunction;
  Step: Extended);
var
  K1, K2, K3, K4: Extended;
begin
  K1 := Funct(X);
  K2 := Funct(X + K1 * Step / 2);
  K3 := Funct(X + K2 * Step / 2);
  K4 := Funct(X + K3 * Step);
  X := X + Step / 6 * (K1 + 2 * K2 + 2 * K3 + K4);
end;

function Newton(var Funct: TCustomFunction; NearRoot: Extended;
  var Root: Extended; Precision: Extended; MaxCount: Integer): Boolean;
var
  Dy, NextRoot: Extended;
  Count: Integer;
begin
  Result := False;
  Count := 0;
  Root := NearRoot;
  while Abs(Funct(Root)) > Precision do
  begin
    Inc(Count);

    try
      Dy := (Funct(Root + Precision)
        - Funct(Root - Precision)) / Precision / 2;
    except
      try
        Dy := (Funct(Root)
          - Funct(Root - Precision)) / Precision;
      except
        try
          Dy := (Funct(Root + Precision)
            - Funct(Root)) / Precision;
        except
          Exit;
        end;
      end;
    end;

    if Dy = 0 then
    begin
{$IFDEF DEBUG_ONLY}
      Result := False;
{$ENDIF}
      Exit;
    end;

    NextRoot := Root - Funct(Root) / Dy;
    if LeftLimit < RightLimit then
    begin
      if NextRoot <= LeftLimit then
        NextRoot := LeftLimit + Precision;
      if NextRoot >= RightLimit then
        NextRoot := RightLimit - Precision;
    end;
    repeat
      try
        Funct(NextRoot);
        Break;
      except
        NextRoot := (Root + NextRoot) / 2;
      end;
    until Abs((NextRoot - Root)) * 100 < Precision;
    if Abs((NextRoot - Root)) * 100 < Precision then
    begin
{$IFDEF DEBUG_ONLY}
      Result := False;
{$ENDIF}
      Exit;
    end;

    Root := NextRoot;

    if Count >= MaxCount then
    begin
{$IFDEF DEBUG_ONLY}
      Result := False;
{$ENDIF}
      Exit;
     end;
    if Abs(Root - NearRoot) >= Big then
    begin
{$IFDEF DEBUG_ONLY}
      Result := False;
{$ENDIF}
      Exit;
    end;
    if Abs(Funct(Root)) >= Big then
    begin
{$IFDEF DEBUG_ONLY}
      Result := False;
{$ENDIF}
      Exit;
    end;
  end;
  Result := True;
end;

function FindRoot(var Funct: TCustomFunction; Left, Right: Extended;
  var Root: Extended; Precision: Extended; MaxCount: Integer): Boolean;

  function FindRootR(Left, Right: Extended): Boolean;
  var
    Mid: Extended;
    i: Integer;
    FLeft, FRight, FMid: Extended;
  begin
    Result := False;

    for i := 0 to MaxCount - 1 do
    begin
      FLeft := Funct(Left);
      FRight := Funct(Right);
{      if Funct(Left) * Funct(Right) > 0 then
      begin
        Result := False;
        Exit;
      end;}
      Mid := Left - FLeft * (Right - Left) / (FRight - FLeft);
      FMid := Funct(Mid);
      if Abs(FMid) <= Precision then
      begin
        Root := Mid;
        Result := True;
        Exit;
      end;

      if FLeft * FMid < 0 then
        Right := Mid
      else
        Left := Mid;
    end;
  end;

begin
  repeat
    try
      Funct(Left);
      Break;
    except
      Left := Left + (Right - Left) * Precision;
    end;
  until Abs(Left - Right) * 1000 < Precision;
  if Abs(Left - Right) * 1000 < Precision then
  begin
    Result := False;
    Exit;
  end;

  repeat
    try
      Funct(Right);
      Break;
    except
      Right := Right - (Right - Left) * Precision;
    end;
  until Abs(Left - Right) * 1000 < Precision;
  if Abs(Left - Right) * 1000 < Precision then
  begin
    Result := False;
    Exit;
  end;

  if Funct(Left) * Funct(Right) > 0 then
  begin
    Result := False;
    Exit;
  end;

  Result := FindRootR(Left, Right);
end;

end.
