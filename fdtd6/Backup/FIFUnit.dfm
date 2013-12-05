object FIForm: TFIForm
  Left = 130
  Top = 51
  Width = 638
  Height = 488
  Caption = '‘урье - спектр'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 215
    Width = 630
    Height = 7
    Cursor = crVSplit
    Align = alTop
  end
  object spIntFFourie: Tsp_XYPlot
    Left = 0
    Top = 0
    Width = 630
    Height = 215
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    OnMouseMove = spIntFourieMouseMove
    LeftAxis.Margin = 4
    LeftAxis.TicksCount = 6
    LeftAxis.LineAttr.Color = clBlack
    LeftAxis.LineAttr.Visible = True
    LeftAxis.GridAttr.Color = clGray
    LeftAxis.GridAttr.Visible = True
    LeftAxis.LabelFormat = '###0.##'
    LeftAxis.SFlags = 1
    LeftAxis.SLinePos = (
      33
      183
      174)
    LeftAxis.fMax = 0.001
    RightAxis.Margin = 4
    RightAxis.LineAttr.Color = clBlack
    RightAxis.LineAttr.Visible = True
    RightAxis.GridAttr.Color = clGray
    RightAxis.GridAttr.Visible = False
    RightAxis.LabelFormat = '###0.##'
    RightAxis.SFlags = 57
    RightAxis.SLinePos = (
      620
      183
      174)
    RightAxis.fMax = 10
    BottomAxis.Margin = 14
    BottomAxis.Caption = 'w, √√ц'
    BottomAxis.LineAttr.Color = clBlack
    BottomAxis.LineAttr.Visible = True
    BottomAxis.GridAttr.Color = clGray
    BottomAxis.GridAttr.Visible = True
    BottomAxis.LabelFormat = '###0.##'
    BottomAxis.SFlags = 0
    BottomAxis.SLinePos = (
      34
      184
      585)
    BottomAxis.fMax = 10
    TopAxis.Margin = 4
    TopAxis.LineAttr.Color = clBlack
    TopAxis.LineAttr.Visible = True
    TopAxis.GridAttr.Color = clGray
    TopAxis.GridAttr.Visible = False
    TopAxis.LabelFormat = '###0.##'
    TopAxis.SFlags = 56
    TopAxis.SLinePos = (
      34
      8
      585)
    TopAxis.fMax = 10
    BorderStyle = bs_Gutter
    FieldColor = clWhite
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 437
    Width = 630
    Height = 24
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object spIntBFourie: Tsp_XYPlot
    Left = 0
    Top = 222
    Width = 630
    Height = 215
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    OnMouseMove = spIntFourieMouseMove
    LeftAxis.Margin = 4
    LeftAxis.TicksCount = 6
    LeftAxis.LineAttr.Color = clBlack
    LeftAxis.LineAttr.Visible = True
    LeftAxis.GridAttr.Color = clGray
    LeftAxis.GridAttr.Visible = True
    LeftAxis.LabelFormat = '###0.##'
    LeftAxis.SFlags = 1
    LeftAxis.SLinePos = (
      33
      183
      174)
    LeftAxis.fMax = 0.001
    RightAxis.Margin = 4
    RightAxis.LineAttr.Color = clBlack
    RightAxis.LineAttr.Visible = True
    RightAxis.GridAttr.Color = clGray
    RightAxis.GridAttr.Visible = False
    RightAxis.LabelFormat = '###0.##'
    RightAxis.SFlags = 57
    RightAxis.SLinePos = (
      620
      183
      174)
    RightAxis.fMax = 10
    BottomAxis.Margin = 14
    BottomAxis.Caption = 'w, √√ц'
    BottomAxis.LineAttr.Color = clBlack
    BottomAxis.LineAttr.Visible = True
    BottomAxis.GridAttr.Color = clGray
    BottomAxis.GridAttr.Visible = True
    BottomAxis.LabelFormat = '###0.##'
    BottomAxis.SFlags = 0
    BottomAxis.SLinePos = (
      34
      184
      585)
    BottomAxis.fMax = 10
    TopAxis.Margin = 4
    TopAxis.LineAttr.Color = clBlack
    TopAxis.LineAttr.Visible = True
    TopAxis.GridAttr.Color = clGray
    TopAxis.GridAttr.Visible = False
    TopAxis.LabelFormat = '###0.##'
    TopAxis.SFlags = 56
    TopAxis.SLinePos = (
      34
      8
      585)
    TopAxis.fMax = 10
    BorderStyle = bs_Gutter
    FieldColor = clWhite
  end
  object splIntFFourie: Tsp_XYLine
    Plot = spIntFFourie
    LineAttr.Color = clBlack
    LineAttr.Visible = True
    PointAttr.Kind = ptRectangle
    PointAttr.Visible = False
    Left = 216
    Top = 16
  end
  object splIntBFourie: Tsp_XYLine
    Plot = spIntBFourie
    LineAttr.Color = clBlack
    LineAttr.Visible = True
    PointAttr.Kind = ptRectangle
    PointAttr.Visible = False
    Left = 264
    Top = 208
  end
end
