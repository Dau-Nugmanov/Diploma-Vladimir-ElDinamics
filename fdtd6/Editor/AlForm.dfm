object AlignForm: TAlignForm
  Left = 237
  Top = 167
  BorderStyle = bsDialog
  Caption = 'Выравнивание'
  ClientHeight = 160
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object rgVertAlign: TRadioGroup
    Left = 8
    Top = 8
    Width = 137
    Height = 105
    Caption = 'Вертикально'
    ItemIndex = 3
    Items.Strings = (
      'К верхнему краю'
      'В центр'
      'К нижнему краю'
      'Без изменений')
    TabOrder = 0
  end
  object rgHorAlign: TRadioGroup
    Left = 152
    Top = 8
    Width = 137
    Height = 105
    Caption = 'Горизонтально'
    ItemIndex = 3
    Items.Strings = (
      'К левому краю'
      'В центр'
      'К правому краю'
      'Без изменений')
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 128
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Отмена'
    TabOrder = 3
    Kind = bkCancel
  end
end
