{====================================================================}
{   TOxygenDirectorySpy Component, v1.6 c 2000-2001 Oxygen Software  }
{--------------------------------------------------------------------}
{          Written by Oleg Fyodorov, delphi@oxygensoftware.com       }
{                  http://www.oxygensoftware.com                     }
{====================================================================}

unit o2DirSpy;

interface

  uses Classes, Controls, Windows, SysUtils, ShellApi, Dialogs, Messages, FileCtrl;

  type
    TDirectoryChangeType = (ctNone, ctAttributes, ctSize, ctCreationTime, ctLastModificationTime, ctLastAccessTime, ctLastTime, ctCreate, ctRemove);

    TOxygenDirectorySpy = class;

    TDirectoryChangeRecord = record
      Directory : String;
      FileFlag : Boolean; // When True, ChangeType applies to a file; False - ChangeType applies to Directory
      Name : String; // Name of changed file/directory
      OldTime, NewTime : TDateTime;  // Significant only when ChangeType is one of ctCreationTime, ctLastModificationTime, ctLastAccessTime, ctLastTime
      OldAttributes, NewAttributes : DWord; // Significant only when ChangeType is ctAttributes
      OldSize, NewSize : DWord; // Significant only when ChangeType is ctSize
      ChangeType : TDirectoryChangeType; // Describes a change type (creation, removing etc.)
    end;

    TSpySearchRec = record
      Time: Integer;
      Size: Integer;
      Attr: Integer;
      dwFileAttributes: DWORD;
      ftCreationTime: TFileTime;
      ftLastAccessTime: TFileTime;
      ftLastWriteTime: TFileTime;
      nFileSizeHigh: DWORD;
      nFileSizeLow: DWORD;
    end;

    TFileData = class
      private
        FSearchRec : TSpySearchRec;
        Name: TFileName;
        FFound : Boolean;
      public
        constructor Create;
        procedure Free;
    end;

    TFileDataList = class(TStringList)
      private
        function NewFileData(const FileName : String; sr : TSearchRec) : TFileData;
        function GetFoundCount : Integer;
      public
        property FoundCount : Integer read GetFoundCount;

        destructor Destroy; override;
        function AddFileData(FileData : TFileData) : Integer;
        function AddSearchRec(const Directory : String; sr : TSearchRec) : Integer;
        procedure Delete(Index : Integer); override;
        procedure Clear; override;
        procedure SetFound(Value : Boolean);
    end;

    TReadDirChangesThread = class(TThread)
    private
      FOwner           : TOxygenDirectorySpy;
      FDirectories     : TStringList;
      FHandles         : TList;
      FChangeRecord    : TDirectoryChangeRecord;
      FFilesData,
      FTempFilesData   : TFileDataList;
      pHandles         : PWOHandleArray;
      procedure ReleaseHandle;
      procedure AllocateHandle;
      procedure ReadDirectories(DestData : TFileDataList);
      procedure CompareSearchRec(var srOld, srNew : TSpySearchRec);
    protected
      procedure Execute; override;
      procedure Notify;
    public
      constructor Create(Owner : TOxygenDirectorySpy);
      destructor Destroy; override;
      procedure Reset;
    end;

    TChangeDirectoryEvent = procedure (Sender : TObject; ChangeRecord : TDirectoryChangeRecord) of object;

    TOxygenDirectorySpy = class(TComponent)
      private
        FThread : TReadDirChangesThread;
        FEnabled,
        FWatchSubTree : Boolean;
        FDirectories : TStrings;
        FOnChangeDirectory : TChangeDirectoryEvent;

        procedure SetEnabled(const Value : Boolean);
        procedure CheckDirectories;
        procedure SetDirectories(const Value : TStrings);
        procedure SetWatchSubTree(const Value : Boolean);
      protected
        procedure DoChangeDirectory(ChangeRecord : TDirectoryChangeRecord);
      published
        property Enabled : Boolean read FEnabled write SetEnabled;
        property Directories : TStrings read FDirectories write SetDirectories;
        property WatchSubTree : Boolean read FWatchSubTree write SetWatchSubTree;
        property OnChangeDirectory : TChangeDirectoryEvent read FOnChangeDirectory write FOnChangeDirectory;
      public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy; override;
    end;

    function ChangeRecord2String(ChangeRecord : TDirectoryChangeRecord) : String;

    procedure Register;

implementation

function ChangeRecord2String(ChangeRecord : TDirectoryChangeRecord) : String;
  var s : String;
begin
  case ChangeRecord.ChangeType of
    ctAttributes           : s := 'Attributes';
    ctSize                 : s := 'Size';
    ctCreationTime         : s := 'CreationTime';
    ctLastModificationTime : s := 'LastModificationTime';
    ctLastAccessTime       : s := 'LastAccessTime';
    ctLastTime             : s := 'LastTime';
    ctCreate               : s := 'Create';
    ctRemove               : s := 'Remove';
  end;
  Result := booltostr(ChangeRecord.FileFlag)+'|'+ChangeRecord.Name+'|'+s;
{  Result := 'No changes';
  if ChangeRecord.FileFlag then s := 'File ' else s := 'Directory ';
  s := s + '"' + ChangeRecord.Name + '"';
  case ChangeRecord.ChangeType of
    ctAttributes           : Result := s + ' attributes are changed. Old: ' + IntToHex(ChangeRecord.OldAttributes,8) + ', New: ' + IntToHex(ChangeRecord.NewAttributes,8);
    ctSize                 : Result := s + ' size is changed. Old: ' + IntToStr(ChangeRecord.OldSize) + ', New: ' + IntToStr(ChangeRecord.NewSize);
    ctCreationTime         : Result := s + ' creation time is changed. Old: ' + DateTimeToStr(ChangeRecord.OldTime) + ', New: ' + DateTimeToStr(ChangeRecord.NewTime);
    ctLastModificationTime : Result := s + ' last modification time is changed. Old: ' + DateTimeToStr(ChangeRecord.OldTime) + ', New: ' + DateTimeToStr(ChangeRecord.NewTime);
    ctLastAccessTime       : Result := s + ' last access time is changed. Old: ' + DateTimeToStr(ChangeRecord.OldTime) + ', New: ' + DateTimeToStr(ChangeRecord.NewTime);
    ctLastTime             : Result := s + ' time is changed. Old: ' + DateTimeToStr(ChangeRecord.OldTime) + ', New: ' + DateTimeToStr(ChangeRecord.NewTime);
    ctCreate               : Result := s + ' is created';
    ctRemove               : Result := s + ' is deleted';
  end;}
end;

function  SameSystemTime(Time1, Time2 : TSystemTime) : Boolean;
begin
  Result := ((Time1.wYear = Time2.wYear) and (Time1.wMonth = Time2.wMonth) and (Time1.wDay = Time2.wDay) and (Time1.wHour = Time2.wHour) and (Time1.wMinute = Time2.wMinute) and (Time1.wSecond = Time2.wSecond) and (Time1.wMilliseconds = Time2.wMilliseconds));
end;

function ReplaceText(s, SourceText, DestText: String):String;
  var st,res:string;
      i:Integer;
begin
  ReplaceText:='';
  if ((s='') or (SourceText='')) then Exit;
  st:=s;
  res:='';
  i:=Pos(SourceText,s);
  while (i>0) do
  begin
    res:=res+Copy(st,1,i-1)+DestText;
    Delete(st,1,(i+Length(SourceText)-1));
    i:=Pos(SourceText,st);
  end;
  res:=res+st;
  ReplaceText:=res;
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TFileData
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TFileData.Create;
begin
  inherited Create;
  Name := '';
  FillChar(FSearchRec,SizeOf(FSearchRec),0);
  FFound := False;
end;

procedure TFileData.Free;
begin
  Name := '';
  //Finalize(FSearchRec);
  inherited Free;
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  TFileDataList
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TFileDataList.Destroy;
begin
  Clear;
  inherited Destroy;;
end;

function TFileDataList.NewFileData(const FileName : String; sr : TSearchRec) : TFileData;
begin
  Result := TFileData.Create;
  Result.Name := FileName;
  with Result.FSearchRec do begin
    Time := sr.Time;
    Size := sr.Size;
    Attr := sr.Attr;
    dwFileAttributes := sr.FindData.dwFileAttributes;
    ftCreationTime := sr.FindData.ftCreationTime;
    ftLastAccessTime := sr.FindData.ftLastAccessTime;
    ftLastWriteTime := sr.FindData.ftLastWriteTime;
    nFileSizeHigh := sr.FindData.nFileSizeHigh;
    nFileSizeLow := sr.FindData.nFileSizeLow;
  end;
end;

function TFileDataList.GetFoundCount : Integer;
  var i : Integer;
begin
  Result := 0;
  for i := 1 to Count do if TFileData(Objects[i-1]).FFound then Inc(Result);
end;

function TFileDataList.AddFileData(FileData : TFileData) : Integer;
  var fd : TFileData;
begin
  fd := TFileData.Create;
  fd.Name := FileData.Name;
  fd.FSearchRec := FileData.FSearchRec;
  Result := AddObject(fd.Name, fd);
end;

function TFileDataList.AddSearchRec(const Directory : String; sr : TSearchRec) : Integer;
  var FileName : String;
begin
  if (Directory <> '') then FileName := ReplaceText(Directory + '\' + sr.Name,'\\','\') else FileName := sr.Name;
  Result := AddObject(FileName, NewFileData(FileName, sr));
end;

procedure TFileDataList.Delete(Index : Integer);
begin
  TFileData(Objects[Index]).Free;
  inherited Delete(Index);
end;

procedure TFileDataList.Clear;
begin
  while (Count > 0) do Delete(0);
  inherited Clear;
end;

procedure TFileDataList.SetFound(Value : Boolean);
  var i : Integer;
begin
  for i := 1 to Count do TFileData(Objects[i-1]).FFound := Value;
end;

function CompareMem(fpBlock1, fpBlock2: Pointer; Size: Cardinal): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,fpBlock1
        MOV     EDI,fpBlock2
        MOV     ECX,Size
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,2
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//       TReadDirChangesThread
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TReadDirChangesThread.CompareSearchRec(var srOld, srNew : TSpySearchRec);
  var tt,nt,ot : TSystemTime;
      //sro,srn : TSpySearchRec;
begin
  FChangeRecord.ChangeType := ctNone;
  if CompareMem(@srOld,@srNew, SizeOf(TSpySearchRec)) then Exit;
  if (srOld.Time <> srNew.Time) then begin
    FChangeRecord.ChangeType := ctLastTime;
    FChangeRecord.OldTime := FileDateToDateTime(srOld.Time);
    FChangeRecord.NewTime := FileDateToDateTime(srNew.Time);
    srOld.Time := srNew.Time;
    Exit;
  end
  else if (srOld.Size <> srNew.Size) then begin
    FChangeRecord.ChangeType := ctSize;
    FChangeRecord.OldSize := srOld.Size;
    FChangeRecord.NewSize := srNew.Size;
    srOld.Size := srNew.Size;
    Exit;
  end
  else if (srOld.Attr <> srNew.Attr) or (srOld.dwFileAttributes <> srNew.dwFileAttributes) then begin
    FChangeRecord.ChangeType := ctAttributes;
    FChangeRecord.OldAttributes := srOld.dwFileAttributes;
    FChangeRecord.NewAttributes := srNew.dwFileAttributes;
    srOld.dwFileAttributes := srNew.dwFileAttributes;
    srOld.Attr := srNew.Attr;
    Exit;
  end
  else begin
    FileTimeToSystemTime(srNew.ftCreationTime,nt);
    SystemTimeToTzSpecificLocalTime(nil,nt,tt);
    nt := tt;
    FileTimeToSystemTime(srOld.ftCreationTime,ot);
    SystemTimeToTzSpecificLocalTime(nil,ot,tt);
    ot := tt;
    if not SameSystemTime(nt,ot) then begin
      FChangeRecord.ChangeType := ctCreationTime;
      FChangeRecord.OldTime := SystemTimeToDateTime(ot);
      FChangeRecord.NewTime := SystemTimeToDateTime(nt);
      srOld.ftCreationTime := srNew.ftCreationTime;
      Exit;
    end
    else begin
      FileTimeToSystemTime(srNew.ftLastAccessTime,nt);
      SystemTimeToTzSpecificLocalTime(nil,nt,tt);
      nt := tt;
      FileTimeToSystemTime(srOld.ftLastAccessTime,ot);
      SystemTimeToTzSpecificLocalTime(nil,ot,tt);
      ot := tt;
      if not SameSystemTime(nt,ot) then begin
        FChangeRecord.ChangeType := ctLastAccessTime;
        FChangeRecord.OldTime := SystemTimeToDateTime(ot);
        FChangeRecord.NewTime := SystemTimeToDateTime(nt);
        srOld.ftLastAccessTime := srNew.ftLastAccessTime;
        Exit;
      end
      else begin
        FileTimeToSystemTime(srNew.ftLastWriteTime,nt);
        SystemTimeToTzSpecificLocalTime(nil,nt,tt);
        nt := tt;
        FileTimeToSystemTime(srOld.ftLastWriteTime,ot);
        SystemTimeToTzSpecificLocalTime(nil,ot,tt);
        ot := tt;
        if not SameSystemTime(nt,ot) then begin
          FChangeRecord.ChangeType := ctLastModificationTime;
          FChangeRecord.OldTime := SystemTimeToDateTime(ot);
          FChangeRecord.NewTime := SystemTimeToDateTime(nt);
          srOld.ftLastWriteTime := srNew.ftLastWriteTime;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TReadDirChangesThread.Execute;
  var i, Index : Integer;
      R : DWord;
      fd : TFileData;
begin
  while not Terminated do try
    if (FDirectories.Count = 0) or (not FOwner.Enabled) then Sleep(0)
    else begin
      R := WaitForMultipleObjects(FHandles.Count,pHandles,False,200);
      if (R < (WAIT_OBJECT_0 + DWord(FHandles.Count))) then begin
        FillChar(FChangeRecord,SizeOf(FChangeRecord),0);
        FFilesData.SetFound(False);
        FTempFilesData.Clear;
        ReadDirectories(FTempFilesData);
        while (FTempFilesData.Count > 0) do begin
          fd := TFileData(FTempFilesData.Objects[0]);
          // New file/directory is created
          if not FFilesData.Find(fd.Name,Index) then begin
            Index := FFilesData.AddFileData(fd);
            TFileData(FFilesData.Objects[Index]).FFound := True;
            FChangeRecord.ChangeType := ctCreate;
            FChangeRecord.Name := fd.Name;
            FChangeRecord.FileFlag := ((fd.FSearchRec.Attr and faDirectory) = 0);
            FChangeRecord.Directory := FDirectories[R - WAIT_OBJECT_0];
            Synchronize(Notify);
          end
          else begin
            // file/directory is modified
            TFileData(FFilesData.Objects[Index]).FFound := True;
            CompareSearchRec(TFileData(FFilesData.Objects[Index]).FSearchRec, fd.FSearchRec);
            while (FChangeRecord.ChangeType <> ctNone) do begin
              FChangeRecord.Name := fd.Name;
              FChangeRecord.FileFlag := ((fd.FSearchRec.Attr and faDirectory) = 0);
              FChangeRecord.Directory := FDirectories[R - WAIT_OBJECT_0];
              Synchronize(Notify);
              CompareSearchRec(TFileData(FFilesData.Objects[Index]).FSearchRec, fd.FSearchRec);
            end;
          end;
          FTempFilesData.Delete(0);
        end;
        for i := FFilesData.Count downto 1 do if not TFileData(FFilesData.Objects[i-1]).FFound then begin
          // file/directory is deleted
          fd := TFileData(FFilesData.Objects[i-1]);
          FChangeRecord.ChangeType := ctRemove;
          FChangeRecord.Name := fd.Name;
          FChangeRecord.FileFlag := ((fd.FSearchRec.Attr and faDirectory) = 0);
          FChangeRecord.Directory := FDirectories[R - WAIT_OBJECT_0];
          FFilesData.Delete(i-1);
          Synchronize(Notify);
        end;
        FindNextChangeNotification(THandle(FHandles[R - WAIT_OBJECT_0]));
      end;
    end;
  except end;
end;


procedure TReadDirChangesThread.Notify;
  var cr : TDirectoryChangeRecord;
begin
  cr := FChangeRecord;
  if (cr.ChangeType <> ctNone) then FOwner.DoChangeDirectory(cr);
end;

constructor TReadDirChangesThread.Create(Owner : TOxygenDirectorySpy);
begin
  inherited Create(True);
  FOwner := Owner;
  FHandles := TList.Create;
  pHandles := nil;
  FDirectories := TStringList.Create;
  FDirectories.Sorted := True;
  FDirectories.Duplicates := dupIgnore;
  FreeOnTerminate := False;
  FFilesData := TFileDataList.Create;
  FFilesData.Sorted := True;
  FFilesData.Duplicates := dupIgnore;
  FTempFilesData := TFileDataList.Create;
  FTempFilesData.Sorted := True;
  FTempFilesData.Duplicates := dupIgnore;
  //Reset;
end;

procedure TReadDirChangesThread.ReleaseHandle;
  var i : Integer;
begin
  if (pHandles <> nil) then FreeMem(pHandles,FHandles.Count * SizeOf(THandle));
  pHandles := nil;
  for i := 1 to FHandles.Count do if (THandle(FHandles[i-1]) <> INVALID_HANDLE_VALUE) then FindCloseChangeNotification(THandle(FHandles[i-1]));//CloseHandle(FHandle);
  FHandles.Clear;
end;

destructor TReadDirChangesThread.Destroy;
begin
  ReleaseHandle;
  FHandles.Free;
  FDirectories.Free;
  FFilesData.Clear;
  FFilesData.Free;
  FTempFilesData.Clear;
  FTempFilesData.Free;
  inherited Destroy;
end;

procedure TReadDirChangesThread.AllocateHandle;
  var i : Integer;
      h : THandle;
begin
  if (FOwner <> nil) then for i := 1 to FDirectories.Count do begin
    h := FindFirstChangeNotification(PChar(FDirectories[i-1]), FOwner.WatchSubTree, FILE_NOTIFY_CHANGE_FILE_NAME +
                                           FILE_NOTIFY_CHANGE_DIR_NAME + FILE_NOTIFY_CHANGE_ATTRIBUTES +
                                           FILE_NOTIFY_CHANGE_SIZE + FILE_NOTIFY_CHANGE_LAST_WRITE);
    {h := FindFirstChangeNotification(PChar(FDirectories[i-1]), FALSE, FILE_NOTIFY_CHANGE_FILE_NAME +
                                           FILE_NOTIFY_CHANGE_DIR_NAME + FILE_NOTIFY_CHANGE_ATTRIBUTES +
                                           FILE_NOTIFY_CHANGE_SIZE + FILE_NOTIFY_CHANGE_LAST_WRITE);}
    if (h <> INVALID_HANDLE_VALUE) then FHandles.Add(Pointer(h)) else raise Exception.Create('Error allocating handle: #'+IntToStr(GetLastError));
  end;
  GetMem(pHandles,FHandles.Count * SizeOf(THandle));
  for i := 1 to FHandles.Count do pHandles^[i-1] := THandle(FHandles[i-1]);
  ReadDirectories(FFilesData);
end;

procedure TReadDirChangesThread.ReadDirectories(DestData : TFileDataList);
  var i : Integer;

  procedure AppendDirContents(const Directory : String);
    var sr : TSearchRec;
        s : String;
  begin
    if (Directory[Length(Directory)] <> '\') then s := Directory + '\*.*' else s := Directory + '*.*';
    if (FindFirst(s,faAnyFile,sr) = 0) then begin
      if (sr.Name <> '.') and (sr.Name <> '..') then begin
        DestData.AddSearchRec(Directory,sr);
        if ((sr.Attr and faDirectory) <> 0) and FOwner.WatchSubTree then AppendDirContents(Directory + '\' + sr.Name);
      end;
      while (FindNext(sr) = 0) do if (sr.Name <> '.') and (sr.Name <> '..') then begin
        DestData.AddSearchRec(Directory,sr);
        if ((sr.Attr and faDirectory) <> 0) and FOwner.WatchSubTree then AppendDirContents(Directory + '\' + sr.Name);
      end;
      FindClose(sr);
    end;
  end;

begin
  for i := 1 to FDirectories.Count do AppendDirContents(FDirectories[i-1]);
end;

procedure TReadDirChangesThread.Reset;
begin
  ReleaseHandle;
  if (FDirectories.Count = 0) then Exit;
  AllocateHandle;
  if (FHandles.Count > 0) then Resume;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//       TOxygenDirectorySpy
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TOxygenDirectorySpy.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FEnabled := False;
  FWatchSubTree := False;
  FDirectories := TStringList.Create;
  TStringList(FDirectories).Sorted := True;
  TStringList(FDirectories).Duplicates := dupIgnore;
  FOnChangeDirectory := nil;
  FThread := nil;
{$IFDEF O2_SW}
  if (MessageDlg('This version of TOxygenDirectorySpy is NOT REGISTERED. '+#13#10+
                 'Press Ok to visit http://www.oxygensoftware.com and register.',
                 mtWarning,[mbOk,mbCancel],0) = mrOk) then ShellExecute(0,'open','http://www.oxygensoftware.com',nil,nil,SW_SHOWNORMAL);
{$ENDIF}
end;

procedure TOxygenDirectorySpy.SetEnabled(const Value : Boolean);
begin
  if (csDesigning in ComponentState) then Exit;
  if (Value = FEnabled) then Exit;
  CheckDirectories;
  if (FDirectories.Count = 0) then FEnabled := False else FEnabled := Value;
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) then FWatchSubTree := False;
  if FEnabled then begin
    FThread := TReadDirChangesThread.Create(Self);
    FThread.FDirectories.Clear;
    FThread.FDirectories.AddStrings(FDirectories);
    FThread.Reset;
  end
  else if (FThread <> nil) then begin
    FThread.Terminate;
    FThread.WaitFor;
    //TerminateThread(FThread.Handle,0);
    FThread := nil;
  end;
end;

procedure TOxygenDirectorySpy.CheckDirectories;
  var i : Integer;
      s : String;
begin
  for i := FDirectories.Count downto 1 do begin
    s := Trim(FDirectories[i-1]);
    if (s = '') or (not DirectoryExists(s)) then FDirectories.Delete(i-1);
  end;
  while (FDirectories.Count > MAXIMUM_WAIT_OBJECTS) do FDirectories.Delete(FDirectories.Count - 1);
end;

procedure TOxygenDirectorySpy.SetDirectories(const Value : TStrings);
begin
  FDirectories.Clear;
  FDirectories.AddStrings(Value);
  CheckDirectories;
  if FEnabled then begin
    SetEnabled(False);
    SetEnabled(True);
  end;
end;

procedure TOxygenDirectorySpy.SetWatchSubTree(const Value : Boolean);
begin
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) then begin
    FWatchSubTree := False;
    Exit;
  end;
  if (FWatchSubTree = Value) then Exit;
  FWatchSubTree := Value;
  if FEnabled then begin
    SetEnabled(False);
    SetEnabled(True);
  end;
end;

procedure TOxygenDirectorySpy.DoChangeDirectory(ChangeRecord : TDirectoryChangeRecord);
begin
  if Assigned(FOnChangeDirectory) then FOnChangeDirectory(Self, ChangeRecord);
end;

destructor TOxygenDirectorySpy.Destroy;
begin
  if (FThread <> nil) then begin
    FThread.Terminate;
    FThread.WaitFor;
    //TerminateThread(FThread.Handle,0);
    //FThread.Free;
    FThread := nil;
  end;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Oxygen', [TOxygenDirectorySpy]);
end;

end.
