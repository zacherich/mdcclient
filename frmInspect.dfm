object frm_Inspect: Tfrm_Inspect
  Left = 0
  Top = 0
  BorderIcons = []
  ClientHeight = 617
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object spb_close: TSpeedButton
    Left = 418
    Top = 579
    Width = 77
    Height = 30
    Caption = #20851#38381
    OnClick = spb_closeClick
  end
  object spb_save: TSpeedButton
    Left = 319
    Top = 579
    Width = 77
    Height = 30
    Caption = #20445#23384
    OnClick = spb_saveClick
  end
  object lbl_tag_fixture: TLabel
    Left = 3
    Top = 584
    Width = 48
    Height = 19
    Caption = #22841#20855#65306
  end
  object dbg_inspect: TDBGrid
    Left = 0
    Top = 153
    Width = 514
    Height = 419
    Align = alTop
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = dbg_inspectDrawColumnCell
    OnKeyDown = dbg_inspectKeyDown
    OnKeyPress = dbg_inspectKeyPress
  end
  object edt_fixture: TEdit
    Left = 57
    Top = 581
    Width = 224
    Height = 27
    TabOrder = 1
  end
  object gpl_top: TGridPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 70.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lbl_tag_wo
        Row = 0
      end
      item
        Column = 1
        Control = lbl_wo
        Row = 0
      end
      item
        Column = 0
        Control = lbl_tag_product_code
        Row = 1
      end
      item
        Column = 1
        Control = lbl_product_code
        Row = 1
      end>
    RowCollection = <
      item
        Value = 49.999999999999960000
      end
      item
        Value = 50.000000000000040000
      end>
    TabOrder = 2
    DesignSize = (
      514
      73)
    object lbl_tag_wo: TLabel
      Left = 2
      Top = 5
      Width = 66
      Height = 25
      Anchors = []
      Caption = #24037#21333#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 120
      ExplicitTop = 6
    end
    object lbl_wo: TLabel
      Left = 257
      Top = 5
      Width = 70
      Height = 25
      Anchors = []
      Caption = 'lbl_wo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 363
      ExplicitTop = 6
    end
    object lbl_tag_product_code: TLabel
      Left = 2
      Top = 42
      Width = 66
      Height = 25
      Anchors = []
      Caption = #20135#21697#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 120
      ExplicitTop = 41
    end
    object lbl_product_code: TLabel
      Left = 201
      Top = 42
      Width = 181
      Height = 25
      Anchors = []
      Caption = 'lbl_product_code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 363
      ExplicitTop = 41
    end
  end
  object pnl_middle: TPanel
    Left = 0
    Top = 73
    Width = 514
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object gpl_middle: TGridPanel
      Left = 0
      Top = 0
      Width = 71
      Height = 80
      Align = alLeft
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 70.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lbl_tag_qty
          Row = 0
        end
        item
          Column = 0
          Control = lbl_qty
          Row = 1
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentColor = True
      ParentFont = False
      RowCollection = <
        item
          Value = 50.000000000000040000
        end
        item
          Value = 49.999999999999960000
        end>
      TabOrder = 0
      DesignSize = (
        71
        80)
      object lbl_tag_qty: TLabel
        Left = 13
        Top = 7
        Width = 44
        Height = 25
        Anchors = []
        Caption = #23436#25104
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 8
      end
      object lbl_qty: TLabel
        Left = 32
        Top = 47
        Width = 6
        Height = 25
        Anchors = []
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ExplicitLeft = 33
      end
    end
    object pnl_result: TPanel
      Left = 71
      Top = 0
      Width = 443
      Height = 80
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -37
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
  end
end
