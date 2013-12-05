unit Initial6;

{Модуль начальных возмущений
PlaneWaveTE и PlaneWaveTM - задают плоскую, Sin-идальную волну
GaussTE и GaussTM - плоскую волну с распределением Гаусса}

interface

{$D+}

uses
  Common6, Regions, PhisCnst;

procedure PlaneWaveTE;
procedure PlaneWaveTM;
procedure GaussTE;
procedure GaussTM;
procedure WaveFromRegionList;

implementation

procedure PlaneWaveTE;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
//перешагивание в пространстве
      if (i + j + 2) mod 2 = 0 then
      begin
        Ez[i, j] := Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Dz[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hy[i, j] := Hz0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        By[i, j] := Hy[i, j] * Mu0;
      end;
end;

procedure PlaneWaveTM;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
      if (i + j + 2) mod 2 = 0 then
      begin
        Ey[i, j]:=Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Cos(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Dy[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hz[i, j]:=Hz0
          *Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          *Cos(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Bz[i, j]:=Hy[i, j] * Mu0;
      end;
end;

procedure GaussTE;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
      if (i + j + 2) mod 2 = 0 then
      begin
        Ez[i, j]:=Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1))
          * Exp(-Sqr(ExpX * (I - (InitialX1 + InitialX2) / 2))
          -Sqr(ExpY * (j - (InitialY1 + InitialY2) / 2)));
        Dz[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hy[i, j]:=Hz0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1))
          * Exp(-Sqr(ExpX * (I - (InitialX1 + InitialX2) / 2))
          -Sqr(ExpY * (j - (InitialY1 + InitialY2) / 2)));
        By[i, j]:=Hy[i, j] * Mu0;
      end;
end;

procedure GaussTM;
begin
end;

procedure WaveFromRegionList;
var
  i, j, k: Integer;
  EndX, EndY: Integer;
begin
  with RegionList do
  for i := 0 to FieldList.Count - 1 do
  begin
    FieldList[i].FillEx(Ex);
    FieldList[i].FillEy(Ey);
    FieldList[i].FillEz(Ez);
    FieldList[i].FillDx(Dx);
    FieldList[i].FillDy(Dy);
    FieldList[i].FillDz(Dz);
    FieldList[i].FillBx(Bx);
    FieldList[i].FillBy(By);
    FieldList[i].FillBz(Bz);
    FieldList[i].FillHx(Hx);
    FieldList[i].FillHy(Hy);
    FieldList[i].FillHz(Hz);
  end;
end;

end.
