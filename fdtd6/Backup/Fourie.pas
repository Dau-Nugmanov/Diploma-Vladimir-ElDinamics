unit Fourie;

{Модуль, производящий преобразование Фурье}

{$D-}

interface

uses
  SysUtils, Grapher, ExtMath, FFTran;

procedure DoFFT(var Points: TPoints);

implementation

function GetDepth(var Points: TPoints): Word;
//нахождение числа n, такого, что 2^n = N (Points.Count)
begin
  Result := 0;
  repeat
    Inc(Result);
  until Degree(2, Result) >= Points.Count;
end;

procedure PutZero(var Points: TPoints; NewCount: Integer);
var
  Dif, i: Integer;
//дополнение ряда нулями до 2^n
begin
  Dif := NewCount-Points.Count;
  for i := 0 to Dif div 2 - 1 do
    Points.Insert(0, -i, 0);
  for i := Dif downto Dif - Dif div 2 + 1 do
    Points.Add(Points.Values[Points.Count-1].X + 1, 0);
end;

procedure FillArrays(var Points: TPoints; var XR, XI: PScalars);
var
  i: Integer;
//заполнить массивы значениями из Points
begin
  for i := 0 to Points.Count - 1 do
  begin
    XR^[i] := Points.Values[i].Y;
    XI^[i] := 0;
  end;
end;

procedure FillPoints(var Points: TPoints; var XR, XI: PScalars);
var
  i, Count: Integer;
//поместить в Points мощность спектра
begin
  Count := Points.Count;
  Points.Clear;
  for i := 0 to Count - 1 do
  begin
    Points.Add(i, Sqrt(Sqr(XR^[i]) + Sqr(XI^[i])));
  end;
end;

procedure DoFFT;
var
  Depth: Word;
  N: Integer;
  XR, XI, YR, YI: PScalars;
begin
  Depth := GetDepth(Points);
  N := Round(Degree(2, Depth));
  if N > Points.Count then
    PutZero(Points, N);

  XR := AllocMem(N * SizeOf(TScalar));
  YR := AllocMem(N * SizeOf(TScalar));
  XI := AllocMem(N * SizeOf(TScalar));
  YI := AllocMem(N * SizeOf(TScalar));

  FillArrays(Points, XR, XI);
  FFT(Depth, XR, XI, YR, YI);
  FillPoints(Points, YR, YI);

  FreeMem(XR);
  FreeMem(YR);
  FreeMem(XI);
  FreeMem(YI);
end;

end.
