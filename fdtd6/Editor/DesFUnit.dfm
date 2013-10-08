object DescrForm: TDescrForm
  Left = 240
  Top = 129
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Описание'
  ClientHeight = 255
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 379
    Height = 209
    TabOrder = 0
    WantReturns = False
  end
  object BitBtn1: TBitBtn
    Left = 192
    Top = 224
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 280
    Top = 224
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
