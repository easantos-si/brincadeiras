object Form1: TForm1
  Left = 315
  Top = 196
  Width = 1097
  Height = 646
  Caption = 'Erick Andrade dos Santos RA: 09111204 Uniesp 4'#186': A'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 608
    Align = alLeft
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 8
      Top = 16
      Width = 257
      Height = 121
      TabOrder = 0
      object Label1: TLabel
        Left = 72
        Top = 16
        Width = 100
        Height = 16
        Caption = 'Arvore Bin'#225'ria'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button2: TButton
        Left = 139
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Balancear'
        TabOrder = 2
        OnClick = Button2Click
      end
      object B_Inserir: TButton
        Left = 35
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Inserir'
        TabOrder = 1
        OnClick = B_InserirClick
      end
      object E_Entrada: TEdit
        Left = 59
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
        OnKeyPress = E_EntradaKeyPress
      end
    end
    object GroupBox2: TGroupBox
      Left = 20
      Top = 176
      Width = 224
      Height = 105
      Caption = 'Total de NO'#39's'
      TabOrder = 1
      object L_TotalNos: TLabel
        Left = 2
        Top = 15
        Width = 220
        Height = 88
        Align = alClient
        Alignment = taCenter
        Caption = '0'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -64
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
    end
  end
  object Panel2: TPanel
    Left = 273
    Top = 0
    Width = 808
    Height = 608
    Align = alClient
    TabOrder = 1
    object IM_visualizador: TImage
      Left = 1
      Top = 1
      Width = 806
      Height = 606
      Align = alClient
      PopupMenu = PopupMenu1
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'ArvoreAVL'
    Filter = 'Imagem|*.BMP'
    Left = 849
    Top = 80
  end
  object PopupMenu1: TPopupMenu
    Left = 377
    Top = 200
    object Salvar1: TMenuItem
      Caption = 'Salvar'
      OnClick = Salvar1Click
    end
  end
end
