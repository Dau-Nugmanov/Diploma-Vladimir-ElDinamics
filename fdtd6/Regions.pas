unit Regions;

{Модуль, содержащий объекты среды

TFigure - базовый класс, описывающий форму объекта
TRect, TCircle, TEllipse, THalfSpace - классы (наследники
  TFigure), описывающие прямоугольник, окружность, эллипс
  и полуплоскость соответсвенно
TRegion - отдельный объект среды
TField - область поля (начального возмущения)
TFieldList - совокупность всех полей
TRegionList - совокупность всех объектов и полей, определяет
  свойства среды
TMovingShape - базовый класс (имеющий предком TShape, а значит
  являющийся визуальной компонентой), способный перетаскиваться
  мышкой
TShapeRegion - отдельный объект среды, но являющийся наследником
  класса TMovingShape (используется редактором)
TShapeField - тоже для поля
TShapeFieldList - совокупность всех объектов TShapeField
  (входит в TShapeList)
TShapeList - совокупность всех объектов TShapeRegion, связан
  с глобальной переменной RegionList}

{$D+}

interface

uses
  Windows, Classes, Graphics, ExtCtrls, Controls, Menus, SysUtils, ExtArr,
  ColorUnit, PhisCnst, Math, ExtMath;

const
  FileCode=13031979;

type
  TBoundsType = (btMetall, btAbsorb);
  TContourShape = (shRect, shCircle, shEllipse, shHalfSpace);
  TOrientation = (orLeft, orRight, orTop, orBottom);
  TMatterType = (mtVacuum, mtMetall, mtDielectr);
  THorAlign = (haLeft, haCenter, haRight, haNo);
  TVertAlign = (vaTop, vaCenter, vaBottom, vaNo);
  TResizeDirection = (rdLeft, rdRight, rdUp, rdDown);
  TMouseAction = (maMove, maResize);
  TInitialFieldType = (ftSin, ftGauss, ftRectSelf, ftRectSelf2);

{TFigure
методы:
  CustomDraw - прорисовка объекта на Canvas, вызывается методами
    Draw и DrawContour
  Draw - прорисовка объекта: вакуум белым цветом, металл - черным,
    диэлектрик заштрихован
  DrawContour - прорисовка только контура
  Point1 и Point2 - контрольные точки объекта, по которым определяется
    вложенность объектов друг в друга
  Belong - возращает True, если точка (X, Y) принадлежит данному
    объекту
  BelongContour - возращает True, если точка (X, Y) принадлежит
    контору (границе) данного объекта
  Align - выравнивание объекта, SizeX и SizeY - границы области
свойства:
  CoordX и CoordY - координаты расположения объекта
  Shape - форма объекта
  Param1 и Param2 - некие параметры формы объекта, переопределяются
    наследниками}
  TFigure = class (TPersistent)
  protected
    FShape: TContourShape;
    procedure CustomDraw(Canvas: TCanvas; Height, Width :Integer); virtual; abstract;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer); virtual; abstract;
    procedure DrawContour(var Canvas: TCanvas; Height, Width :Integer); virtual; abstract;
    function GetParam1: Integer; virtual; abstract;
    function GetParam2: Integer; virtual; abstract;
    procedure SetParam1(Value: Integer); virtual; abstract;
    procedure SetParam2(Value: Integer); virtual; abstract;
  public
    CoordX,
    CoordY: Integer;
    property Shape: TContourShape read FShape write FShape;
    property Param1: Integer read GetParam1 write SetParam1;
    property Param2: Integer read GetParam2 write SetParam2;
    constructor Create;
    function Point1: TPoint; virtual; abstract;
    function Point2: TPoint; virtual; abstract;
    function Belong(X, Y: Integer): Boolean; virtual; abstract;
    function BelongContour(X, Y: Integer): Boolean; virtual; abstract;
    procedure Align(HorAlign: THorAlign; VertAlign: TVertAlign;
      SizeX, SizeY: Integer); virtual; abstract;
  end;

{TRect (см. TFigure)
методы:
  Point1 - верхняя левая точка = (CoordX, CoordY)
  Point2 - нижняя правая точка
свойства:
  HorSize - длина = Param1
  VertSize - высота = Param2}
  TRect = class (TFigure)
  private
    FHorSize,
    FVertSize: Integer;
  protected
    procedure CustomDraw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure DrawContour(var Canvas: TCanvas; Height, Width :Integer); override;
    function GetParam1: Integer; override;
    function GetParam2: Integer; override;
    procedure SetParam1(Value: Integer); override;
    procedure SetParam2(Value: Integer); override;
  public
    property HorSize: Integer read FHorSize write FHorSize;
    property VertSize: Integer read FVertSize write FVertSize;
    constructor Create;
    function Point1: TPoint; override;
    function Point2: TPoint; override;
    function Belong(X, Y: Integer): Boolean; override;
    function BelongContour(X, Y: Integer): Boolean; override;
    procedure Align(HorAlign: THorAlign; VertAlign: TVertAlign;
      SizeX, SizeY: Integer); override;
  end;

{TCircle (см. TFigure)
методы:
  Point1 - самая левая точка
  Point2 - самая правая точка
свойства:
  Radius - радиус
  CoordX, CoordY - определяют центр
  Param1, Param2 = Radius}
  TCircle = class (TFigure)
  private
    FRadius: Integer;
  protected
    procedure CustomDraw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure DrawContour(var Canvas: TCanvas; Height, Width :Integer); override;
    function GetParam1: Integer; override;
    function GetParam2: Integer; override;
    procedure SetParam1(Value: Integer); override;
    procedure SetParam2(Value: Integer); override;
  public
    property Radius: Integer read FRadius write FRadius;
    constructor Create;
    function Point1: TPoint; override;
    function Point2: TPoint; override;
    function Belong(X, Y: Integer): Boolean; override;
    function BelongContour(X, Y: Integer): Boolean; override;
    procedure Align(HorAlign: THorAlign; VertAlign: TVertAlign;
      SizeX, SizeY: Integer); override;
  end;

{TEllipse (см. TFigure)
методы:
  Point1 - самая левая точка
  Point2 - самая правая точка
свойства:
  HorAxel - горизонтальная ось (длина прямоугольника, описанного
    вогруг эллипса) = Param1
  VertAxel - вертикальная ось (высота прямоугольника, описанного
    вогруг эллипса) = Param2
  CoordX, CoordY - центр эллипса}
  TEllipse = class (TFigure)
  private
    FHorAxel,
    FVertAxel: Integer;
  protected
    procedure CustomDraw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure DrawContour(var Canvas: TCanvas; Height, Width :Integer); override;
    function GetParam1: Integer; override;
    function GetParam2: Integer; override;
    procedure SetParam1(Value: Integer); override;
    procedure SetParam2(Value: Integer); override;
  public
    property HorAxel: Integer read FHorAxel write FHorAxel;
    property VertAxel: Integer read FVertAxel write FVertAxel;
    constructor Create;
    function Point1: TPoint; override;
    function Point2: TPoint; override;
    function Belong(X, Y: Integer): Boolean; override;
    function BelongContour(X, Y: Integer): Boolean; override;
    procedure Align(HorAlign: THorAlign; VertAlign: TVertAlign;
      SizeX, SizeY: Integer); override;
  end;

{THalfSpace (см. TFigure)
методы:
  Point1 и Point2 - возращают точку (CoordX, CoordY)
свойства:
  Orientation - направление (ориентация) полуплоскости
  CoordX и CoordY - одна из координат определяет границу
    полуплоскости (какая из них - зависит от направления), другая
    неопределена
  Param1 и Param2 - возвращают Orientation}
  THalfSpace = class (TFigure)
  private
    FOrientation: TOrientation;
  protected
    procedure CustomDraw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer); override;
    procedure DrawContour(var Canvas: TCanvas; Height, Width :Integer); override;
    function GetParam1: Integer; override;
    function GetParam2: Integer; override;
    procedure SetParam1(Value: Integer); override;
    procedure SetParam2(Value: Integer); override;
  public
    property Orientation: TOrientation read FOrientation write FOrientation;
    constructor Create;
    function Point1: TPoint; override;
    function Point2: TPoint; override;
    function Belong(X, Y: Integer): Boolean; override;
    function BelongContour(X, Y: Integer): Boolean; override;
    procedure Align(HorAlign: THorAlign; VertAlign: TVertAlign;
      SizeX, SizeY: Integer); override;
  end;

  TParentMouseEvent = procedure(Sender: TObject; X, Y: Integer) of object;

{TRegion :
методы :
  CreateFigure - придает объекту форму, определяемую AShape
  Assign - присвоить данному объекту все свойства объета Source
свойства :
  Eps - диэлектрическая проницаемость
  Figure - определяет геометрию объекта
  CoordX и CoordY - положение объекта
  MatterType - вещество (вакуум, диэлектрик или металл)}
  TRegion = class(TPersistent)
  private
    FEps: Extended;
    FEps2: Extended;
  protected
    procedure SetEps(Value: Extended);
    function GetEps: Extended;
    procedure SetEps2(Value: Extended);
    function GetEps2: Extended;
  public
    Figure: TFigure;
    MatterType: TMatterType;
    property Eps:Extended read GetEps write SetEps;
    property Eps2:Extended read GetEps2 write SetEps2;
    constructor Create;
    destructor Destroy; override;
    procedure CreateFigure(AShape: TContourShape);
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TMemoryStream);
    function LoadFromStream(Stream: TMemoryStream): Boolean;
  end;

{TField
методы:
  CreateArrays - выделить память под массивы
  CreateTempArrays - выделить память под временные массивы
  FreeArrays - очистить память, выделенную под массивы
  FreeTempArrays - очистить память, выделенную под
    временные массивы
  StoreArrays - сохранить значения массивов во временные
  UnStoreArrays - вернуть значения массивов
  Realloc - изменить размеры поля (а значит перераспределить
    память)
свойства:
  SizeOfX и SizeOfY - размеры поля
  StartX и StartY - координаты начала области, в которой
    задается поле (верхняя левая точка)
  Ex, Ey, Ez, Dx, Dy, Dz, Hx, Hy, Hz, Bx, By, Bz - массивы
    значений компонент
  ExT, EyT, EzT, DxT, DyT, DzT, HxT, HyT, HzT, BxT, ByT, BzT -
    временные массивы (используются для сохранения значений
    основных при перераспределении памяти (Realloc))}
  TField = class(TPersistent)
  private
    FSizeOfX,
    FSizeOfY,
    FStartX,
    FStartY: Integer;
    FEx, FEy, FEz,
    FDx, FDy, FDz,
    FBx, FBy, FBz,
    FHx, FHy, FHz: TExtArray;
    FExT, FEyT, FEzT,
    FDxT, FDyT, FDzT,
    FBxT, FByT, FBzT,
    FHxT, FHyT, FHzT: TExtArray;
    ArraysExist: Boolean;
    procedure CreateArrays;
    procedure CreateTempArrays;
    procedure FreeArrays;
    procedure FreeTempArrays;
    procedure StoreArrays;
    procedure UnStoreArrays;
  public
    property SizeOfX: Integer read FSizeOfX;
    property SizeOfY: Integer read FSizeOfY;
    property StartX: Integer read FStartX;
    property StartY: Integer read FStartY;
    property Ex: TExtArray read FEx;
    property Ey: TExtArray read FEy;
    property Ez: TExtArray read FEz;
    property Dx: TExtArray read FDx;
    property Dy: TExtArray read FDy;
    property Dz: TExtArray read FDz;
    property Bx: TExtArray read FBx;
    property By: TExtArray read FBy;
    property Bz: TExtArray read FBz;
    property Hx: TExtArray read FHx;
    property Hy: TExtArray read FHy;
    property Hz: TExtArray read FHz;
    constructor Create(ASizeOfX, ASizeOfY, AStartX, AStartY: Integer);
    destructor Destroy; override;
    procedure Realloc(ASizeOfX, ASizeOfY, AStartX, AStartY: Integer);
  end;

  TField2 = class (TPersistent)
  private
    FFieldType: TInitialFieldType;
    FSizeOfX,
    FSizeOfY,
    FStartX,
    FStartY: Integer;
    FHalfX,
    FHalfY: Integer;
    FBettaX,
    FBettaY: Extended;
    FOnSetup: TNotifyEvent;
  protected
    procedure Realloc(FieldComp: TExtArray);
    procedure Setup;
  public
    property FieldType: TInitialFieldType read FFieldType;
    property SizeOfX: Integer read FSizeOfX;
    property SizeOfY: Integer read FSizeOfY;
    property StartX: Integer read FStartX;
    property StartY: Integer read FStartY;
    property HalfX: Integer read FHalfX;
    property HalfY: Integer read FHalfY;
    property BettaX: Extended read FBettaX;
    property BettaY: Extended read FBettaY;
    property OnSetup: TNotifyEvent read FOnSetup write FOnSetup;
    procedure SetField(ASizeX, ASizeY, AStartX, AStartY,
      AHalfX, AHalfY: Integer);
    procedure FillEx(Ex: TExtArray); virtual; abstract;
    procedure FillEy(Ey: TExtArray); virtual; abstract;
    procedure FillEz(Ez: TExtArray); virtual; abstract;
    procedure FillDx(Dx: TExtArray); virtual; abstract;
    procedure FillDy(Dy: TExtArray); virtual; abstract;
    procedure FillDz(Dz: TExtArray); virtual; abstract;
    procedure FillBx(Bx: TExtArray); virtual; abstract;
    procedure FillBy(By: TExtArray); virtual; abstract;
    procedure FillBz(Bz: TExtArray); virtual; abstract;
    procedure FillHx(Hx: TExtArray); virtual; abstract;
    procedure FillHy(Hy: TExtArray); virtual; abstract;
    procedure FillHz(Hz: TExtArray); virtual; abstract;
    procedure FillEzMax(Ez: TExtArray); virtual; abstract;
    procedure FillHyMax(Hy: TExtArray); virtual; abstract;
    procedure SaveToStream(Stream: TMemoryStream); virtual;
    function LoadFromStream(Stream: TMemoryStream): boolean; virtual;
    procedure Assign(Source: TField2); virtual;
  end;

  TSinField = class (TField2)
  public
    constructor Create;
    procedure FillEx(Ex: TExtArray); override;
    procedure FillEy(Ey: TExtArray); override;
    procedure FillEz(Ez: TExtArray); override;
    procedure FillDx(Dx: TExtArray); override;
    procedure FillDy(Dy: TExtArray); override;
    procedure FillDz(Dz: TExtArray); override;
    procedure FillBx(Bx: TExtArray); override;
    procedure FillBy(By: TExtArray); override;
    procedure FillBz(Bz: TExtArray); override;
    procedure FillHx(Hx: TExtArray); override;
    procedure FillHy(Hy: TExtArray); override;
    procedure FillHz(Hz: TExtArray); override;
    procedure FillEzMax(Ez: TExtArray); override;
    procedure FillHyMax(Hy: TExtArray); override;
    procedure SaveToStream(Stream: TMemoryStream); override;
    function LoadFromStream(Stream: TMemoryStream): boolean; override;
  end;

  TGaussField = class (TField2)
  private
    FExpX,
    FExpY: Extended;
  public
    property ExpX: Extended read FExpX;
    property ExpY: Extended read FExpY;
    constructor Create;
    procedure SetField(ASizeX, ASizeY, AStartX, AStartY,
      AHalfX, AHalfY: Integer; AExpX, AExpY: Extended);
    procedure FillEx(Ex: TExtArray); override;
    procedure FillEy(Ey: TExtArray); override;
    procedure FillEz(Ez: TExtArray); override;
    procedure FillDx(Dx: TExtArray); override;
    procedure FillDy(Dy: TExtArray); override;
    procedure FillDz(Dz: TExtArray); override;
    procedure FillBx(Bx: TExtArray); override;
    procedure FillBy(By: TExtArray); override;
    procedure FillBz(Bz: TExtArray); override;
    procedure FillHx(Hx: TExtArray); override;
    procedure FillHy(Hy: TExtArray); override;
    procedure FillHz(Hz: TExtArray); override;
    procedure FillEzMax(Ez: TExtArray); override;
    procedure FillHyMax(Hy: TExtArray); override;
    procedure SaveToStream(Stream: TMemoryStream); override;
    function LoadFromStream(Stream: TMemoryStream): boolean; override;
    procedure Assign(Source: TField2); override;
  end;

  TRectSelfField = class (TField2)
  private
    FP, FQ, FR: Extended;
    A, B: Extended;
    FRect : TRegion;
    FModeNum: Integer;
    FDelY: Extended;
    FEps: Extended;
    EpsA, EpsB: Extended;
    Odd: Boolean;
    One: ShortInt;
    Size: Extended;
    ZeroPoint: Extended;
    Sym: Boolean;
    function Bell(i: Integer): Extended;
  protected
    function GetHalfY: Integer;
    function GetBettaY: Extended;
    procedure CalculateParams; virtual;
  public
    RectNum: Integer;
    property HalfY: Integer read GetHalfY;
    property BettaY: Extended read GetBettaY;
    property P: Extended read FP;
    property Q: Extended read FQ;
    property R: Extended read FR;
    property Rect: TRegion read FRect;
    property ModeNum: Integer read FModeNum;
    property Betta: Extended read FBettaY write FBettaY;
    property K: Extended read FBettaX write FBettaX;
    constructor Create;
    procedure SetField(ASizeX, ASizeY, AStartX, AStartY,
      AHalfX, AHalfY: Integer; ARect: TRegion; AModeNum: Integer);
    procedure FillEx(Ex: TExtArray); override;
    procedure FillEy(Ey: TExtArray); override;
    procedure FillEz(Ez: TExtArray); override;
    procedure FillDx(Dx: TExtArray); override;
    procedure FillDy(Dy: TExtArray); override;
    procedure FillDz(Dz: TExtArray); override;
    procedure FillBx(Bx: TExtArray); override;
    procedure FillBy(By: TExtArray); override;
    procedure FillBz(Bz: TExtArray); override;
    procedure FillHx(Hx: TExtArray); override;
    procedure FillHy(Hy: TExtArray); override;
    procedure FillHz(Hz: TExtArray); override;
    procedure FillEzMax(Ez: TExtArray); override;
    procedure FillHyMax(Hy: TExtArray); override;
    procedure SaveToStream(Stream: TMemoryStream); override;
    function LoadFromStream(Stream: TMemoryStream): boolean; override;
    procedure Assign(Source: TField2); override;
  end;

  TRectSelfField2 = class (TRectSelfField)
  protected
    procedure CalculateParams; override;
  public
    constructor Create;
    procedure SetField(ASizeX, ASizeY, AStartX, AStartY,
      AHalfX, AHalfY: Integer; ARect: TRegion; AModeNum: Integer;
      AP, AQ: Extended);
end;

{TFieldList
методы:
  Add - добавить поле (начальные значения компонент поля
    будут нулевые), возращает указатель на новое поле
  Delete - удалить поле с определенным индексом
  Clear - удалить все поля
  Insert - аналогично Add, но назначает новому полю
    определенный индекс, смещая все остальные
свойства:
  Values - список полей}
  TFieldList = class(TList)
  protected
    function GetValue(Index: Integer): TField2;
    procedure AfterSetupField(Sender: TObject);
  public
    property Values[Index: Integer]: TField2 read GetValue; default;
    function Add(AField: TField2): TField2;
    procedure Delete(Index: Integer);
    procedure Clear; override;
    constructor Create;
    destructor Destroy; override;
  end;

{TRegionList :
методы :
  FindChild - возращает индекс объекта, содержащегося в объекте,
    определяемом  индексом Index (т. к. объекты сортируются, то,
    если содержится несколько объектов, то возращается индекс
    объекта, содержащего остальные) - нужен для сортировки
  FindParent - обратная функция FindChild
  SetupOrder - отсортировать объекты
  Add - добавить объект Region, возращается указатель на добавленный
    объект
  Delete - удалить объект с индексом Index
  Clear - удалить все объекты
  Draw - вызов метода Draw для всех объектов (TRegion)
  DrawContour - то же для DrawContour
  GetEps - возращает значение диэлектрической проницаемости в точке
  SaveToFile - сохранить среду в файл
  LoadFromFile - загрузить среду из файла, возращает True, если
    удалось загрузить
  RectNum - количество плоских диэлектриков
  Align - выровнить объект с индексом Index
свойства :
  BoundsWidth - ширина поглощающих слоев
  Sigma - параметр поглощающих слоев Sigma0 (электрическая
    проводимость на границе системы)
  CoefG - коэффициент геометрической прогрессии G, определяющий
    изменение Sigma внутри поглощающих слоев
  SizeX и SizeY - размеры системы
  DelX и DelY - размеры ячеек
  BoundsType - граничные условия (поглощающие слои или металл)
  Values - объекты TRegion
  FieldList - список всех полей
  Rects - список прямоугольников, необходимо при задании собственных
    мод плоских диэлектриков}
  TRegionList = class (TList)
  private
    FSizeOfX,
    FSizeOfY: Integer;
    FDelX,
    FDelY,
    FDelT: Extended;
    FEps: Extended;
    FBoundsWidth: Integer;
    FSigma: Extended;
    FCoefG: Extended;
    FEpsField: TExtArray;
    FEps2Field: TExtArray;
    FDescrib: string;
    function FindChild(Index: Integer): Integer;
    function FindParent(Index: Integer): Integer;
    procedure SetupOrder;
    procedure SetEpsField;
  protected
    procedure SetSizeOfX(Value: Integer);
    procedure SetSizeOfY(Value: Integer);
    function GetValue(Index: Integer): TRegion;
    function GetBoundsWidth: Integer;
    function GetSigma: Extended;
    function GetG: Extended;
    function GetRect(Index: Integer): TRegion;
    function GetEpsValue(X, Y: Integer): Extended;
    function GetEps2Value(X, Y: Integer): Extended;
  public
    BoundsType: TBoundsType;
    FieldList: TFieldList;
    property SizeOfX: Integer read FSizeOfX write FSizeOfX;
    property SizeOfY: Integer read FSizeOfY write FSizeOfY;
    property DelX: Extended read FDelX write FDelX;
    property DelY: Extended read FDelY write FDelY;
    property DelT: Extended read FDelT write FDelT;
    property Eps: Extended read FEps write FEps;
    property BoundsWidth: Integer read GetBoundsWidth write FBoundsWidth;
    property Sigma: Extended read GetSigma write FSigma;
    property CoefG: Extended read GetG write FCoefG;
    property Values[Index: Integer]: TRegion read GetValue; default;
    property Rects[Index: Integer]: TRegion read GetRect;
    property EpsField[X, Y: Integer]: Extended read GetEpsValue;
    property Eps2Field[X, Y: Integer]: Extended read GetEps2Value;
    property Describ: string read FDescrib write FDescrib;
    constructor Create;
    destructor Destroy; override;
    function Add(var Region: TRegion): TRegion;
    procedure Delete(Index: Integer);
    procedure Clear; override;
    procedure Draw(Canvas: TCanvas; Height, Width :Integer);
    procedure DrawContour(Canvas: TCanvas; Height, Width :Integer);
    function GetEps(X, Y: Integer): Extended;
    procedure SaveToFile(FileName: string);
    function LoadFromFile(FileName: string): Boolean;
    function RectNum: Integer;
    procedure Align(Index: Integer; HorAlign: THorAlign;
      VertAlign: TVertAlign);
  end;

{TMovingShape
методы:
  ResizeAction - произвести изменение размера
  MoveAction - переместить объект
свойства:
  MouseAction - определяет, производится ли перемещение
    или изменение размеров объекта
  ResizeDirection - направление изменения размера (сторона
    объекта, за которую тянут мышью)
  Clicked - True, если на объект нажали левой кнопкой мыши
  RightClicked - True, если на объект нажали правой кнопкой мыши
  XClick и YClick - координаты щелчка мышью
  ActiveOnMove - разрешает (True) или запрещает (False)
    действия над объектом
  Menu - локальное меню (присваивается пользователем)
  OnParentUp, OnParentDown и OnParentMove - события,
    эквивалентные OnMouseUp, OnMouseDown и OnMouseMove
  OnEndMoving - событие, возникающее после окончания
    перемещения или изменения размера}
  TMovingShape = class (TShape)
  private
    FOnParentMove: TParentMouseEvent;
    FOnParentDown: TParentMouseEvent;
    FOnParentUp: TParentMouseEvent;
    FOnEndMoving: TNotifyEvent;
    MouseAction: TMouseAction;
    ResizeDirection: TResizeDirection;
    procedure ResizeAction(X, Y: Integer); virtual;
    procedure MoveAction(X, Y: Integer); virtual;
  protected
    Clicked: Boolean;
    RightClicked: Boolean;
    XClick,
    YClick: Integer;
    procedure MouseDown(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,
      Y: Integer); override;
    procedure ParentMove(X, Y: Integer); virtual;
    procedure ParentDown(X, Y: Integer); virtual;
    procedure ParentUp(X, Y: Integer); virtual;
    procedure EndMoving; virtual;
  public
    ActiveOnMove: Boolean;
    Menu: TPopupMenu;
    property OnParentMove: TParentMouseEvent read FOnParentMove write FOnParentMove;
    property OnParentDown: TParentMouseEvent read FOnParentDown write FOnParentDown;
    property OnParentUp: TParentMouseEvent read FOnParentUp write FOnParentUp;
    property OnEndMoving: TNotifyEvent read FOnEndMoving write FOnEndMoving;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{TShapeRegion :
методы :
  ResizeAction - выполнить изменение размера, если курсор мыши в
    данный момент находится в точке (X, Y)
  MoveAction - выполнить перемещение
  UpdateByRegion - изменить параметры при изменении объекта Region
  UpdateRegion - изменить парметры поля Region по NewRegion
  UpdateShape - изменить парметры расположения Region после
    изменеия размера или перемещения
  Сreate - создает новыю компоненту TShapeRegion (конструктор) на
    компоненте AOwner
свойства :
  Region - объект TRegion, к которому привязана данная компонента
    TShapeRegion
  IndexOfRegion - индекс объекта, определяемом полем Region в
    списке RegionList}
  TShapeRegion = class (TMovingShape)
  private
    procedure ResizeAction(X, Y: Integer); override;
    procedure MoveAction(X, Y: Integer); override;
    procedure UpdateByRegion;
  protected
    procedure EndMoving; override;
  public
    Region: TRegion;
    IndexOfRegion: Integer;
    procedure UpdateRegion(NewRegion: TRegion);
    procedure UpdateShape;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{TShapeField
методы:
  Update - перерисовать объект
свойства
  Field - указатель на объект Field в объекте RegionList}
  TShapeField = class (TMovingShape)
  private
    FField: TField2;
    Ez: TExtArray;
    procedure UpdateByShape;
  protected
    procedure SetField(Value: TField2);
    procedure Paint; override;
    procedure EndMoving; override;
  public
    property Field: TField2 read FField write SetField;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{TShapeFieldList
методы:
  Add - добавить область поля
  Delete - удалить поле
  Clear - удалить все поля
  Insert - добавить область поля и вставить его в определенное
    место
свойства:
  Values - список всех полей
  ActiveOnMove - разрешает (True) или запрещает (False)
    действия над всеми объектами}
  TShapeFieldList = class(TList)
  private
    FActiveOnMove: Boolean;
    procedure ClearWithoutUpdate;
  protected
    function GetValue(Index: Integer): TShapeField;
    procedure SetActive(Value: Boolean);
  public
    property Values[Index: Integer]: TShapeField read GetValue; default;
    property ActiveOnMove: Boolean read FActiveOnMove write SetActive;
    constructor Create;
    destructor Destroy; override;
    procedure Add(AOwner: TComponent; Field: TField2; NewField: Boolean = True);
    procedure Delete(Index: Integer);
    procedure Clear; override;
  end;

{TShapeList :
методы :
  SetupOrder - отсортировать объекты
  UpdateAfterLoad - изменить праметры, если был загружен из файла
    RegionList
  ParentMoveEvent, ParentUpEvent, ParentDownEvent и EndMovingEvent -
    процедуры выполняющиеся при возникновении соответствующих
    событий у одного из объектов TShapeRegion
  Add - добавить объект TShapeRegion на компоненту AOwner,
    с полем Region
  Delete, Clear, SaveToFile, LoadFromFile - тоже, что и
    у TRegionList
свойства :
  ActiveOnMove - разрешает (True) или запрещает (False)
    действия над всеми объектами и полями
  OnParentMove, OnParentUp и OnParentDown - события, аналогичные
    таким же у TShapeRegion (и у TMovingShape)
  Values - объекты TShapeRegion
  FieldList - список полей}
  TShapeList=class(TList)
  private
    FActiveOnMove: Boolean;
    FOnParentMove: TParentMouseEvent;
    FOnParentDown: TParentMouseEvent;
    FOnParentUp: TParentMouseEvent;
    procedure SetupOrder;
    procedure UpdateAfterLoad(AOwner: TComponent);
    procedure ClearWithoutUpdate;
  protected
    function GetValue(Index: Integer): TShapeRegion;
    function GetActive: Boolean;
    procedure SetActive(Active: Boolean);
    procedure ParentMove(X, Y: Integer);
    procedure ParentDown(X, Y: Integer);
    procedure ParentUp(X, Y: Integer);
    procedure ParentMoveEvent(Sender: TObject; X, Y: Integer);
    procedure ParentDownEvent(Sender: TObject; X, Y: Integer);
    procedure ParentUpEvent(Sender: TObject; X, Y: Integer);
    procedure EndMovingEvent(Sender: TObject);
  public
    FieldList: TShapeFieldList;
    property Values[Index: Integer]: TShapeRegion read GetValue; default;
    property ActiveOnMove: Boolean read GetActive write SetActive;
    property OnParentMove: TParentMouseEvent read FOnParentMove write FOnParentMove;
    property OnParentDown: TParentMouseEvent read FOnParentDown write FOnParentDown;
    property OnParentUp: TParentMouseEvent read FOnParentUp write FOnParentUp;
    constructor Create;
    destructor Destroy; override;
    procedure Add(AOwner: TComponent; Region:TRegion);
    procedure Delete(Index: Integer);
    procedure Clear; override;
    procedure SaveToFile(FileName: string);
    function LoadFromFile(AOwner: TComponent; FileName: string): Boolean;
    procedure Align(Index: Integer; HorAlign: THorAlign;
      VertAlign: TVertAlign);
  end;

var
  RegionList: TRegionList;
  ShapeList: TShapeList;

function GetShape(Shape: TContourShape): string;
function GetMatterType(MatterType: TMatterType): string;
function GetFieldType(FieldType: TInitialFieldType): string;

implementation

var
  CoefA, Coef1, Coef2,
  CoefR1, CoefR2, CoefP1, CoefP2: Extended;

function GetShape(Shape: TContourShape): string;
begin
  case Shape of
    shRect : Result := 'прямоугольник';
    shCircle : Result := 'окружность';
    shEllipse : Result := 'эллипс';
    shHalfSpace : Result := 'полупространство';
  else
    Result := '';
  end;
end;

function GetMatterType(MatterType: TMatterType): string;
begin
  case MatterType of
    mtVacuum : Result := 'вакуум';
    mtMetall : Result := 'металл';
    mtDielectr : Result := 'диэлектрик';
  else
    Result := '';
  end;
end;

function GetFieldType(FieldType: TInitialFieldType): string;
begin
  case FieldType of
    ftSin : Result := 'синусоида';
    ftGauss : Result := 'гауссов пучок';
    ftRectSelf : Result := 'собственная мода пластины';
  else
    Result := '';
  end;
end;

function Compare(SRegion1, SRegion2: TShapeRegion): Boolean;
begin
//сравнение двух объектов TShapeRegion по индексу поля Region
  Result := RegionList.IndexOf(SRegion1.Region) <
    RegionList.IndexOf(SRegion2.Region);
end;

function FTan(X: Extended): Extended;
begin
//для нечетной моды
  Result := X * Tan(CoefA * X) - Sqrt(Coef1 - Coef2 * Sqr(X));
end;

function FCotan(X: Extended): Extended;
begin
//для четной моды
  Result := -X * Cotan(CoefA * X) - Sqrt(Coef1 - Coef2 * Sqr(X));
end;

function SelfModeR(Q: Extended): Extended;
begin
  Result := Sqrt(CoefR1 - CoefR2 * Sqr(Q));
end;

function SelfModeP(Q: Extended): Extended;
begin
  Result := Sqrt(CoefP1 - CoefP2 * Sqr(Q));
end;

function FSelfMode(X: Extended): Extended;
begin
  Result := Tan(2 * X * CoefA) - X * (SelfModeP(X) + SelfModeR(X))
    / (Sqr(X) - SelfModeP(X) * SelfModeR(X));
end;

{ TFigure }

constructor TFigure.Create;
begin
  inherited;
end;

{ TRect }

procedure TRect.Align(HorAlign: THorAlign; VertAlign: TVertAlign; SizeX,
  SizeY: Integer);
begin
  case HorAlign of
    haLeft   : CoordX := 0;
    haRight  : CoordX := SizeX - HorSize;
    haCenter : CoordX := SizeX div 2 - HorSize div 2;
  end;

  case VertAlign of
    vaBottom : CoordY := SizeY - VertSize;
    vaTop    : CoordY := 0;
    vaCenter : CoordY := SizeY div 2 - VertSize div 2;
  end;
end;

function TRect.Belong(X, Y: Integer): Boolean;
begin
  Result := (X >= CoordX) and (X < CoordX + FHorSize) and
    (Y >= CoordY) and (Y < CoordY + FVertSize);
end;

function TRect.BelongContour(X, Y: Integer): Boolean;
begin
  Result := (X = CoordX) or (X = CoordX + HorSize) or
    (Y = CoordY) or (Y = CoordY + VertSize);
end;

constructor TRect.Create;
begin
  inherited;
  FShape := shRect;
end;

procedure TRect.CustomDraw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Rectangle(CoordX, CoordY, CoordX + HorSize,
    CoordY + VertSize);
end;

procedure TRect.Draw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  CustomDraw(Canvas, Height, Width);
end;

procedure TRect.DrawContour(var Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsClear;
  CustomDraw(Canvas, Height, Width);
end;

function TRect.GetParam1: Integer;
begin
  Result := FHorSize;
end;

function TRect.GetParam2: Integer;
begin
  Result := FVertSize;
end;

function TRect.Point1: TPoint;
begin
  Result := Point(CoordX, CoordY);
end;

function TRect.Point2: TPoint;
begin
  Result := Point(CoordX + HorSize, CoordY + VertSize);
end;

procedure TRect.SetParam1(Value: Integer);
begin
  if FHorSize = Value then
    Exit;
  FHorSize := Value;
end;

procedure TRect.SetParam2(Value: Integer);
begin
  if FVertSize = Value then
    Exit;
  FVertSize := Value;
end;

{ TCircle }

procedure TCircle.Align(HorAlign: THorAlign; VertAlign: TVertAlign; SizeX,
  SizeY: Integer);
begin
  case HorAlign of
    haLeft   : CoordX := Radius;
    haRight  : CoordX := SizeX - Radius;
    haCenter : CoordX := SizeX div 2;
  end;

  case VertAlign of
    vaBottom : CoordY := SizeY - Radius;
    vaTop    : CoordY := Radius;
    vaCenter : CoordY := SizeY div 2;
  end;
end;

function TCircle.Belong(X, Y: Integer): Boolean;
begin
  Result := (Sqr(X - CoordX) + Sqr(Y - CoordY)) <= Sqr(FRadius);
end;

function TCircle.BelongContour(X, Y: Integer): Boolean;
begin
  Result := Abs(Sqr(X - CoordX) + Sqr(Y - CoordY) - Sqr(Radius)) < 0.5
end;

constructor TCircle.Create;
begin
  inherited;
  FShape := shCircle;
end;

procedure TCircle.CustomDraw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Ellipse(CoordX - Radius, CoordY - Radius,
    CoordX + Radius, CoordY + Radius);
end;

procedure TCircle.Draw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  CustomDraw(Canvas, Height, Width);
end;

procedure TCircle.DrawContour(var Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsClear;
  CustomDraw(Canvas, Height, Width);
end;

function TCircle.GetParam1: Integer;
begin
  Result := FRadius;
end;

function TCircle.GetParam2: Integer;
begin
  Result := FRadius;
end;

function TCircle.Point1: TPoint;
begin
  Result := Point(CoordX - Radius, CoordY);
end;

function TCircle.Point2: TPoint;
begin
  Result := Point(CoordX + Radius, CoordY);
end;

procedure TCircle.SetParam1(Value: Integer);
begin
  if FRadius = Value then
    Exit;
  FRadius := Value;
end;

procedure TCircle.SetParam2(Value: Integer);
begin
end;

{ TEllipse }

procedure TEllipse.Align(HorAlign: THorAlign; VertAlign: TVertAlign; SizeX,
  SizeY: Integer);
begin
  case HorAlign of
    haLeft   : CoordX := HorAxel;
    haRight  : CoordX := SizeX - HorAxel;
    haCenter : CoordX := SizeX div 2;
  end;

  case VertAlign of
    vaBottom : CoordY := SizeY - VertAxel;
    vaTop    : CoordY := VertAxel;
    vaCenter : CoordY := SizeY div 2;
  end;
end;

function TEllipse.Belong(X, Y: Integer): Boolean;
begin
  Result := Sqr(X - CoordX) / Sqr(HorAxel)
    + Sqr(Y - CoordY) / Sqr(VertAxel) <= 1;
end;

function TEllipse.BelongContour(X, Y: Integer): Boolean;
begin
  Result := Abs(Sqr(X - CoordX) / Sqr(HorAxel)
    + Sqr(Y - CoordY) / Sqr(VertAxel) - 1) < 0.5;
end;

constructor TEllipse.Create;
begin
  inherited;
  FShape := shEllipse;
end;

procedure TEllipse.CustomDraw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Ellipse(CoordX - HorAxel, CoordY - VertAxel,
    CoordX + HorAxel, CoordY + VertAxel);
end;

procedure TEllipse.Draw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  CustomDraw(Canvas, Height, Width);
end;

procedure TEllipse.DrawContour(var Canvas: TCanvas; Height,
  Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsClear;
  CustomDraw(Canvas, Height, Width);
end;

function TEllipse.GetParam1: Integer;
begin
  Result := FHorAxel;
end;

function TEllipse.GetParam2: Integer;
begin
  Result := FVertAxel;
end;

function TEllipse.Point1: TPoint;
begin
  Result := Point(CoordX - HorAxel div 2, CoordY);
end;

function TEllipse.Point2: TPoint;
begin
  Result := Point(CoordX + HorAxel div 2, CoordY);
end;

procedure TEllipse.SetParam1(Value: Integer);
begin
  if FHorAxel = Value then
    Exit;
  FHorAxel := Value;
end;

procedure TEllipse.SetParam2(Value: Integer);
begin
  if FVertAxel = Value then
    Exit;
  FVertAxel := Value;
end;

{ THalfSpace }

procedure THalfSpace.Align(HorAlign: THorAlign; VertAlign: TVertAlign;
  SizeX, SizeY: Integer);
begin
end;

function THalfSpace.Belong(X, Y: Integer): Boolean;
begin
  case Orientation of
    orLeft   : Result := X <= CoordX;
    orRight  : Result := X >= CoordX;
    orTop    : Result := Y <= CoordY;
    orBottom : Result := Y >= CoordY;
  else
    Result := False;
  end;
end;

function THalfSpace.BelongContour(X, Y: Integer): Boolean;
begin
  case Orientation of
    orLeft : Result := X = CoordX;
    orRight : Result := X = CoordX;
    orTop : Result := Y = CoordY;
    orBottom : Result := Y = CoordY;
  else
    Result := False;
  end;
end;

constructor THalfSpace.Create;
begin
  inherited;
  FShape := shHalfSpace;
end;

procedure THalfSpace.CustomDraw(Canvas: TCanvas; Height, Width: Integer);
begin
  case Orientation of
    orLeft   : Canvas.Rectangle(0, 0, CoordX, Height);
    orRight  : Canvas.Rectangle(CoordX, 0, Width, Height);
    orTop    : Canvas.Rectangle(0, 0, Width, CoordY);
    orBottom : Canvas.Rectangle(0, CoordY, Width, Height);
  end;
end;

procedure THalfSpace.Draw(Canvas: TCanvas; Height, Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  CustomDraw(Canvas, Height, Width);
end;

procedure THalfSpace.DrawContour(var Canvas: TCanvas; Height,
  Width: Integer);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsClear;
  CustomDraw(Canvas, Height, Width);
end;

function THalfSpace.GetParam1: Integer;
begin
  Result := Integer(FOrientation);
end;

function THalfSpace.GetParam2: Integer;
begin
  Result := Integer(FOrientation);
end;

function THalfSpace.Point1: TPoint;
begin
  Result := Point(CoordX, CoordY);
end;

function THalfSpace.Point2: TPoint;
begin
  Result := Point(CoordX, CoordY);
end;

procedure THalfSpace.SetParam1(Value: Integer);
begin
  FOrientation := TOrientation(Value);
end;

procedure THalfSpace.SetParam2(Value: Integer);
begin
end;

{ TRegion }

procedure TRegion.Assign(Source: TPersistent);
var
  Region: TRegion;
begin
//присвоить объекту свойства Source
  Region := TRegion(Source);
  CreateFigure(Region.Figure.Shape);
  Figure.Param1 := Region.Figure.Param1;
  Figure.Param2 := Region.Figure.Param2;
  FEps := Region.Eps;
  FEps2 := Region.Eps2;
  Figure.CoordX := Region.Figure.CoordX;
  Figure.CoordY := Region.Figure.CoordY;
  MatterType := Region.MatterType;
end;

constructor TRegion.Create;
begin
  inherited;
  Figure := TFigure.Create;
end;

procedure TRegion.CreateFigure(AShape: TContourShape);
begin
  if Assigned(Figure) then
    Figure.Free;
  case AShape of
    shRect      : Figure := TRect.Create;
    shCircle    : Figure := TCircle.Create;
    shEllipse   : Figure := TEllipse.Create;
    shHalfSpace : Figure := THalfSpace.Create;
  end;
end;

destructor TRegion.Destroy;
begin
  Figure.Free;
  inherited;
end;

function TRegion.GetEps: Extended;
begin
  case MatterType of
    mtVacuum   : Result := 1;
    mtMetall   : Result := 0;
    mtDielectr : Result := FEps;
  else
    Result := 0;
  end;
end;

function TRegion.GetEps2: Extended;
begin
  Result := 0;
  if MatterType = mtDielectr then
    Result := FEps2;
end;

function TRegion.LoadFromStream(Stream: TMemoryStream): Boolean;
var
  Param: Integer;
  Shape: TContourShape;
begin
  Result := True;
  try
    Stream.ReadBuffer(MatterType, SizeOf(TMatterType));
    Stream.ReadBuffer(FEps, SizeOf(Extended));
    Stream.ReadBuffer(FEps2, SizeOf(Extended));
    Stream.ReadBuffer(Shape, SizeOf(TContourShape));
    CreateFigure(Shape);
    Stream.ReadBuffer(Figure.CoordX, SizeOf(Integer));
    Stream.ReadBuffer(Figure.CoordY, SizeOf(Integer));
    Stream.ReadBuffer(Param, SizeOf(Integer));
    Figure.Param1 := Param;
    Stream.ReadBuffer(Param, SizeOf(Integer));
    Figure.Param2 := Param;
  except
    Result := False;
  end;
end;

procedure TRegion.SaveToStream(Stream: TMemoryStream);
var
  Param1, Param2: Integer;
begin
  Stream.WriteBuffer(MatterType, SizeOf(TMatterType));
  Stream.WriteBuffer(FEps, SizeOf(Extended));
  Stream.WriteBuffer(FEps2, SizeOf(Extended));
  Stream.WriteBuffer(Figure.Shape, SizeOf(TContourShape));
  Stream.WriteBuffer(Figure.CoordX, SizeOf(Integer));
  Stream.WriteBuffer(Figure.CoordY, SizeOf(Integer));
  Param1 := Figure.Param1;
  Stream.WriteBuffer(Param1, SizeOf(Integer));
  Param2 := Figure.Param2;
  Stream.WriteBuffer(Param2, SizeOf(Integer));
end;

procedure TRegion.SetEps(Value: Extended);
begin
  if MatterType = mtDielectr then
    FEps := Value;
end;

procedure TRegion.SetEps2(Value: Extended);
begin
  if MatterType = mtDielectr then
    FEps2 := Value;
end;

{ TRegionList }

function TRegionList.Add;
var
  NewRegion: TRegion;
begin
//добавить объект
  NewRegion := TRegion.Create;
  NewRegion.Assign(Region);
  inherited Add(NewRegion);
  Result := Values[Count-1];
//отсортировать
  SetupOrder;
  SetEpsField;
end;

procedure TRegionList.Align(Index: Integer; HorAlign: THorAlign;
  VertAlign: TVertAlign);
begin
  if Values[Index].Figure.Shape = shHalfSpace then
    Exit;

  Values[Index].Figure.Align(HorAlign, VertAlign, SizeOfX, SizeOfY);
  SetEpsField;
end;

procedure TRegionList.Clear;
var
  i: Integer;
  Region: TRegion;
begin
//очистить список
  if Count = 0 then
    Exit;
  for i := 0 to Count - 1 do
  begin
    Region := Values[i];
    Region.Free;
  end;
  inherited;
//  SetEpsField;
end;

constructor TRegionList.Create;
begin
  inherited;
  FieldList := TFieldList.Create;
  FSizeOfX := 201;
  FSizeOfY := 101;
  FDelX := 1e-6;
  FDelY := 1e-6;
  FDelT := FDelX / C * 0.2;
  FEps := 1;
  SetEpsField;
end;

procedure TRegionList.Delete;
var
  Region: TRegion;
begin
//удалить объект
  Region := TRegion(Items[Index]);
  Region.Free;
  inherited Delete(Index);
//  SetEpsField;
end;

destructor TRegionList.Destroy;
begin
  FieldList.Free;
  FEpsField.Free;
  inherited;
end;

procedure TRegionList.Draw;
var
  i: Integer;
begin
//прорисовать все объекты
  if Count = 0 then Exit;
  for i := 0 to Count - 1 do
    Values[i].Figure.Draw(Canvas, Height, Width);
end;

procedure TRegionList.DrawContour;
var
  i: Integer;
begin
//прорисовать контуры всех объектов
  if Count = 0 then Exit;
  for i := 0 to Count - 1 do
    Values[i].Figure.DrawContour(Canvas, Height, Width);
end;

function TRegionList.FindChild(Index: Integer): Integer;
var
  i: Integer;
begin
//найти первый содержащийся объект
  Result := -1;
  if Count < 2 then Exit;
  for i := Count - 1 downto 0 do
    if i <> Index then
      with Values[i] do
        if Values[Index].Figure.Belong(Figure.Point1.X, Figure.Point1.Y) and
          Values[Index].Figure.Belong(Figure.Point2.X, Figure.Point2.Y) then
        begin
          Result := i;
          Exit;
        end;
end;

function TRegionList.FindParent(Index: Integer): Integer;
var
  i: Integer;
begin
//найти первый содержащий объект
  Result := -1;
  for i := 0 to Count - 1 do
    if FindChild(i) = Index then
    begin
      Result := i;
      Exit;
    end;
end;

function TRegionList.GetBoundsWidth: Integer;
begin
  if BoundsType = btAbsorb then
    Result := FBoundsWidth
  else
    Result := 0;
end;

function TRegionList.GetEps(X, Y: Integer): Extended;
var
  i: Integer;
begin
   Result := 1;
   if (BoundsType = btMetall) and
     ((X < 0) or (X >= SizeOfX) or (Y < 0) or (Y >= SizeOfY))then
     Result := 0;
   for i := Count - 1 downto 0 do
     if Values[i].Figure.Belong(X, Y) then
     begin
{       if Values[i].Figure.BelongContour(X, Y) then
         Result := Values[i].Eps / 2;}
       Result := Values[i].Eps;
       Exit;
     end;
end;

function TRegionList.GetEps2Value(X, Y: Integer): Extended;
begin
  Result := FEps2Field[X, Y];
end;

function TRegionList.GetEpsValue(X, Y: Integer): Extended;
begin
  Result := FEpsField[X, Y];
end;

function TRegionList.GetG: Extended;
begin
  if BoundsType = btAbsorb then
    Result := FCoefG
  else
    Result := 0;
end;

function TRegionList.GetRect(Index: Integer): TRegion;
var
  RectCount, i: Integer;
begin
  Result := nil;
  RectCount := -1;
  for i := 0 to Count - 1 do
    if (Values[i].Figure.Shape = shRect)
      and (Values[i].MatterType = mtDielectr) then
    begin
      Inc(RectCount);
      if RectCount = Index then
      begin
        Result := Values[i];
        Exit;
      end;
    end;
end;

function TRegionList.GetSigma: Extended;
begin
  if BoundsType=btAbsorb then
    Result:=FSigma
  else
    Result:=0;
end;

function TRegionList.GetValue(Index: Integer): TRegion;
begin
  Result := TRegion(Items[Index]);
end;

function TRegionList.LoadFromFile(FileName: string): Boolean;
var
  MStream: TMemoryStream;
  i, Len: Integer;
  Code: Cardinal;
  NewCount: Byte;
  NewRegion: TRegion;
  Field: TField2;
  FieldType: TInitialFieldType;
begin
//загрузить среду из файла
  Result := False;

  if not(FileExists(FileName))then
  begin
    NewCount := 0;
    raise Exception.Create('File doesn' + '''' + 't exist: ' + FileName);
  end;

  MStream := TMemoryStream.Create;
  try
    MStream.LoadFromFile(FileName);
    MStream.ReadBuffer(Code, SizeOf(Cardinal));

    if Code <> FileCode then
    begin
      MStream.Free;
      raise Exception.Create(Filename + ' is not correct medium file');
    end;

    Clear;
    FieldList.Clear;

    MStream.ReadBuffer(FSizeOfX, SizeOf(Word));
    MStream.ReadBuffer(FSizeOfY, SizeOf(Word));
    MStream.ReadBuffer(FDelX, SizeOf(Extended));
    MStream.ReadBuffer(FDelY, SizeOf(Extended));
    MStream.ReadBuffer(FDelT, SizeOf(Extended));
    MStream.ReadBuffer(FEps, SizeOf(Extended));
    MStream.ReadBuffer(BoundsType, SizeOf(TBoundsType));
    MStream.ReadBuffer(FBoundsWidth, SizeOf(Integer));
    MStream.ReadBuffer(FSigma, SizeOf(Extended));
    MStream.ReadBuffer(FCoefG, SizeOf(Extended));
    MStream.ReadBuffer(NewCount, SizeOf(Byte));
//если есть объекты, то добавить их
    if NewCount <> 0 then
    begin
      NewRegion := TRegion.Create;
      for i := 0 to NewCount - 1 do
      begin
        if not NewRegion.LoadFromStream(MStream) then
        begin
          NewRegion.Free;
          Result := False;
          Exit;
        end;
        Add(NewRegion);
      end;
      NewRegion.Free;
    end;
    SetEpsField;
//загрузить возмушения
    MStream.ReadBuffer(NewCount, SizeOf(Integer));
    if NewCount <> 0 then
      for i := 0 to NewCount - 1 do
      begin
        MStream.ReadBuffer(FieldType, SizeOf(FieldType));
        case FieldType of
          ftSin       : Field := TSinField.Create;
          ftGauss     : Field := TGaussField.Create;
          ftRectSelf  : Field := TRectSelfField.Create;
          ftRectSelf2 : Field := TRectSelfField2.Create;
        else
          Field := TField2.Create;
        end;
        Field.LoadFromStream(MStream);
        FieldList.Add(Field);
      end;
//описание
    try
      MStream.ReadBuffer(Len, SizeOf(Integer));
      if Len <> 0 then
      begin
        SetLength(FDescrib, Len);
        MStream.ReadBuffer(FDescrib, Len);
      end;
    except
    end;
    MStream.Free;
  except
    MStream.Free;
    FieldList.Clear;
    Clear;
    raise Exception.Create('Can' + '''' + 't open file: ' + FileName);
  end;

  Result := True;
end;

function TRegionList.RectNum: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if Values[i].Figure.Shape = shRect then
      Inc(Result);
end;

procedure TRegionList.SaveToFile(FileName: string);
var
  MStream: TMemoryStream;
  i, Len: Integer;
  Code: Cardinal;
begin
//сохранить среду в файл
  Code := FileCode;
  MStream := TMemoryStream.Create;
  try
    MStream.WriteBuffer(Code, SizeOf(Cardinal));
    MStream.WriteBuffer(SizeOfX, SizeOf(Word));
    MStream.WriteBuffer(SizeOfY, SizeOf(Word));
    MStream.WriteBuffer(DelX, SizeOf(Extended));
    MStream.WriteBuffer(DelY, SizeOf(Extended));
    MStream.WriteBuffer(DelT, SizeOf(Extended));
    MStream.WriteBuffer(Eps, SizeOf(Extended));
    MStream.WriteBuffer(BoundsType, SizeOf(TBoundsType));
    MStream.WriteBuffer(FBoundsWidth, SizeOf(Integer));
    MStream.WriteBuffer(FSigma, SizeOf(Extended));
    MStream.WriteBuffer(FCoefG, SizeOf(Extended));
    MStream.WriteBuffer(Count, SizeOf(Byte));
//сохранить объекты
    if Count <> 0 then
      for i := 0 to Count - 1 do
        Values[i].SaveToStream(MStream);
//сохранить возмущения
    MStream.WriteBuffer(FieldList.Count, SizeOf(Integer));
    if FieldList.Count <> 0 then
      for i := 0 to FieldList.Count - 1 do
        FieldList[i].SaveToStream(MStream);
//описание
    Len := Length(FDescrib);
    MStream.WriteBuffer(Len, SizeOf(Integer));
    if Len <> 0 then
      MStream.WriteBuffer(FDescrib, Len);
    MStream.SaveToFile(FileName);
  finally
    MStream.Free;
  end;
end;

procedure TRegionList.SetEpsField;
var
  i, j, k: Integer;
begin
  if Assigned(FEpsField) then
    FEpsField.Free;
  FEpsField := TExtArray.Create(vtExtended, FSizeOfX, FSizeOfY,
    0, 0, 0, 0, 0, 0);
  if Assigned(FEps2Field) then
    FEps2Field.Free;
  FEps2Field := TExtArray.Create(vtExtended, FSizeOfX, FSizeOfY,
    0, 0, 0, 0, 0, 0);
  for i := 0 to SizeOfX do
    for j := 0 to SizeOfY do
    begin
      FEpsField[i, j] := FEps;
      for k := 0 to Count - 1 do
        if Values[k].Figure.Belong(i, j) then
        begin
          FEpsField[i, j] := Values[k].Eps;
          FEps2Field[i, j] := Values[k].Eps2;
          Break;
        end;
      if BoundsType = btMetall then
        if (i = 0) or (i = SizeOfX) or (j = 0) or (j = SizeOfY) then
          FEpsField[i, j] := 0;
    end;
end;

procedure TRegionList.SetSizeOfX(Value: Integer);
begin
  FSizeOfX := Value;
  SetEpsField;
end;

procedure TRegionList.SetSizeOfY(Value: Integer);
begin
  FSizeOfY := Value;
  SetEpsField;
end;

procedure TRegionList.SetupOrder;
var
  LastChild, LastParent: Integer;
begin
//сортировка, учитывая содержание одних объектов другими
//нужно отсортировать только последний объект, т. к. остальные
//отсортированы ранее
  LastChild := FindChild(Count - 1);
  if LastChild <> -1 then
    Move(Count - 1, LastChild + 1)
  else
  begin
    LastParent := FindParent(Count - 1);
    if LastParent <> -1 then
      Move(Count - 1, LastParent);
  end;
end;

{ TShapeRegion }

constructor TShapeRegion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TShapeRegion.Destroy;
begin
  inherited;
end;


procedure TShapeRegion.EndMoving;
begin
  inherited;
  RegionList.SetupOrder;
end;

procedure TShapeRegion.MoveAction;
begin
  inherited;
//для полупространства премещение только для одной границы =
//изменению размера
  if Region.Figure.Shape = shHalfSpace then
    case THalfSpace(Region.Figure).Orientation of
      orLeft :
      begin
        Width := Width + Left;
        Left := 0;
        Height := Parent.Height;
        XClick := X;
        YClick := Y;
      end;
      orRight :
      begin
        Width := Parent.Width - Left;
        Height := Parent.Height;
      end;
      orTop :
      begin
        Height := Height + Top;
        Top := 0;
        Width := Parent.Width;
        XClick := X;
        YClick := Y;
      end;
      orBottom :
      begin
        Height := Parent.Height - Top;
        Width := Parent.Width;
      end;
    end;
end;

procedure TShapeRegion.ResizeAction;
begin
//изменить размер
  inherited;
end;

procedure TShapeRegion.UpdateByRegion;
begin
//изменить параметры при изменеии Region
  case Region.Figure.Shape of
    shRect :
    begin
      Shape := stRectangle;
      Width := TRect(Region.Figure).HorSize;
      Height := TRect(Region.Figure).VertSize;
      Left := Region.Figure.CoordX;
      Top := Region.Figure.CoordY;
    end;
    shCircle :
    begin
      Shape := stCircle;
      Width := TCircle(Region.Figure).Radius * 2;
      Height := TCircle(Region.Figure).Radius * 2;
      Left := Region.Figure.CoordX - Width div 2;
      Top := Region.Figure.CoordY - Width div 2;
    end;
    shEllipse :
    begin
      Shape := stEllipse;
      Width := TEllipse(Region.Figure).HorAxel * 2;
      Height := TEllipse(Region.Figure).VertAxel * 2;
      Left := Region.Figure.CoordX - Width div 2;
      Top := Region.Figure.CoordY - Height div 2;
    end;
    shHalfSpace :
    begin
      Shape := stRectangle;
      case THalfSpace(Region.Figure).Orientation of
        orLeft :
        begin
          Left := 0;
          Top := 0;
          Width := Region.Figure.CoordX;
          Height := Parent.Height;
        end;
        orRight :
        begin
          Left := Region.Figure.CoordX;
          Top := 0;
          Width := Parent.Width - Left;
          Height := Parent.Height;
        end;
        orTop :
        begin
          Left := 0;
          Top := 0;
          Width := Parent.Width;
          Height := Region.Figure.CoordY;
        end;
        orBottom :
        begin
          Left := 0;
          Top := Region.Figure.CoordY;
          Width := Parent.Width;
          Height := Parent.Height-Top;
        end;
      end;
    end;
  end;
  case Region.MatterType of
    mtVacuum :
    begin
      Brush.Color := clWhite;
      Brush.Style := bsSolid;
    end;
    mtMetall :
    begin
      Brush.Color := clBlack;
      Brush.Style := bsSolid;
    end;
    mtDielectr :
    begin
      Brush.Color := clBlack;
      Brush.Style := bsDiagCross;
    end;
  end;
end;

procedure TShapeRegion.UpdateRegion(NewRegion: TRegion);
begin
//присвоить Region свойства TRegion
  Region.Assign(NewRegion);
  UpdateByRegion;
end;

procedure TShapeRegion.UpdateShape;
begin
//изменить свойсива Region после перемещения
  case Region.Figure.Shape of
    shRect :
    begin
      Region.Figure.CoordX := Left;
      Region.Figure.CoordY := Top;
      TRect(Region.Figure).HorSize := Width;
      TRect(Region.Figure).VertSize := Height;
    end;
    shCircle :
    begin
      TCircle(Region.Figure).Radius := Width div 2;
      Region.Figure.CoordX := Left + Width div 2;
      Region.Figure.CoordY := Top + Width div 2;
    end;
    shEllipse :
    begin
      TEllipse(Region.Figure).HorAxel := Width div 2;
      TEllipse(Region.Figure).VertAxel := Height div 2;
      Region.Figure.CoordX := Left + Width div 2;
      Region.Figure.CoordY := Top + Height div 2;
    end;
    shHalfSpace :
    begin
      Shape := stRectangle;
      case THalfSpace(Region.Figure).Orientation of
        orLeft  : Region.Figure.CoordX := Width;
        orRight : Region.Figure.CoordX := Left;
        orTop   : Region.Figure.CoordY := Height;
        orBottom: Region.Figure.CoordY := Top;
      end;
    end;
  end;
end;

{ TShapeList }

procedure TShapeList.Add;
var
  NewShape: TShapeRegion;
begin
//добавить новый объект TShapeRegion
  NewShape := TShapeRegion.Create(AOwner);
  inherited Add(NewShape);
  Values[Count-1].Region := RegionList.Add(Region);
//присвоить события
  Values[Count - 1].OnParentMove := ParentMoveEvent;
  Values[Count - 1].OnParentDown := ParentDownEvent;
  Values[Count - 1].OnParentUp := ParentUpEvent;
  Values[Count - 1].OnEndMoving := EndMovingEvent;
  Values[Count - 1].ActiveOnMove := FActiveOnMove;
  Values[Count - 1].UpdateByRegion;
  Move(Count - 1, RegionList.IndexOf(Values[Count - 1].Region));
end;

procedure TShapeList.Align(Index: Integer; HorAlign: THorAlign;
  VertAlign: TVertAlign);
begin
  RegionList.Align(Index, HorAlign, VertAlign);
  Values[Index].UpdateByRegion;
end;

procedure TShapeList.Clear;
{var
  i: Integer;
  ShapeRegion: TShapeRegion;}
begin
//очистить
  RegionList.Clear;
{  if Count = 0 then Exit;
  for i := 0 to Count - 1 do
  begin
    ShapeRegion := Values[i];
    ShapeRegion.Free;
  end;
  inherited;}
  ClearWithoutUpdate;
end;

procedure TShapeList.ClearWithoutUpdate;
var
  i: Integer;
  ShapeRegion: TShapeRegion;
begin
//очистить
  if Count = 0 then Exit;
  for i := 0 to Count - 1 do
  begin
    ShapeRegion := Values[i];
    ShapeRegion.Free;
  end;
  inherited Clear;
end;

constructor TShapeList.Create;
begin
  inherited;
  FieldList := TShapeFieldList.Create;
end;

procedure TShapeList.Delete(Index: Integer);
var
  ShapeRegion: TShapeRegion;
begin
//удалить
  RegionList.Delete(RegionList.IndexOf(Values[Index].Region));
  ShapeRegion := Values[Index];
  ShapeRegion.Free;
  inherited Delete(Index);
end;

destructor TShapeList.Destroy;
begin
  FieldList.Free;
  inherited;
end;

procedure TShapeList.EndMovingEvent(Sender: TObject);
begin
//после перемещения обновить параметры и отсортировать
  (Sender as TShapeRegion).UpdateShape;
//  Sort(@Compare);
  RegionList.SetupOrder;
  SetupOrder;
end;

function TShapeList.GetActive: Boolean;
begin
  Result := FActiveOnMove;
end;

function TShapeList.GetValue(Index: Integer): TShapeRegion;
begin
  Result := TShapeRegion(Items[Index]);
end;

function TShapeList.LoadFromFile(AOwner: TComponent; FileName: string): Boolean;
begin
//загрузить из файла
  Result := RegionList.LoadFromFile(FileName);
  if not(Result) then
    Exit;
  UpdateAfterLoad(AOwner);
end;

procedure TShapeList.ParentDown;
begin
  if Assigned(FOnParentDown) then FOnParentDown(Self, X, Y);
end;

procedure TShapeList.ParentDownEvent(Sender: TObject; X, Y: Integer);
var
  XOnParent, YOnParent: Integer;
begin
  XOnParent := X + Values[IndexOf(Sender)].Left;
  YOnParent := Y + Values[IndexOf(Sender)].Top;
  ParentDown(XOnParent, YOnParent);
end;

procedure TShapeList.ParentMove;
begin
  if Assigned(FOnParentMove) then FOnParentMove(Self, X, Y);
end;

procedure TShapeList.ParentMoveEvent(Sender: TObject; X, Y: Integer);
var
  XOnParent, YOnParent: Integer;
begin
  XOnParent := X{ + Values[IndexOf(Sender)].Left};
  YOnParent := Y{ + Values[IndexOf(Sender)].Top};
  ParentMove(XOnParent, YOnParent);
end;

procedure TShapeList.ParentUp;
begin
  if Assigned(FOnParentUp) then FOnParentUp(Self, X, Y);
end;

procedure TShapeList.ParentUpEvent(Sender: TObject; X, Y: Integer);
var
  XOnParent, YOnParent: Integer;
begin
  XOnParent := X + Values[IndexOf(Sender)].Left;
  YOnParent := Y + Values[IndexOf(Sender)].Top;
  ParentUp(XOnParent, YOnParent);
end;

procedure TShapeList.SaveToFile(FileName: string);
begin
//сохранить в файл
  RegionList.SaveToFile(FileName);
end;

procedure TShapeList.SetActive(Active: Boolean);
var
  i: Integer;
begin
  if FActiveOnMove = Active then
    Exit;
  FActiveOnMove := Active;
  for i := 0 to Count - 1 do
    Values[i].ActiveOnMove := Active;
  FieldList.ActiveOnMove := Active;
end;

procedure TShapeList.SetupOrder;
var
  i: Integer;
begin
//обновление объектов TShapeRegion как компоненты
  if Count = 0 then Exit;
  for i := Count - 1 downto 0 do
  begin
    Values[i].SendToBack;
    Values[i].Update;
  end;
end;

procedure TShapeList.UpdateAfterLoad;
var
  NewShape: TShapeRegion;
  Field: TShapeField;
  i: Integer;
begin
//обновить после загрузки
  ClearWithoutUpdate;
  FieldList.ClearWithoutUpdate;
  for i := 0 to RegionList.Count - 1 do
  begin
    NewShape := TShapeRegion.Create(AOwner);
    inherited Add(NewShape);
    Values[i].Region := RegionList[i];
    Values[i].OnParentMove := ParentMoveEvent;
    Values[i].OnParentDown := ParentDownEvent;
    Values[i].OnParentUp := ParentUpEvent;
    Values[i].OnEndMoving := EndMovingEvent;
    Values[i].ActiveOnMove := FActiveOnMove;
    Values[i].UpdateByRegion;
  end;
  for i := 0 to RegionList.FieldList.Count - 1 do
  begin
{    with RegionList.FieldList[i] do
      FieldList.Add(AOwner, SizeOfX, SizeOfY, StartX, StartY);}
    FieldList.Add(AOwner, RegionList.FieldList[i], False);
//    FieldList[i].Field := RegionList.FieldList[i];
    FieldList[i].Repaint;
  end;
end;

{ TField }

constructor TField.Create(ASizeOfX, ASizeOfY, AStartX,
  AStartY: Integer);
begin
  inherited Create;
  ArraysExist := False;
  Realloc(ASizeOfX, ASizeOfY, AStartX, AStartY);
end;

procedure TField.CreateArrays;
begin
  FEx := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FEy := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FEz := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDx := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDy := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDz := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FBx := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FBy := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FBz := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHx := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHy := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHz := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);

  ArraysExist := True;
end;

procedure TField.CreateTempArrays;
begin
  FExT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FEyT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FEzT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDxT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDyT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FDzT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FBxT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FByT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FBzT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHxT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHyT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
  FHzT := TExtArray.Create(vtExtended, SizeOfX, SizeOfY, 0, 0,
    0, 0, StartX, StartY);
end;

destructor TField.Destroy;
begin
  if ArraysExist then
    FreeArrays;
  inherited;
end;

procedure TField.FreeArrays;
begin
  FEx.Free;
  FEy.Free;
  FEz.Free;
  FDx.Free;
  FDy.Free;
  FDz.Free;
  FBx.Free;
  FBy.Free;
  FBz.Free;
  FHx.Free;
  FHy.Free;
  FHz.Free;

  ArraysExist := False;
end;

procedure TField.FreeTempArrays;
begin
  FExT.Free;
  FEyT.Free;
  FEzT.Free;
  FDxT.Free;
  FDyT.Free;
  FDzT.Free;
  FBxT.Free;
  FByT.Free;
  FBzT.Free;
  FBxT.Free;
  FByT.Free;
  FBzT.Free;
end;

procedure TField.Realloc(ASizeOfX, ASizeOfY, AStartX, AStartY: Integer);
begin
  FSizeOfX := ASizeOfX;
  FSizeOfY := ASizeOfY;
  FStartX := AStartX;
  FStartY := AStartY;
  if ArraysExist then
  begin
    StoreArrays;
    FreeArrays;
    CreateArrays;
    UnStoreArrays;
  end
  else
    CreateArrays;
end;

procedure TField.StoreArrays;
var
  i, j: Integer;
begin
  CreateTempArrays;
  for i := StartX to SizeOfX + StartX do
    for j := StartY to SizeOfY + StartY do
    begin
      FExT[i, j]:=FEx[i, j];
      FEyT[i, j]:=FEy[i, j];
      FEzT[i, j]:=FEz[i, j];
      FDxT[i, j]:=FDx[i, j];
      FDyT[i, j]:=FDy[i, j];
      FDzT[i, j]:=FDz[i, j];
      FBxT[i, j]:=FBx[i, j];
      FByT[i, j]:=FBy[i, j];
      FBzT[i, j]:=FBz[i, j];
      FHxT[i, j]:=FHx[i, j];
      FHyT[i, j]:=FHy[i, j];
      FHzT[i, j]:=FHz[i, j];
    end;
end;

procedure TField.UnStoreArrays;
var
  i, j: Integer;
begin
  for i := StartX to SizeOfX + StartX do
    for j := StartY to SizeOfY + StartY do
    begin
      FEx[i, j]:=FExT[i, j];
      FEy[i, j]:=FEyT[i, j];
      FEz[i, j]:=FEzT[i, j];
      FDx[i, j]:=FDxT[i, j];
      FDy[i, j]:=FDyT[i, j];
      FDz[i, j]:=FDzT[i, j];
      FBx[i, j]:=FBxT[i, j];
      FBy[i, j]:=FByT[i, j];
      FBz[i, j]:=FBzT[i, j];
      FHx[i, j]:=FHxT[i, j];
      FHy[i, j]:=FHyT[i, j];
      FHz[i, j]:=FHzT[i, j];
    end;
  FreeTempArrays;
end;

{ TFieldList }

function TFieldList.Add(AField: TField2): TField2;
begin
//  Result := TField.Create(SizeOfX, SizeOfY, StartX, StartY);
  case AField.FFieldType of
    ftSin : Result := TSinField.Create;
    ftGauss : Result := TGaussField.Create;
    ftRectSelf : Result := TRectSelfField.Create;
    ftRectSelf2 : Result := TRectSelfField2.Create;
  else
    Result := TField2.Create;
  end;
  Result.Assign(AField);
  Result.OnSetup := AfterSetupField;
  inherited Add(Result);
end;

procedure TFieldList.AfterSetupField(Sender: TObject);
begin
  TRectSelfField(Sender).RectNum := RegionList.IndexOf(
    TRectSelfField(Sender).Rect);
end;

procedure TFieldList.Clear;
var
  i: Integer;
  Field: TField2;
begin
  for i := 0 to Count - 1 do
  begin
    Field := Values[i];
    Field.Free;
  end;
  inherited;
end;

constructor TFieldList.Create;
begin
  inherited;
end;

procedure TFieldList.Delete(Index: Integer);
var
  Field: TField2;
begin
  Field := Values[Index];
  Field.Free;
  inherited;
end;

destructor TFieldList.Destroy;
begin
//  Clear;
  inherited;
end;

function TFieldList.GetValue(Index: Integer): TField2;
begin
  Result := TField2(Items[Index]);
end;

{ TShapeField }

constructor TShapeField.Create(AOwner: TComponent);
begin
  inherited;
//  Parent := AOwner as TWinControl;
end;

destructor TShapeField.Destroy;
begin
  inherited;
end;

procedure TShapeField.SetField(Value: TField2);
begin
  FField := Value;
  if Assigned(Ez) then
    Ez.Free;
  Ez := TExtArray.Create(vtExtended, FField.FSizeOfX, FField.FSizeOfY,
    0, 0, 0, 0, FField.FStartX, FField.FStartY);
  FField.FillEz(Ez);
end;

procedure TShapeField.Paint;
var
  Bitmap: TBitmap;
  i, j: Integer;
  FieldValue: Extended;
begin
  inherited;
  Bitmap := TBitmap.Create;
  Bitmap.Width := Field.SizeOfX;
  Bitmap.Height := Field.SizeOfY;
  for i := 0 to Bitmap.Width - 1 do
    for j := 0 to Bitmap.Height - 1 do
    begin
      FieldValue := Abs(Ez[i + Field.StartX , j + Field.StartY] / Ez0);
{      FieldValue := (Ez[i + Field.StartX , j + Field.StartY] / Ez0/Eps0/2);
      if FieldValue < 0 then
        FieldValue := 0;}
      if FieldValue > 1 then
        Bitmap.Canvas.Pixels[i, j] := clBlack
      else
        Bitmap.Canvas.Pixels[i, j] := ColorArray[Round(
          255 * FieldValue)];
    end;
  Canvas.Draw(0, 0, Bitmap);
  Bitmap.Free;
end;

procedure TShapeField.EndMoving;
begin
  inherited;
  UpdateByShape;
end;

procedure TShapeField.UpdateByShape;
begin
  FField.FStartX := Left;
  FField.FStartY := Top;
end;

{ TShapeFieldList }

procedure TShapeFieldList.Add(AOwner: TComponent; Field: TField2;
  NewField: Boolean = True);
var
  ShapeField: TShapeField;
begin
  ShapeField := TShapeField.Create(AOwner);
  if NewField then
    ShapeField.Field := RegionList.FieldList.Add(Field)
  else
    ShapeField.Field := Field;  
  ShapeField.Left := ShapeField.Field.StartX;
  ShapeField.Top := ShapeField.Field.StartY;
  ShapeField.Width := ShapeField.Field.SizeOfX;
  ShapeField.Height := ShapeField.Field.SizeOfY;
  ShapeField.Update;
  inherited Add(ShapeField);
end;

procedure TShapeFieldList.Clear;
{var
  ShapeField: TShapeField;
  i: Integer;}
begin
  RegionList.FieldList.Clear;
{  for i := 0 to Count - 1 do
  begin
    ShapeField := Values[i];
    ShapeField.Free;
  end;
  inherited;}
  ClearWithoutUpdate;
end;

procedure TShapeFieldList.ClearWithoutUpdate;
var
  ShapeField: TShapeField;
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    ShapeField := Values[i];
    ShapeField.Free;
  end;
  inherited Clear;
end;

constructor TShapeFieldList.Create;
begin
  inherited;
end;

procedure TShapeFieldList.Delete(Index: Integer);
var
  ShapeField: TShapeField;
begin
  RegionList.FieldList.Delete(Index);
  ShapeField := Values[Index];
  ShapeField.Free;
  inherited;
end;

destructor TShapeFieldList.Destroy;
begin
  Clear;
  inherited;
end;

function TShapeFieldList.GetValue(Index: Integer): TShapeField;
begin
  Result := TShapeField(Items[Index]);
end;

procedure TShapeFieldList.SetActive(Value: Boolean);
var
  i: Integer;
begin
  if FActiveOnMove = Value then
    Exit;
  FActiveOnMove := Value;
  for i := 0 to Count - 1 do
    Values[i].ActiveOnMove := Value;
end;

{ TMovingShape }

constructor TMovingShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  Clicked := False;
  RightClicked := False;
end;

destructor TMovingShape.Destroy;
begin
  inherited;
end;

procedure TMovingShape.EndMoving;
begin
  Update;
  if Assigned(FOnEndMoving) then FOnEndMoving(Self);
end;

procedure TMovingShape.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbRight then RightClicked := True;
  if (Button = mbLeft) and ActiveOnMove then
  begin
//нажатие для перемещения
    Clicked := True;
    Cursor := crSizeAll;
    MouseAction := maMove;
    XClick := X;
    YClick := Y;
//нажатие для перемещения
    if X = 0 then
    begin
      MouseAction := maResize;
      ResizeDirection := rdLeft;
    end;
    if X = Width - 1 then
    begin
      MouseAction := maResize;
      ResizeDirection := rdRight;
    end;
    if Y = 0 then
    begin
      MouseAction := maResize;
      ResizeDirection:=rdUp;
    end;
    if Y = Height - 1 then
    begin
      MouseAction := maResize;
      ResizeDirection := rdDown;
    end;
  end;
//событие для родительской компоненты
  if not ActiveOnMove then
  begin
    ParentDown(X, Y);
  end;
end;

procedure TMovingShape.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not Clicked then
    Cursor := crDefault;
  if ((X = 0) or (X = Width - 1)) and ActiveOnMove then
    Cursor := crSizeWE;
  if ((Y = 0) or (Y = Height - 1)) and ActiveOnMove then
    Cursor := crSizeNS;
  if Clicked then
//переместить или изменить размер
    case MouseAction of
      maMove   :
      begin
        Cursor := crSizeAll;
        MoveAction(X, Y);
      end;
      maResize : ResizeAction(X, Y);
    end;
  ParentMove(X, Y);
end;

procedure TMovingShape.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  Clicked := False;
  Cursor := crDefault;
//по правой кнопке меню
  if RightClicked  and Assigned(Menu) then
  begin
    Menu.PopupComponent := Self;
    Menu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    RightClicked := False;
  end;
  EndMoving;
  if not(ActiveOnMove) then
  begin
    ParentUp(X, Y);
  end;
end;

procedure TMovingShape.MoveAction(X, Y: Integer);
begin
//перемещение
  Left := Left + X - XClick;
  Top := Top + Y - YClick;
//не должно выходить за границы системы
  if Left < 0 then Left := 0;
  if Top < 0 then Top := 0;
  if Left + Width > Parent.Width - 1 then
    Left := Parent.Width - Width - 1;
  if Top + Height > Parent.Height - 1 then
    Top := Parent.Height - Height - 1;
end;

procedure TMovingShape.ParentDown(X, Y: Integer);
begin
  if Assigned(FOnParentDown) then FOnParentDown(Self, X + Left, Y + Top);
end;

procedure TMovingShape.ParentMove(X, Y: Integer);
begin
  if Assigned(FOnParentMove) then FOnParentMove(Self, X + Left, Y + Top);
end;

procedure TMovingShape.ParentUp(X, Y: Integer);
begin
  if Assigned(FOnParentUp) then FOnParentUp(Self, X + Left, Y + Top);
end;

procedure TMovingShape.ResizeAction(X, Y: Integer);
begin
//изменить размер
  case ResizeDirection of
    rdLeft  : if (Width - X > 0) and (Left + X >= 0) then
      begin
        Width := Width - X;
        Left := Left + X;
      end;
    rdRight : if (Width + X - XClick > 0)and
      (Left + Width + X - XClick < Parent.Width - 1) then
      Width := Width + X - XClick;
    rdUp    : if (Height - Y > 0) and (Top + Y >= 0) then
      begin
        Height := Height - Y;
        Top := Top + Y;
      end;
    rdDown  : if (Height + Y - YClick > 0)and
      (Top + Height + Y - YClick < Parent.Height - 1) then
      Height := Height + Y - YClick;
  end;
  XClick := X;
  YClick := Y;
end;

{ TField2 }

procedure TField2.Assign(Source: TField2);
begin
  FSizeOfX := Source.FSizeOfX;
  FSizeOfY := Source.FSizeOfY;
  FStartX := Source.FStartX;
  FStartY := Source.FStartY;
  FHalfX := Source.FHalfX;
  FHalfY := Source.FHalfY;
  FBettaX := Source.BettaX;
  FBettaY := Source.BettaY;
end;

function TField2.LoadFromStream(Stream: TMemoryStream): boolean;
begin
  Result := True;
  try
    Stream.ReadBuffer(FSizeOfX, SizeOf(Integer));
    Stream.ReadBuffer(FSizeOfY, SizeOf(Integer));
    Stream.ReadBuffer(FStartX, SizeOf(Integer));
    Stream.ReadBuffer(FStartY, SizeOf(Integer));
    Stream.ReadBuffer(FHalfX, SizeOf(Integer));
    Stream.ReadBuffer(FHalfY, SizeOf(Integer));
    Stream.ReadBuffer(FBettaX, SizeOf(Extended));
    Stream.ReadBuffer(FBettaY, SizeOf(Extended));
  except
    Result := False;
  end;
end;

procedure TField2.Realloc(FieldComp: TExtArray);
begin
  if (FieldComp.SizeX < FSizeOfX) or (FieldComp.SizeY < FSizeOfY)
    or (FieldComp.StartX > FStartX) or (FieldComp.StartY > FStartY) then
  begin
    FieldComp.Free;
    FieldComp := TExtArray.Create(vtExtended, FSizeOfX, FSizeOfY, 0, 0,
      0, 0, FStartX, FStartY);
  end;
end;

procedure TField2.SaveToStream(Stream: TMemoryStream);
begin
  Stream.WriteBuffer(FFieldType, SizeOf(FieldType));
  Stream.WriteBuffer(FSizeOfX, SizeOf(Integer));
  Stream.WriteBuffer(FSizeOfY, SizeOf(Integer));
  Stream.WriteBuffer(FStartX, SizeOf(Integer));
  Stream.WriteBuffer(FStartY, SizeOf(Integer));
  Stream.WriteBuffer(FHalfX, SizeOf(Integer));
  Stream.WriteBuffer(FHalfY, SizeOf(Integer));
  Stream.WriteBuffer(FBettaX, SizeOf(Extended));
  Stream.WriteBuffer(FBettaY, SizeOf(Extended));
end;

procedure TField2.SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX,
  AHalfY: Integer);
begin
  FSizeOfX := ASizeX;
  FSizeOfY := ASizeY;
  FStartX := AStartX;
  FStartY := AStartY;
  FHalfX := AHalfX;
  FHalfY := AHalfY;
  FBettaX := Pi / FSizeOfX * FHalfX / RegionList.FDelX;
  FBettaY := Pi / FSizeOfY * FHalfY / RegionList.FDelY;
end;

procedure TField2.Setup;
begin
  if Assigned(FOnSetup) then FOnSetup(Self);
end;

{ TSinField }

constructor TSinField.Create;
begin
  inherited;
  FFieldType := ftSin;
end;

procedure TSinField.FillBx(Bx: TExtArray);
begin
  Realloc(Bx);
end;

procedure TSinField.FillBy(By: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(By);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := Hz0 * Mu0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY));
end;

procedure TSinField.FillBz(Bz: TExtArray);
begin
end;

procedure TSinField.FillDx(Dx: TExtArray);
begin
end;

procedure TSinField.FillDy(Dy: TExtArray);
begin
end;

procedure TSinField.FillDz(Dz: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Dz);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := Ez0 * Eps0 * RegionList.Eps
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY));
end;

procedure TSinField.FillEx(Ex: TExtArray);
begin
end;

procedure TSinField.FillEy(Ey: TExtArray);
begin
end;

procedure TSinField.FillEz(Ez: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Ez);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := Ez0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY));
end;

procedure TSinField.FillEzMax(Ez: TExtArray);
var
  j: Integer;
  Ky: Extended;
begin
  Ky := FBettaY * RegionList.DelY;
  for j := FStartY to FStartY + FSizeOfY do
    if (j + 2) mod 2 = 0 then
      Ez[0, j] := Ez0
        * Sin(Ky * (j - FStartY));
end;

procedure TSinField.FillHx(Hx: TExtArray);
begin
  Realloc(Hx);
end;

procedure TSinField.FillHy(Hy: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Hy);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := Hz0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY));
end;

procedure TSinField.FillHyMax(Hy: TExtArray);
begin
end;

procedure TSinField.FillHz(Hz: TExtArray);
begin
end;

function TSinField.LoadFromStream(Stream: TMemoryStream): boolean;
begin
  Result := inherited LoadFromStream(Stream);
end;

procedure TSinField.SaveToStream(Stream: TMemoryStream);
begin
  inherited;
end;

{ TGaussField }

procedure TGaussField.Assign(Source: TField2);
begin
  inherited;
  FExpX := TGaussField(Source).FExpX;
  FExpY := TGaussField(Source).FExpY;
end;

constructor TGaussField.Create;
begin
  inherited;
  FFieldType := ftGauss;
end;

procedure TGaussField.FillBx(Bx: TExtArray);
begin
  Realloc(Bx);
end;

procedure TGaussField.FillBy(By: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(By);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := Hz0 * Mu0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY))
          * Exp(-Sqr(ExpX * (i - FStartX - FSizeOfX / 2))
          -Sqr(ExpY * (j - FStartY - FSizeOfY / 2)));
end;

procedure TGaussField.FillBz(Bz: TExtArray);
begin
end;

procedure TGaussField.FillDx(Dx: TExtArray);
begin
end;

procedure TGaussField.FillDy(Dy: TExtArray);
begin
end;

procedure TGaussField.FillDz(Dz: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Dz);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := Ez0 * Eps0 * RegionList.Eps
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY))
          * Exp(-Sqr(ExpX * (i - FStartX - FSizeOfX / 2))
          -Sqr(ExpY * (j - FStartY - FSizeOfY / 2)));
end;

procedure TGaussField.FillEx(Ex: TExtArray);
begin
end;

procedure TGaussField.FillEy(Ey: TExtArray);
begin
end;

procedure TGaussField.FillEz(Ez: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Ez);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := Ez0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY))
          * Exp(-Sqr(ExpX * (i - FStartX - FSizeOfX / 2))
          -Sqr(ExpY * (j - FStartY - FSizeOfY / 2)));
end;

procedure TGaussField.FillEzMax(Ez: TExtArray);
var
  j: Integer;
  Ky: Extended;
begin
  Ky := FBettaY * RegionList.DelY;
  for j := FStartY to FStartY + FSizeOfY do
    if (j + 2) mod 2 = 0 then
      Ez[0, j] := Ez0
        * Sin(Ky * (j - FStartY))
          * Exp(-Sqr(ExpY * (j - FStartY - FSizeOfY / 2)));
end;

procedure TGaussField.FillHx(Hx: TExtArray);
begin
end;

procedure TGaussField.FillHy(Hy: TExtArray);
var
  i, j: Integer;
  Kx, Ky: Extended;
begin
  Realloc(Hy);
  Kx := FBettaX * RegionList.DelX;
  Ky := FBettaY * RegionList.DelY;
  for i := FStartX to FStartX + FSizeOfX do
    for j := FStartY to FStartY + FSizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := Hz0
          * Sin(Kx * (i - FStartX))
          * Sin(Ky * (j - FStartY))
          * Exp(-Sqr(ExpX * (i - FStartX - FSizeOfX / 2))
          -Sqr(ExpY * (j - FStartY - FSizeOfY / 2)));
end;

procedure TGaussField.FillHyMax(Hy: TExtArray);
begin
end;

procedure TGaussField.FillHz(Hz: TExtArray);
begin
end;

function TGaussField.LoadFromStream(Stream: TMemoryStream): boolean;
begin
  Result := inherited LoadFromStream(Stream);
  if not Result then
    Exit;
  try
    Stream.ReadBuffer(FExpX, SizeOf(Extended));
    Stream.ReadBuffer(FExpY, SizeOf(Extended));
  except
    Result := False;
  end;
end;

procedure TGaussField.SaveToStream(Stream: TMemoryStream);
begin
  inherited;
  Stream.WriteBuffer(FExpX, SizeOf(Extended));
  Stream.WriteBuffer(FExpY, SizeOf(Extended));
end;

procedure TGaussField.SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX,
  AHalfY: Integer; AExpX, AExpY: Extended);
begin
  inherited SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX, AhalfY);
  FExpX := AExpX;
  FExpY := AExpY;
end;

{ TRectSelfField }

procedure TRectSelfField.Assign(Source: TField2);
begin
  inherited;
  FQ := TRectSelfField(Source).FQ;
  FP := TRectSelfField(Source).FP;
  FR := TRectSelfField(Source).FR;
  A := TRectSelfField(Source).A;
  B := TRectSelfField(Source).B;
  Betta := TRectSelfField(Source).Betta;
  K := TRectSelfField(Source).K;
  FModeNum := TRectSelfField(Source).FModeNum;
  FRect := TRectSelfField(Source).FRect;
  RectNum := TRectSelfField(Source).RectNum;
  FDelY := TRectSelfField(Source).FDelY;
  FEps := TRectSelfField(Source).FEps;
  EpsA := TRectSelfField(Source).EpsA;
  EpsB := TRectSelfField(Source).EpsB;
  Size := TRectSelfField(Source).Size;
  ZeroPoint := TRectSelfField(Source).ZeroPoint;
  Odd := TRectSelfField(Source).Odd;
  One := TRectSelfField(Source).One;

  Sym := (EpsA = EpsB);
end;

function TRectSelfField.Bell(i: Integer): Extended;
begin
  Result := Sqr(Sin(Pi * (i - StartX) / SizeOfX));
end;

procedure TRectSelfField.CalculateParams;
var
  Funct: TCustomFunction;
//  EpsA, EpsB: Extended;
  LeftRoot, RightRoot, Root: Extended;

  procedure FindLeftRight;
  var
    Assim: Extended;
  begin
    LeftRoot := (ModeNum - 1.5) * Pi / 2 / Size + 0.1;
    if LeftRoot < 0 then
      LeftRoot := 0.1;
    RightRoot := (ModeNum - 0.5) * Pi / 2 / Size - 0.1;

    Assim := K * Sqrt((FEps - EpsA) * (FEps - EpsB)
      / (2 * FEps - EpsA - EpsB));

    if (Assim > LeftRoot) and (Assim < RightRoot) then
    begin
      if Tan(2 * Size * Assim) < 0 then
      begin
        RightRoot := Assim - 0.1;
//        Root := RightRoot;
      end
      else
      begin
        LeftRoot := Assim + 0.1;
//        Root := LeftRoot;
      end;
    end;
    if RightRoot > Sqrt(FEps - EpsA) * K
      then RightRoot := Sqrt(FEps - EpsA) * K - 0.1;
    if RightRoot > Sqrt(FEps - EpsB) * K
      then RightRoot := Sqrt(FEps - EpsB) * K - 0.1;
{    if Root > RightRoot then
      Root := RightRoot;}
    Root := (LeftRoot + RightRoot) / 2;
  end;

begin
  Odd := (ModeNum + 2) mod 2 = 1; //четность или нечетность моды
  One := Ord(Odd) * 2 - 1;  //+-1

  EpsA := RegionList.EpsField[FRect.Figure.CoordX + FRect.Figure.Param1 div 2,
     FRect.Figure.CoordY - 1];
  EpsB := RegionList.EpsField[FRect.Figure.CoordX + FRect.Figure.Param1 div 2,
    FRect.Figure.CoordY + FRect.Figure.Param2 + 2];

  Sym := (EpsA = EpsB);
//  Sym := False;

  CoefA := Size;
  CoefP1 := Sqr(K) * (FEps - EpsA);
  CoefP2 := 1;
  CoefR1 := Sqr(K) * (FEps - EpsB);
  CoefR2 := 1;
  Coef1 := Sqr(K) * (FEps - EpsA);
  Coef2 := 1;

  if Sym then
  begin
    if Odd then
       Funct := @FTan
    else
      Funct := @FCotan;
    LeftRoot := (ModeNum - 1.5) * Pi / Size + 0.1;
    if LeftRoot < 0 then
      LeftRoot := 0.1;
    RightRoot := (ModeNum - 0.5) * Pi / Size - 0.1;
    Root := (LeftRoot + RightRoot) / 2;
  end
  else
  begin
    Funct := @FSelfMode;
    FindLeftRight;
  end;

  if not FindRoot(Funct, LeftRoot, RightRoot, FQ, 0.1, 30000)
    or (Abs(FQ) < 10) then
    if not Newton(Funct, Root, FQ,
      0.0001, 30000) or (Abs(FQ) < 10) then
      raise Exception.Create('Невозможно задать моду с такими параметрами');

  if Sym then
  begin
    if Odd then
    begin
      FP := FQ * Tan(FQ * Size);
      A := Ez0;
      B := 0;
    end
    else
    begin
      FP := -FQ * Cotan(FQ * Size);
      A := 0;
      B := Ez0;
    end;
    FR := FP;
  end
  else
  begin
    FP := SelfModeP(FQ);
    FR := SelfModeR(FQ);
    if FQ + FP * Tan(FQ * Size) <> 0 then
      A := Ez0 / ((P - Q * Tan(Q * Size)) / (Q + P * Tan (Q * Size)) + 1)
    else
      A := 0;
    B := Ez0 - A;
  end;

//  FBettaY := Sqrt((Sqr(P) + Sqr(Q)) / (FEps - RegionList.Eps));
  Betta := Sqrt(FEps * Sqr(K) - Sqr(Q));
  FSizeOfX := Round(HalfX / Betta * Pi / RegionList.FDelX);
end;

constructor TRectSelfField.Create;
begin
  inherited;
  FFieldType := ftRectSelf;
end;

procedure TRectSelfField.FillBx(Bx: TExtArray);
var
  BxIn, BxOut, BxIn1, BxIn2, BxA, BxB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  BxIn := -Ez0 / FBettaY / Z0 * Mu0;
  if Odd then
    BxOut := BxIn * Cos(Q * Size) / Exp(-P * Size)
  else
    BxOut := BxIn * Sin(Q * Size) / Exp(-P * Size);}
  BxIn1 := -A / K / Z0 * Mu0;
  BxIn2 := -B / K / Z0 * Mu0;
  BxA := BxIn1 * Sin(Q * Size) + BxIn2 * Cos(Q * Size);
  BxB := -BxIn1 * Sin(Q * Size) + BxIn2 * Cos(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Bx[i, j] := BxOut
          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j)) * (-RP) / FDelY;
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        if Odd then
          Bx[i, j] := BxIn
            * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j)) * (-RQ) / FDelY
        else
          Bx[i, j] := BxIn
            * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j)) * (RQ) / FDelY;
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Bx[i, j] := One * BxOut
          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint)) * (RP) / FDelY;
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Bx[i, j] := BxA
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Cos(Betta * (i - StartX) * Dx)
          * Exp(-RP * (FRect.Figure.CoordY - j)) * (-RP) / FDelY;
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        Bx[i, j] := (BxIn1 * Sin(RQ * (ZeroPoint - j)) * (-RQ) / FDelY
          + BxIn2 *  Cos(RQ * (ZeroPoint - j)) * (RQ) / FDelY)
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Cos(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Bx[i, j] := BxB
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Cos(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2))
          * (-RR) / FDelY;
  end;
end;

procedure TRectSelfField.FillBy(By: TExtArray);
var
  ByIn, ByOut, ByIn1, ByIn2, ByA, ByB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  ByIn := Ez0 * FBettaX / FBettaY / Z0 * Mu0;
  if Odd then
    ByOut := ByIn * Cos(Q * Size) / Exp(-P * Size)
  else
    ByOut := ByIn * Sin(Q * Size) / Exp(-P * Size);}
  ByIn1 := A * Betta / K / Z0 * Mu0;
  ByIn2 := B * Betta / K / Z0 * Mu0;
  ByA := ByIn1 * Cos(Q * Size) + ByIn2 * Sin(Q * Size);
  ByB := ByIn1 * Cos(Q * Size) - ByIn2 * Sin(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := ByOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        if Odd then
          By[i, j] := ByIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j))
        else
          By[i, j] := ByIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := One * ByOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint));
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := ByA
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := (ByIn1 * Cos(RQ * (ZeroPoint - j))
          + ByIn2  * Sin(RQ * (ZeroPoint - j)))
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        By[i, j] := ByB
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
  end;
end;

procedure TRectSelfField.FillBz(Bz: TExtArray);
begin
end;

procedure TRectSelfField.FillDx(Dx: TExtArray);
begin
end;

procedure TRectSelfField.FillDy(Dy: TExtArray);
begin
end;

procedure TRectSelfField.FillDz(Dz: TExtArray);
var
  DzIn, DzOut, DzIn1, DzIn2, DzA, DzB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  DzIn := Ez0 * Eps0 * FEps;
  if Odd then
    DzOut := DzIn * Cos(Q * Size) / Exp(-P * Size) / FEps * RegionList.Eps
  else
    DzOut := DzIn * Sin(Q * Size) / Exp(-P * Size) / FEps * RegionList.Eps;}
  DzIn1 := A * Eps0 * FEps;
  DzIn2 := B * Eps0 * FEps;
  DzA := (DzIn1 * Cos(Q * Size) + DzIn2 * Sin(Q * Size)) / FEps * EpsA;
  DzB := (DzIn1 * Cos(Q * Size) - DzIn2 * Sin(Q * Size)) / FEps * EpsB;

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := DzOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 0 then
        if Odd then
          Dz[i, j] := DzIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j))
        else
          Dz[i, j] := DzIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := One * DzOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint));
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := DzA
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := (DzIn1 * Cos(RQ * (ZeroPoint - j))
          + DzIn2 * Sin(RQ * (ZeroPoint - j)))
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Dz[i, j] := DzB
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
  end;
end;

procedure TRectSelfField.FillEx(Ex: TExtArray);
begin
end;

procedure TRectSelfField.FillEy(Ey: TExtArray);
begin
end;

procedure TRectSelfField.FillEz(Ez: TExtArray);
var
  EzIn, EzOut, EzIn1, EzIn2, EzA, EzB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  EzIn := Ez0;
  if Odd then
    EzOut := EzIn * Cos(Q * Size) / Exp(-P * Size)
  else
    EzOut := EzIn * Sin(Q * Size) / Exp(-P * Size);}
  EzIn1 := A;
  EzIn2 := B;
  EzA := EzIn1 * Cos(Q * Size) + EzIn2 * Sin(Q * Size);
  EzB := EzIn1 * Cos(Q * Size) - EzIn2 * Sin(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := EzOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 0 then
        if Odd then
          Ez[i, j] := EzIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j))
        else
          Ez[i, j] := EzIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := One * EzOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint));
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := EzA
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := (EzIn1 * Cos(RQ * (ZeroPoint - j))
          + EzIn2 * Sin(RQ * (ZeroPoint - j)))
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 0 then
        Ez[i, j] := EzB
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
  end;
end;

procedure TRectSelfField.FillEzMax(Ez: TExtArray);
var
  EzIn, EzOut, EzIn1, EzIn2, EzA, EzB: Extended;
  j: Integer;
  RQ, RP, RR: Extended;
begin
{  EzIn := Ez0;
  if Odd then
    EzOut := EzIn * Cos(Q * Size) / Exp(-P * Size)
  else
    EzOut := EzIn * Sin(Q * Size) / Exp(-P * Size);}
  EzIn1 := A;
  EzIn2 := B;
  EzA := EzIn1 * Cos(Q * Size) + EzIn2 * Sin(Q * Size);
  EzB := EzIn1 * Cos(Q * Size) - EzIn2 * Sin(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

//верхняя часть
{  for j := StartY to FRect.Figure.CoordY do
    if (j + 2) mod 2 = 0 then
      Ez[0, j] := EzOut
        * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
  for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
    if (j + 2) mod 2 = 0 then
      if Odd then
        Ez[0, j] := EzIn
          * Cos(RQ * (ZeroPoint - j))
      else
        Ez[0, j] := EzIn
          * Sin(RQ * (ZeroPoint - j));
//нижняя часть
  for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
    if (j + 2) mod 2 = 0 then
      Ez[0, j] := One * EzOut
        * Exp(-RP * (j - ZeroPoint));}
    for j := StartY to FRect.Figure.CoordY do
      if (j + 2) mod 2 = 0 then
        Ez[0, j] := EzA
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (j + 2) mod 2 = 0 then
        Ez[0, j] := EzIn1 * Cos(RQ * (ZeroPoint - j))
          + EzIn2 * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (j + 2) mod 2 = 0 then
        Ez[0, j] := EzB
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
//          * Exp(-RR * (j - StartY + SizeOfY));
end;

procedure TRectSelfField.FillHx(Hx: TExtArray);
var
  HxIn, HxOut, HxIn1, HxIn2, HxA, HxB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  HxIn := -Ez0 / FBettaY / Z0;
  if Odd then
    HxOut := HxIn * Cos(Q * Size) / Exp(-P * Size)
  else
    HxOut := HxIn * Sin(Q * Size) / Exp(-P * Size);}
  HxIn1 := A / K / Z0;
  HxIn2 := B / K / Z0;
  HxA := HxIn1 * Sin(Q * Size) + HxIn2 * Cos(Q * Size);
  HxB := -HxIn1 * Sin(Q * Size) + HxIn2 * Cos(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Hx[i, j] := HxOut
          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j)) * (-RP) / FDelY;
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        if Odd then
          Hx[i, j] := HxIn
            * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j)) * (-RQ) / FDelY
        else
          Hx[i, j] := HxIn
            * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j)) * (RQ) / FDelY;
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hx[i, j] := One * HxOut
          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint)) * (RP) / FDelY;
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Hx[i, j] := HxA
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Cos(Betta * (i - StartX) * Dx)
          * Bell(i)
          * Exp(-RP * (FRect.Figure.CoordY - j)) * (-RP) / FDelY;
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        Hx[i, j] := (HxIn1 * Sin(RQ * (ZeroPoint - j)) * (-RQ) / FDelY
          + HxIn2 *  Cos(RQ * (ZeroPoint - j)) * (RQ) / FDelY)
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Cos(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hx[i, j] := HxB
//          * Cos(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Cos(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2))
          * (-RR) / FDelY;
  end;
end;

procedure TRectSelfField.FillHy(Hy: TExtArray);
var
  HyIn, HyOut, HyIn1, HyIn2, HyA, HyB: Extended;
  i, j: Integer;
  RQ, RP, RR: Extended;
  Dx: Extended;
begin
{  HyIn := Ez0 * FBettaX / FBettaY / Z0;
  if Odd then
    HyOut := HyIn * Cos(Q * Size) / Exp(-P * Size)
  else
    HyOut := HyIn * Sin(Q * Size) / Exp(-P * Size);}
  HyIn1 := A * Betta / K / Z0;
  HyIn2 := B * Betta / K / Z0;
  HyA := HyIn1 * Cos(Q * Size) + HyIn2 * Sin(Q * Size);
  HyB := HyIn1 * Cos(Q * Size) - HyIn2 * Sin(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

  Dx := RegionList.DelX;
{  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := HyOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        if Odd then
          Hy[i, j] := HyIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Cos(RQ * (ZeroPoint - j))
        else
          Hy[i, j] := HyIn
            * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
            * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := One * HyOut
          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Exp(-RP * (j - ZeroPoint));
  end;}
  for i := StartX to StartX + SizeOfX do
  begin
//верхняя часть
    for j := StartY to FRect.Figure.CoordY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := HyA
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := (HyIn1 * Cos(RQ * (ZeroPoint - j))
          + HyIn2 * Sin(RQ * (ZeroPoint - j)))
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX);
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx);
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (i + j + 2) mod 2 = 1 then
        Hy[i, j] := HyB
//          * Sin(Pi * HalfX * (i - StartX) / SizeOfX)
          * Bell(i)
          * Sin(Betta * (i - StartX) * Dx)
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
  end;
end;

procedure TRectSelfField.FillHyMax(Hy: TExtArray);
var
  HyIn, HyOut, HyIn1, HyIn2, HyA, HyB: Extended;
  j: Integer;
  RQ, RP, RR: Extended;
begin
{  HyIn := Ez0 * FBettaX / FBettaY / Z0;
  if Odd then
    HyOut := HyIn * Cos(Q * Size) / Exp(-P * Size)
  else
    HyOut := HyIn * Sin(Q * Size) / Exp(-P * Size);}
  HyIn1 := A * Betta / K / Z0;
  HyIn2 := B * Betta / K / Z0;
  HyA := HyIn1 * Cos(Q * Size) + HyIn2 * Sin(Q * Size);
  HyB := HyIn1 * Cos(Q * Size) - HyIn2 * Sin(Q * Size);

  RQ := FQ * FDelY;
  RP := FP * FDelY;
  RR := FR * FDelY;

//верхняя часть
{  for j := StartY to FRect.Figure.CoordY do
    if (j + 2) mod 2 = 1 then
      Hy[0, j] := HyOut
        * Exp(-RP * (ZeroPoint - j));
//внутри диэлектрика
  for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
    if (j + 2) mod 2 = 1 then
      if Odd then
        Hy[0, j] := HyIn
          * Cos(RQ * (ZeroPoint - j))
      else
        Hy[0, j] := HyIn
          * Sin(RQ * (ZeroPoint - j));
//нижняя часть
  for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
    if (j + 2) mod 2 = 1 then
      Hy[0, j] := One * HyOut
        * Exp(-RP * (j - ZeroPoint));}
    for j := StartY to FRect.Figure.CoordY do
      if (j + 2) mod 2 = 1 then
        Hy[0, j] := HyA
          * Exp(-RP * (FRect.Figure.CoordY - j));
//внутри диэлектрика
    for j := FRect.Figure.CoordY + 1 to FRect.Figure.CoordY + FRect.Figure.Param2 do
      if (j + 2) mod 2 = 1 then
        Hy[0, j] := HyIn1 * Cos(RQ * (ZeroPoint - j))
          + HyIn2 * Sin(RQ * (ZeroPoint - j));
//нижняя часть
    for j := FRect.Figure.CoordY + FRect.Figure.Param2 to StartY + SizeOfY do
      if (j + 2) mod 2 = 1 then
        Hy[0, j] := HyB
          * Exp(-RR * (j - FRect.Figure.CoordY - FRect.Figure.Param2));
end;

procedure TRectSelfField.FillHz(Hz: TExtArray);
begin
end;

function TRectSelfField.GetBettaY: Extended;
begin
  Result := FBettaY;
end;

function TRectSelfField.GetHalfY: Integer;
begin
  Result := ModeNum + 2;
end;

function TRectSelfField.LoadFromStream(Stream: TMemoryStream): boolean;
begin
  Result := inherited LoadFromStream(Stream);
  if not Result then
    Exit;
  try
    Stream.ReadBuffer(FQ, SizeOf(Extended));
    Stream.ReadBuffer(FP, SizeOf(Extended));
    Stream.ReadBuffer(FR, SizeOf(Extended));
    Stream.ReadBuffer(A, SizeOf(Extended));
    Stream.ReadBuffer(B, SizeOf(Extended));
    Stream.ReadBuffer(FModeNum, SizeOf(Integer));
    Stream.ReadBuffer(RectNum, SizeOf(Integer));
{    Stream.ReadBuffer(K, SizeOf(Extended));
    Stream.ReadBuffer(Betta, SizeOf(Extended));}
    FRect := RegionList[RectNum];
    FDelY := RegionList.DelY;
    FEps := FRect.Eps;
    EpsA := RegionList.EpsField[FRect.Figure.CoordX + FRect.Figure.Param1 div 2,
       FRect.Figure.CoordY - 1];
    EpsB := RegionList.EpsField[FRect.Figure.CoordX + FRect.Figure.Param1 div 2,
      FRect.Figure.CoordY + FRect.Figure.Param2 + 2];
    Sym := (EpsA = EpsB);
    Size := FRect.Figure.Param2 * FDelY / 2;
    Betta := Sqrt(FEps * Sqr(K) - Sqr(Q));
    ZeroPoint := FRect.Figure.CoordY + FRect.Figure.Param2 / 2; //начало координат
    Odd := (ModeNum + 2) mod 2 = 1; //четность или нечетность моды
    One := Ord(Odd) * 2 - 1;  //+-1
  except
    Result := False;
  end;
end;

procedure TRectSelfField.SaveToStream(Stream: TMemoryStream);
begin
  inherited;
  Stream.WriteBuffer(FQ, SizeOf(Extended));
  Stream.WriteBuffer(FP, SizeOf(Extended));
  Stream.WriteBuffer(FR, SizeOf(Extended));
  Stream.WriteBuffer(A, SizeOf(Extended));
  Stream.WriteBuffer(B, SizeOf(Extended));
  Stream.WriteBuffer(FModeNum, SizeOf(Integer));
  RectNum := RegionList.IndexOf(FRect);
  Stream.WriteBuffer(RectNum, SizeOf(Integer));
{  Stream.WriteBuffer(K, SizeOf(Extended));
  Stream.WriteBuffer(Betta, SizeOf(Extended));}
end;

procedure TRectSelfField.SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX,
  AHalfY: Integer; ARect: TRegion; AModeNum: Integer);
begin
  inherited SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX, AHalfY);
  FModeNum := AModeNum;
  FRect := ARect;
  FDelY := RegionList.DelY;
  FEps := FRect.Eps;
  Size := FRect.Figure.Param2 * FDelY / 2;
  ZeroPoint := FRect.Figure.CoordY + FRect.Figure.Param2 / 2; //начало координат
  CalculateParams;
  Setup;
end;

{ TRectSelfField2 }

procedure TRectSelfField2.CalculateParams;
begin
end;

constructor TRectSelfField2.Create;
begin
  inherited;
  FFieldType := ftRectSelf2;
end;

procedure TRectSelfField2.SetField(ASizeX, ASizeY, AStartX, AStartY,
  AHalfX, AHalfY: Integer; ARect: TRegion; AModeNum: Integer;
  AP, AQ: Extended);
begin
  inherited SetField(ASizeX, ASizeY, AStartX, AStartY, AHalfX, AHalfY, ARect, AModeNum);
  FModeNum := AModeNum;
  FRect := ARect;
  FDelY := RegionList.DelY;
  FEps := FRect.Eps;
  Size := FRect.Figure.Param2 * FDelY / 2;
  ZeroPoint := FRect.Figure.CoordY + FRect.Figure.Param2 / 2; //начало координат
  FQ := AQ;
  FP := AP;
  FR := AP;
  if FQ + FP * Tan(FQ * Size) <> 0 then
    A := Ez0 / ((P - Q * Tan(Q * Size)) / (Q + P * Tan (Q * Size)) + 1)
  else
    A := 0;
  B := Ez0 - A;
  Setup;
end;

end.
