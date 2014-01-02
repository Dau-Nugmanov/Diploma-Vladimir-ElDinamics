unit Common6;

{Модуль, содержащий основные переменные и константы
Ex..Bz - массивы компонент со старыми значениями
ExN..BzN - массивы компонент с новыми значениями
Exy..Hzy и ExyN..HzyN - расщепленные компоненты внутри поглощающих
  слоев
WaveF, GrF1, GrF2 и CompF1..CompF4 - указатели на массивы компонент
  для прорисовки волны, графиков и компонент
ColorArray - массив с градиентом цветов (для рисунка волны)
SizeX и SizeY - размер ситсемы в количестве узлов сетки
Lx и Ly - реальные размеры системы
Tn - текущий временной шаг
BoundWidth - ширина поглощающих слоев
XGr1, XGr2, YGr1 и YGr2 - координаты точек, в которых строятя
  графики (от времени)
FixY и FixX - координаты линий, вдоль которых строятся графики
  компонент (от координаты)
ModeType - мода начального возмущения
SigmaX, SigmaY, SigmaZ, SigmaXS, SigmaYS и SigmaZS - параметры
  (проводимости) для поглощающих слоев
CoefG - коэффициент геометрической прогрессии G, определяющий
  изменение Sigma внутри слоев;
CompCoord - определяет направление (вдоль X или Y) построения
  графиков компонент;
ProcessState - состояние процесса
DelX, DelY - пространственнные шаги (dx, dy)
DelT - временной шаг (dt)
ScaleCoef - масштаб рисунка волны;
WaveBitmap - Bitmap для рсунка волны;
AutoStopTime - время, через которое должен включиться автостоп,
  если <0, то автостоп выключен
MouseOnWave и MouseOnComp1..MouseOnComp4 - находится ли курсор мыши
  на рисунке волны или на компоненте
XMouse и YMouse - координаты курсора мыши
InitialWave - тип начального возмущения
InitialX1, InitialX2, InitialY1 и InitialY2 - определяют границы
  области начальрого возмущения
HalfPX и HalfPY - количество полупериодов начального импульса
ExpX и ExpY - показатель степени экспоненты для распределения
  Гаусса
WhiteValue и BlackValue - определяют минимальное (которое рисуется
  белым цветом) и максимальное (черный цвет) значения для рисунка
  волны
DrawRecord - содержит настройки для рисования
Saving - множество объектов для сохранения
ValuesFile1 и ValuesFile2 - файлы для записи значений графиков
ReportFile - файл отчета
WavePath, CompPath, GraphPath, ValuesPath и ReportPath - пути для
  сохранения
MainPath - рабочий каталог программы
EditorPath - путь к редактору
Written - количество занесенных в файл значений
CompSaveCount, WaveSaveCount и GraphSaveCount - количество
  сохранений
SaveOnActivePage - сохранение на активной странице
AutoSave - автосохранение вкл/выкл
ToRewrite - нужно ли перезаписывать имеющиеся файлы
AutoSaveTime - период автосохранения}

{$D-}


interface

uses
  Graphics, VCLUtils, Classes, ExtArr, Regions, IniFiles, Registry, PhisCnst,
  EditMess, Grapher;

const
  SizeX0 = 201;
  SizeY0 = 101;
  DelX0 = 1e-6;
  DelY0 = DelX0;
  Lx0 = DelX0 * SizeX0;
  Ly0 = DelY0 * SizeY0;
  DelT0 = DelX0 / 9 / C;
  Ez0 = 100;
  Hz0 = 100 / Z0;
  BoundWidth0 = 30;
  G = 2.0;
  IntX: Integer = 100;

  ValuesFile1Name = 'Values1.txt';
  ValuesFile2Name = 'Values2.txt';
  ReportFileName = 'Report.txt';
//  MainPath: string = '';
  SelfModeNumber: Integer = 0;

type
  TColorArray = array[0..255] of TColor;
  TModeType = (mtTE, mtTM);
  TFieldType = (ftEType, ftDType, ftHType, ftBType);
  TCompCoord = (ccHoriz, ccVert);
  TProcessState = (psStoped, psRuning, psPaused);
  TInitialWave = (iwSin, iwGauss);
  TToDraw = (tdEachStep, tdOnStep, tdOnTime);
  TDrawObjects = (doWave, doComponents, doGraphics, doFourier);
  TDrawObjectsSet = set of TDrawObjects;
  TInitialStyle = (isFromMedium, isManual);
  TInitialStyleSet = set of TInitialStyle;

{указатель на компоненту
Enable  - прорисовывать ли данную компоненту (нужно для графиков)}
  TFieldPointer = record
    Field: ^TExtArray;
    FieldType: TFieldType;
    Enable: Boolean;
  end;

{настройки прорисовки
ReadyToDraw - готовность к прорисовке
ObjectsSet - оределяет то, что нужно рисовать
ToDraw - частота прорисовки}
  TDrawRecord = record
    ReadyToDraw: Boolean;
    ObjectsSet: TDrawObjectsSet;
    case ToDraw: TToDraw of
      tdEachStep : ();
      tdOnStep   : (StepCount: Integer);
      tdOnTime   : (Time: Extended);
  end;

var
  Ex, Ey, Ez, Dx, Dy, Dz, Hx, Hy, Hz, Bx, By, Bz,
  ExN, EyN, EzN, DxN, DyN, DzN, HxN, HyN, HzN,
  BxN, ByN, BzN: TExtArray;
  Exy, Exz, Eyx, Eyz, Ezx, Ezy, Hxy, Hxz, Hyx, Hyz,
  Hzx, Hzy, ExyN, ExzN, EyxN, EyzN, EzxN, EzyN,
  HxyN, HxzN, HyxN, HyzN, HzxN, HzyN: TExtArray;
  WaveF, GrF1, GrF2, CompF1, CompF2, CompF3,
  CompF4, CompF5, CompF6, FourierF1, FourierF2: TFieldPointer;
{  ColorArray: TColorArray;}
  SizeX, SizeY, Tn, BoundWidth: Integer;
  Lx, Ly: Extended;
  XGr1, XGr2, YGr1, YGr2, FixY, FixX, FourX1, FourX2: Integer;
  ModeType: TModeType;
  SigmaX, SigmaY, SigmaZ, SigmaXS, SigmaYS, SigmaZS, CoefG: Extended;
  CompCoord: TCompCoord;
  ProcessState: TProcessState;
  DelX, DelY, DelT, DtDivDx, DtDivDy, ScaleCoef: Extended;
  WaveBitmap: TBitmap;
  AutoStopTime: Integer;
  MouseOnWave, MouseOnComp1, MouseOnComp2, MouseOnComp3,
  MouseOnComp4: Boolean;
  XMouse, YMouse: Integer;
  InitialWave: TInitialWave;
  InitialX1, InitialX2, InitialY1, InitialY2, HalfPX, HalfPY: Integer;
  ExpX, ExpY: Extended;
  WhiteValue, BlackValue: Extended;
  DrawGraphicsPoints: Boolean;
  DrawRecord: TDrawRecord;
  Saving: TDrawObjectsSet;
  ValuesFile1, ValuesFile2, ReportFile: Text;
  WavePath, CompPath, GraphPath, ValuesPath, ReportPath, FourPath: string;
  {MainPath,} EditorPath: string;
  Written, CompSaveCount, WaveSaveCount, GraphSaveCount: Integer;
  SaveOnActivePage, AutoSave, ToRewrite: Boolean;
  AutoSaveTime: Integer;
  InitialStyleSet: TInitialStyleSet;
  GPoints1, GPoints2, IntFPoints, IntBPoints: TPoints;
  IntFModeEz, IntFModeHy: TExtArray;
  BettaX, BettaY: Extended;
  IntEnable: Boolean;
  LastAdded, LastAddedI: Integer;
  SigmaXCoeffs, SigmaYCoeffs, SigmaZCoeffs,
  SigmaXSCoeffs, SigmaYSCoeffs, SigmaZSCoeffs,
  OneDivSigmaX, OneDivSigmaY, OneDivSigmaXS, OneDivSigmaYS: TExtArray;

{$IFDEF WRPROCESS}
var
  PrFile: Text;
{$ENDIF}

implementation

begin
{$IFDEF WRPROCESS}
  AssignFile(PrFile, 'Process.txt');
  Rewrite(PrFile);
{$ENDIF}
//начальная установка параметров
  EditorPath := MainPath + 'Editor\';

  RegionList := TRegionList.Create;
  BoundWidth := BoundWidth0;
  SigmaX := 2 * Pi * Eps0 / 1000;
  SigmaY := 2 * Pi * Eps0 / 1000;
  SigmaZ := 0;
  SigmaXS := SigmaX * Mu0 / Eps0;
  SigmaYS := SigmaY * Mu0 / Eps0;
  SigmaZS := 0;
  CoefG := G;
  SizeX := SizeX0;
  SizeY := SizeY0;
  Lx := Lx0;
  Ly := Ly0;
  DelT := DelT0;
  DelX := DelX0;
  DelY := DelY0;
  DtDivDx := DelT / DelX;
  DtDivDy := DelT / DelY;
  ModeType := mtTE;
  InitialWave := iwSin;
  InitialX1 := 50;
  InitialX2 := 150;
  InitialY1 := 0;
  InitialY2 := SizeY - 1;
  HalfPX := 4;
  HalfPY := 1;
  ExpX := 0.1;
  ExpY := 0.1;
  DrawGraphicsPoints := True;
  DrawRecord.ToDraw := tdEachStep;
  DrawRecord.ReadyToDraw := True;
  DrawRecord.ObjectsSet := [doWave..doFourier];
  Saving := [doWave..doFourier];
  WaveSaveCount := -1;
  CompSaveCount := -1;
  GraphSaveCount := -1;
  SaveOnActivePage := False;
  ToRewrite := True;
  AutoSave := False;
  AutoSaveTime := 1;
  ScaleCoef := 1.0;
  WhiteValue := 0;
  BlackValue := 1.50;
  InitialStyleSet := [isFromMedium, isManual];
  FourX1 := 20;
  FourX2 := 40;

  GPoints1 := TPoints.Create;
  GPoints2 := TPoints.Create;
  IntFPoints := TPoints.Create;
  IntBPoints := TPoints.Create;
  IntEnable := False;
  LastAdded := 0;
  LastAddedI := 0;
end.
