object RSelfForm: TRSelfForm
  Left = 204
  Top = 125
  Width = 264
  Height = 234
  Caption = 'RSelfForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 67
    Width = 36
    Height = 13
    Caption = 'по X от'
  end
  object Label2: TLabel
    Left = 16
    Top = 13
    Width = 62
    Height = 13
    Caption = 'Диэлектрик'
  end
  object Label3: TLabel
    Left = 16
    Top = 35
    Width = 65
    Height = 13
    Caption = 'Номер моды'
  end
  object Label4: TLabel
    Left = 16
    Top = 93
    Width = 94
    Height = 13
    Caption = 'Полупериоды по X'
  end
  object Label5: TLabel
    Left = 126
    Top = 66
    Width = 12
    Height = 13
    Caption = 'до'
  end
  object Label6: TLabel
    Left = 16
    Top = 116
    Width = 14
    Height = 13
    Caption = 'l ='
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 17
    Top = 140
    Width = 15
    Height = 13
    Caption = 'w ='
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 214
    Top = 67
    Width = 35
    Height = 13
    Caption = 'ячейки'
  end
  object Label9: TLabel
    Left = 214
    Top = 116
    Width = 22
    Height = 13
    Caption = 'мкм'
  end
  object Label10: TLabel
    Left = 214
    Top = 140
    Width = 12
    Height = 13
    Caption = 'Гц'
  end
  object seStartX: TRxSpinEdit
    Left = 56
    Top = 64
    Width = 65
    Height = 21
    TabOrder = 0
    OnChange = seStartXChange
  end
  object seEndX: TRxSpinEdit
    Left = 144
    Top = 64
    Width = 65
    Height = 21
    TabOrder = 1
    OnChange = seEndXChange
  end
  object cbRectList: TComboBox
    Left = 88
    Top = 8
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object seModeNumber: TRxSpinEdit
    Left = 88
    Top = 32
    Width = 121
    Height = 21
    MaxValue = 20
    MinValue = 1
    Value = 1
    TabOrder = 3
  end
  object seHalfX: TRxSpinEdit
    Left = 144
    Top = 88
    Width = 65
    Height = 21
    MaxValue = 1000
    MinValue = 1
    Value = 4
    TabOrder = 4
    OnChange = seHalfXChange
  end
  object BitBtn1: TBitBtn
    Left = 56
    Top = 168
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 136
    Top = 168
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
  object seLambda: TRxSpinEdit
    Left = 88
    Top = 112
    Width = 121
    Height = 21
    Increment = 0.1
    ValueType = vtFloat
    Value = 70
    TabOrder = 7
    OnChange = seLambdaChange
  end
  object seOmega: TRxSpinEdit
    Left = 88
    Top = 136
    Width = 121
    Height = 21
    Increment = 0.1
    ValueType = vtFloat
    TabOrder = 8
    OnChange = seOmegaChange
  end
end
