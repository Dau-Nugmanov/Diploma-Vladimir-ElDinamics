unit eds_demom;
{(c) S.P.Pod'yachev 1999}
{****************************************************}
{ Simple Example of using of Tsp_ndsXYLine, which    }
{ plots data from external data storage. Here data   }
{ are kept in 2D array for data.                     }
{****************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sgr_def, sgr_data, sgr_eds;

Const
 xi=0; yi=1;
 maxi=15;
type
  TForm1 = class(TForm)
    sp_XYPlot1: Tsp_XYPlot;
    sp_XYLine1: Tsp_XYLine;
    sp_ndsXYLine1: Tsp_ndsXYLine;
    procedure FormCreate(Sender: TObject);
    procedure sp_ndsXYLine1GetXYCount(DS: Tsp_ndsXYLine);
    procedure sp_ndsXYLine1GetXY(DS: Tsp_ndsXYLine; idx: Integer);
    function sp_ndsXYLine1GetXMax(DS: Tsp_ndsXYLine;
      var V: Double): Boolean;
    function sp_ndsXYLine1GetXMin(DS: Tsp_ndsXYLine;
      var V: Double): Boolean;
    function sp_ndsXYLine1GetYMax(DS: Tsp_ndsXYLine;
      var V: Double): Boolean;
    function sp_ndsXYLine1GetYMin(DS: Tsp_ndsXYLine;
      var V: Double): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
    Data:array [0..maxi-1,xi..yi] of integer; //external date for plot
    MaxX,MinX,MaxY,MinY:double;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var j:integer;
begin
 //create demo data
 for j:=1 to maxi do begin
  Data[j-1,xi]:=j;
  Data[j-1,yi]:=j+round(j*j/100)+ 2;
 end;
 MaxX:=Data[maxi-1,xi]; MaxY:=Data[maxi-1,yi];
 MinX:=Data[0,xi]; MinY:=Data[0,yi];
 //trig autoscale process
 sp_ndsXYLine1.Active:=False;
 sp_ndsXYLine1.Active:=True; 
end;

//-------------------------------------------------------------//
// handlers for external data

procedure TForm1.sp_ndsXYLine1GetXYCount(DS: Tsp_ndsXYLine);
begin
 DS.Count:=maxi;
end;

procedure TForm1.sp_ndsXYLine1GetXY(DS: Tsp_ndsXYLine; idx: Integer);
begin
 DS.XV:=Data[idx,xi];
 DS.YV:=Data[idx,yi];
end;

function TForm1.sp_ndsXYLine1GetXMax(DS: Tsp_ndsXYLine;
  var V: Double): Boolean;
begin
 Result:=True;
 V:=MaxX;
end;

function TForm1.sp_ndsXYLine1GetXMin(DS: Tsp_ndsXYLine;
  var V: Double): Boolean;
begin
 Result:=True;
 V:=MinX;
end;

function TForm1.sp_ndsXYLine1GetYMax(DS: Tsp_ndsXYLine;
  var V: Double): Boolean;
begin
 Result:=True;
 V:=MaxY;
end;

function TForm1.sp_ndsXYLine1GetYMin(DS: Tsp_ndsXYLine;
  var V: Double): Boolean;
begin
 Result:=True;
 V:=MinY;
end;

//-------------------------------------------------------------//
end.
