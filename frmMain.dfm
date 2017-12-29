object frm_main: Tfrm_main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #23433#36153#35834#23425#24503'MES  V1.0.1.2'
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
        OnDblClick = lbl_lineDblClick
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
    object lbl_tag_product_code: TLabel
      Left = 11
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
      Left = 11
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
      Left = 11
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
      Left = 113
      Top = 2
      Width = 22
      Height = 25
      Caption = #26080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_product_code: TLabel
      Left = 69
      Top = 37
      Width = 17
      Height = 19
      Caption = #26080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_todo_qty: TLabel
      Left = 69
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
      Left = 69
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
      Left = 11
      Top = 2
      Width = 96
      Height = 25
      Caption = #24403#21069#24037#21333':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object spb_submit: TSpeedButton
      Left = 347
      Top = 6
      Width = 65
      Height = 22
      Caption = #25253#24037
      Flat = True
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000090000
        000E000000100000001000000010000000100000001000000011000000110000
        0011000000110000001100000011000000100000000B000000038B6545C1C18B
        5FFFC0895DFFC0885CFFBF875BFFBE8658FFBD8457FFBD8456FFBC8355FFBB81
        54FFBB8053FFBA7F52FFBA7F52FFB97E51FF845A39C30000000ACD9D71FFEACB
        A1FFE9C99CFFE9C89CFFE8C89BFFE8C79AFFE7C69BFFE7C698FFE7C598FFE6C5
        97FFE6C596FFE7C496FFE5C394FFE5C394FFC68F5DFF0000000FCD9E72FFEACE
        A5FFE3BE8AFFE3BD8AFFE3BD89FFE3BD89FFE2BC89FFE3BC88FFE2BC87FFE2BB
        87FFE2BA86FFE1BA86FFE1BA85FFE7C598FFC78F5FFF00000010CE9E74FFD7AF
        86FFD3A677FFD3A676FFD3A575FFD2A474FFD1A373FFD1A372FFD1A272FFD0A1
        70FFD0A06FFFD09F6FFFD09F6DFFD2A577FFC79060FF0000000FB18577FFF9F3
        F0FFF7EDE9FFF7EDE8FFF7EEE9FFF2E8E4FFE7DDD9FFE2D9D5FFE7DDD9FFF2E8
        E4FFF6EDE9FFF7EDE8FFF6EDE9FFF9F1EDFFAB7E6FFF0000000EB2887AFFF9F4
        F0FFF7EEE9FFF7EDE9FFF7EEE9FFE8DEDAFFAC6B42FFAB6B42FFAB6A40FFE7DD
        D9FFF6EDE9FFF6EDE9FFF7EEE9FFF8F1EEFFAD8072FF0000000EB48A7CFFF9F4
        F1FFF7EEEAFFF7EEEAFFF7EDEAFFE5DBD9FFB4764BFFF7C276FFB37449FFE4DB
        D7FFF7EDE9FFF6EDE9FFF7EEE9FFF9F2EFFFAF8274FF0000000DB68D7FFFFAF4
        F2FFF7EEEAFFF5ECE8FFEDE5E1FFDAD2CEFFB77B50FFF8C77BFFB5784FFFD8D0
        CDFFECE3DFFFF4EBE7FFF7EEEAFFF9F2EFFFB08476FF0000000CB88F82FFFAF5
        F2FFF7EEEAFFF1E8E5FFC2987CFFB57950FFB97F55FFF9CA82FFB87E53FFB376
        4CFFBF9478FFF0E8E4FFF7EEEAFFF9F3F0FFB28679FF0000000CB99184FFFAF5
        F3FFF8EFEBFFF4ECE7FFE2D7D0FFBB8760FFF5D8A7FFFACF89FFF4D7A7FFB884
        5EFFE1D6D0FFF4EBE7FFF7EFEBFFFAF4F1FFB3897BFF0000000BBB9387FFFAF6
        F4FFF7EFEBFFF7EEEBFFF3EAE6FFD4BEB0FFC9986EFFFCDDA5FFC7956AFFD4BF
        B2FFF2EAE6FFF6EEEAFFF7EEEBFFFAF3F2FFB58B7DFF0000000ABD968AFFFAF6
        F4FFF8EFECFFF7EFECFFF6EEEBFFEFE7E4FFC6A087FFDCB68CFFC6A38CFFEEE7
        E4FFF6EEEAFFF7EFEBFFF7EFECFFFAF5F2FFB68D80FF00000009BE998BFFFAF7
        F4FFF7F0ECFFF8F0ECFFF8F0EDFFF6EDEAFFECE2DEFFD4B499FFECE4DFFFF5EE
        EAFFF8EFECFFF8EFECFFF7EFECFFFAF5F2FFB99083FF00000009C09B8EFFFAF8
        F6FFFBF8F6FFFBF8F6FFFAF8F5FFFAF8F6FFF8F6F3FFF6F4F2FFF8F6F3FFFAF8
        F5FFFAF8F5FFFAF8F5FFFAF7F5FFFAF6F4FFBB9286FF00000008947B72C0C7A6
        9AFFC7A69AFFC6A699FFC6A599FFC6A599FFC6A598FFC6A498FFC5A498FFC5A3
        97FFC5A397FFC5A396FFC4A296FFC4A195FF91776EC200000005}
      OnClick = spb_submitClick
    end
    object spb_refresh: TSpeedButton
      Left = 426
      Top = 6
      Width = 65
      Height = 22
      Caption = #21047#26032
      Flat = True
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000030000000B00000013000000190000001A0000
        00140000000B0000000300000000000000000000000000000000000000000000
        000000000000000000060402011C4827118B7C431ED2A65927FFA55927FF7E44
        1ED442230F7B0100000F0000000E000000070000000000000000000000000000
        000000000005120A05348A4F26DDC58A53FFDCB37CFFEFD298FFEFD198FFB676
        43FF2E1A0C62100904398F5127E10E05013A0000000600000000000000000000
        0002040201198D552BDCD1A169FFF1D6A5FFCE9E6EFFC08656FFBD8251FF613A
        1DA6000000227D4B26CBE2B97BFF5F290FCF0101001900000003000000000000
        00074C2F1B82C99765FFECD2A3FFB98154FB5238238A120C07300F0A06270201
        01194C2F1B88CE9D66FFF6DC9BFFBA8657FF3F1C0C910000000D000000000000
        000A8C5B36D0E3C598FFCB9D75FF573B258C0000000C00000003000000062014
        0C43BD875AFBF8E5BCFFF8DFA5FFF7E4BAFFA16540FC1C0E074C000000080000
        0014B37A4BFAF5E6BDFFBC8356FF0D0704300000000C00000003000000079666
        3FD5B87D4DFFBB8153FFF2D9A1FFB87D4DFFB87C4DFF9C6941DE845331D3A263
        3BFFBB8557FFF6E7BFFFBF8B5EFFA06238FF87522FDC00000006000000020000
        000B0D08042FA1653CFFF4DEAEFFB68155FA000000180000000A1F170F34C79D
        75FBFBF5DCFFFCF3CCFFFAF4DAFFB3855FFB21150C4100000004000000020000
        0009492C1886BA8B5EFFE7CEA7FF926B48CB0000000900000000000000045540
        2D77DDC1A2FFFDF7D9FFD4B598FF5037227F0202010C0D08041F110A05274B2D
        1986A1683EFAF3E4C3FFD8B692FF533F2C780000000400000000000000000000
        00058F6F50BCEFE1CDFF886343C20202010D58382091A3693CFFA66F43FFBE94
        6DFFF4E9D1FFE3CAADFFA47E5BD60504030E0000000100000000000000000000
        0001130F0B1DAB8863DA18130E242C1E1248B78B63FDF8F3E2FFF9F3E4FFEDDE
        C7FFDCC1A1FFA3815ED215110C22000000020000000000000000000000000000
        000000000001000000010101000342301E629A7B5CC2C6A078F9C6A078F9997B
        5DC3564634710504030A00000001000000000000000000000000000000000000
        0000000000000000000000000000000000010000000200000002000000020000
        0002000000010000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
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
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00040000000F0000000F00000007000000010000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000EB0683FFF834324E131190D6A000000110000000600000001000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0011B37045FFDEAF77FFB47247FF773C20D2201009500000000F000000050000
        0001000000000000000000000000000000000000000000000000000000000000
        0010B6764BFFECC38FFFE8BA7DFFD8A66FFFAD693FFF6A371CBE170C06400000
        000D000000040000000100000000000000000000000000000000000000000000
        000FBB7C51FFEFCD9CFFE9BB7FFFE8BC80FFEABE83FFD39D6CFFA7623BFD5B30
        1AA90D07032C0000000B00000003000000010000000000000000000000000000
        000EBE8257FFF1D5ACFFEBC087FFE9BF85FFE8BD81FFE9BF82FFE9C087FFCD97
        65FF9F5933F74E29169408040221000000090000000200000000000000000000
        000DC0855EFFF5DEBBFFEDC68FFFEDC58DFFEBC289FFEAC084FFE8BC80FFE9BD
        82FFE8BB87FFC78E60FF965430EE4223137E0000000900000000000000000000
        000CC59067FFF9E9CFFFF3D4A3FFF2D09FFFF0CC98FFEEC890FFEBC088FFE9BE
        83FFEAC38AFFECC693FFE3B889FFA65B33FF0000000D00000000000000000000
        000BC9956EFFFAEFDAFFF4DAAEFFF5D8AAFFF2D5A6FFF1D1A1FFF1D0A2FFF1D2
        A8FFEDCDA1FFCC956BFF9A5D39E33A2314680000000700000000000000000000
        000ACC9B73FFFCF4E3FFF8E0B7FFF6DDB4FFF6DEB4FFF7E2C0FFF6E1C1FFD9B2
        8CFFB0754EF14D301F7E04030216000000060000000100000000000000000000
        0009CDA077FFFEF7E9FFFBE7C2FFFBEBCCFFFBEFD6FFE3C5A7FFC08B65F96544
        2E960B07051E0000000600000002000000000000000000000000000000000000
        0008D0A47CFFFEFBEFFFFDF4E0FFEEDAC1FFD1A07DFF78553CA717100B2C0000
        0007000000020000000000000000000000000000000000000000000000000000
        0007D2A77FFFF5EADBFFD8B291FF916D50BE261C143C00000007000000020000
        0000000000000000000000000000000000000000000000000000000000000000
        0005D5AA83FFA98462D3372B204F000000070000000200000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0001000000040000000500000002000000010000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
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
    Top = 254
    Width = 523
    Height = 417
    ActivePage = tbs_workorder
    Align = alClient
    TabOrder = 2
    object tbs_workorder: TTabSheet
      Caption = #26009#21333#20449#24687
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 0
        Top = 235
        Width = 515
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 232
      end
      object pnl_workorder: TPanel
        Left = 0
        Top = 0
        Width = 515
        Height = 235
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
          Height = 215
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
        Top = 238
        Width = 515
        Height = 146
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
          Height = 126
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
      object dbg_collection: TDBGrid
        Left = 0
        Top = 25
        Width = 515
        Height = 359
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
      object lbx_log: TListBox
        Left = 0
        Top = 0
        Width = 515
        Height = 384
        Style = lbVirtual
        Align = alClient
        ItemHeight = 18
        TabOrder = 0
      end
    end
  end
  object pnl_tipsbar: TPanel
    Left = 0
    Top = 217
    Width = 523
    Height = 37
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
end
