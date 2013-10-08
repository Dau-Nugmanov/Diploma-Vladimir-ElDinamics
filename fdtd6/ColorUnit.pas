unit ColorUnit;

{$D-}

interface

uses
  Graphics, VCLUtils, Classes;

var
  GradientBitmap: TBitmap;
  ColorArray: array[0..255] of TColor;

implementation

var
  i: Integer;

initialization

  GradientBitmap := TBitmap.Create;
  GradientBitmap.Width := 256;
  GradientBitmap.Height := 1;
  GradientFillRect(GradientBitmap.Canvas, Rect(0, 0, 256, 1),
    clWhite, clBlack, fdLeftToRight, 255);
  for i:=0 to 255 do
    ColorArray[i] := GradientBitmap.Canvas.Pixels[i, 0];

finalization

  GradientBitmap.Free;

end.
