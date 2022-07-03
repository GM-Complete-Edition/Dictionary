object TelephoneBook: TTelephoneBook
  Left = 71
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Telephone Book Directory'
  ClientHeight = 348
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 409
    Top = 0
    Width = 2
    Height = 348
    Align = alLeft
    Shape = bsLeftLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 348
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object NumberPanel: TPanel
      Left = 0
      Top = 23
      Width = 409
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Shell Dlg'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 97
        Height = 20
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Number:'
        TabOrder = 0
      end
      object Number: TEdit
        Left = 96
        Top = 0
        Width = 312
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
    end
    object Names: TListBox
      Left = 0
      Top = 43
      Width = 409
      Height = 305
      Align = alClient
      Color = clAppWorkSpace
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 1
      OnClick = NamesClick
      OnDblClick = Button4Click
      OnKeyPress = NamesKeyPress
    end
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 409
      Height = 23
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Names'
      Color = 13018781
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Shell Dlg'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 411
    Top = 0
    Width = 119
    Height = 348
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 24
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 24
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Rename'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 24
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 24
      Top = 176
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 119
      Height = 23
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Item'
      Color = 13018781
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Shell Dlg'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
  end
  object Dictionary: TDictionary
    Left = 8
    Top = 52
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 52
    object SortbyName1: TMenuItem
      Caption = 'Sort by Name'
      OnClick = SortbyName1Click
    end
    object SortByNumber1: TMenuItem
      Caption = 'Sort by Number'
      OnClick = SortByNumber1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Shuffle1: TMenuItem
      Caption = 'Shuffle'
      OnClick = Shuffle1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
  end
end
