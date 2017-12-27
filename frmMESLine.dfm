object frm_MESLine: Tfrm_MESLine
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #23433#36153#35834#23425#24503'MES----'#20999#25442#20135#32447
  ClientHeight = 396
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    291
    396)
  PixelsPerInch = 96
  TextHeight = 18
  object lbl_tag_line: TLabel
    Left = 21
    Top = 8
    Width = 80
    Height = 19
    Anchors = []
    Caption = #24403#21069#20135#32447#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 16
  end
  object lbl_tag_station: TLabel
    Left = 21
    Top = 34
    Width = 80
    Height = 19
    Anchors = []
    Caption = #24403#21069#24037#20301#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 16
  end
  object lbl_line: TLabel
    Left = 100
    Top = 8
    Width = 51
    Height = 19
    Anchors = []
    Caption = 'lbl_line'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 89
  end
  object lbl_station: TLabel
    Left = 101
    Top = 34
    Width = 73
    Height = 19
    Anchors = []
    Caption = 'lbl_station'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 89
  end
  object dlc_mesline: TDBLookupComboBox
    Left = 12
    Top = 59
    Width = 267
    Height = 26
    TabOrder = 0
    OnCloseUp = dlc_meslineCloseUp
  end
  object dbg_station: TDBGrid
    Left = 12
    Top = 86
    Width = 267
    Height = 294
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -15
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = dbg_stationDrawColumnCell
    OnDblClick = dbg_stationDblClick
  end
end
