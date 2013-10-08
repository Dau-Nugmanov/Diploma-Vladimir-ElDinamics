unit FIFUnit;

interface

{$D+}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sgr_def, sgr_data, ComCtrls, Grapher, ExtCtrls, Fourie, Common6;

type
  TFIForm = class(TForm)
    spIntFFourie: Tsp_XYPlot;
    splIntFFourie: Tsp_XYLine;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    spIntBFourie: Tsp_XYPlot;
    splIntBFourie: Tsp_XYLine;
    procedure spIntFourieMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    function DrawCurrent(Points: TPoints; Min, Max: Integer;
      UseWindow: Boolean; Plot: Tsp_XYPlot; Line: Tsp_XYLine): Extended;
  public
    procedure Draw(FPoints, BPoints: TPoints; MinF, MaxF, MinB, MaxB: Integer;
      UseWindowF, UseWindowB: Boolean);
  end;

var
  FIForm: TFIForm;

implementation

{$R *.DFM}

const
  WindowRepeat = 8;

procedure TFIForm.Draw(FPoints, BPoints: TPoints; MinF, MaxF, MinB, MaxB: Integer;
  UseWindowF, UseWindowB: Boolean);
var
  MaxValueF, MaxValueB: Extended;
begin
  MaxValueF := DrawCurrent(FPoints, MinF, MaxF, UseWindowF, spIntFFourie,
    splIntFFourie);


  MaxValueB := DrawCurrent(BPoints, MinB, MaxB, UseWindowB, spIntBFourie,
    splIntBFourie);

  StatusBar1.Panels[1].Text := 'R = ' + FloatToStrF(MaxValueB / MaxValueF,
    ffGeneral, 4, 4) + ' (' + FloatToStrF(MaxValueF / MaxValueB, ffGeneral, 4, 4)
    + ')';
end;

function TFIForm.DrawCurrent(Points: TPoints; Min, Max: Integer;
  UseWindow: Boolean; Plot: Tsp_XYPlot; Line: Tsp_XYLine): Extended;
var
  i, j: Integer;
  TempPoints: TPoints;
begin
  Result := 0;

  TempPoints := TPoints.Create;
  if UseWindow then
    for j := 0 to WindowRepeat do
      for i := Min to Max do
        TempPoints.Add(i - Min + j * (Max - Min + 1), Points.Values[i].Y *
          (1 - Sqr(Cos(Pi * (i - Min)) / (Max - Min))))
  else
    for i := Min to Max do
      TempPoints.Add(i - Min, Points.Values[i].Y);

  DoFFT(TempPoints);

  Plot.BottomAxis.SetMinMax(0, 0.25 / DelT * 1e-9);

  for i := 0 to TempPoints.Count div 2 do
  begin
    if Result < TempPoints.Values[i].Y then
    begin
      Result := TempPoints.Values[i].Y;
      if Result > Plot.LeftAxis.Max then
        Plot.LeftAxis.SetMinMax(0, 1.5 * Result);
    end;
    Line.QuickAddXY(i * 0.5
      / TempPoints.Count / DelT * 1e-9, TempPoints.Values[i].Y);
  end;

  TempPoints.Free;
end;

procedure TFIForm.spIntFourieMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBar1.Panels[0].Text := FloatToStrF(Tsp_XYPlot(Sender).BottomAxis.P2V(X),
    ffGeneral, 4, 4) + ':' + FloatToStrF(Tsp_XYPlot(Sender).LeftAxis.P2V(Y),
    ffGeneral, 4, 4);
end;

end.
