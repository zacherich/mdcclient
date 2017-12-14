object frm_main: Tfrm_main
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #23433#36153#35834#23425#24503'MES'
  ClientHeight = 671
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object pnl_top: TPanel
    Left = 0
    Top = 0
    Width = 523
    Height = 102
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lbl_equipment_state: TLabel
      Left = 4
      Top = 71
      Width = 42
      Height = 25
      Alignment = taCenter
      Caption = #29366#24577
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object shp_equipment_state: TShape
      Left = 4
      Top = 4
      Width = 64
      Height = 64
      Brush.Color = clGray
      Pen.Color = clWhite
      Pen.Style = psClear
      Pen.Width = 0
      Shape = stEllipse
    end
    object gpl_operator: TGridPanel
      Left = 385
      Top = 1
      Width = 137
      Height = 100
      Align = alRight
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lbl_tag_operator
          Row = 0
        end
        item
          Column = 0
          Control = lbl_operator
          Row = 1
        end>
      RowCollection = <
        item
          Value = 37.500000000000000000
        end
        item
          Value = 62.500000000000000000
        end>
      TabOrder = 0
      DesignSize = (
        137
        100)
      object lbl_tag_operator: TLabel
        Left = 34
        Top = 9
        Width = 68
        Height = 19
        Anchors = []
        Caption = #25805#20316#20154#21592
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 36
      end
      object lbl_operator: TLabel
        Left = 0
        Top = 37
        Width = 137
        Height = 63
        Align = alClient
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 7
        ExplicitHeight = 25
      end
    end
    object gpl_equipment: TGridPanel
      Left = 91
      Top = 1
      Width = 294
      Height = 100
      Align = alRight
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 20.000000000000030000
        end
        item
          Value = 79.999999999999970000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lbl_tag_equipment
          Row = 0
        end
        item
          Column = 1
          Control = lbl_equipment
          Row = 0
        end
        item
          Column = 0
          Control = lbl_tag_line
          Row = 1
        end
        item
          Column = 1
          Control = lbl_line
          Row = 1
        end
        item
          Column = 0
          Control = lbl_tag_station
          Row = 2
        end
        item
          Column = 1
          Control = lbl_station
          Row = 2
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 25.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 25.000000000000000000
        end
        item
          SizeStyle = ssAuto
        end>
      TabOrder = 1
      DesignSize = (
        294
        100)
      object lbl_tag_equipment: TLabel
        Left = 0
        Top = 10
        Width = 58
        Height = 29
        Anchors = []
        Caption = #35774#22791#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnDblClick = lbl_tag_equipmentDblClick
      end
      object lbl_equipment: TLabel
        Left = 116
        Top = 13
        Width = 119
        Height = 23
        Alignment = taCenter
        Anchors = []
        Caption = 'lbl_equipment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 125
        ExplicitTop = 15
      end
      object lbl_tag_line: TLabel
        Left = 5
        Top = 53
        Width = 48
        Height = 19
        Anchors = []
        Caption = #20135#32447#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 14
        ExplicitTop = 54
      end
      object lbl_line: TLabel
        Left = 150
        Top = 53
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
        ExplicitLeft = 86
      end
      object lbl_tag_station: TLabel
        Left = 5
        Top = 78
        Width = 48
        Height = 19
        Anchors = []
        Caption = #24037#20301#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 14
        ExplicitTop = 79
      end
      object lbl_station: TLabel
        Left = 139
        Top = 78
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
        ExplicitLeft = 153
        ExplicitTop = 79
      end
    end
  end
  object pnl_middle: TPanel
    Left = 0
    Top = 102
    Width = 523
    Height = 115
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lbl_tag_wo: TLabel
      Left = 16
      Top = 37
      Width = 64
      Height = 19
      Caption = #24037#21333#21495#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_product_code: TLabel
      Left = 268
      Top = 37
      Width = 63
      Height = 19
      Caption = #20135'   '#21697#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_todo_qty: TLabel
      Left = 16
      Top = 62
      Width = 63
      Height = 19
      Caption = #24212'   '#20570#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_done_qty: TLabel
      Left = 149
      Top = 62
      Width = 63
      Height = 19
      Caption = #23454'   '#20316#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_good_qty: TLabel
      Left = 268
      Top = 62
      Width = 63
      Height = 19
      Caption = #21512'   '#26684#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_bad_qty: TLabel
      Left = 410
      Top = 62
      Width = 64
      Height = 19
      Caption = #19981#21512#26684#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_doing_qty: TLabel
      Left = 16
      Top = 87
      Width = 64
      Height = 19
      Caption = #24453#25253#24037#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_wo: TLabel
      Left = 74
      Top = 37
      Width = 16
      Height = 19
      Caption = #26080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_product_code: TLabel
      Left = 325
      Top = 37
      Width = 16
      Height = 19
      Caption = #26080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_todo_qty: TLabel
      Left = 74
      Top = 62
      Width = 9
      Height = 19
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_done_qty: TLabel
      Left = 207
      Top = 62
      Width = 9
      Height = 19
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_good_qty: TLabel
      Left = 325
      Top = 62
      Width = 9
      Height = 19
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_bad_qty: TLabel
      Left = 468
      Top = 62
      Width = 9
      Height = 19
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_doing_qty: TLabel
      Left = 74
      Top = 87
      Width = 9
      Height = 19
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_tag_title: TLabel
      Left = 190
      Top = 2
      Width = 112
      Height = 33
      Caption = #24403#21069#24037#21333
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object spb_submit: TSpeedButton
      Left = 347
      Top = 6
      Width = 65
      Height = 22
      Caption = #25253#24037
      Flat = True
      OnClick = spb_submitClick
    end
    object spb_refresh: TSpeedButton
      Left = 426
      Top = 6
      Width = 65
      Height = 22
      Caption = #21047#26032
      Flat = True
      OnClick = spb_refreshClick
    end
    object lbl_tag_state: TLabel
      Left = 149
      Top = 87
      Width = 60
      Height = 18
      Caption = #29366'   '#24577#65306
    end
    object lbl_state: TLabel
      Left = 207
      Top = 87
      Width = 8
      Height = 18
      Caption = '0'
    end
    object spb_start: TSpeedButton
      Left = 418
      Top = 6
      Width = 65
      Height = 22
      Caption = #24320#24037
      Flat = True
      OnClick = spb_startClick
    end
    object lbl_tag_weld_count: TLabel
      Left = 268
      Top = 87
      Width = 75
      Height = 18
      Caption = #28938#25509#27425#25968#65306
    end
    object lbl_weld_count: TLabel
      Left = 340
      Top = 87
      Width = 8
      Height = 18
      Caption = '0'
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 217
    Width = 523
    Height = 431
    ActivePage = tbs_workorder
    Align = alClient
    TabOrder = 2
    object tbs_workorder: TTabSheet
      Caption = #26009#21333#20449#24687
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 0
        Top = 201
        Width = 515
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 145
        ExplicitWidth = 256
      end
      object pnl_workorder: TPanel
        Left = 0
        Top = 0
        Width = 515
        Height = 201
        Align = alTop
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object lbl_tag_workorder: TLabel
          Left = 1
          Top = 1
          Width = 513
          Height = 18
          Align = alTop
          Caption = #24037#21333#20449#24687
          Color = clSkyBlue
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = False
          ExplicitWidth = 60
        end
        object dbg_workorder: TDBGrid
          Left = 1
          Top = 19
          Width = 513
          Height = 181
          Align = alClient
          DataSource = data_module.dsc_workorder
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = dbg_workorderDrawColumnCell
          OnDblClick = dbg_workorderDblClick
        end
      end
      object pnl_materiel: TPanel
        Left = 0
        Top = 204
        Width = 515
        Height = 194
        Align = alClient
        TabOrder = 1
        object lbl_tag_materiel: TLabel
          Left = 1
          Top = 1
          Width = 513
          Height = 18
          Align = alTop
          Caption = #21407#26448#26009#20449#24687
          Color = clMoneyGreen
          ParentColor = False
          Transparent = False
          ExplicitWidth = 75
        end
        object dbg_materiel: TDBGrid
          Left = 1
          Top = 19
          Width = 513
          Height = 174
          Align = alClient
          DataSource = data_module.dsc_materials
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
    object tbs_collection: TTabSheet
      Caption = #37319#38598#25968#25454
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbg_collection: TDBGrid
        Left = 0
        Top = 25
        Width = 515
        Height = 373
        Align = alClient
        DataSource = data_module.dsc_mdc
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object pnl_collection: TPanel
        Left = 0
        Top = 0
        Width = 515
        Height = 25
        Align = alTop
        Color = clInfoBk
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 1
        object lbl_tag_send_qty: TLabel
          Left = 26
          Top = 1
          Width = 105
          Height = 18
          Caption = #37319#38598#25104#21151#26465#25968#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_send_qty: TLabel
          Left = 137
          Top = 1
          Width = 8
          Height = 18
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_tag_fail_qty: TLabel
          Left = 233
          Top = 1
          Width = 105
          Height = 18
          Caption = #37319#38598#22833#36133#26465#25968#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_fail_qty: TLabel
          Left = 344
          Top = 1
          Width = 8
          Height = 18
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
    end
    object tbs_log: TTabSheet
      Caption = #31995#32479#26085#24535
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbx_log: TListBox
        Left = 0
        Top = 0
        Width = 515
        Height = 398
        Style = lbVirtual
        Align = alClient
        ItemHeight = 18
        TabOrder = 0
      end
    end
  end
  object stb_tipsbar: TStatusBar
    Left = 0
    Top = 648
    Width = 523
    Height = 23
    Panels = <
      item
        Width = 350
      end
      item
        Width = 50
      end>
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 468
    Top = 610
  end
end
