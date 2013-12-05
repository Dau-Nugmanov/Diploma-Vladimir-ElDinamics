object FSForm: TFSForm
  Left = 234
  Top = 115
  BorderStyle = bsDialog
  ClientHeight = 222
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 120
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 200
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 265
    Height = 85
    Caption = 'Прямая волна'
    TabOrder = 2
    object lbToF: TLabel
      Left = 144
      Top = 40
      Width = 12
      Height = 13
      Caption = 'до'
    end
    object rbAllF: TRadioButton
      Left = 8
      Top = 16
      Width = 201
      Height = 17
      Caption = 'Обработать всю реализацию'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbFromFClick
    end
    object rbFromF: TRadioButton
      Left = 8
      Top = 40
      Width = 41
      Height = 17
      Caption = 'от'
      TabOrder = 1
      OnClick = rbFromFClick
    end
    object seFromF: TRxSpinEdit
      Left = 40
      Top = 38
      Width = 97
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object seToF: TRxSpinEdit
      Left = 160
      Top = 37
      Width = 97
      Height = 21
      Value = 200
      Enabled = False
      TabOrder = 3
    end
    object cbWindowF: TCheckBox
      Left = 9
      Top = 64
      Width = 128
      Height = 17
      Caption = 'Использовать окно'
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 86
    Width = 265
    Height = 85
    Caption = 'Обратная волна'
    TabOrder = 3
    object lbToB: TLabel
      Left = 144
      Top = 40
      Width = 12
      Height = 13
      Caption = 'до'
    end
    object rbAllB: TRadioButton
      Left = 8
      Top = 16
      Width = 217
      Height = 17
      Caption = 'Обработать всю реализацию'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbFromBClick
    end
    object rbFromB: TRadioButton
      Left = 8
      Top = 40
      Width = 41
      Height = 17
      Caption = 'от'
      TabOrder = 1
      OnClick = rbFromBClick
    end
    object seFromB: TRxSpinEdit
      Left = 40
      Top = 38
      Width = 97
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object seToB: TRxSpinEdit
      Left = 160
      Top = 37
      Width = 97
      Height = 21
      Value = 200
      Enabled = False
      TabOrder = 3
    end
    object cbWindowB: TCheckBox
      Left = 9
      Top = 64
      Width = 128
      Height = 17
      Caption = 'Использовать окно'
      TabOrder = 4
    end
  end
end
