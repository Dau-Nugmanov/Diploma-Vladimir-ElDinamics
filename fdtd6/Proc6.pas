unit Proc6;

{Модуль с основными процедурами
CreateFields и DestroyFields - создают и уничтожают динамические
  массивы для компонент поля
ElectrTE и MagnTE - рассчитывают электрические и магнитные
  компоненты в следуюший момент времени для TE-моды
ElectrTE и MagnTE - то же для ТМ-моды
Next - осуществляет переход к следующему шагу: учитывает граничные
  условия и переписывает значения из нового массива в старый}

{$D+}

interface

uses
  Common6, ExtArr, Regions, ExtMath, PhisCnst;

procedure CreateFields;
procedure DestroyFields;
procedure ElectrTE(i, j: Integer);
procedure MagnTE(i, j: Integer);
procedure ElectrTM(i, j: Integer);
procedure MagnTM(i, j: Integer);
procedure Next;
procedure SetSigmaCoeffs;
procedure FreeSigmaCoeffs;
procedure SetIntMode;
function CalcIntegral(Forw: Boolean): Extended;
procedure AddValues;
procedure AddIntValues;

implementation

procedure CreateFields;
begin
//создание массивов для компонент
  Ez := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  EzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Ex := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  ExN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Ey := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  EyN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Dz := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  DzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Dx := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  DxN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Dy := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  DyN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Bz := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  BzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Bx := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  BxN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  By := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  ByN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Hz := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  HzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Hx := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  HxN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  Hy := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
  HyN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);

  Exy := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Exz := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Eyx := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Eyz := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Ezx := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Ezy := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hxy := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hxz := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hyx := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hyz := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hzx := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  Hzy := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  ExyN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  ExzN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  EyxN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  EyzN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  EzxN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  EzyN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HxyN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HxzN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HyxN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HyzN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HzxN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  HzyN := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Field arrays are created');
{$ENDIF}
end;

procedure DestroyFields;
begin
//уничтожение массивов для компонент
  Ex.Free;
  Ey.Free;
  Ez.Free;
  Dx.Free;
  Dy.Free;
  Dz.Free;
  Bx.Free;
  By.Free;
  Bz.Free;
  Hx.Free;
  Hy.Free;
  Hz.Free;
  ExN.Free;
  EyN.Free;
  EzN.Free;
  DxN.Free;
  DyN.Free;
  DzN.Free;
  BxN.Free;
  ByN.Free;
  BzN.Free;
  HxN.Free;
  HyN.Free;
  HzN.Free;

  Exy.Free;
  Exz.Free;
  Eyx.Free;
  Eyz.Free;
  Ezx.Free;
  Ezy.Free;
  Hxy.Free;
  Hxz.Free;
  Hyx.Free;
  Hyz.Free;
  Hzx.Free;
  Hzy.Free;
  ExyN.Free;
  ExzN.Free;
  EyxN.Free;
  EyzN.Free;
  EzxN.Free;
  EzyN.Free;
  HxyN.Free;
  HxzN.Free;
  HyxN.Free;
  HyzN.Free;
  HzxN.Free;
  HzyN.Free;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Field arrays are destroyed');
{$ENDIF}
end;

procedure SwapFields(var Field1, Field2: TExtArray);
var
  TempField: TExtArray;
begin
//меняет местами указатели на две компоненты поля
  TempField := Field2;
  Field2 := Field1;
  Field1 := TempField;
end;

//следующие 6 функций возращают значения компонент в точке:
//само значение, если точка внутри системы
//иначе - сумма значений расщепленных компонент

function GetEx(i, j: Integer): Extended;
begin
  if (i >= 0)and(i < SizeX)and(j >= 0)and(j < SizeY) then
    Result := Ex[i, j]
  else
    Result := Exy[i, j] + Exz[i, j];
end;

function GetEy(i, j: Integer): Extended;
begin
  if (i >= 0) and (i < SizeX) and (j >= 0) and (j < SizeY) then
    Result := Ey[i, j]
  else
    Result := Eyx[i, j] + Eyz[i, j];
end;

function GetEz(i, j: Integer): Extended;
begin
  if (i >= 0) and (i < SizeX) and (j >= 0) and (j < SizeY) then
    Result := Ez[i, j]
  else
    Result := Ezx[i, j] + Ezy[i, j];
end;

function GetHx(i, j: Integer): Extended;
begin
  if (i >= 0) and (i < SizeX) and (j >= 0) and (j < SizeY) then
    Result := Hx[i, j]
  else
    Result := Hxy[i, j] + Hxz[i, j];
end;

function GetHy(i, j: Integer): Extended;
begin
  if (i >= 0) and (i < SizeX) and (j >= 0) and (j < SizeY) then
    Result := Hy[i, j]
  else
    Result := Hyx[i, j] + Hyz[i, j];
end;

function GetHz(i, j: Integer): Extended;
begin
  if (i >= 0) and (i < SizeX) and (j >= 0) and (j < SizeY) then
    Result := Hz[i, j]
  else
    Result := Hzx[i, j] + Hzy[i, j];
end;

//следующие 6 функций возращают значения параметров Sigma в точке
//учитывается расстояние до границы ситемы

function GetSigmaX(i, j: Integer): Extended;
begin
  Result := SigmaX;
  if i < 0 then
    Result := SigmaX * Degree(CoefG, -i + 1);
  if i >= SizeX then
    Result := SigmaX * Degree(CoefG, i - SizeX);
end;

function GetSigmaY(i, j: Integer): Extended;
begin
  Result := SigmaY;
  if j < 0 then
    Result := SigmaY * Degree(CoefG, -j + 1);
  if j >= SizeY then
    Result := SigmaY * Degree(CoefG, j - SizeY);
end;

function GetSigmaZ(i, j: Integer): Extended;
begin
  Result := 0;
end;

function GetSigmaXS(i, j: Integer): Extended;
begin
  Result := GetSigmaX(i, j) * MuDivEps;
end;

function GetSigmaYS(i, j: Integer): Extended;
begin
  Result := GetSigmaY(i, j) * MuDivEps;
end;

function GetSigmaZS(i, j: Integer): Extended;
begin
  Result := GetSigmaZ(i, j) * MuDivEps;
end;

procedure ElectrTE(i, j: Integer);
var
  Eps: Extended;
begin
if i = 50 then
begin
  Eps := RegionList.EpsField[i, j] * Eps0
    + RegionList.Eps2Field[i, j] * Eps0 * Sqr(Ez[i, j] / Ez0);
end;
//расчет электрических компонент
  Eps := RegionList.EpsField[i, j] * Eps0
    + RegionList.Eps2Field[i, j] * Eps0 * Sqr(Ez[i, j] / Ez0);
  DzN[i, j] := Dz[i, j]
    + DtDivDx * (Hy[i + 1, j] - Hy[i - 1, j])
    - DtDivDy * (Hx[i, j + 1] - Hx[i, j - 1]);
  if Eps <> 0 then
    EzN[i, j] := DzN[i, j] / Eps
  else
    EzN[i, j] := 0;
end;

procedure MagnTE(i, j: Integer);
begin
//расчет магнитных компонент
  BxN[i, j] := Bx[i, j]
    - DtDivDy * (Ez[i, j + 1] - Ez[i, j - 1]);
  ByN[i ,j] := By[i, j]
    + DtDivDx * (Ez[i + 1, j] - Ez[i - 1, j]);
  HxN[i, j] := BxN[i, j] / Mu0;
  HyN[i, j] := ByN[i, j] / Mu0;
end;

procedure ElectrTM(i, j: Integer);
begin
end;

procedure MagnTM(i, j: Integer);
begin
end;

procedure MetallABC;
var
  i, j: Integer;
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Applying metall');
{$ENDIF}
// металлические граничные условия
  for i := 0 to SizeX - 1 do
  begin
//верхняя стенка
//    Ex[i, 0] := 0;
//    Dx[i, 0] := 0;
    Ez[i, 0] := 0;
    Dz[i, 0] := 0;
//    Ex[i, -1] := -Ex[i, 1];
//    Dx[i, -1] := -Dx[i, 1];
//    Ey[i, -1] := Ey[i, 1];
//    Dy[i, -1] := Dy[i, 1];
    Ez[i, -1] := -Ez[i, 1];
    Dz[i, -1] := -Dz[i, 1];

//нижняя стенка
//    Ex[i, SizeY - 1] := 0;
//    Dx[i, SizeY - 1] := 0;
    Ez[i, SizeY - 1] := 0;
    Dz[i, SizeY - 1] := 0;
//    Ex[i, SizeY] := -Ex[i, SizeY - 2];
//    Dx[i, SizeY] := -Dx[i, SizeY - 2];
//    Ey[i, SizeY] := Ey[i, SizeY - 2];
//    Dy[i, SizeY] := Dy[i, SizeY - 2];
    Ez[i, SizeY] := -Ez[i, SizeY - 2];
    Dz[i, SizeY] := -Dz[i, SizeY - 2];
  end;

  for j := 0 to SizeY-1 do
  begin
//левая стенка
//    Ey[0, j] := 0;
//    Dy[0, j] := 0;
    Ez[0, j] := 0;
    Dz[0, j] := 0;
//    Ex[-1, j] := Ex[1, j];
//    Dx[-1, j] := Dx[1, j];
//    Ey[-1, j] := -Ey[1, j];
//    Dy[-1, j] := -Dy[1, j];
    Ez[-1, j] := -Ez[1, j];
    Dz[-1, j] := -Dz[1, j];

//правая стенка
//    Ey[SizeX - 1, j] := 0;
//   Dy[SizeX - 1, j] := 0;
    Ez[SizeX - 1, j] := 0;
    Dz[SizeX - 1, j] := 0;
//    Ex[SizeX, j] := Ex[SizeX - 2, j];
//    Dx[SizeX, j] := Dx[SizeX - 2, j];
//    Ey[SizeX, j] := -Ey[SizeX - 2, j];
//    Dy[SizeX, j] := -Dy[SizeX - 2, j];
    Ez[SizeX, j] := -Ez[SizeX - 2, j];
    Dz[SizeX, j] := -Dz[SizeX - 2, j];
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Finish of bounds calculations');
{$ENDIF}
end;

procedure AbsElectr;
var
  i, j: Integer;
begin
//расчет электрических расщепленных компонент
  for i := -BoundWidth to SizeX + BoundWidth - 1 do
    for j := -BoundWidth to SizeY + BoundWidth - 1 do
      if (i < 0) or (i >= SizeX) or (j < 0) or (j >= SizeY) then
        case ModeType of
          mtTE :
          begin
{            EzxN[i, j] := Ezx[i, j]
              * Exp(-GetSigmaX(i, j) * DelT / Eps0)
              + 1 / DelX / GetSigmaX(i, j)
              * (GetHy(i + 1, j) - GetHy(i - 1, j))
              * (1 - Exp(-GetSigmaX(i ,j) * DelT / Eps0));}
            EzxN[i, j] := Ezx[i, j]
              * SigmaXCoeffs[i, j]
              + OneDivSigmaX[i, j]
              * (GetHy(i + 1, j) - GetHy(i - 1, j))
              * (1 - SigmaXCoeffs[i, j]);
            EzyN[i, j] := Ezy[i, j]
              * SigmaXCoeffs[i, j]
              - OneDivSigmaY[i, j]
              * (GetHx(i, j + 1) - GetHx(i, j - 1))
              * (1 - SigmaYCoeffs[i, j]);
          end;
          mtTM :
          begin
            ExyN[i, j] := Exy[i, j]
              * Exp( -GetSigmaY(i, j) * DelT / Eps0)
              + 1 / DelY / GetSigmaY(i, j)
              * (GetHz(i, j + 1) - GetHz(i, j - 1))
              * (1 - Exp(-GetSigmaY(i, j) * DelT / Eps0));
            ExzN[i, j] := Exz[i, j]
              * Exp(-GetSigmaZ(0, 0) * DelT / Eps0);
            EyxN[i, j] := Eyx[i, j]
              * Exp(-GetSigmaX(i, j) * DelT / Eps0)
              - 1 / DelX / GetSigmaX(i, j)
              * (GetHz(i + 1, j) - GetHz(i - 1, j))
              * (1 - Exp(-GetSigmaX(i, j) * DelT / Eps0));
            EyzN[i, j] := Eyz[i, j]
              * Exp(-GetSigmaZ(0, 0) * DelT / Eps0);
          end;
        end;
end;

procedure AbsMagn;
var
  i, j: Integer;
begin
//расчет магнитных расщепленных компонент
  for i := -BoundWidth to SizeX + BoundWidth - 1 do
    for j := -BoundWidth to SizeY + BoundWidth - 1 do
      if (i < 0) or (i >= SizeX) or (j < 0) or (j >= SizeY) then
        case ModeType of
          mtTE :
          begin
{            HxyN[i, j] := Hxy[i, j]
              * Exp(-GetSigmaYS(i, j) * DelT / Mu0)
              - 1 / DelY / GetSigmaYS(i, j)
              * (GetEz(i, j + 1) - GetEz(i, j - 1))
              * (1 - Exp(-GetSigmaYS(i, j) * DelT / Mu0));
            HxzN[i, j] := Hxz[i, j]
              * Exp(-GetSigmaZS(0, 0) * DelT / Mu0);
            HyxN[i, j] := Hyx[i, j]
              * Exp(-GetSigmaXS(i, j) * DelT / Mu0)
              + 1 / DelX / GetSigmaXS(i, j)
              * (GetEz(i + 1, j) - GetEz(i - 1, j))
              * (1 - Exp(-GetSigmaXS(i, j) * DelT / Mu0));
            HyzN[i, j] := Hyz[i, j]
              * Exp(-GetSigmaZS(0, 0) * DelT / Mu0);}
            HxyN[i, j] := Hxy[i, j]
              * SigmaYSCoeffs[i, j]
              - OneDivSigmaYS[i, j]
              * (GetEz(i, j + 1) - GetEz(i, j - 1))
              * (1 - SigmaYSCoeffs[i, j]);
            HxzN[i, j] := Hxz[i, j]
              * SigmaZSCoeffs[i, j];
            HyxN[i, j] := Hyx[i, j]
              * SigmaXSCoeffs[i, j]
              + OneDivSigmaXS[i, j]
              * (GetEz(i + 1, j) - GetEz(i - 1, j))
              * (1 - SigmaXSCoeffs[i, j]);
            HyzN[i, j] := Hyz[i, j]
              * SigmaZSCoeffs[i, j];
          end;
          mtTM :
          begin
            HzxN[i, j] := Hzx[i, j]
              * Exp(-GetSigmaXS(i, j) * DelT / Mu0)
              - 1 / DelX / GetSigmaXS(i, j)
              * (GetEy(i + 1, j) - GetEy(i - 1, j))
              * (1 - Exp(-GetSigmaXS(i, j) * DelT / Mu0));
            HzyN[i, j] := Hzy[i, j]
              * Exp(-GetSigmaYS(i, j) * DelT / Mu0)
              + 1 / DelY / GetSigmaYS(i, j)
              * (GetEx(i, j + 1) - GetEx(i, j - 1))
              * (1 - Exp(-GetSigmaYS(i, j) * DelT / Mu0));
          end;
        end;
end;

procedure AbsLayersABC;
var
  i, j: Integer;
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Applying ABC');
{$ENDIF}
//граничные условия - поглощающие слои
//перешагивание во времени
  if (Tn + 2) mod 2 = 0 then
  begin
    AbsElectr;
    for i := -1 to SizeX do
    begin
      Ex[i, -1] := GetEx(i, -1);
      Ey[i, -1] := GetEy(i, -1);
      Ez[i, -1] := GetEz(i, -1);
      Ex[i, SizeY] := GetEx(i, SizeY);
      Ey[i, SizeY] := GetEy(i, SizeY);
      Ez[i, SizeY] := GetEz(i, SizeY);
    end;
    for j := -1 to SizeY do
    begin
      Ex[-1, j] := GetEx(-1, j);
      Ey[-1, j] := GetEy(-1, j);
      Ez[-1, j] := GetEz(-1, j);
      Ex[SizeX, j] := GetEx(SizeX, j);
      Ey[SizeX, j] := GetEy(SizeX, j);
      Ez[SizeX, j] := GetEz(SizeX, j);
    end;
  end
  else
  begin
    AbsMagn;
    for i := -1 to SizeX do
    begin
      Hx[i, -1] := GetHx(i, -1);
      Hy[i, -1] := GetHy(i, -1);
      Hz[i, -1] := GetHz(i, -1);
      Hx[i, SizeY] := GetHx(i, SizeY);
      Hy[i, SizeY] := GetHy(i, SizeY);
      Hz[i, SizeY] := GetHz(i, SizeY);
    end;
    for j := -1 to SizeY do
    begin
      Hx[-1, j] := GetHx(-1, j);
      Hy[-1, j] := GetHy(-1, j);
      Hz[-1, j] := GetHz(-1, j);
      Hx[SizeX, j] := GetHx(SizeX, j);
      Hy[SizeX, j] := GetHy(SizeX, j);
      Hz[SizeX, j] := GetHz(SizeX, j);
    end;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Finish of bounds calculations');
{$ENDIF}
end;

procedure Next;
begin
//переход к следующему шагу
//учет граничных условий
  case RegionList.BoundsType of
    btMetall : MetallABC;
    btAbsorb : AbsLayersABC;
  end;
//замена массивов со старыми значениями на массивы с новыми
//значениями с учетом перешагивания во времени
  if (Tn + 2) mod 2 = 0 then
  begin
    SwapFields(Ex, ExN);
    SwapFields(Ey, EyN);
    SwapFields(Ez, EzN);
    SwapFields(Dx, DxN);
    SwapFields(Dy, DyN);
    SwapFields(Dz, DzN);
    SwapFields(Exy, ExyN);
    SwapFields(Exz, ExzN);
    SwapFields(Eyx, EyxN);
    SwapFields(Eyz, EyzN);
    SwapFields(Ezx, EzxN);
    SwapFields(Ezy, EzyN);
  end
  else
  begin
    SwapFields(Hx, HxN);
    SwapFields(Hy, HyN);
    SwapFields(Hz, HzN);
    SwapFields(Bx, BxN);
    SwapFields(By, ByN);
    SwapFields(Bz, BzN);
    SwapFields(Hxy, HxyN);
    SwapFields(Hxz, HxzN);
    SwapFields(Hyx, HyxN);
    SwapFields(Hyz, HyzN);
    SwapFields(Hzx, HzxN);
    SwapFields(Hzy, HzyN);
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Arrays are swapped');
{$ENDIF}
end;

procedure SetSigmaCoeffs;
var
  i, j: Integer;
begin
  SigmaXCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  SigmaYCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  SigmaZCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);

  SigmaXSCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  SigmaYSCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  SigmaZSCoeffs := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);

  OneDivSigmaX := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  OneDivSigmaY := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);

  OneDivSigmaXS := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);
  OneDivSigmaYS := TExtArray.Create(vtExtended, SizeX + 2 * BoundWidth,
    SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
    -BoundWidth, -BoundWidth);

  for i := -BoundWidth to SizeX + BoundWidth - 1 do
    for j := -BoundWidth to SizeY + BoundWidth - 1 do
      if (i < 0) or (i >= SizeX) or (j < 0) or (j >= SizeY) then
      begin
        SigmaXCoeffs[i, j] := Exp(-GetSigmaX(i, j) / Eps0 * DelT);
        SigmaYCoeffs[i, j] := Exp(-GetSigmaY(i, j)  / Eps0 * DelT);
        SigmaXSCoeffs[i, j] := Exp(-GetSigmaXS(i, j) / Mu0 * DelT);
        SigmaYSCoeffs[i, j] := Exp(-GetSigmaYS(i, j) / Mu0 * DelT);
        OneDivSigmaX[i, j] := 1 / DelX / GetSigmaX(i, j);
        OneDivSigmaY[i, j] := 1 / DelY / GetSigmaY(i, j);
        OneDivSigmaXS[i, j] := 1 / DelX / GetSigmaXS(i, j);
        OneDivSigmaYS[i, j] := 1 / DelY / GetSigmaYS(i, j);
      end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Sigma arrays are created and set');
{$ENDIF}
end;

procedure FreeSigmaCoeffs;
begin
  if Assigned(SigmaXCoeffs) then
    SigmaXCoeffs.Free;
  if Assigned(SigmaYCoeffs) then
    SigmaYCoeffs.Free;
  if Assigned(SigmaZCoeffs) then
    SigmaZCoeffs.Free;
  if Assigned(SigmaXSCoeffs) then
    SigmaXSCoeffs.Free;
  if Assigned(SigmaYSCoeffs) then
    SigmaYSCoeffs.Free;
  if Assigned(SigmaZSCoeffs) then
    SigmaZSCoeffs.Free;
  if Assigned(OneDivSigmaX) then
    OneDivSigmaX.Free;
  if Assigned(OneDivSigmaY) then
    OneDivSigmaY.Free;
  if Assigned(OneDivSigmaXS) then
    OneDivSigmaXS.Free;
  if Assigned(OneDivSigmaYS) then
    OneDivSigmaYS.Free;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Sigma arrays are destroyed');
{$ENDIF}
end;

procedure SetIntMode;
var
  Number, Count: Integer;
begin
  IntFModeEz := TExtArray.Create(vtExtended, 1, SizeY, 0, 0, 0, 0, 0, 0);
  IntFModeHy := TExtArray.Create(vtExtended, 1, SizeY, 0, 0, 0, 0, 0, 0);
  Number := -1;
  Count := 0;
  while Number < SelfModeNumber do
  begin
    if (RegionList.FieldList[Count].FieldType = ftRectSelf)
      or (RegionList.FieldList[Count].FieldType = ftRectSelf2) then
      Inc(Number);
    Inc(Count);
  end;
{  TRectSelfField(RegionList.FieldList[Number]).FillEzMax(IntFModeEz);
  TRectSelfField(RegionList.FieldList[Number]).FillHyMax(IntFModeHy);}
  RegionList.FieldList[Number].FillEzMax(IntFModeEz);
  RegionList.FieldList[Number].FillHyMax(IntFModeHy);
  BettaX := RegionList.FieldList[Number].BettaX;
  BettaY := RegionList.FieldList[Number].BettaY;
end;

function CalcIntegral(Forw: Boolean): Extended;
var
  j: Integer;
  One: ShortInt;
  Int1, Int2, Coef: Extended;
begin
  Int1 := 0;
  Int2 := 0;

  One := Ord(Forw) * 2 - 1;
  Coef := BettaY / BettaX / Z0;

  for j := 1 to SizeY - 2 do
    if (IntX + j + 2) mod 2 = 0 then
    begin
      Int1 := Int1 + Ez[IntX, j] * IntFModeEz[0, j];
      Int2 := Int2 + (Hy[IntX, j - 1] + Hy[IntX, j + 1]) * IntFModeEz[0, j];
    end;

  Result := (One * Int1 * Coef + Int2 * 0.5) {* DelY};
end;

procedure AddValues;
begin
  if GrF1.Enable then
    GPoints1.Add(Tn, GrF1.Field^[XGr1, YGr1]);
  if GrF2.Enable then
    GPoints2.Add(Tn, GrF2.Field^[XGr2, YGr2]);
  Inc(LastAdded);
end;

procedure AddIntValues;
begin
  IntFPoints.Add(Tn, CalcIntegral(True));
  IntBPoints.Add(Tn, CalcIntegral(False));
  Inc(LastAddedI);
end;

end.
