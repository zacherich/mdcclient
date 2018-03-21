object data_module: Tdata_module
  OldCreateOrder = False
  Height = 426
  Width = 428
  object cds_mdc: TClientDataSet
    Aggregates = <>
    Params = <>
    OnNewRecord = cds_mdcNewRecord
    Left = 88
    Top = 16
  end
  object dsc_mdc: TDataSource
    DataSet = cds_mdc
    Left = 88
    Top = 80
  end
  object dsc_badmode: TDataSource
    DataSet = cds_badmode
    Left = 160
    Top = 80
  end
  object cds_badmode: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    FieldDefs = <
      item
        Name = 'badmode_id'
        DataType = ftInteger
      end
      item
        Name = 'badmode_name'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'badmode_qty'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 160
    Top = 16
  end
  object dsc_workorder: TDataSource
    DataSet = cds_workorder
    Left = 240
    Top = 80
  end
  object cds_workorder: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 240
    Top = 16
  end
  object dsc_materials: TDataSource
    DataSet = cds_materials
    Left = 320
    Top = 80
  end
  object cds_materials: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 320
    Top = 16
  end
  object dsc_mesline: TDataSource
    DataSet = cds_mesline
    Left = 80
    Top = 216
  end
  object cds_mesline: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 80
    Top = 152
  end
  object dsc_station: TDataSource
    DataSet = cds_station
    Left = 168
    Top = 216
  end
  object cds_station: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 168
    Top = 152
  end
  object dsc_replacewo: TDataSource
    DataSet = cds_replacewo
    Left = 240
    Top = 216
  end
  object cds_replacewo: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 240
    Top = 152
  end
  object cds_printer: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 320
    Top = 152
  end
  object dsc_printer: TDataSource
    DataSet = cds_printer
    Left = 320
    Top = 216
  end
  object cds_inspect: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 80
    Top = 288
  end
  object dsc_inspect: TDataSource
    DataSet = cds_inspect
    Left = 80
    Top = 352
  end
end
