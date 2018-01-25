object frm_ReplaceWO: Tfrm_ReplaceWO
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #23433#36153#35834#23425#24503'MES----'#20999#25442#24037#21333
  ClientHeight = 396
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    461
    396)
  PixelsPerInch = 96
  TextHeight = 19
  object lbl_tag_now_wo: TLabel
    Left = 24
    Top = 9
    Width = 110
    Height = 25
    Anchors = []
    Caption = #24403#21069#24037#21333#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_tag_now_product: TLabel
    Left = 24
    Top = 44
    Width = 110
    Height = 25
    Anchors = []
    Caption = #24403#21069#20135#21697#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_now_wo: TLabel
    Left = 124
    Top = 9
    Width = 128
    Height = 25
    Anchors = []
    Caption = 'lbl_now_wo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_now_product: TLabel
    Left = 124
    Top = 44
    Width = 177
    Height = 25
    Anchors = []
    Caption = 'lbl_now_product'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_tag_now_input: TLabel
    Left = 24
    Top = 81
    Width = 80
    Height = 19
    Anchors = []
    Caption = #35745#21010#25968#37327#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_now_input: TLabel
    Left = 98
    Top = 80
    Width = 101
    Height = 19
    Anchors = []
    Caption = 'lbl_now_input'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object spb_default_wo: TSpeedButton
    Left = 344
    Top = 2
    Width = 109
    Height = 38
    Caption = #36820#22238#20027#32447#24037#21333
    OnClick = spb_default_woClick
  end
  object dbg_replacewo: TDBGrid
    Left = 5
    Top = 104
    Width = 449
    Height = 276
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dbg_replacewoDblClick
  end
end
